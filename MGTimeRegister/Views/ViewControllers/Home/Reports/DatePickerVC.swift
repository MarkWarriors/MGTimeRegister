//
//  DatePickerVC.swift
//  MGTimeRegister
//
//  Created by Marco Guerrieri on 05/07/18.
//  Copyright © 2018 Marco Guerrieri. All rights reserved.
//

import UIKit

class DatePickerVC: MGTBaseVC, ViewModelBased {
    typealias ViewModel = DatePickerViewModel
    var viewModel: DatePickerViewModel?
    

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var closeBtn: MGButton!
    @IBOutlet weak var pickDateBtn: MGButton!
    @IBOutlet weak var todayBtn: MGButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModel()
    }
    
    func bindViewModel(){
        viewModel!.initBindings(selectedDate: datePicker.rx.date.asObservable(),
                                todayBtnPressed: todayBtn.rx.tap.asDriver(),
                                pickDateBtnPressed: pickDateBtn.rx.tap.asDriver(),
                                closeBtnPressed: closeBtn.rx.tap.asDriver())
        
        viewModel!.pickerShowedDate.bind(to: datePicker.rx.date).disposed(by: disposeBag)

        datePicker.minimumDate = viewModel!.minSelectableDate.value
        datePicker.maximumDate = viewModel!.maxSelectableDate.value
        
        viewModel!.dismissModal
            .bind { [weak self] (_) in
                self?.dismiss(animated: true, completion: nil)
            }
            .disposed(by: self.disposeBag)

    }
    
}
