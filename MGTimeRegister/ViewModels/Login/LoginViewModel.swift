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
    
    var isLoading: Observable<Bool> {
        return self.privateIsLoading.asObservable()
    }
    
    var performSegue: Observable<(MGTViewModelSegue)> {
        return self.privatePerformSegue.asObservable()
    }
    
    var error: Observable<MGTError> {
        return self.privateError.asObservable()
    }
    
    
    public func initBindings(loginBtnPressed: Driver<Void>, usernameTF: Observable<String>, passwordTF: Observable<String>){
        self.disposeBag = DisposeBag()
        
        usernameTF.bind(to: privateUsername).disposed(by: disposeBag)
        passwordTF.bind(to: privatePassword).disposed(by: disposeBag)
        loginBtnPressed
            .drive(onNext: { [unowned self] in
                self.loginUser()
            })
            .disposed(by: self.disposeBag)
    }
    
    private func loginUser(){
        privateIsLoading.value = true
        if privateUsername.value != "" && privatePassword.value != "" {
            self.privatePerformSegue.onNext(
                MGTViewModelSegue.init(identifier: Segues.Login.loginToHome)
            )
        }
        else {
            self.privateError.onNext(
                MGTError.init(title: Strings.Errors.error,
                              description: Strings.Errors.invalidCredentials)
            )
        }
        privateIsLoading.value = false
    }
    
    public func prepareVCForSegue(_ vc: UIViewController) {
        if vc is OverviewVC {
            (vc as! OverviewVC).viewModel = OverviewViewModel()
        }
    }
}
