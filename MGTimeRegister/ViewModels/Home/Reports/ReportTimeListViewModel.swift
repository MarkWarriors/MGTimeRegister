//
//  TimeListViewModel.swift
//  
//
//  Created by Marco Guerrieri on 05/07/18.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

class ReportTimeListViewModel: MGTBaseViewModel {
    var disposeBag: DisposeBag = DisposeBag()
    
    private let privatePerformSegue = PublishRelay<(MGTViewModelSegue)>()
    private let privateTableItems = BehaviorRelay<[TimeReportData]>(value: [])
    private var privateSelectedTime = BehaviorRelay<Time?>(value: nil)
    private let currentProject : Project
    private var privateTimes = BehaviorRelay<[Time]>(value: [])
    
    var tableItems : Observable<[TimeReportData]> {
        return self.privateTableItems.asObservable()
    }
    
    init(project: Project, times: [Time]) {
        self.privateTimes.accept(times)
        self.currentProject = project
    }
    
    var projectText : Observable<String> {
        return Observable.just("\(currentProject.company!.name!) > \(currentProject.name!)")
    }
    
    var totalHoursText : Observable<String> {
        return privateTimes
            .asObservable()
            .map({ (timeArray) -> String in
                return String(format: "%ld H", timeArray.reduce(0, { $0 + $1.hours }))
            })
            .asObservable()
    }
    
    var performSegue : Observable<(MGTViewModelSegue)> {
        return self.privatePerformSegue.asObservable()
    }
    
    func projectHeaderTextFor(section: Int) -> String {
        return self.privateTableItems.value[section].header.date
    }
    
    func projectHeaderHoursFor(section: Int) -> String {
        return "\(self.privateTableItems.value[section].header.totalHours) h"
    }
    
    let itemsToCell = RxTableViewSectionedReloadDataSource<TimeReportData>(
        configureCell: { (_, tv, indexPath, time) in
            let cell = tv.dequeueReusableCell(withIdentifier: TimeTableViewCell.identifier) as! TimeTableViewCell
            cell.setModel(time)
            return cell
    },
        canEditRowAtIndexPath: { _,_  in
            return true
    })

    
    public func initBindings(fetchDataSource: Driver<Void>,
                             itemDeleted: Driver<Time>){
        
        privateTimes
            .asObservable()
            .bind { (times) in
                var timeReportDict : [String:[Time]] = [:]
                times.forEach { (time) in
                    let date = (time.date! as Date).toStringDate()
                    var entry = timeReportDict.removeValue(forKey: date) ?? []
                    entry.append(time)
                    timeReportDict[date] = entry
                }
                let items = timeReportDict.map { (date, times) -> TimeReportData in
                        let dateHours = DateHours.init(date: date, totalHours: Int32(times.reduce(0, { $0 + $1.hours })))
                        return TimeReportData.init(header: dateHours, items: times)
                    }.sorted(by: { (timeReport, timeReport2) -> Bool in
                        return (timeReport.items[0].date! as Date) < (timeReport2.items[0].date! as Date)
                    })
                self.privateTableItems.accept(items)
            }.disposed(by: disposeBag)
        
        privateSelectedTime
            .filter{ $0 != nil }
            .bind(onNext: { [weak self] (time) in
                self?.privatePerformSegue.accept(MGTViewModelSegue.init(identifier: Segues.Home.Reports.toTimeDetails))
            })
            .disposed(by: disposeBag)

        itemDeleted
            .drive(onNext: { [weak self] (time) in
                ModelController.shared.managedObjectContext.performAndWait { [weak self] in
                    self?.privateTimes.accept((self?.privateTimes.value.filter { $0 != time })!)
                    ModelController.shared.managedObjectContext.delete(time)
                    ModelController.shared.save()
                }
            })
            .disposed(by: disposeBag)
    }
    
}
