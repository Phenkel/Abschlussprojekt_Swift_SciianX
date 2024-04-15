//
//  SciianXTests.swift
//  SciianXTests
//
//  Created by Philipp Henkel on 10.01.24.
//

import XCTest
@testable import SciianX

final class AuthenticationViewModelTests: XCTestCase {
    
    func testLoginSuccess() {
        let viewModel = AuthenticationViewModel(authenticationRepository: MockAuthenticationRepository(), mailCheckRepository: MockMailCheckRepository())
        
        viewModel.login(
            mail: "valid@mail.com",
            password: "validPassword"
        )
        
        XCTAssertNotNil(viewModel.user)
        XCTAssertTrue(viewModel.errorMessage.isEmpty)
    }
    
    func testLoginFailure() {
        let viewModel = AuthenticationViewModel(authenticationRepository: MockAuthenticationRepository(), mailCheckRepository: MockMailCheckRepository())
        
        viewModel.login(
            mail: "invalid@mail.com",
            password: "invalidPassword"
        )
        
        XCTAssertNil(viewModel.user)
        XCTAssertFalse(viewModel.errorMessage.isEmpty)
    }
    
    func testRegisterSuccess() async {
        let viewModel = AuthenticationViewModel(authenticationRepository: MockAuthenticationRepository(), mailCheckRepository: MockMailCheckRepository())
        
        await viewModel.register(
            mail: "valid@mail.com",
            password: "validPassword",
            passwordConfirm: "validPassword",
            realName: "John Doe",
            userName: "johndoe"
        )
        
        _ = await XCTWaiter.fulfillment(of: [expectation(description: "waitForClosueToFinish")], timeout: 1, enforceOrder: true)
        
        XCTAssertNotNil(viewModel.user)
        XCTAssertTrue(viewModel.errorMessage.isEmpty)
    }
    
    func testRegisterFailure() async {
        let viewModel = AuthenticationViewModel(authenticationRepository: MockAuthenticationRepository(), mailCheckRepository: MockMailCheckRepository())
        
        await viewModel.register(
            mail: "invalid@mail.com",
            password: "invalidPassword",
            passwordConfirm: "invalidPassword",
            realName: "realName",
            userName: "userName"
        )
        
        _ = await XCTWaiter.fulfillment(of: [expectation(description: "waitForClosueToFinish")], timeout: 1, enforceOrder: true)
        
        XCTAssertNil(viewModel.user)
        XCTAssertFalse(viewModel.errorMessage.isEmpty)
    }
}
