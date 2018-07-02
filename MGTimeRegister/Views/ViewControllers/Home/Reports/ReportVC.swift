//
//  ReportVC.swift
//  MGTimeRegister
//
//  Created by Marco Guerrieri on 02/07/18.
//  Copyright © 2018 Marco Guerrieri. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ReportVC: MGTBaseVC {

    public var viewModel = ReportViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.title = self.title
    }

}
