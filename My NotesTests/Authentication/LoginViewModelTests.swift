//
//  LoginViewModelTests.swift
//  My NotesTests
//
//  Created by Tamim on 1/12/2023.
//

import XCTest
import CoreData
@testable import My_Notes

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
    var editContext: NSManagedObjectContext = PersistenceController.preview.editContext
    
    var container: NSPersistentContainer = PersistenceController.preview.container
    
    var isLoggedIn: Bool = false
    
    func setLoginStatus(isLoggedIn: Bool, username: String?) {
        self.isLoggedIn = isLoggedIn
    }
}

@MainActor
final class LoginViewModelTests: XCTestCase {
    var loginViewModel: LoginViewModel!
    fileprivate let service = MockAuthenticationService()
    fileprivate let database = MockDatabaseService()
    
    override func setUpWithError() throws {
        loginViewModel = LoginViewModel(service: service, databaseService: database)
    }

    override func tearDownWithError() throws {
        loginViewModel = nil
    }
    
    //Test authentication/Login API
    func testAuthentication() async {
        service.loginSuccess = .success
        loginViewModel.auth = Auth(username: "test", password: "test")
        await loginViewModel.loginButtonPressed()
        
        XCTAssertEqual(loginViewModel.authenticationState, .success, "Success login authentication test failed")
        
        service.loginSuccess = .failed
        await loginViewModel.loginButtonPressed()
        XCTAssertEqual(loginViewModel.authenticationState, .failed, "Failed login authentication test failed")
    }
    
    //Test input field validation
    func testValidateCredentials() {
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
    func testSetLoginStatus() {
        loginViewModel.loginSuccessfullAlertPressed()
        XCTAssertEqual(database.isLoggedIn, true, "testSetLoginStatus is false")
    }
    
    //Test if alert is displayed properly after authentication
    func testAlert() async {
        service.loginSuccess = .success
        loginViewModel.auth = Auth(username: "test", password: "test")
        await loginViewModel.loginButtonPressed()
        XCTAssertEqual(loginViewModel.showAlert, true, "Success login alert test failed")
        
        service.loginSuccess = .failed
        await loginViewModel.loginButtonPressed()
        XCTAssertEqual(loginViewModel.showAlert, true, "Login alert test failed")
    }

}
