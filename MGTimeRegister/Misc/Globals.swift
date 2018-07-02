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

    struct Prefs {
    }
    
    struct Unity {
    }
    
    struct Timing {
        static let RequestTimeout : Double = 120.0
        static let OverlayAnimation : Double = 0.3
    }
    
    struct Database {
        static let dbVersion : UInt64 = 1
    }
    
    struct Analytics {
        struct Screens {
        }
        
        struct Actions {
        }
    }
    
    
    struct Colors {
        static let red : UIColor = UIColor.init(red: 255.0/255.0, green: 44.0/255.0, blue: 89.0/255.0, alpha: 1)
    }    
    
    struct UrlScheme {
        
    }
}
