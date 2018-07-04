//
//  Protocols.swift
//  MGTimeRegister
//
//  Created by Marco Guerrieri on 03/07/18.
//  Copyright © 2018 Marco Guerrieri. All rights reserved.
//

import UIKit

public protocol ViewModelBased where Self: UIViewController {
    associatedtype ViewModel
    var viewModel : ViewModel? { get set }
    
    func bindViewModel()
}

public protocol ViewModel {
}

