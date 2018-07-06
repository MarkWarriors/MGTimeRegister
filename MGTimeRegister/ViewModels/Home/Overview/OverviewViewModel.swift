//
//  OverviewViewModel.swift
//  MGTimeRegister
//
//  Created by Marco Guerrieri on 02/07/18.
//  Copyright © 2018 Marco Guerrieri. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


class OverviewViewModel: MGTBaseViewModel {
    var disposeBag: DisposeBag = DisposeBag()
    
    private let privateCompaniesText = BehaviorSubject<String>(value: "0")
    private let privateProjectsText = BehaviorSubject<String>(value: "0")
    private let privateEffortText = BehaviorSubject<String>(value: "0")
    
    var companiesText : Observable<String> {
        return privateCompaniesText.asObservable()
    }
    
    var projectsText : Observable<String> {
        return privateProjectsText.asObservable()
    }
    
    var effortText : Observable<String> {
        return privateProjectsText.asObservable()
    }

    public func initBindings(fetchDataSource: Driver<Void>){
        fetchDataSource
            .drive(onNext: { [weak self] (_) in
                var companiesText : Observable<String> {
                    let companies = ModelController.shared.countElements(forEntityName: ModelController.Entity.company.rawValue)
                    return Observable.just(String(format: "%ld", companies))
                }
                
                var projectsText : Observable<String> {
                    let projects = ModelController.shared.countElements(forEntityName: ModelController.Entity.project.rawValue)
                    return Observable.just(String(format: "%ld", projects))
                }
                
                var effortText : Observable<String> {
                    let effort = ModelController.shared.sum(forEntityName: ModelController.Entity.time.rawValue, column: "hours")
                    return Observable.just(String(format: "%ld", effort))
                }

            })
            .disposed(by: self.disposeBag)
    }
}
