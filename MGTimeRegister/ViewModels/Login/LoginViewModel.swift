//
//  LoginViewModel.swift
//  MGTimeRegister
//
//  Created by Marco Guerrieri on 02/07/18.
//  Copyright © 2018 Marco Guerrieri. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewModel: MGTBaseViewModel {
    var disposeBag: DisposeBag = DisposeBag()
    
    private let privatePerformSegue = PublishRelay<(MGTViewModelSegue)>()
    private let privateIsLoading = PublishRelay<Bool>()
    private let privateError = PublishRelay<(MGTError)>()
    private let privateConfirm = PublishRelay<(MGTConfirm)>()
    private let privateUsername = BehaviorRelay<String>(value: "")
    private let privatePassword = BehaviorRelay<String>(value: "")
    private let privateSaveCredentials = BehaviorRelay<Bool>(value: false)
    

    var isLoading : Observable<Bool> {
        return self.privateIsLoading.asObservable()
    }
    
    var performSegue : Observable<(MGTViewModelSegue)> {
        return self.privatePerformSegue.asObservable()
    }
    
    var error : Observable<MGTError> {
        return self.privateError.asObservable()
    }
    
    var confirmAction : Observable<MGTConfirm> {
        return self.privateConfirm.asObservable()
    }
    
    var buttonEnabled : Observable<Bool> {
        return Observable.combineLatest(self.privateUsername.asObservable(), self.privatePassword.asObservable()) { (username, password) in
            return username != "" && password != ""
        }
    }
    
    public func initBindings(viewDidAppear: Driver<Void>,
                             loginBtnPressed: Driver<Void>,
                             usernameTF: Observable<String>,
                             passwordTF: Observable<String>,
                             saveCredentialsSwitch: Observable<Bool>){
        
        usernameTF.bind(to: privateUsername).disposed(by: disposeBag)
        passwordTF.bind(to: privatePassword).disposed(by: disposeBag)
        saveCredentialsSwitch.bind(to: privateSaveCredentials).disposed(by: disposeBag)
        
        viewDidAppear.drive(onNext: { [weak self] (_) in
                self?.checkAutologin()
            })
            .disposed(by: self.disposeBag)
        
        loginBtnPressed
            .drive(onNext: { [weak self] in
                self?.checkUserForLogin(autologin: false)
            })
            .disposed(by: self.disposeBag)
    }
    
    private func checkAutologin(){
        if let credentials = SharedInstance.shared.getStoredCredentials() {
            self.privateUsername.accept(credentials.username)
            self.privatePassword.accept(credentials.password)
            checkUserForLogin(autologin: true)
        }
    }
    
    private func checkUserForLogin(autologin: Bool){
        privateIsLoading.accept(true)
        
        if privateUsername.value == "" && privatePassword.value == "" {
            privateError.accept(MGTError.init(title: Strings.Errors.error,
                                  description: Strings.Errors.incompleteForm))
        }
    
        if let storedUser = ModelController.shared.listAllElements(forEntityName: ModelController.Entity.user.rawValue, predicate: NSPredicate.init(format: "username = %@", privateUsername.value, privatePassword.value)).first as? User {
            if storedUser.password != privatePassword.value {
                privateError.accept(MGTError.init(title: Strings.Errors.error,
                                      description: Strings.Errors.invalidCredentials))
            }
            else {
                loginUser(user: storedUser, storeCredential: privateSaveCredentials.value || autologin)
            }
        }
        else {
            privateConfirm.accept(MGTConfirm.init(title: Strings.Login.createUserTitle,
                                                  message: Strings.Login.createUserMessage(username: privateUsername.value),
                                                  callback: { [weak self] (confirm) in
                                                    if confirm {
                                                        self?.createUser()
                                                    }
            }))
        }
        
        privateIsLoading.accept(false)
    }
    
    private func loginUser(user: User, storeCredential: Bool){
        SharedInstance.shared.loginUser(user, storeCredential: storeCredential)

        self.privatePerformSegue.accept(MGTViewModelSegue.init(identifier: Segues.Login.toHome))
    }
    
    private func createUser(){
        ModelController.shared.managedObjectContext.performAndWait {
            let user = ModelController.shared.new(forEntity: .user) as? User
            user!.username = self.privateUsername.value
            user!.password = self.privatePassword.value
            ModelController.shared.save()
            self.loginUser(user: user!,
                           storeCredential: self.privateSaveCredentials.value)
        }
    }
    
}
