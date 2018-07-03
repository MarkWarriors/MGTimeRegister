//
//  NewCompanyVC.swift
//  MGTimeRegister
//
//  Created by Marco Guerrieri on 03/07/18.
//  Copyright © 2018 Marco Guerrieri. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class NewCompanyVC: MGTBaseVC {

    @IBOutlet weak var saveBtn: MGButton!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var companyNameTF: MGTextField!
    
    public var viewModel = NewCompanyViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModel()
    }
    
    
    private func bindViewModel() {
        viewModel.initBindings(
            newCompanyName: companyNameTF.rx.text.orEmpty.asObservable(),
            saveBtnPressed: saveBtn.rx.tap.asDriver(),
            closeBtnPressed: closeBtn.rx.tap.asDriver())
        
        viewModel.buttonEnabled.bind(to: saveBtn.rx.isEnabled).disposed(by: disposeBag)
        
        viewModel.closeVC
            .bind { [weak self] (_) in
                self?.dismiss(animated: true, completion: nil)
            }
            .disposed(by: self.disposeBag)
    }
}
