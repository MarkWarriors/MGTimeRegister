//
//  DatePickerViewModel.swift
//  MGTimeRegister
//
//  Created by Marco Guerrieri on 05/07/18.
//  Copyright © 2018 Marco Guerrieri. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class DatePickerViewModel: MGTBaseViewModel {
    var disposeBag: DisposeBag = DisposeBag()
    
    private let privateDateSelected = PublishRelay<Date>()
    private let privateCurrentDate = BehaviorRelay<Date>(value: Date())
    private let privateDismissModal = PublishSubject<(Void)>()
    
    var dismissModal : Observable<Void> {
        return self.privateDismissModal.asObservable()
    }
    
    var pickerShowedDate = BehaviorRelay<Date>(value: Date())
    var maxSelectableDate = BehaviorRelay<Date?>(value: nil)
    var minSelectableDate = BehaviorRelay<Date?>(value: nil)
    
    init(withDate startDate: Date?, maxSelectableDate: Date?, minSelectableDate: Date?, onDateSelected: BehaviorRelay<Date?>) {
        self.privateDateSelected.bind(to: onDateSelected).disposed(by: disposeBag)
        self.privateCurrentDate.accept(startDate ?? Date())
        
        self.pickerShowedDate.accept(startDate ?? Date())
        self.maxSelectableDate.accept(maxSelectableDate)
        self.minSelectableDate.accept(minSelectableDate)
    }
    
    func initBindings(selectedDate: Observable<Date>,
                      todayBtnPressed: Driver<Void>,
                      pickDateBtnPressed: Driver<Void>,
                      closeBtnPressed: Driver<Void>){

        selectedDate.bind(to: self.privateCurrentDate).disposed(by: disposeBag)

        todayBtnPressed
            .drive(onNext: { [weak self] in
                self?.pickerShowedDate.accept(Date())
            })
            .disposed(by: self.disposeBag)
        
        closeBtnPressed
            .drive(onNext: { [weak self] in
                self?.privateDismissModal.onNext(Void())
            })
            .disposed(by: self.disposeBag)
        
        pickDateBtnPressed
            .drive(onNext: { [weak self] in
                if let selectedDate = self?.privateCurrentDate.value {
                    self?.privateDateSelected.accept(selectedDate)
                    self?.privateDismissModal.onNext(Void())
                }
            })
            .disposed(by: self.disposeBag)
        
    }
    
    
}
