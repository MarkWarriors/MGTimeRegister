//
//  NewProjectVC.swift
//  MGTimeRegister
//
//  Created by Marco Guerrieri on 03/07/18.
//  Copyright © 2018 Marco Guerrieri. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class NewProjectVC: MGTBaseVC, ViewModelBased {
    typealias ViewModel = NewProjectViewModel
    var viewModel: NewProjectViewModel?
    
    @IBOutlet weak var saveBtn: MGButton!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var companyNameLbl: UILabel!
    @IBOutlet weak var projectNameTF: MGTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModel()
    }
    
    
    func bindViewModel() {
        viewModel!.initBindings(newProjectName: projectNameTF.rx.text.orEmpty.asObservable(),
                                saveBtnPressed: saveBtn.rx.tap.asDriver(),
                                closeBtnPressed: closeBtn.rx.tap.asDriver())
        
        viewModel!.companyNameText.bind(to: companyNameLbl.rx.text).disposed(by: disposeBag)
        
        viewModel!.buttonEnabled.bind(to: saveBtn.rx.isEnabled).disposed(by: disposeBag)
        
        viewModel!.dismissModal
            .bind { [weak self] (_) in
                self?.dismiss(animated: true, completion: nil)
            }
            .disposed(by: self.disposeBag)
    }

}
