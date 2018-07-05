//
//  ReportViewModel.swift
//  MGTimeRegister
//
//  Created by Marco Guerrieri on 02/07/18.
//  Copyright © 2018 Marco Guerrieri. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

struct ProjectHours {
    var project: Project
    var hours: Int32
}

struct CompanyHours {
    var company: Company
    var hours: Int32
}

struct TableSectionData {
    var header: CompanyHours
    var items: [ProjectHours]
}

extension TableSectionData: SectionModelType {
    init(original: TableSectionData, items: [ProjectHours]) {
        self = original
        self.items = items
    }
}


class ReportViewModel: MGTBaseViewModel {
    var disposeBag: DisposeBag = DisposeBag()
    
    private let privatePerformSegue = PublishSubject<(MGTViewModelSegue)>()
    private let privateTableItems = BehaviorRelay<[TableSectionData]>(value: [])
    private let privateStartDate = BehaviorRelay<Date?>(value: nil)
    private let privateEndDate = BehaviorRelay<Date?>(value: nil)
    
    var tableItems : Observable<[TableSectionData]> {
        return self.privateTableItems.asObservable()
    }
    
    func projectHeaderTextFor(section: Int) -> String {
        return self.privateTableItems.value[section].header.company.name ?? ""
    }
    
    func projectHeaderHoursFor(section: Int) -> String {
        return "total: \(self.privateTableItems.value[section].header.hours) h"
    }
    
    let dataSource = RxTableViewSectionedReloadDataSource<TableSectionData>(
        configureCell: { (_, tv, indexPath, projectHours) in
            let cell = tv.dequeueReusableCell(withIdentifier: ProjectTableViewCell.identifier) as! ProjectTableViewCell
            cell.nameLbl.text = projectHours.project.name
            cell.hoursLbl.text = "\(projectHours.hours)"
            return cell
    })

    
    public func initBindings(fetchDataSource: Driver<Void>,
                             selectedRow: Driver<IndexPath>) {
        fetchDataSource
            .drive(onNext: { [weak self] (_) in
                self?.fetchData()
            })
            .disposed(by: self.disposeBag)
        
        selectedRow
            .drive(onNext: { [weak self] (indexPath) in
//                self?.privateSelectedCompany.accept((self?.privateDataSource.value[indexPath.row])!)
            })
            .disposed(by: self.disposeBag)
    }
    
    private func fetchData(){
        ModelController.shared.managedObjectContext.perform { [weak self] in
            var predicate : NSPredicate?
            
            let startDate : Date? = self?.privateStartDate.value?.startOfDay()
            let endDate : Date? = self?.privateEndDate.value?.endOfDay()
            
            if startDate != nil && endDate != nil {
                predicate = NSPredicate.init(format: "date >= %@ AND date <= %@ AND hours > 0", startDate! as NSDate, endDate! as NSDate)
            }
            else if startDate != nil {
                predicate = NSPredicate.init(format: "date >= %@ AND hours > 0", startDate! as NSDate)
            }
            else if endDate != nil {
                predicate = NSPredicate.init(format: "Sdate <= %@ AND hours > 0", endDate! as NSDate)
            }
            
            let sortDescriptor : NSSortDescriptor = NSSortDescriptor.init(key: "project", ascending: true)
            
            var sectionsMap : [Company:[Project:Int32]] = [:]
            
            if let times = ModelController.shared.listAllElements (
                forEntityName: ModelController.Entity.time.rawValue,
                whereCondition: predicate,
                descriptors: [sortDescriptor]) as? [Time], times.count > 0{
                
                times.forEach({ (time) in
                    let company = time.project!.company!
                    let project = time.project!
                    
                    // Faster code, see https://stackoverflow.com/questions/42486686/swiftier-swift-for-add-to-array-or-create-if-not-there
                    var projDict = sectionsMap.removeValue(forKey: company) ?? [:]
                    projDict[project] = (projDict[project] ?? 0) + Int32(time.hours)
                    sectionsMap[company] = projDict
                })
            }
            
            let dataSource = sectionsMap.map({ (company, projHours) -> TableSectionData in
                var companyHours = CompanyHours.init(company: company, hours: 0)
                var items : [ProjectHours] = []
                projHours.forEach({ (project, hours) in
                    companyHours.hours = companyHours.hours + hours
                    items.append(ProjectHours.init(project: project, hours: hours))
                })
                
                return TableSectionData.init(header: companyHours, items: items)
            })

            self?.privateTableItems.accept(dataSource)
        }
    }
    
    public func viewModelFor(_ vc: inout UIViewController) {
        if let vc = vc as? SelectProjectVC {
//            vc.viewModel = SelectProjectViewModel(company: privateSelectedCompany.value!)
        }
    }
}
