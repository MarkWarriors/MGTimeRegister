//
//  NewTimeEntryViewModel.swift
//  MGTimeRegister
//
//  Created by Marco Guerrieri on 02/07/18.
//  Copyright © 2018 Marco Guerrieri. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class NewTimeEntryViewModel: MGTBaseViewModel {
    var disposeBag: DisposeBag = DisposeBag()
    
    private let privatePerformSegue = PublishSubject<(MGTViewModelSegue)>()
    private let privateHoursDataSource = BehaviorRelay<[Int16]>(value: [])
    
    private let privateDate = BehaviorRelay<Date?>(value: nil)
    private let privateHours = BehaviorRelay<Int16>(value: 0)
    private let privateNotes = BehaviorRelay<String>(value: "")
    private let privateCurrentProject : Project
    
    var saveEnabled : Observable<Bool> {
        return Observable
            .combineLatest(privateDate.asObservable(),
                           privateHours.asObservable())
            { (date, hours) -> Bool in
                return date != nil && hours > 0
            }
    }
    
    var hoursDataSource : Observable<[Int16]> {
        return self.privateHoursDataSource.asObservable()
    }
    
    var performSegue : Observable<(MGTViewModelSegue)> {
        return self.privatePerformSegue.asObservable()
    }
    
    
    
    init(project: Project) {
        self.privateCurrentProject = project
        self.privateHoursDataSource.accept(Array(1...24))
    }

    func initBindings(timeEntryDate: Observable<Date>,
                      timeEntryHours: Observable<(row: Int, component: Int)>,
                      timeEntryNotes: Observable<String>,
                      saveTimeEntry: Driver<Void>){
        timeEntryDate.bind(to: self.privateDate).disposed(by: disposeBag)
        
        timeEntryHours
            .bind(onNext: { (row, component) in
                self.privateHours.accept(self.privateHoursDataSource.value[row])
            })
            .disposed(by: disposeBag)
        
        timeEntryNotes.bind(to: self.privateNotes).disposed(by: disposeBag)
        
        saveTimeEntry.drive(onNext: { [weak self] in
            self?.saveTimeEntry()
        })
        .disposed(by: disposeBag)
        
    }
    
    private func saveTimeEntry(){
        ModelController.shared.managedObjectContext.performAndWait {
            let timeEntry = ModelController.shared.new(forEntity: ModelController.Entity.time) as! Time
            timeEntry.date = self.privateDate.value!.startOfDay() as NSDate
            timeEntry.hours = self.privateHours.value
            timeEntry.notes = self.privateNotes.value
            self.privateCurrentProject.addToTimes(timeEntry)
            ModelController.shared.save()
        }
    }
    
    
}
