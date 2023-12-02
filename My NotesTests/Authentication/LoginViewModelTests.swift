//
//  LoginViewModelTests.swift
//  My NotesTests
//
//  Created by Tamim on 1/12/2023.
//

import XCTest

fileprivate class MockAuthenticationService: AuthenticationServiceProtocol {
    var loginSuccess: AuthenticationState = .success
    func authenticate(auth: Auth) async -> AuthenticationState {
        return loginSuccess
    }
    
    func register(auth: Auth) async -> Bool {
        return true
    }
}

fileprivate class MockDatabaseService: DatabaseServiceProtocol {
    var isLoggedIn: Bool = false
    
    func setLoginStatus(isLoggedIn: Bool, username: String?) {
        self.isLoggedIn = isLoggedIn
    }
}

final class LoginViewModelTests: XCTestCase {
    var loginViewModel: LoginViewModel!
    fileprivate let service = MockAuthenticationService()
    fileprivate let database = MockDatabaseService()
    
    @MainActor override func setUpWithError() throws {
        loginViewModel = LoginViewModel(service: service, databaseService: database)
    }

    override func tearDownWithError() throws {
        loginViewModel = nil
    }
    
    @MainActor func testAuthentication() async {
        service.loginSuccess = .success
        loginViewModel.auth = Auth(username: "test", password: "test")
        await loginViewModel.loginButtonPressed()
        
        XCTAssertEqual(loginViewModel.authenticationState, .success, "Success login authentication test failed")
        
        service.loginSuccess = .failed
        await loginViewModel.loginButtonPressed()
        XCTAssertEqual(loginViewModel.authenticationState, .failed, "Failed login authentication test failed")
    }
    
    @MainActor func testValidateCredentials() {
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
    
    @MainActor func testSetLoginStatus() {
        loginViewModel.loginSuccessfullAlertPressed()
        XCTAssertEqual(database.isLoggedIn, true, "testSetLoginStatus is false")
    }
    
    @MainActor func testAlert() async {
        service.loginSuccess = .success
        loginViewModel.auth = Auth(username: "test", password: "test")
        await loginViewModel.loginButtonPressed()
        XCTAssertEqual(loginViewModel.showAlert, true, "Success login alert test failed")
        
        service.loginSuccess = .failed
        await loginViewModel.loginButtonPressed()
        XCTAssertEqual(loginViewModel.showAlert, true, "Login alert test failed")
    }

}
