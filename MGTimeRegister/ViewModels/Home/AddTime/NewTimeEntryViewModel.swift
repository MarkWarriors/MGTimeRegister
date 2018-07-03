//
//  NewTimeEntryViewModel.swift
//  MGTimeRegister
//
//  Created by Marco Guerrieri on 02/07/18.
//  Copyright © 2018 Marco Guerrieri. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class NewTimeEntryViewModel: MGTBaseViewModel {
    var disposeBag: DisposeBag = DisposeBag()
    private let privateCurrentProject : Project
    
    init(project: Project) {
        self.privateCurrentProject = project
    }

}
