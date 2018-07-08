//
//  ReportTimeListVC.swift
//  MGTimeRegister
//
//  Created by Marco Guerrieri on 05/07/18.
//  Copyright © 2018 Marco Guerrieri. All rights reserved.
//

import UIKit

class ReportTimeListVC: MGTBaseVC, ViewModelBased, UITableViewDelegate {
    typealias ViewModel = ReportTimeListViewModel
    var viewModel: ReportTimeListViewModel?
    
    @IBOutlet weak var projectLbl: UILabel!
    @IBOutlet weak var timesTableView: UITableView!
    @IBOutlet weak var totalHoursLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureTableView()
        self.bindViewModel()
    }
    
    private func configureTableView(){
        timesTableView.tableFooterView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: timesTableView.frame.width, height: 76))
        timesTableView.register(UINib.init(nibName: TimeTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: TimeTableViewCell.identifier)
        timesTableView.register(UINib.init(nibName: TableHeaderTimeCell.identifier, bundle: nil), forCellReuseIdentifier: TableHeaderTimeCell.identifier)
        timesTableView.rowHeight = UITableViewAutomaticDimension;
        timesTableView.estimatedRowHeight = 67.0;
    }
    
    func bindViewModel(){
        let viewWillAppear =  self.rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .map({ _ -> Void in return () })
            .asDriver(onErrorJustReturn: ())
        
        viewModel!.initBindings(fetchDataSource: viewWillAppear,
                                itemDeleted: timesTableView.rx.modelDeleted(Time.self).asDriver())
        
        viewModel!.totalHoursText.bind(to: totalHoursLbl.rx.text).disposed(by: disposeBag)
        viewModel!.projectText.bind(to: projectLbl.rx.text).disposed(by: disposeBag)
        
        timesTableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.timesTableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: self.disposeBag)
        
        viewModel!.tableItems
            .bind(to: timesTableView.rx
                .items(dataSource: viewModel!.itemsToCell)
            )
            .disposed(by: disposeBag)
        
        timesTableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: TableHeaderTimeCell.identifier) as! TableHeaderTimeCell
        headerCell.nameLbl.text = viewModel?.projectHeaderTextFor(section: section)
        headerCell.hoursLbl.text = viewModel?.projectHeaderHoursFor(section: section)
        return headerCell
    }
}
