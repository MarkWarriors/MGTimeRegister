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
    
    private let privatePerformSegue = PublishSubject<(MGTViewModelSegue)>()
    private let privateIsLoading = Variable(false)
    private let privateError = PublishSubject<MGTError>()
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
    
    var buttonEnabled : Observable<Bool> {
        return Observable.combineLatest(self.privateUsername.asObservable(), self.privatePassword.asObservable()) { (username, password) in
            return username != "" && password != ""
        }
    }
    
    public func initBindings(viewWillAppear: Driver<Void>,
                             loginBtnPressed: Driver<Void>,
                             usernameTF: Observable<String>,
                             passwordTF: Observable<String>,
                             saveCredentialsSwitch: Observable<Bool>){
        self.disposeBag = DisposeBag()
        usernameTF.bind(to: privateUsername).disposed(by: disposeBag)
        passwordTF.bind(to: privatePassword).disposed(by: disposeBag)
        saveCredentialsSwitch.bind(to: privateSaveCredentials).disposed(by: disposeBag)
        
        viewWillAppear.drive(onNext: { (_) in
                self.checkAutologin()
            })
            .disposed(by: self.disposeBag)
        
        loginBtnPressed
            .drive(onNext: { [unowned self] in
                self.loginUser()
            })
            .disposed(by: self.disposeBag)
    }
    
    private func checkAutologin(){
        if let credentials = SharedInstance.shared.getStoredCredentials() {
            self.privateUsername.accept(credentials.username)
            self.privatePassword.accept(credentials.password)
            loginUser()
        }
    }
    
    private func loginUser(){
        privateIsLoading.value = true
        var user : User?
        
        if let storedUser = ModelController.shared.listAllElements(forEntityName: ModelController.Entity.user.rawValue, whereCondition: NSPredicate.init(format: "username = %@", privateUsername.value)).first as? User {
            user = storedUser
        }
        else {
            user = ModelController.shared.new(forEntity: .user) as? User
            user!.username = privateUsername.value
            ModelController.shared.save()
        }

        SharedInstance.shared.loginUser(user!)
        if privateSaveCredentials.value {
            SharedInstance.shared.storeCredentials(username: privateUsername.value, password: privatePassword.value)
        }
        
        self.privatePerformSegue.onNext(
            MGTViewModelSegue.init(identifier: Segues.Login.toHome)
        )
        
// Usefull if with Apicall
//        self.privateError.onNext(
//            MGTError.init(title: Strings.Errors.error,
//                          description: Strings.Errors.invalidCredentials)
//        )
        privateIsLoading.value = false
    }
    
    public func prepareVCForSegue(_ vc: UIViewController) {
        if vc is OverviewVC {
            (vc as! OverviewVC).viewModel = OverviewViewModel()
        }
    }
}
