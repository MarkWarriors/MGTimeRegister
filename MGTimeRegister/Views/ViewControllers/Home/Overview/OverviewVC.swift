//
//  OverviewVC.swift
//  MGTimeRegister
//
//  Created by Marco Guerrieri on 02/07/18.
//  Copyright © 2018 Marco Guerrieri. All rights reserved.
//

import UIKit

class OverviewVC: MGTBaseVC, ViewModelBased {
    typealias ViewModel = OverviewViewModel
    var viewModel: OverviewViewModel? = OverviewViewModel()
    
    @IBOutlet weak var companiesLbl: UILabel!
    @IBOutlet weak var projectsLbl: UILabel!
    @IBOutlet weak var effortLbl: UILabel!
    @IBOutlet weak var logoutBtn: MGButton!
    @IBOutlet weak var usernameLbl: UILabel!
    
    private var currentCalendar: Calendar?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.title = self.title
        
        bindViewModel()
    }
    
    func bindViewModel() {
        let viewWillAppear =  self.rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .map({ _ -> Void in return () })
            .asDriver(onErrorJustReturn: ())
        
        viewModel!.usernameText.bind(to: usernameLbl.rx.text).disposed(by: disposeBag)
        
        viewModel!.initBindings(fetchDataSource: viewWillAppear,
                                logoutBtn: logoutBtn.rx.tap.asDriver())
        
        viewModel!.companiesText.bind(to: companiesLbl.rx.text).disposed(by: disposeBag)
        viewModel!.projectsText.bind(to: projectsLbl.rx.text).disposed(by: disposeBag)
        viewModel!.effortText.bind(to: effortLbl.rx.text).disposed(by: disposeBag)
    }
    
    
}
