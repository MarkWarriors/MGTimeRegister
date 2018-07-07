//
//  LoginVC.swift
//  MGTimeRegister
//
//  Created by Marco Guerrieri on 02/07/18.
//  Copyright © 2018 Marco Guerrieri. All rights reserved.
//

import UIKit

class LoginVC: MGTBaseVC, ViewModelBased {
    typealias ViewModel = LoginViewModel
    var viewModel: LoginViewModel? = LoginViewModel()
    

    @IBOutlet weak var loginBtn: MGButton!
    @IBOutlet weak var usernameTF: MGTextField!
    @IBOutlet weak var passwordTF: MGTextField!
    @IBOutlet weak var saveCredentialsSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModel()
    }

    func bindViewModel(){
        let viewDidAppear = self.rx.sentMessage(#selector(UIViewController.viewDidAppear(_:)))
            .map({ _ -> Void in return () })
            .asDriver(onErrorJustReturn: ())
        
        viewModel!.initBindings(viewDidAppear: viewDidAppear,
                               loginBtnPressed: loginBtn.rx.tap.asDriver(),
                               usernameTF: usernameTF.rx.text.orEmpty.asObservable(),
                               passwordTF: passwordTF.rx.text.orEmpty.asObservable(),
                               saveCredentialsSwitch: saveCredentialsSwitch.rx.isOn.asObservable())
        
        viewModel!.isLoading
            .bind { [weak self] (isLoading) in
                if isLoading {
                    self?.showWaitView()
                }
                else{
                    self?.dismissWaitView()
                }
            }
            .disposed(by: self.disposeBag)
        
        viewModel!.buttonEnabled
            .bind(to: self.loginBtn.rx.isEnabled)
            .disposed(by: self.disposeBag)
        
        viewModel!.performSegue
            .bind(onNext: { [weak self] (segue) in
                self?.performSegue(withIdentifier: segue.identifier, sender: nil)
            })
            .disposed(by: self.disposeBag)
        
        viewModel!.error
            .bind { [weak self] (error) in
                self?.showAlert(title: error.title, message: error.description)
            }
            .disposed(by: self.disposeBag)
        
        viewModel!.confirmAction
            .bind { (confirm) in
                self.showConfirm(title: confirm.title,
                                 message: confirm.message,
                                 onChoice: confirm.callback)
            }
            .disposed(by: disposeBag)
    }
    
}
