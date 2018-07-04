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
    var project: String
    var hours: Int32
}

struct CompanyHours {
    var company: String
    var hours: Int32
}

struct SectionOfTiming {
    var header: CompanyHours
    var items: [Item]
}

extension SectionOfTiming: SectionModelType {
    typealias Item = ProjectHours
    
    init(original: SectionOfTiming, items: [Item]) {
        self = original
        self.items = items
    }
}

class ReportViewModel: MGTBaseViewModel {
    var disposeBag: DisposeBag = DisposeBag()
    
    private let privatePerformSegue = PublishSubject<(MGTViewModelSegue)>()
    private let privateTableItems = BehaviorRelay<[SectionOfTiming]>(value: [])
    
    var tableItems : Observable<[SectionOfTiming]> {
        return self.privateTableItems.asObservable()
    }
    
    func sectionCountText(section: Int) -> String {
        return self.privateTableItems.value[section].header.company
    }
    
    let dataSource = RxTableViewSectionedReloadDataSource<SectionOfTiming>(
        configureCell: { (_, tv, indexPath, element) in
            let cell = tv.dequeueReusableCell(withIdentifier: ProjectTableViewCell.identifier) as! ProjectTableViewCell
            cell.nameLbl.text = element.project
            cell.hoursLbl.text = "\(element.hours)"
            return cell
    },
        titleForHeaderInSection: { dataSource, sectionIndex in
            return dataSource[sectionIndex].header.company
    })

    
    public func initBindings(fetchDataSource: Driver<Void>,
                             selectedRow: Driver<IndexPath>) {
        fetchDataSource
            .drive(onNext: { [weak self] (_) in
                let startDate : NSDate = Date().startOfDay() as NSDate
                let endDate : NSDate = Date().changeOfDays(-5) as NSDate
                
                let predicate = NSPredicate.init(format: "SUBQUERY(projects, $p, ANY $p.times.date <= %@).@count != 0", endDate)
                
                let companies = ModelController.shared.listAllElements(
                    forEntityName: ModelController.Entity.company.rawValue,
                    whereCondition: predicate) as! [Company]
                
                let timeArr : [SectionOfTiming] = companies
                    .map({ (company) -> SectionOfTiming in
                        let projects = company.projects?.allObjects as! [Project]
                        var totalHours : Int32 = 0
                        let items = projects.map({ (project) -> SectionOfTiming.Item in
                            let times = project.times!
                            let hours = times.reduce(0, { $0 + ($1 as! Time).hours })
                            totalHours += Int32(hours)
                            return SectionOfTiming.Item.init(project: project.name!, hours: Int32(hours))
                        })
                        
                        let header = CompanyHours.init(company: company.name!, hours: totalHours)
                        
                        return SectionOfTiming.init(header: header, items: items)
                    })
        
                self?.privateTableItems.accept(timeArr)
            })
            .disposed(by: self.disposeBag)
        
        selectedRow
            .drive(onNext: { [weak self] (indexPath) in
//                self?.privateSelectedCompany.accept((self?.privateDataSource.value[indexPath.row])!)
            })
            .disposed(by: self.disposeBag)
    }
    
    public func viewModelFor(_ vc: inout UIViewController) {
        if let vc = vc as? SelectProjectVC {
//            vc.viewModel = SelectProjectViewModel(company: privateSelectedCompany.value!)
        }
    }
}
