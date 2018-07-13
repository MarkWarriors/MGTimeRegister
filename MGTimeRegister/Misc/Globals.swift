//
//  Globals.swift
//  MGTimeRegister
//
//  Created by Marco Guerrieri on 02/07/18.
//  Copyright © 2018 Marco Guerrieri. All rights reserved.
//

import Foundation
import UIKit

class Globals {

    class PrefsKeys {
        static let loggedUsername : String = "loggedUsername"
        static let loggedPassword : String = "loggedPassword"
    }
    
    class Timing {
        static let transitionFromBottom : Double = 0.3
        static let overlayAnimation : Double = 0.3
        static let toggleAnimation : Double = 0.3
    }
    
    class Database {
        static let dbVersion : UInt64 = 1
    }
    
    class Colors {
        static let red : UIColor = UIColor.init(red: 255.0/255.0, green: 0.0/255.0, blue: 39.0/255.0, alpha: 1)
    }    
    
}
