//
//  SelectProjectVC.swift
//  MGTimeRegister
//
//  Created by Marco Guerrieri on 02/07/18.
//  Copyright © 2018 Marco Guerrieri. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SelectProjectVC: MGTBaseVC, ViewModelBased {
    typealias ViewModel = SelectProjectViewModel
    var viewModel: SelectProjectViewModel?
    
    @IBOutlet weak var projectsTableView: UITableView!
    @IBOutlet weak var addProjectBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureTableView()
        self.bindViewModel()
    }
    
    private func configureTableView(){
        projectsTableView.tableFooterView = UIView()
        projectsTableView.register(UINib.init(nibName: ProjectTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ProjectTableViewCell.identifier)
    }
    
    private func bindViewModel(){
        let viewWillAppear =  self.rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .map({ _ -> Void in return () })
            .asDriver(onErrorJustReturn: ())
        
        viewModel!.initBindings(viewWillAppear: viewWillAppear,
                               selectedRow: projectsTableView.rx.itemSelected.asDriver(),
                               newProjectBtnPressed: addProjectBtn.rx.tap.asDriver())
        
        projectsTableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.projectsTableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: self.disposeBag)
        
        viewModel!.dataSource
            .bind(to: self.projectsTableView.rx
                .items(cellIdentifier: ProjectTableViewCell.identifier,
                       cellType: ProjectTableViewCell.self)) { _, project, cell in
            }
            .disposed(by: self.disposeBag)
    }

}
