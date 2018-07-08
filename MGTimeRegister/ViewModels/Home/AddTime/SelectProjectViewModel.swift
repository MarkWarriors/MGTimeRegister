//
//  SelectProjectViewModel.swift
//  MGTimeRegister
//
//  Created by Marco Guerrieri on 02/07/18.
//  Copyright © 2018 Marco Guerrieri. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SelectProjectViewModel: MGTBaseViewModel {
    var disposeBag: DisposeBag = DisposeBag()
    
    private let privatePerformSegue = PublishRelay<(MGTViewModelSegue)>()
    private let privateDataSource = BehaviorRelay<[Project]>(value: [])
    
    private var privateSelectedProject = BehaviorRelay<Project?>(value: nil)
    
    private let privateCurrentCompany : Company
    
    init(company: Company) {
        self.privateCurrentCompany = company
    }
    
    var companyText : Observable<String> {
        return Observable.just(privateCurrentCompany.name!)
    }
    
    var dataSource : Observable<[Project]> {
        return self.privateDataSource.asObservable()
    }
    
    var performSegue : Observable<(MGTViewModelSegue)> {
        return self.privatePerformSegue.asObservable()
    }
    
    public func initBindings(fetchDataSource: Driver<Void>,
                             selectedRow: Driver<IndexPath>,
                             newProjectBtnPressed: Driver<Void>){
        privateSelectedProject
            .filter{ $0 != nil }
            .bind(onNext: { [weak self] (project) in
                self?.privatePerformSegue.accept(MGTViewModelSegue.init(identifier: Segues.Home.AddTimeEntry.newTimeEntry))
        })
        .disposed(by: disposeBag)
        
        fetchDataSource
            .drive(onNext: { [weak self] (_) in
                self?.reloadDataSource()
            })
            .disposed(by: self.disposeBag)
        
        selectedRow
            .drive(onNext: { [weak self] (indexPath) in self?.privateSelectedProject.accept((self?.privateDataSource.value[indexPath.row])!)
            })
            .disposed(by: self.disposeBag)
        
        newProjectBtnPressed
            .drive(onNext: { [weak self] in
                self?.privatePerformSegue.accept(MGTViewModelSegue.init(identifier: Segues.Home.AddTimeEntry.newProject))
            })
            .disposed(by: self.disposeBag)
    }
    
    private func reloadDataSource(){
        privateDataSource.accept(privateCurrentCompany.projects?.allObjects as! [Project])
    }
    

    public func viewModelFor(_ vc: inout UIViewController) {
        if let vc = vc as? NewTimeEntryVC {
            vc.viewModel = NewTimeEntryViewModel(project: privateSelectedProject.value!)
        }
        else if let vc = vc as? NewProjectVC {
            vc.viewModel = NewProjectViewModel(company: privateCurrentCompany, onProjectSelected: privateSelectedProject)
        }
    }
}
