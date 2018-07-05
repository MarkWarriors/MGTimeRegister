//
//  ReportVC.swift
//  MGTimeRegister
//
//  Created by Marco Guerrieri on 02/07/18.
//  Copyright © 2018 Marco Guerrieri. All rights reserved.
//

import UIKit
import RxDataSources

class ReportVC: MGTBaseVC, ViewModelBased, UITableViewDelegate {
    typealias ViewModel = ReportViewModel
    var viewModel: ReportViewModel? = ReportViewModel()
    
    @IBOutlet weak var projectsTableView: UITableView!
    @IBOutlet weak var dateFromBtn: UIButton!
    @IBOutlet weak var dateToBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.title = self.title
        configureTableView()
        bindViewModel()
    }
    
    func configureTableView(){
        projectsTableView.tableFooterView = UIView()
        projectsTableView.register(UINib.init(nibName: ProjectTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ProjectTableViewCell.identifier)
        projectsTableView.register(UINib.init(nibName: ProjectHeaderCell.identifier, bundle: nil), forCellReuseIdentifier: ProjectHeaderCell.identifier)
    }
    
    func bindViewModel() {
        let viewWillAppear =  self.rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .map({ _ -> Void in return () })
            .asDriver(onErrorJustReturn: ())
        
        viewModel!.initBindings(fetchDataSource: viewWillAppear,
                                selectedRow: projectsTableView.rx.itemSelected.asDriver(),
                                dateFromBtnPressed: dateFromBtn.rx.tap.asDriver(),
                                dateToBtnPressed: dateToBtn.rx.tap.asDriver())
        
        viewModel!.dateFromText.bind(to: dateFromBtn.rx.title(for: .normal)).disposed(by: disposeBag)
        viewModel!.dateToText.bind(to: dateToBtn.rx.title(for: .normal)).disposed(by: disposeBag)
        
        viewModel!.tableItems
            .bind(to: projectsTableView.rx
                .items(dataSource: viewModel!.dataSource))
            .disposed(by: disposeBag)
        
        projectsTableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        viewModel!.performSegue
            .bind { [weak self] (segue) in
                self?.performSegue(withIdentifier: segue.identifier, sender: segue.flag)
            }
            .disposed(by: disposeBag)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var vc = segue.destination
        viewModel!.viewModelFor(&vc, flag: sender as? String)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: ProjectHeaderCell.identifier) as! ProjectHeaderCell
        headerCell.projectLbl.text = viewModel?.projectHeaderTextFor(section: section)
        headerCell.hoursLbl.text = viewModel?.projectHeaderHoursFor(section: section)
        return headerCell
    }
    
}
