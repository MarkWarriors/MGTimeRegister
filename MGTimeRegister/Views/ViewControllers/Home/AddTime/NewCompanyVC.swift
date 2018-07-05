//
//  NewCompanyVC.swift
//  MGTimeRegister
//
//  Created by Marco Guerrieri on 03/07/18.
//  Copyright © 2018 Marco Guerrieri. All rights reserved.
//

import UIKit

class NewCompanyVC: MGTBaseVC, ViewModelBased {
    typealias ViewModel = NewCompanyViewModel
    var viewModel: NewCompanyViewModel?
    
    @IBOutlet weak var saveBtn: MGButton!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var companyNameTF: MGTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModel()
    }
    
    
    func bindViewModel() {
        viewModel!.initBindings(
            newCompanyName: companyNameTF.rx.text.orEmpty.asObservable(),
            saveBtnPressed: saveBtn.rx.tap.asDriver(),
            closeBtnPressed: closeBtn.rx.tap.asDriver())
        
        viewModel!.buttonEnabled.bind(to: saveBtn.rx.isEnabled).disposed(by: disposeBag)
        
        viewModel!.dismissModal
            .bind { [weak self] (_) in
                self?.dismiss(animated: true, completion: nil)
            }
            .disposed(by: self.disposeBag)
    }
}
