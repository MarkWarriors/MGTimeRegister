//
//  SelectCompanyVC.swift
//  MGTimeRegister
//
//  Created by Marco Guerrieri on 02/07/18.
//  Copyright © 2018 Marco Guerrieri. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SelectCompanyVC: MGTBaseVC {
    
    @IBOutlet weak var companyTableView: UITableView!
    @IBOutlet weak var addCompanyBtn: UIButton!
    
    public var viewModel = SelectCompanyViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureTableView()
        self.bindViewModel()
    }
    
    private func configureTableView(){
        companyTableView.tableFooterView = UIView()
        companyTableView.register(UINib.init(nibName: CompanyTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: CompanyTableViewCell.identifier)
    }
    
    private func bindViewModel(){
        let viewWillAppear =  self.rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .map({ _ -> Void in return () })
            .asDriver(onErrorJustReturn: ())
        
        viewModel.initBindings(viewWillAppear: viewWillAppear,
                               selectedRow: companyTableView.rx.itemSelected.asDriver(),
                               newCompanyBtnPressed: addCompanyBtn.rx.tap.asDriver())
        
        companyTableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath  in
                self?.companyTableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: self.disposeBag)
        
        viewModel.dataSource
            .bind(to: self.companyTableView.rx
                .items(cellIdentifier: CompanyTableViewCell.identifier,
                       cellType: CompanyTableViewCell.self)) { _, company, cell in
                        cell.setModel(company)
            }
            .disposed(by: self.disposeBag)
    }

}
