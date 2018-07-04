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
    
    private let privateDismissModal = PublishSubject<(Void)>()
    private let privateCompanyName = BehaviorRelay<String>(value: "")
    private let privateCompanySelected = PublishRelay<Company>()
    
    var companySelected : Observable<Company> {
        return self.privateCompanySelected.asObservable()
    }
    
    var dismissModal : Observable<Void> {
        return self.privateDismissModal.asObservable()
    }

    var buttonEnabled : Observable<Bool> {
        return privateCompanyName.map { $0 != "" }.asObservable()
    }
    
    init(onCompanySelected: BehaviorRelay<Company?>) {
        privateCompanySelected.bind(to: onCompanySelected).disposed(by: disposeBag)
    }
    
    public func initBindings(newCompanyName: Observable<String>,
                             saveBtnPressed: Driver<Void>,
                             closeBtnPressed: Driver<Void>) {
        
        newCompanyName.bind(to: privateCompanyName).disposed(by: disposeBag)
        
        closeBtnPressed
            .drive(onNext: { [weak self] in
                self?.privateDismissModal.onNext(Void())
            })
            .disposed(by: self.disposeBag)
        
        saveBtnPressed
            .drive(onNext: { [weak self] in
                self?.privateDismissModal.onNext(Void())
                self?.createCompany()
            })
            .disposed(by: self.disposeBag)
    }
    
    private func createCompany() {
        ModelController.shared.managedObjectContext.performAndWait {
            let company = ModelController.shared.new(forEntity: ModelController.Entity.company) as! Company
            company.name = privateCompanyName.value
            SharedInstance.shared.currentUser?.addToCompanies(company)
            ModelController.shared.save()
            self.privateDismissModal.onNext(Void())
            self.privateCompanySelected.accept(company)
        }
    }
    
}
