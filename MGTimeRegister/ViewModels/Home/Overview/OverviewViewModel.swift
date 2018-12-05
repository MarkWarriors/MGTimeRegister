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
    
    private let privateUsernameText = PublishRelay<String>()
    private let privateCompaniesText = PublishRelay<String>()
    private let privateProjectsText = PublishRelay<String>()
    private let privateEffortText = PublishRelay<String>()
    private let privateConfirm = PublishRelay<(MGTConfirm)>()
    
    @available(iOS 3.0, *)
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
    
    var confirmAction : Observable<MGTConfirm> {
        return self.privateConfirm.asObservable()
    }

    public func initBindings(fetchDataSource: Driver<Void>,
                             logoutBtn: Driver<Void>){
        logoutBtn
            .drive(onNext: { [weak self] _ in
                self?.privateConfirm.accept(MGTConfirm.init(title: Strings.Logout.logoutUserTitle,
                                                            message: Strings.Logout.logoutUserText,
                                                            callback: { (confirm) in
                                                                if confirm {
                                                                    SharedInstance.shared.logout()
                                                                }
                }))
            })
            .disposed(by: disposeBag)
        
        fetchDataSource
            .drive(onNext: { [weak self] (_) in
                ModelController.shared.managedObjectContext.performAndWait {
                    let predicateCompanies = NSPredicate.init(format: "SUBQUERY(user, $u, $u.username == %@).@count != 0", (SharedInstance.shared.currentUser?.username)!)
                    let predicateProjects = NSPredicate.init(format: "SUBQUERY(company, $c, SUBQUERY($c.user, $u, $u.username == %@).@count != 0) != NULL", (SharedInstance.shared.currentUser?.username)!)
                    let predicateEffort =  NSPredicate.init(format: "SUBQUERY(project, $p, SUBQUERY($p.company, $c, SUBQUERY($c.user, $u, $u.username == %@).@count != 0) != NULL) != NULL", (SharedInstance.shared.currentUser?.username)!)
                    
                    let companies = ModelController.shared.countElements(forEntityName: ModelController.Entity.company.rawValue, predicate: predicateCompanies)
                    self?.privateCompaniesText.accept(String(companies))
                    
                    let projects = ModelController.shared.countElements(forEntityName: ModelController.Entity.project.rawValue, predicate: predicateProjects)
                    self?.privateProjectsText.accept(String(projects))
                    
                    let effort = ModelController.shared.sum(forEntityName: ModelController.Entity.time.rawValue, column: "hours", predicate: predicateEffort)
                    self?.privateEffortText.accept(String(effort))
                }
            })
            .disposed(by: self.disposeBag)
        
    }
}
