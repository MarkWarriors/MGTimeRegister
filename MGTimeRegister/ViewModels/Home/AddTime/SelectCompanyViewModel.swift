//
//  SelectCompanyViewModel.swift
//  MGTimeRegister
//
//  Created by Marco Guerrieri on 02/07/18.
//  Copyright © 2018 Marco Guerrieri. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SelectCompanyViewModel: MGTBaseViewModel {
    var disposeBag: DisposeBag = DisposeBag()
    
    private let privatePerformSegue = PublishSubject<(MGTViewModelSegue)>()
    private let privateDataSource = BehaviorRelay<[Company]>(value: [])
    private var privateSelectedCompany : Company?
    
    var dataSource : Observable<[Company]> {
        return self.privateDataSource.asObservable()
    }
    
    var performSegue : Observable<(MGTViewModelSegue)> {
        return self.privatePerformSegue.asObservable()
    }
    
    public func initBindings(viewWillAppear: Driver<Void>,
                             selectedRow: Driver<IndexPath>,
                             newCompanyBtnPressed: Driver<Void>){
        
        viewWillAppear
            .drive(onNext: { [weak self] (_) in
                self?.reloadDataSource()
            })
            .disposed(by: self.disposeBag)
        
        selectedRow
            .drive(onNext: { [weak self] (indexPath) in
                self?.privateSelectedCompany = self?.privateDataSource.value[indexPath.row]
                self?.privatePerformSegue.onNext (
                    MGTViewModelSegue.init(identifier: Segues.Home.AddTime.pickProject)
                )
            })
            .disposed(by: self.disposeBag)
        
        newCompanyBtnPressed
            .drive(onNext: { [weak self] in
                self?.newCompany()
            })
            .disposed(by: self.disposeBag)
    }
    
    private func reloadDataSource(){
        privateDataSource.accept(SharedInstance.shared.currentUser?.companies?.allObjects as! [Company])
    }
    
    private func newCompany(){
        self.privatePerformSegue.onNext(
            MGTViewModelSegue.init(identifier: Segues.Home.AddTime.newCompany)
        )
    }
    
    public func viewModelFor(_ vc: inout UIViewController) {
        if let vc = vc as? SelectProjectVC {
            vc.viewModel = SelectProjectViewModel(company: privateSelectedCompany!)
        }
        else if let vc = vc as? NewCompanyVC {
            vc.viewModel = NewCompanyViewModel()
        }
    }
    
}
