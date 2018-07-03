//
//  NewTimeEntryVC.swift
//  MGTimeRegister
//
//  Created by Marco Guerrieri on 02/07/18.
//  Copyright © 2018 Marco Guerrieri. All rights reserved.
//

import UIKit

class NewTimeEntryVC: MGTBaseVC, ViewModelBased {
    typealias ViewModel = NewTimeEntryViewModel
    var viewModel: NewTimeEntryViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModel()
    }
    
    
    func bindViewModel(){
        
    }
    
}
