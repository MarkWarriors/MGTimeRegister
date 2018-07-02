//
//  SharedInstance.swift
//  MGTimeRegister
//
//  Created by Marco Guerrieri on 02/07/18.
//  Copyright © 2018 Marco Guerrieri. All rights reserved.
//

import Foundation

public class SharedInstance : NSObject {
    
    public static let shared = SharedInstance()
    
    public var currentUser : User?
    
    
    
}
