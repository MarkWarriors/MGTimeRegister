//
//  NewCompanyViewModel.swift
//  MGTimeRegister
//
//  Created by Marco Guerrieri on 03/07/18.
//  Copyright © 2018 Marco Guerrieri. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class NewCompanyViewModel: MGTBaseViewModel {
    var disposeBag: DisposeBag = DisposeBag()
    
    private let privateCloseVC = PublishSubject<(Void)>()
    private let privatePerformSegue = PublishSubject<(MGTViewModelSegue)>()
    private let privateCompanyName = BehaviorRelay<String>(value: "")
    
    var closeVC : Observable<(Void)> {
        return self.privateCloseVC.asObservable()
    }

    var buttonEnabled : Observable<Bool> {
        return privateCompanyName.map { $0 != "" }.asObservable()
    }
    
    public func initBindings(newCompanyName: Observable<String>,
                             saveBtnPressed: Driver<Void>,
                             closeBtnPressed: Driver<Void>) {
        
        newCompanyName.bind(to: privateCompanyName).disposed(by: disposeBag)
        
        closeBtnPressed
            .drive(onNext: { [weak self] in
                self?.privateCloseVC.onNext(Void())
            })
            .disposed(by: self.disposeBag)
        
        saveBtnPressed
            .drive(onNext: { [weak self] in
                self?.createCompany()
                self?.privateCloseVC.onNext(Void())
            })
            .disposed(by: self.disposeBag)
    }
    
    private func createCompany(){
        let company = ModelController.shared.new(forEntity: ModelController.Entity.company) as! Company
        company.name = privateCompanyName.value
        SharedInstance.shared.currentUser?.addToCompanies(company)
        ModelController.shared.save()
    }
    
}
