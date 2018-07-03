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
    private let privateDataSource = BehaviorRelay<[Company]>(value: [])
    
    var dataSource : Observable<[Company]> {
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
            .drive(onNext: { [weak self] (row) in
                self?.privatePerformSegue.onNext(
                    MGTViewModelSegue.init(identifier: Segues.Home.AddTime.newTimeEntry, viewModel: NewTimeEntryViewModel())
                )
            })
            .disposed(by: self.disposeBag)
        
        newProjectBtnPressed
            .drive(onNext: { [weak self] in
                self?.newProject()
            })
            .disposed(by: self.disposeBag)
    }
    
    private func reloadDataSource(){
        
    }
    
    private func newProject(){
        self.privatePerformSegue.onNext(
            MGTViewModelSegue.init(identifier: Segues.Home.AddTime.newProject, viewModel: NewProjectViewModel())
        )
    }
    
    public func prepareVCForSegue(_ vc: UIViewController) {
        //        if vc is OverviewVC {
        //            (vc as! OverviewVC).viewModel = OverviewViewModel()
        //        }
    }
}
