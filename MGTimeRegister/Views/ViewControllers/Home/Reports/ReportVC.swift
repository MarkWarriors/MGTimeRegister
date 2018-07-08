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
    @IBOutlet weak var searchTF: MGTextField!
    @IBOutlet weak var todayBtn: MGButton!
    @IBOutlet weak var lastWeekBtn: MGButton!
    @IBOutlet weak var lastMonthBtn: MGButton!
    @IBOutlet weak var filterViewHeight: NSLayoutConstraint!
    @IBOutlet weak var toggleFilterBtn: UIButton!
    var filterViewOpenedHeight : CGFloat? = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.title = self.title
        filterViewOpenedHeight = filterViewHeight.constant
        configureTableView()
        bindViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func configureTableView(){
        projectsTableView.tableFooterView = UIView()
        projectsTableView.register(UINib.init(nibName: ProjectTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ProjectTableViewCell.identifier)
        projectsTableView.register(UINib.init(nibName: TableHeaderTimeCell.identifier, bundle: nil), forCellReuseIdentifier: TableHeaderTimeCell.identifier)
    }
    
    func bindViewModel() {
        let viewWillAppear =  self.rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .map({ _ -> Void in return () })
            .asDriver(onErrorJustReturn: ())
        
        viewModel!.initBindings(viewWillAppear: viewWillAppear,
                                todayBtnPressed: todayBtn.rx.tap.asDriver(),
                                lastWeekBtnPressed: lastWeekBtn.rx.tap.asDriver(),
                                lastMonthBtnPressed: lastMonthBtn.rx.tap.asDriver(),
                                searchText: searchTF.rx.text.asObservable(),
                                selectedItem: projectsTableView.rx.modelSelected(ProjectHours.self).asDriver(),
                                dateFromBtnPressed: dateFromBtn.rx.tap.asDriver(),
                                dateToBtnPressed: dateToBtn.rx.tap.asDriver())
        
        viewModel!.dateFromText.bind(to: dateFromBtn.rx.title(for: .normal)).disposed(by: disposeBag)
        viewModel!.dateToText.bind(to: dateToBtn.rx.title(for: .normal)).disposed(by: disposeBag)
        
        viewModel!.tableItems
            .bind(to: projectsTableView.rx
                .items(dataSource: viewModel!.itemsToCell)
            )
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
    
    @IBAction func toggleFilterBtnPressed(_ sender: Any) {
        self.toggleFilterBtn.setImage(self.filterViewHeight.constant == 0 ? #imageLiteral(resourceName: "caret_up") : #imageLiteral(resourceName: "caret_down"), for: .normal)
        UIView.animate(withDuration: Globals.Timing.toggleAnimation, animations: {
            self.filterViewHeight.constant = abs(self.filterViewHeight.constant - self.filterViewOpenedHeight!)
            self.view.layoutSubviews()
        }) { (completed) in
        }
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
        let headerCell = tableView.dequeueReusableCell(withIdentifier: TableHeaderTimeCell.identifier) as! TableHeaderTimeCell
        headerCell.nameLbl.text = viewModel?.projectHeaderTextFor(section: section)
        headerCell.hoursLbl.text = viewModel?.projectHeaderHoursFor(section: section)
        return headerCell
    }
    
}
