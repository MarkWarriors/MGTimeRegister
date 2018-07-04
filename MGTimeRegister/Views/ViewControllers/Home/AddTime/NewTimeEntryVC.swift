//
//  NewTimeEntryVC.swift
//  MGTimeRegister
//
//  Created by Marco Guerrieri on 02/07/18.
//  Copyright © 2018 Marco Guerrieri. All rights reserved.
//

import UIKit

class NewTimeEntryVC: MGTBaseVC, ViewModelBased {
    typealias ViewModel = NewTimeEntryViewModel
    var viewModel: NewTimeEntryViewModel?
    
    @IBOutlet weak var companyLbl: UILabel!
    @IBOutlet weak var projectLbl: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var hoursPicker: UIPickerView!
    @IBOutlet weak var notesTV: UITextView!
    @IBOutlet weak var saveBtn: MGButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModel()
    }
    
    func bindViewModel(){
        viewModel!.initBindings(timeEntryDate: datePicker.rx.date.asObservable(),
                                timeEntryHours: hoursPicker.rx.itemSelected.asObservable(),
                                timeEntryNotes: notesTV.rx.text.orEmpty.asObservable(),
                                saveTimeEntry: saveBtn.rx.tap.asDriver())
        
        viewModel!.companyText.bind(to: companyLbl.rx.text).disposed(by: disposeBag)
        viewModel!.projectText.bind(to: projectLbl.rx.text).disposed(by: disposeBag)

        viewModel!
            .hoursDataSource
            .bind(to: hoursPicker.rx.itemTitles) { _, item in
                return "\(item)"
            }
            .disposed(by: disposeBag)
        
        viewModel!
            .performSegue
            .bind { [weak self] (segue) in
                self?.performSegue(withIdentifier: segue.identifier, sender: nil)
            }
            .disposed(by: disposeBag)
    }
    
}
