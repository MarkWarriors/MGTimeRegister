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
    
    let fetchData = PublishRelay<Void>()
    let logoutBtn = PublishRelay<Void>()
    
    var fakeUser : User?
    
    override func setUp() {
        super.setUp()
        overviewVM = OverviewViewModel.init()
        
        overviewVM?.initBindings(fetchDataSource: fetchData.asDriver(onErrorJustReturn: Void()),
                                 logoutBtn: logoutBtn.asDriver(onErrorJustReturn: Void()))
        
        fakeUser = ModelController.shared.new(forEntity: ModelController.Entity.user) as? User
        fakeUser!.username = testUsername
        fakeUser!.password = testPassword
        
        SharedInstance.shared.loginUser(fakeUser!, storeCredential: false)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testFetchData() {
        XCTAssertNotNil(SharedInstance.shared.currentUser, "current user nil")
        
        overviewVM!.usernameText.bind(onNext: { (text) in
            XCTAssert(text == self.fakeUser!.username)
        }).disposed(by: disposeBag)
        
        overviewVM!.companiesText.bind(onNext: { (text) in
            XCTAssert(text != "" && Int(text) != nil)
        }).disposed(by: disposeBag)
        
        overviewVM!.projectsText.bind(onNext: { (text) in
            XCTAssert(text != "" && Int(text) != nil)
        }).disposed(by: disposeBag)
        
        overviewVM!.effortText.bind(onNext: { (text) in
            XCTAssert(text != "" && Int(text) != nil)
        }).disposed(by: disposeBag)
        
        fetchData.accept(Void())
        
    }
    
    func testLogoutCanceled() {
        XCTAssertNotNil(SharedInstance.shared.currentUser, "current user nil")
        
        let confirmExpectation = self.expectation(description: "show confirm")
        overviewVM?.confirmAction.bind(onNext: { (confirm) in
            confirmExpectation.fulfill()
            confirm.callback?(false)
        }).disposed(by: disposeBag)
        
        logoutBtn.accept(Void())
        
        wait(for: [confirmExpectation], timeout: 1)
        
        XCTAssertNotNil(SharedInstance.shared.currentUser, "current user nil")
    }
    
    func testLogoutConfirm() {
        XCTAssertNotNil(SharedInstance.shared.currentUser, "current user nil")
        
        let confirmExpectation = self.expectation(description: "show confirm")
        let logoutExpectation = self.expectation(description: "logout confirm")
        
        overviewVM?.confirmAction.bind(onNext: { (confirm) in
            confirm.callback?(true)
            confirmExpectation.fulfill()
        }).disposed(by: disposeBag)
        
        logoutBtn.accept(Void())
        
        
        DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(2)) {
            XCTAssertNil(SharedInstance.shared.currentUser, "current user not nil")
            logoutExpectation.fulfill()
        }
        wait(for: [confirmExpectation, logoutExpectation], timeout: 3)
    }
    
}
