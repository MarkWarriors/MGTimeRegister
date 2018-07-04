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
    private var privateSelectedCompany = BehaviorRelay<Company?>(value: nil)

    
    var dataSource : Observable<[Company]> {
        return self.privateDataSource.asObservable()
    }
    
    var performSegue : Observable<(MGTViewModelSegue)> {
        return self.privatePerformSegue.asObservable()
    }
    
    public func initBindings(fetchDataSource: Driver<Void>,
                             selectedRow: Driver<IndexPath>,
                             newCompanyBtnPressed: Driver<Void>){
        
        privateSelectedCompany
            .filter{ $0 != nil }
            .bind(onNext: { [weak self] (project) in
                self?.privatePerformSegue.onNext(MGTViewModelSegue.init(identifier: Segues.Home.AddTimeEntry.selectProject))
            })
            .disposed(by: disposeBag)
        
        fetchDataSource
            .drive(onNext: { [weak self] (_) in
                self?.privateDataSource.accept(SharedInstance.shared.currentUser?.companies?.allObjects as! [Company])
            })
            .disposed(by: self.disposeBag)
        
        selectedRow
            .drive(onNext: { [weak self] (indexPath) in
                self?.privateSelectedCompany.accept((self?.privateDataSource.value[indexPath.row])!)
            })
            .disposed(by: self.disposeBag)
        
        newCompanyBtnPressed
            .drive(onNext: { [weak self] in
                self?.privatePerformSegue.onNext(MGTViewModelSegue.init(identifier: Segues.Home.AddTimeEntry.newCompany))
            })
            .disposed(by: self.disposeBag)
    }
    
    public func viewModelFor(_ vc: inout UIViewController) {
        if let vc = vc as? SelectProjectVC {
            vc.viewModel = SelectProjectViewModel(company: privateSelectedCompany.value!)
        }
        else if let vc = vc as? NewCompanyVC {
            vc.viewModel = NewCompanyViewModel(onCompanySelected: privateSelectedCompany)
        }
    }
    
}
