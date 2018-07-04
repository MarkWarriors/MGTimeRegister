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
    
    @IBOutlet weak var companyLbl: UILabel!
    @IBOutlet weak var projectsTableView: UITableView!
    @IBOutlet weak var addProjectBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureTableView()
        self.bindViewModel()
    }
    
    private func configureTableView(){
        projectsTableView.tableFooterView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: projectsTableView.frame.width, height: 76))
        projectsTableView.register(UINib.init(nibName: ProjectTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ProjectTableViewCell.identifier)
    }
    
    func bindViewModel(){
        let viewWillAppear =  self.rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .map({ _ -> Void in return () })
            .asDriver(onErrorJustReturn: ())
        
        viewModel!.initBindings(fetchDataSource: viewWillAppear,
                               selectedRow: projectsTableView.rx.itemSelected.asDriver(),
                               newProjectBtnPressed: addProjectBtn.rx.tap.asDriver())
        
        viewModel!.companyText.bind(to: companyLbl.rx.text).disposed(by: disposeBag)
        
        projectsTableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.projectsTableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: self.disposeBag)
        
        viewModel!.dataSource
            .bind(to: self.projectsTableView.rx
                .items(cellIdentifier: ProjectTableViewCell.identifier,
                       cellType: ProjectTableViewCell.self)) { _, project, cell in
                        cell.setModel(project)
            }
            .disposed(by: self.disposeBag)
        
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
