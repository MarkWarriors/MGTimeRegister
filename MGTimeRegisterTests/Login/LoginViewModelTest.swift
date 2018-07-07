//
//  LoginViewModelTest.swift
//  MGTimeRegisterTests
//
//  Created by Marco Guerrieri on 07/07/18.
//  Copyright © 2018 Marco Guerrieri. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa

@testable import MGTimeRegister

class LoginViewModelTest: XCTestCase {
    
    let testUsername = "NotExistentUser"
    let testPassword = "NotExistentUserPassword"
    
    let disposeBag = DisposeBag()
    var loginVM : LoginViewModel?
    let viewDidAppear = PublishRelay<Void>()
    let loginBtn = PublishRelay<Void>()
    let usernameTF = PublishRelay<String>()
    let passwordTF = PublishRelay<String>()
    let saveCredentialsSwitch = PublishRelay<Bool>()
    var createdUser : User?

    
    override func setUp() {
        super.setUp()
        loginVM = LoginViewModel.init()
        
        loginVM?.initBindings(viewDidAppear: viewDidAppear.asDriver(onErrorJustReturn: Void()),
                              loginBtnPressed: loginBtn.asDriver(onErrorJustReturn: Void()),
                              usernameTF: usernameTF.asObservable(),
                              passwordTF: passwordTF.asObservable(),
                              saveCredentialsSwitch: saveCredentialsSwitch.asObservable())
    }
    
    override func tearDown() {
        createdUser = ModelController.shared.listAllElements(forEntityName: ModelController.Entity.user.rawValue,
                                                             predicate: NSPredicate.init(format: "username = %@ AND password = %@", testUsername, testPassword)).first as? User
        if createdUser != nil {
            ModelController.shared.managedObjectContext.delete(createdUser!)
            try? ModelController.shared.managedObjectContext.save()
        }
        
        super.tearDown()
    }
    
    func testLoginWithoutCredentials() {
        let loadingExpectation = self.expectation(description: "show and dismiss loading expectation")
        loadingExpectation.expectedFulfillmentCount = 2
        
        let errorExpectation = self.expectation(description: "show error expectation")

        loginVM?.isLoading.bind(onNext: { (loading) in
            if loading && loadingExpectation.expectationCount == 0{
                loadingExpectation.fulfillAndCount()
            }
            else if !loading && loadingExpectation.expectationCount == 1 {
                loadingExpectation.fulfillAndCount()
            }
        }).disposed(by: disposeBag)
        
        loginVM?.error.bind(onNext: { (error) in
            errorExpectation.fulfill()
        }).disposed(by: disposeBag)
        
        loginBtn.accept(Void())
        
        wait(for: [loadingExpectation, errorExpectation], timeout: 3)
    }
    
    func testLoginUserNotFound() {
        let loadingExpectation = self.expectation(description: "show and dismiss loading expectation")
        loadingExpectation.expectedFulfillmentCount = 2
        
        let errorExpectation = self.expectation(description: "show error expectation")
        errorExpectation.isInverted = true
        
        let confirmExpectation = self.expectation(description: "show confirm expectation")
        
        let segueExpectation = self.expectation(description: "segue expectation")
        segueExpectation.isInverted = true
        
        loginVM?.isLoading.bind(onNext: { (loading) in
            if loading && loadingExpectation.expectationCount == 0{
                loadingExpectation.fulfillAndCount()
            }
            else if !loading && loadingExpectation.expectationCount == 1 {
                loadingExpectation.fulfillAndCount()
            }
            else {
                loadingExpectation.fulfillAndCount()
            }
        }).disposed(by: disposeBag)
        
        loginVM?.error.bind(onNext: { (error) in
            errorExpectation.fulfill()
        }).disposed(by: disposeBag)
        
        loginVM?.confirmAction.bind(onNext: { (confirm) in
            XCTAssertNotNil(confirm, "nil confirm")
            confirmExpectation.fulfill()
            confirm.callback!(false)
        }).disposed(by: disposeBag)
        
        loginVM?.performSegue.bind(onNext: { (segue) in
            segueExpectation.fulfill()
        }).disposed(by: disposeBag)
        
        usernameTF.accept(testUsername)
        passwordTF.accept(testPassword)
        loginBtn.accept(Void())
        
        wait(for: [loadingExpectation, errorExpectation, confirmExpectation, segueExpectation], timeout: 2)
        
        createdUser = ModelController.shared.listAllElements(forEntityName: ModelController.Entity.user.rawValue,
                                                             predicate: NSPredicate.init(format: "username = %@ AND password = %@", testUsername, testPassword)).first as? User
        
        XCTAssertNil(createdUser)
    }
    
    func testCreateUserAndLogin() {
        let loadingExpectation = self.expectation(description: "show and dismiss loading expectation")
        loadingExpectation.expectedFulfillmentCount = 2
        
        let errorExpectation = self.expectation(description: "show error expectation")
        errorExpectation.isInverted = true
        
        let confirmExpectation = self.expectation(description: "show confirm expectation")
        let segueExpectation = self.expectation(description: "segue expectation")
        
        loginVM?.isLoading.bind(onNext: { (loading) in
            if loading && loadingExpectation.expectationCount == 0{
                loadingExpectation.fulfillAndCount()
            }
            else if !loading && loadingExpectation.expectationCount == 1 {
                loadingExpectation.fulfillAndCount()
            }
            else {
                loadingExpectation.fulfillAndCount()
            }
        }).disposed(by: disposeBag)
        
        loginVM?.error.bind(onNext: { (error) in
            errorExpectation.fulfill()
        }).disposed(by: disposeBag)
        
        loginVM?.confirmAction.bind(onNext: { (confirm) in
            XCTAssertNotNil(confirm, "nil confirm")
            confirmExpectation.fulfill()
            confirm.callback!(true)
        }).disposed(by: disposeBag)
        
        loginVM?.performSegue.bind(onNext: { (segue) in
            XCTAssertNotNil(segue, "nil segue")
            segueExpectation.fulfill()
        }).disposed(by: disposeBag)
        
        createdUser = ModelController.shared.listAllElements(forEntityName: ModelController.Entity.user.rawValue,
                                                             predicate: NSPredicate.init(format: "username = %@ AND password = %@", testUsername, testPassword)).first as? User
        XCTAssertNil(createdUser)
        
        usernameTF.accept(testUsername)
        passwordTF.accept(testPassword)
        loginBtn.accept(Void())
        
        wait(for: [loadingExpectation, errorExpectation, confirmExpectation, segueExpectation], timeout: 2)
        
        createdUser = ModelController.shared.listAllElements(forEntityName: ModelController.Entity.user.rawValue,
                                                          predicate: NSPredicate.init(format: "username = %@ AND password = %@", testUsername, testPassword)).first as? User
        XCTAssertNotNil(createdUser)

        XCTAssertNotNil(SharedInstance.shared.currentUser)
    }
    
    func testLoginWrongCredentials() {
        
        if createdUser == nil {
            createdUser = ModelController.shared.new(forEntity: ModelController.Entity.user) as? User
            createdUser!.username = testUsername
            createdUser!.password = testPassword
        }
        
        let loadingExpectation = self.expectation(description: "show and dismiss loading expectation")
        loadingExpectation.expectedFulfillmentCount = 2
        
        let errorExpectation = self.expectation(description: "show error expectation")
        
        loginVM?.isLoading.bind(onNext: { (loading) in
            if loading && loadingExpectation.expectationCount == 0{
                loadingExpectation.fulfillAndCount()
            }
            else if !loading && loadingExpectation.expectationCount == 1 {
                loadingExpectation.fulfillAndCount()
            }
        }).disposed(by: disposeBag)
        
        loginVM?.error.bind(onNext: { (error) in
            errorExpectation.fulfill()
        }).disposed(by: disposeBag)
        
        usernameTF.accept(testUsername)
        passwordTF.accept("wrongpassword")
        loginBtn.accept(Void())
        
        wait(for: [loadingExpectation, errorExpectation], timeout: 3)
    }
    
    func testLoginSucceed() {
        
        if createdUser == nil {
            createdUser = ModelController.shared.new(forEntity: ModelController.Entity.user) as? User
            createdUser!.username = testUsername
            createdUser!.password = testPassword
        }
        
        let loadingExpectation = self.expectation(description: "show and dismiss loading expectation")
        loadingExpectation.expectedFulfillmentCount = 2
        
        let errorExpectation = self.expectation(description: "show error expectation")
        errorExpectation.isInverted = true
        
        let confirmExpectation = self.expectation(description: "show confirm expectation")
        confirmExpectation.isInverted = true
        
        let segueExpectation = self.expectation(description: "segue expectation")
        
        loginVM?.isLoading.bind(onNext: { (loading) in
            if loading && loadingExpectation.expectationCount == 0{
                loadingExpectation.fulfillAndCount()
            }
            else if !loading && loadingExpectation.expectationCount == 1 {
                loadingExpectation.fulfillAndCount()
            }
        }).disposed(by: disposeBag)
        
        loginVM?.error.bind(onNext: { (error) in
            errorExpectation.fulfill()
        }).disposed(by: disposeBag)
        
        loginVM?.confirmAction.bind(onNext: { (error) in
            confirmExpectation.fulfill()
        }).disposed(by: disposeBag)
        
        loginVM?.performSegue.bind(onNext: { (segue) in
            XCTAssertNotNil(segue, "nil segue")
            segueExpectation.fulfill()
        }).disposed(by: disposeBag)
        
        usernameTF.accept(testUsername)
        passwordTF.accept(testPassword)
        loginBtn.accept(Void())
        
        wait(for: [loadingExpectation, errorExpectation, confirmExpectation, segueExpectation], timeout: 3)

        XCTAssertNotNil(SharedInstance.shared.currentUser)
    }
    
}
