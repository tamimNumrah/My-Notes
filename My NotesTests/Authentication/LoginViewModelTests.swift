//
//  LoginViewModelTests.swift
//  My NotesTests
//
//  Created by Tamim on 1/12/2023.
//

import XCTest
import CoreData
@testable import My_Notes

fileprivate final actor MockAuthenticationService: AuthenticationServiceProtocol {
    var loginSuccess: AuthenticationState = .success
    func authenticate(auth: Auth) async -> AuthenticationState {
        return loginSuccess
    }
    
    func register(auth: Auth) async -> Bool {
        return true
    }
    
    func setLoginState(state: AuthenticationState) async {
        guard loginSuccess != state else { return }
        loginSuccess = state
    }
}

final class LoginViewModelTests: XCTestCase {
    var loginViewModel: LoginViewModel!
    fileprivate let service = MockAuthenticationService()
    var database: MockDatabaseService!

    override func setUp() async throws {
        try await super.setUp()
        database = await MockDatabaseService()
        loginViewModel = await LoginViewModel(service: service, databaseService: database)
    }

    override func tearDown() async throws {
        try await super.tearDown()
        loginViewModel = nil
        database = nil
    }
    
    //Test authentication/Login API
    @MainActor
    func testAuthentication() async throws {
        await service.setLoginState(state: .success)
        loginViewModel.auth = Auth(username: "test", password: "test")
        await loginViewModel.loginButtonPressed()
        
        XCTAssertEqual(loginViewModel.authenticationState, .success, "Success login authentication test failed")
        
        await service.setLoginState(state: .failed)
        await loginViewModel.loginButtonPressed()
        XCTAssertEqual(loginViewModel.authenticationState, .failed, "Failed login authentication test failed")
    }
    
    //Test input field validation
    @MainActor
    func testValidateCredentials() async throws {
        loginViewModel.auth.password = ""
        loginViewModel.auth.username = ""
        
        loginViewModel.validateCredentials()
        XCTAssertEqual(loginViewModel.loginButtonEnabled, false, "validateCredentials is incorrect for empty strings")
        
        loginViewModel.auth.password = "password"
        loginViewModel.auth.username = ""
        
        loginViewModel.validateCredentials()
        XCTAssertEqual(loginViewModel.loginButtonEnabled, false, "validateCredentials is incorrect for empty username")
        
        loginViewModel.auth.password = ""
        loginViewModel.auth.username = "username"
        
        loginViewModel.validateCredentials()
        XCTAssertEqual(loginViewModel.loginButtonEnabled, false, "validateCredentials is incorrect for empty password")
        
        loginViewModel.auth.password = "password"
        loginViewModel.auth.username = "username"
        
        loginViewModel.validateCredentials()
        XCTAssertEqual(loginViewModel.loginButtonEnabled, true, "validateCredentials is incorrect for non-empty password")
    }
    
    //Test if login status gets set after alert pressed
    @MainActor
    func testSetLoginStatus() async throws {
        loginViewModel.loginSuccessfullAlertPressed()
        let isLoggedIn = database.isLoggedIn
        XCTAssertEqual(isLoggedIn, true, "testSetLoginStatus is false")
    }
    
    //Test if alert is displayed properly after authentication
    @MainActor
    func testAlert() async throws {
        await service.setLoginState(state: .success)
        loginViewModel.auth = Auth(username: "test", password: "test")
        await loginViewModel.loginButtonPressed()
        XCTAssertEqual(loginViewModel.showAlert, true, "Success login alert test failed")
        
        await service.setLoginState(state: .failed)
        await loginViewModel.loginButtonPressed()
        XCTAssertEqual(loginViewModel.showAlert, true, "Login alert test failed")
    }

}
