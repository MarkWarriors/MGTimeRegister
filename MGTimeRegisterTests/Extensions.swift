//
//  Extensions.swift
//  MGTimeRegisterTests
//
//  Created by Marco Guerrieri on 07/07/18.
//  Copyright © 2018 Marco Guerrieri. All rights reserved.
//

import XCTest

extension XCTestExpectation {
    
    private struct AssociatedKey {
        static var expectationCountKey = "expCountKey"
    }
    
    var expectationCount:Int {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.expectationCountKey) as? Int ?? 0
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.expectationCountKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    open func fulfillAndCount(){
        self.fulfill()
        self.expectationCount += 1
    }
}
