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
    
    private let privateUsernameText = BehaviorRelay<String>(value: "")
    private let privateCompaniesText = BehaviorRelay<String>(value: "0")
    private let privateProjectsText = BehaviorRelay<String>(value: "0")
    private let privateEffortText = BehaviorRelay<String>(value: "0")
    
    var usernameText : Observable<String> {
        return Observable.just((SharedInstance.shared.currentUser?.username)!)
    }
    
    var companiesText : Observable<String> {
        return privateCompaniesText.asObservable()
    }
    
    var projectsText : Observable<String> {
        return privateProjectsText.asObservable()
    }
    
    var effortText : Observable<String> {
        return privateEffortText.asObservable()
    }

    public func initBindings(fetchDataSource: Driver<Void>,
                             logoutBtn: Driver<Void>){
        logoutBtn
            .drive(onNext: { _ in
                SharedInstance.shared.logout()
            })
            .disposed(by: disposeBag)
        
        fetchDataSource
            .drive(onNext: { [weak self] (_) in
                ModelController.shared.managedObjectContext.performAndWait {
                    let companies = ModelController.shared.countElements(forEntityName: ModelController.Entity.company.rawValue)
                    self?.privateCompaniesText.accept(String(companies))
                    
                    let projects = ModelController.shared.countElements(forEntityName: ModelController.Entity.project.rawValue)
                    self?.privateProjectsText.accept(String(projects))
                    
                    let effort = ModelController.shared.sum(forEntityName: ModelController.Entity.time.rawValue, column: "hours")
                    self?.privateEffortText.accept(String(effort))
                }
            })
            .disposed(by: self.disposeBag)
    }
}
