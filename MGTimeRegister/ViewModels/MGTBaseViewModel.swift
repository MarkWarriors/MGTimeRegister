//
//  MGTBaseViewModel.swift
//  MGTimeRegister
//
//  Created by Marco Guerrieri on 02/07/18.
//  Copyright © 2018 Marco Guerrieri. All rights reserved.
//

import Foundation
import RxSwift

public class MGTBaseViewModel : NSObject {
    
    internal var disposeBag = DisposeBag()
    
    deinit {
        self.disposeBag = DisposeBag()
    }
    
}
