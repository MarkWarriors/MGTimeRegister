//
//  ReportTimeListVC.swift
//  MGTimeRegister
//
//  Created by Marco Guerrieri on 05/07/18.
//  Copyright © 2018 Marco Guerrieri. All rights reserved.
//

import UIKit

class ReportTimeListVC: MGTBaseVC, ViewModelBased {
    typealias ViewModel = ReportTimeListViewModel
    var viewModel: ReportTimeListViewModel?
    
    @IBOutlet weak var projectLbl: UILabel!
    @IBOutlet weak var timesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureTableView()
        self.bindViewModel()
    }
    
    private func configureTableView(){
        timesTableView.tableFooterView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: timesTableView.frame.width, height: 76))
        timesTableView.register(UINib.init(nibName: ProjectTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ProjectTableViewCell.identifier)
    }
    
    func bindViewModel(){
        let viewWillAppear =  self.rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .map({ _ -> Void in return () })
            .asDriver(onErrorJustReturn: ())
        
        viewModel!.initBindings(fetchDataSource: viewWillAppear,
                                selectedRow: timesTableView.rx.itemSelected.asDriver()
        )
        
        viewModel!.projectText.bind(to: projectLbl.rx.text).disposed(by: disposeBag)
        
        timesTableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.timesTableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: self.disposeBag)
        
//        viewModel!.dataSource
//            .bind(to: self.timesTableView.rx
//                .items(cellIdentifier: ProjectTableViewCell.identifier,
//                       cellType: ProjectTableViewCell.self)) { _, project, cell in
//                        cell.setModel(project)
//            }
//            .disposed(by: self.disposeBag)
        
        viewModel!.performSegue
            .bind { [weak self] (segue) in
                self?.performSegue(withIdentifier: segue.identifier, sender: nil)
            }
            .disposed(by: disposeBag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var vc = segue.destination
        viewModel!.viewModelFor(&vc)
    }
}
