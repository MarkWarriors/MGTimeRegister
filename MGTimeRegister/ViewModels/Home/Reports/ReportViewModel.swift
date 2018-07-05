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

enum Flags : String {
    case pickDateFrom = "dateFrom"
    case pickDateTo = "dateTo"
}

class ReportViewModel: MGTBaseViewModel {
    var disposeBag: DisposeBag = DisposeBag()
    
    private let privatePerformSegue = PublishSubject<(MGTViewModelSegue)>()
    private let privateTableItems = BehaviorRelay<[TableSectionData]>(value: [])
    private let privateDateFrom = BehaviorRelay<Date?>(value: nil)
    private let privateDateTo = BehaviorRelay<Date?>(value: nil)
    private let privateSearchText = BehaviorRelay<String?>(value: nil)
    
    var tableItems : Observable<[TableSectionData]> {
        return self.privateTableItems.asObservable()
    }
    
    var dateFromText : Observable<String> {
        return self.privateDateFrom.asObservable().map({ (date) -> String in
            return date != nil ? date!.toStringDate() : Strings.Commons.select
        }).asObservable()
    }
    
    var dateToText : Observable<String> {
        return self.privateDateTo.asObservable().map({ (date) -> String in
            return date != nil ? date!.toStringDate() : Strings.Commons.select
        }).asObservable()
    }
    
    var performSegue : Observable<(MGTViewModelSegue)> {
        return self.privatePerformSegue.asObservable()
    }
    
    func projectHeaderTextFor(section: Int) -> String {
        return self.privateTableItems.value[section].header.company.name ?? ""
    }
    
    func projectHeaderHoursFor(section: Int) -> String {
        return "\(self.privateTableItems.value[section].header.hours) h"
    }
    
    let dataSource = RxTableViewSectionedReloadDataSource<TableSectionData>(
        configureCell: { (_, tv, indexPath, projectHours) in
            let cell = tv.dequeueReusableCell(withIdentifier: ProjectTableViewCell.identifier) as! ProjectTableViewCell
            cell.nameLbl.text = projectHours.project.name
            cell.hoursLbl.text = "\(projectHours.hours)"
            return cell
    })

    
    public func initBindings(fetchDataSource: Driver<Void>,
                             searchText: Observable<String?>,
                             selectedRow: Driver<IndexPath>,
                             dateFromBtnPressed: Driver<Void>,
                             dateToBtnPressed: Driver<Void>) {
        
        Observable
            .combineLatest(
                fetchDataSource.asObservable(),
                searchText
                    .throttle(2, scheduler: MainScheduler.instance)
                    .distinctUntilChanged()
                    .asObservable(),
                self.privateDateFrom
                    .asObservable(),
                self.privateDateTo
                    .asObservable())
            .bind { [weak self] (_, text, dateFrom, dateTo) in
                    self?.fetchData(text: text, dateFrom: dateFrom, dateTo: dateTo)
            }
            .disposed(by: disposeBag)
        
        dateFromBtnPressed
            .drive(onNext: { [weak self] (_) in
                self?.privatePerformSegue.onNext(MGTViewModelSegue.init(identifier: Segues.Home.Reports.pickDate, flag: Flags.pickDateFrom.rawValue))
            })
            .disposed(by: self.disposeBag)
        
        dateToBtnPressed
            .drive(onNext: { [weak self] (_) in
                self?.privatePerformSegue.onNext(MGTViewModelSegue.init(identifier: Segues.Home.Reports.pickDate, flag: Flags.pickDateTo.rawValue))
            })
            .disposed(by: self.disposeBag)

    }
    
    private func fetchData(text: String?, dateFrom: Date?, dateTo: Date?){
        ModelController.shared.managedObjectContext.perform { [weak self] in
            var predicate : NSPredicate?
            
            let startDate : Date? = self?.privateDateFrom.value?.startOfDay()
            let endDate : Date? = self?.privateDateTo.value?.endOfDay()
            
            print("search \(text) from \(startDate?.toStringDate()) to \(endDate?.toStringDate())")
            
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
                predicate: predicate,
                descriptors: [sortDescriptor]) as? [Time], times.count > 0{
                
                times.forEach({ (time) in
                    let company = time.project!.company!
                    let project = time.project!
                    
                    // Faster code, see https://stackoverflow.com/questions/42486686/swiftier-swift-for-add-to-array-or-create-if-not-there
                    var projDict = sectionsMap.removeValue(forKey: company) ?? [:]
                    projDict[project] = (projDict[project] ?? 0) + Int32(time.hours)
                    sectionsMap[company] = projDict
                })
                
                print("founded \(times.count)")
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
    
    public func viewModelFor(_ vc: inout UIViewController, flag: String?) {
        if let vc = vc as? DatePickerVC {
            if flag == Flags.pickDateFrom.rawValue {
                // Date From Picker
                vc.viewModel = DatePickerViewModel(withDate: self.privateDateFrom.value,
                                                   maxSelectableDate: self.privateDateTo.value,
                                                   minSelectableDate: nil,
                                                   onDateSelected: self.privateDateFrom
                )
            }
            if flag == Flags.pickDateTo.rawValue {
                // Date To Picker
                vc.viewModel = DatePickerViewModel(withDate: self.privateDateTo.value,
                                                   maxSelectableDate: nil,
                                                   minSelectableDate: self.privateDateFrom.value,
                                                   onDateSelected: self.privateDateTo
                )
            }
            
        }
    }
}
