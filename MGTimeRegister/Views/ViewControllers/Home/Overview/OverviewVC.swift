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
    
    @IBOutlet weak var companiesLbl: UILabel!
    @IBOutlet weak var projectsLbl: UILabel!
    @IBOutlet weak var effortLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.title = self.title
        bindViewModel()
    }

    
    func bindViewModel() {
        viewModel?.companiesText.bind(to: companiesLbl.rx.text).disposed(by: disposeBag)
        viewModel?.projectsText.bind(to: projectsLbl.rx.text).disposed(by: disposeBag)
        viewModel?.effortText.bind(to: effortLbl.rx.text).disposed(by: disposeBag)
    }
}
