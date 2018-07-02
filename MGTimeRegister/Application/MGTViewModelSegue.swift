//
//  MGTViewModelSegue.swift
//  MGTimeRegister
//
//  Created by Marco Guerrieri on 02/07/18.
//  Copyright © 2018 Marco Guerrieri. All rights reserved.
//

import Foundation

public class MGTViewModelSegue {
    var identifier : String
    var viewModel : MGTBaseViewModel?
    
    init(identifier: String, viewModel: MGTBaseViewModel? = nil) {
        self.identifier = identifier
        self.viewModel = viewModel
    }
}
