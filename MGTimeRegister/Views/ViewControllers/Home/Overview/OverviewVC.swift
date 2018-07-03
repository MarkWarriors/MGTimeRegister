//
//  OverviewVC.swift
//  MGTimeRegister
//
//  Created by Marco Guerrieri on 02/07/18.
//  Copyright © 2018 Marco Guerrieri. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class OverviewVC: MGTBaseVC, ViewModelBased {
    typealias ViewModel = OverviewViewModel
    var viewModel: OverviewViewModel? = OverviewViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.title = self.title
    }

}
