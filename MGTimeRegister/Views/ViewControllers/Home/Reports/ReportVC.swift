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
import RxDataSources

class ReportVC: MGTBaseVC, ViewModelBased, UITableViewDelegate {
    typealias ViewModel = ReportViewModel
    var viewModel: ReportViewModel? = ReportViewModel()
    
    @IBOutlet weak var projectsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.title = self.title
        configureTableView()
        bindViewModel()
    }
    
    func configureTableView(){
        projectsTableView.tableFooterView = UIView()
        projectsTableView.register(UINib.init(nibName: ProjectTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ProjectTableViewCell.identifier)
    }
    
    func bindViewModel() {
        let viewWillAppear =  self.rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .map({ _ -> Void in return () })
            .asDriver(onErrorJustReturn: ())
        
        viewModel!.initBindings(fetchDataSource: viewWillAppear,
                                selectedRow: projectsTableView.rx.itemSelected.asDriver())
        viewModel!.tableItems
            .bind(to: projectsTableView.rx
                .items(dataSource: viewModel!.dataSource))
            .disposed(by: disposeBag)
        
        projectsTableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    // to prevent swipe to delete behavior
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = Globals.Colors.red
        
        let header:UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
    }
}
