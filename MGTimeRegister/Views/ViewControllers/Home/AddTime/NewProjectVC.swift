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

class NewProjectVC: MGTBaseVC {
    
    @IBOutlet weak var saveBtn: MGButton!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var companyNameLbl: UILabel!
    @IBOutlet weak var projectNameTF: MGTextField!
    
    public var viewModel = NewProjectViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModel()
    }
    
    
    private func bindViewModel() {
        
    }

}
