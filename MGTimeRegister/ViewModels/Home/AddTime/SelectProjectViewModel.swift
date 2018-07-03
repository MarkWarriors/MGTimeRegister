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
    
    private let privatePerformSegue = PublishSubject<(MGTViewModelSegue)>()
    private let privateDataSource = BehaviorRelay<[Project]>(value: [])
    private let privateCurrentCompany : Company
    private var privateSelectedProject : Project?
    
    init(company: Company) {
        self.privateCurrentCompany = company
    }
    
    var dataSource : Observable<[Project]> {
        return self.privateDataSource.asObservable()
    }
    
    var performSegue : Observable<(MGTViewModelSegue)> {
        return self.privatePerformSegue.asObservable()
    }
    
    public func initBindings(viewWillAppear: Driver<Void>,
                             selectedRow: Driver<IndexPath>,
                             newProjectBtnPressed: Driver<Void>){
        
        viewWillAppear
            .drive(onNext: { [weak self] (_) in
                self?.reloadDataSource()
            })
            .disposed(by: self.disposeBag)
        
        selectedRow
            .drive(onNext: { [weak self] (indexPath) in
                self?.privateSelectedProject = self?.privateDataSource.value[indexPath.row]
                self?.privatePerformSegue.onNext(
                    MGTViewModelSegue.init(identifier: Segues.Home.AddTime.newTimeEntry)
                )
            })
            .disposed(by: self.disposeBag)
        
        newProjectBtnPressed
            .drive(onNext: { [weak self] in
                self?.newProjectForCompany()
            })
            .disposed(by: self.disposeBag)
    }
    
    private func reloadDataSource(){
        privateDataSource.accept(privateCurrentCompany.projects?.allObjects as! [Project])
    }
    
    private func newProjectForCompany(){
        self.privatePerformSegue.onNext(
            MGTViewModelSegue.init(identifier: Segues.Home.AddTime.newProject)
        )
    }
    
    public func viewModelFor(_ vc: inout UIViewController) {
        if let vc = vc as? NewTimeEntryVC {
            vc.viewModel = NewTimeEntryViewModel(project: privateSelectedProject!)
        }
        else if let vc = vc as? NewProjectVC {
            vc.viewModel = NewProjectViewModel(company: privateCurrentCompany)
        }
    }
}
