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
        self.disposeBag = DisposeBag()
        
        viewWillAppear.drive(onNext: { (_) in
            self.reloadDataSource()
        })
            .disposed(by: self.disposeBag)
        
        selectedRow.drive(onNext: { (row) in
            self.privatePerformSegue.onNext(
                MGTViewModelSegue.init(identifier: Segues.Home.AddTime.pickProject)
            )
        })
            .disposed(by: self.disposeBag)
        
        newProjectBtnPressed
            .drive(onNext: { [unowned self] in
                self.newProject()
            })
            .disposed(by: self.disposeBag)
    }
    
    private func reloadDataSource(){
        
    }
    
    private func newProject(){
        self.privatePerformSegue.onNext(
            MGTViewModelSegue.init(identifier: Segues.Home.AddTime.newProject)
        )
    }
    
    public func prepareVCForSegue(_ vc: UIViewController) {
        //        if vc is OverviewVC {
        //            (vc as! OverviewVC).viewModel = OverviewViewModel()
        //        }
    }
}
