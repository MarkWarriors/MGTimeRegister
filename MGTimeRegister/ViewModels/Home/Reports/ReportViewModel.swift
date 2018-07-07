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


enum Flags : String {
    case pickDateFrom = "dateFrom"
    case pickDateTo = "dateTo"
}

class ReportViewModel: MGTBaseViewModel {
    var disposeBag: DisposeBag = DisposeBag()
    
    private let privatePerformSegue = PublishSubject<(MGTViewModelSegue)>()
    private let privateTableItems = BehaviorRelay<[ReportData]>(value: [])
    private let privateDateFrom = BehaviorRelay<Date?>(value: Date().changeOfWeeks(-1))
    private let privateDateTo = BehaviorRelay<Date?>(value: Date())
    private let privateSearchText = BehaviorRelay<String?>(value: nil)
    private var privateReportTimeList : (project: Project, times: [Time])?
    
    var tableItems : Observable<[ReportData]> {
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
        return "\(self.privateTableItems.value[section].header.totalHours) h"
    }
    
    let itemsToCell = RxTableViewSectionedReloadDataSource<ReportData>(
        configureCell: { (_, tv, indexPath, projectHours) in
            let cell = tv.dequeueReusableCell(withIdentifier: ProjectTableViewCell.identifier) as! ProjectTableViewCell
            cell.nameLbl.text = projectHours.project.name
            cell.hoursLbl.text = "\(projectHours.totalHours)"
            return cell
    })

    
    public func initBindings(viewWillAppear: Driver<Void>,
                             todayBtnPressed: Driver<Void>,
                             lastWeekBtnPressed: Driver<Void>,
                             lastMonthBtnPressed: Driver<Void>,
                             searchText: Observable<String?>,
                             selectedItem: Driver<ProjectHours>,
                             dateFromBtnPressed: Driver<Void>,
                             dateToBtnPressed: Driver<Void>) {
        
        todayBtnPressed.drive(onNext: { [weak self] _ in
            self?.privateDateFrom.accept(Date())
            self?.privateDateTo.accept(Date())
        })
        .disposed(by: disposeBag)
        
        lastWeekBtnPressed.drive(onNext: { [weak self] _ in
                self?.privateDateFrom.accept(Date().changeOfWeeks(-1))
                self?.privateDateTo.accept(Date())
            })
            .disposed(by: disposeBag)
        
        lastMonthBtnPressed.drive(onNext: { [weak self] _ in
                self?.privateDateFrom.accept(Date().changeOfMonths(-1))
                self?.privateDateTo.accept(Date())
            })
            .disposed(by: disposeBag)
        
        Observable
            .combineLatest(
                viewWillAppear.asObservable(),
                searchText
                    .throttle(2, scheduler: MainScheduler.instance)
                    .distinctUntilChanged()
                    .asObservable(),
                self.privateDateFrom
                    .asObservable(),
                self.privateDateTo
                    .asObservable())
            .bind { [weak self] (_, text, dateFrom, dateTo) in
                    self?.fetchData(text: text, dateFrom: dateFrom?.startOfDay(), dateTo: dateTo?.endOfDay())
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
        
        selectedItem.drive(onNext: { [weak self] (projectHours) in
            let predicateArray : [NSPredicate] = self?.createFetchPredicate(text: nil,
                                                                            dateFrom: self?.privateDateFrom.value?.startOfDay(),
                                                                            dateTo: self?.privateDateTo.value?.startOfDay()) ?? []
            
            let project = projectHours.project
            let times = Array(projectHours.project.times?.filtered(using: NSCompoundPredicate.init(andPredicateWithSubpredicates: predicateArray)) ?? []) as! [Time]
            
            self?.privateReportTimeList = (project: project, times: times)
            self?.privatePerformSegue.onNext(MGTViewModelSegue.init(identifier: Segues.Home.Reports.toReportTimeList))
        })
        .disposed(by: disposeBag)

    }
    
    private func createFetchPredicate(text: String?, dateFrom: Date?, dateTo: Date?) -> [NSPredicate] {
        var predicateArray : [NSPredicate] = []
        predicateArray.append(NSPredicate.init(format: "hours > 0"))
        
        if text != nil && (text?.count)! > 0 {
            predicateArray.append(NSPredicate.init(format: "SUBQUERY(project, $p, $p.name BEGINSWITH[c] %@).@count != 0 OR SUBQUERY(project, $p, SUBQUERY($p.company, $c, $c.name BEGINSWITH[c] %@).@count != 0) != NULL", text!, text!))
        }
        
        if dateFrom != nil {
            predicateArray.append(NSPredicate.init(format: "date >= %@", dateFrom! as NSDate))
        }
        
        if dateTo != nil {
            predicateArray.append(NSPredicate.init(format: "date <= %@", dateTo! as NSDate))
        }
        return predicateArray
    }
    
    private func fetchData(text: String?, dateFrom: Date?, dateTo: Date?){
        ModelController.shared.managedObjectContext.perform { [weak self] in

            let predicateArray : [NSPredicate] = self?.createFetchPredicate(text: text,
                                                                            dateFrom: dateFrom,
                                                                            dateTo: dateTo) ?? []
            
            
            let sortDescriptors : [NSSortDescriptor] = [
                NSSortDescriptor.init(key: "project.company.name", ascending: true, selector: #selector(NSString.caseInsensitiveCompare)),
                NSSortDescriptor.init(key: "project.name", ascending: true, selector: #selector(NSString.caseInsensitiveCompare))
            ]
                                                       
            
            var sectionsMap : [Company:[Project:Int32]] = [:]
            
            if let times = ModelController.shared.listAllElements (
                forEntityName: ModelController.Entity.time.rawValue,
                predicate: NSCompoundPredicate.init(andPredicateWithSubpredicates: predicateArray),
                descriptors: sortDescriptors) as? [Time], times.count > 0{
                
                times.forEach({ (time) in
                    let company = time.project!.company!
                    let project = time.project!
                    // Faster code, see https://stackoverflow.com/questions/42486686/swiftier-swift-for-add-to-array-or-create-if-not-there
                    var projDict = sectionsMap.removeValue(forKey: company) ?? [:]
                    projDict[project] = (projDict[project] ?? 0) + Int32(time.hours)
                    sectionsMap[company] = projDict
                })
            }
            
            let sortedSections = sectionsMap.sorted(by: { $0.key.name!.compare($1.key.name!, options: .caseInsensitive) == .orderedAscending })
            
            let dataSource = sortedSections.map({ (company, projHours) -> ReportData in
                var companyHours = CompanyHours.init(company: company, totalHours: 0)
                var items : [ProjectHours] = []
                
                let sortedProjHours = projHours.sorted(by: { $0.key.name!.compare($1.key.name!, options: .caseInsensitive) == .orderedAscending })
                
                sortedProjHours.forEach({ (project, hours) in
                    companyHours.totalHours = companyHours.totalHours + hours
                    items.append(ProjectHours.init(project: project, totalHours: hours))
                })
                
                return ReportData.init(header: companyHours, items: items)
            })

            self?.privateTableItems.accept(dataSource)
        }
    }
    
    public func viewModelFor(_ vc: inout UIViewController, flag: String?) {
        if let vc = vc as? ReportTimeListVC {
            vc.viewModel = ReportTimeListViewModel(project: privateReportTimeList!.project, times: privateReportTimeList!.times)
        }
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
