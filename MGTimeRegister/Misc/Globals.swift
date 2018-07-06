//
//  Globals.swift
//  MGTimeRegister
//
//  Created by Marco Guerrieri on 02/07/18.
//  Copyright © 2018 Marco Guerrieri. All rights reserved.
//

import Foundation
import UIKit

struct Globals {

    struct PrefsKeys {
        static let loggedUsername : String = "loggedUsername"
        static let loggedPassword : String = "loggedPassword"
    }
    
    struct Timing {
        static let overlayAnimation : Double = 0.3
        static let toggleAnimation : Double = 0.3
    }
    
    struct Database {
        static let dbVersion : UInt64 = 1
    }
    
    struct Colors {
        static let red : UIColor = UIColor.init(red: 255.0/255.0, green: 44.0/255.0, blue: 89.0/255.0, alpha: 1)
    }    
    
}
