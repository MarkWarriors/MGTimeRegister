//
//  OverviewViewModelTest.swift
//  MGTimeRegisterTests
//
//  Created by Marco Guerrieri on 07/07/18.
//  Copyright © 2018 Marco Guerrieri. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa

@testable import MGTimeRegister

class OverviewViewModelTest: XCTestCase {
    
    let testUsername = "NotExistentUser"
    let testPassword = "NotExistentUserPassword"
    
    let disposeBag = DisposeBag()
    var overviewVM : OverviewViewModel?
    
    let fetchData = Driver<Void()>
    let logoutBtn = Driver<Void()>
    
    override func setUp() {
        super.setUp()
        overviewVM = OverviewViewModel.init()
        
        overviewVM?.initBindings(fetchDataSource: fetchData,
                                 logoutBtn: <#T##SharedSequence<DriverSharingStrategy, Void>#>)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testA() {
        
    }
    
    
}
