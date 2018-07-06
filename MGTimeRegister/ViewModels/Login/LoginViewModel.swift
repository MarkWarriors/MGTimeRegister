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
    
    private let privatePerformSegue = PublishSubject<(MGTViewModelSegue)>()
    private let privateIsLoading = BehaviorRelay<Bool>(value: false)
    private let privateError = PublishSubject<(MGTError)>()
    private let privateConfirm = PublishSubject<(MGTConfirm)>()
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
        var user : User?
    
        if let storedUser = ModelController.shared.listAllElements(forEntityName: ModelController.Entity.user.rawValue, predicate: NSPredicate.init(format: "username = %@", privateUsername.value, privatePassword.value)).first as? User {
            if storedUser.password != privatePassword.value {
                privateError
                    .onNext(
                        MGTError.init(title: Strings.Errors.error,
                                      description: Strings.Errors.invalidCredentials)
                    )
            }
            else {
                loginUser(user: storedUser, storeCredential: privateSaveCredentials.value || autologin)
            }
        }
        else {
            privateConfirm.onNext(MGTConfirm.init(title: Strings.Login.createUserTitle,
                                                  message: Strings.Login.createUserMessage(username: privateUsername.value),
                                                  callback: { [weak self] (confirm) in
                                                    if confirm {
                                                        user = ModelController.shared.new(forEntity: .user) as? User
                                                        user!.username = self?.privateUsername.value
                                                        user!.password = (self?.privatePassword.value)!
                                                        ModelController.shared.save()
                                                        self?.loginUser(user: user!,
                                                                        storeCredential: (self?.privateSaveCredentials.value)! || autologin)
                                                    }
            }))
        }
        
        privateIsLoading.accept(false)
    }
    
    func loginUser(user: User, storeCredential: Bool){
        SharedInstance.shared.loginUser(user, storeCredential: storeCredential)

        self.privatePerformSegue.onNext(
            MGTViewModelSegue.init(identifier: Segues.Login.toHome)
        )
    }
    
    public func viewModelFor(_ vc: inout UIViewController) {
        if let vc = vc as? OverviewVC {
            vc.viewModel = OverviewViewModel()
        }
    }
}
