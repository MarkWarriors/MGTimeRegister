//
//  LoginVC.swift
//  MGTimeRegister
//
//  Created by Marco Guerrieri on 02/07/18.
//  Copyright © 2018 Marco Guerrieri. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LoginVC: MGTBaseVC {
    
    @IBOutlet weak var loginBtn: MGButton!
    @IBOutlet weak var usernameTF: MGTextField!
    @IBOutlet weak var passwordTF: MGTextField!
    
    public var viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModel()
    }

    private func bindViewModel(){
        viewModel.initBindings(loginBtnPressed: loginBtn.rx.tap.asDriver(),
                               usernameTF: usernameTF.rx.text.orEmpty.asObservable(),
                               passwordTF: passwordTF.rx.text.orEmpty.asObservable())
        
        viewModel.isLoading.bind { (isLoading) in
            if isLoading {
                self.showWaitView()
            }
            else{
                self.dismissWaitView()
            }
        }
        .disposed(by: self.disposeBag)
        
        viewModel.performSegue.bind(onNext: { (segue) in
            self.performSegue(withIdentifier: segue.identifier, sender: segue.viewModel)
        })
        .disposed(by: self.disposeBag)
        
        viewModel.error.bind { (error) in
            self.showAlert(title: error.title, message: error.description)
        }
        .disposed(by: self.disposeBag)
    }
    
    
}
