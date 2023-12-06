//
//  RegistrationViewModelTests.swift
//  My NotesTests
//
//  Created by Tamim on 1/12/2023.
//

import XCTest
@testable import My_Notes

fileprivate class MockAuthenticationService: AuthenticationServiceProtocol {
    var signupSuccess: Bool = false
    func authenticate(auth: Auth) async -> AuthenticationState {
        return .success
    }
    
    func register(auth: Auth) async -> Bool {
        return signupSuccess
    }
}

@MainActor
final class RegistrationViewModelTests: XCTestCase {
    var registrationViewModel: RegistrationViewModel!
    fileprivate let service = MockAuthenticationService()
    override func setUpWithError() throws {
        registrationViewModel = RegistrationViewModel(service: service)
    }
    
    override func tearDownWithError() throws {
        registrationViewModel = nil
    }
    
    //Test Input fields validation
    func testValidateCredentials() {
        registrationViewModel.auth.password = ""
        registrationViewModel.auth.username = ""
        
        registrationViewModel.validateCredentials()
        XCTAssertEqual(registrationViewModel.signUpButtonEnabled, false, "registrationViewModel.validateCredentials is incorrect for empty strings")
        
        registrationViewModel.auth.password = "password"
        registrationViewModel.auth.username = ""
        
        registrationViewModel.validateCredentials()
        XCTAssertEqual(registrationViewModel.signUpButtonEnabled, false, "registrationViewModel.validateCredentials is incorrect for empty username")
        
        registrationViewModel.auth.password = ""
        registrationViewModel.auth.username = "username"
        
        registrationViewModel.validateCredentials()
        XCTAssertEqual(registrationViewModel.signUpButtonEnabled, false, "registrationViewModel.validateCredentials is incorrect for empty password")
        
        registrationViewModel.auth.password = "password"
        registrationViewModel.auth.username = "username"
        
        registrationViewModel.validateCredentials()
        XCTAssertEqual(registrationViewModel.signUpButtonEnabled, true, "registrationViewModel.validateCredentials is incorrect for non-empty password")
    }
    
    //Test sign up API
    func testSignup() async{
        service.signupSuccess = true
        registrationViewModel.auth.password = "password"
        registrationViewModel.auth.username = "username"
        await registrationViewModel.signUpButtonPressed()
        
        XCTAssertEqual(registrationViewModel.registrationSuccess, true, "Sign up success test failed")
        
        XCTAssertEqual(registrationViewModel.auth.username, "", "Username clearing after signup test failed")
        XCTAssertEqual(registrationViewModel.auth.password, "", "password clearing after signup test failed")

        
        service.signupSuccess = false
        registrationViewModel.auth.password = "password"
        registrationViewModel.auth.username = "username"
        await registrationViewModel.signUpButtonPressed()
        
        XCTAssertEqual(registrationViewModel.registrationSuccess, false, "Sign up failure test failed")
    }
    
    //Test if alert displayed after sign up
    func testAlert() async {
        service.signupSuccess = true
        registrationViewModel.auth.password = "password"
        registrationViewModel.auth.username = "username"
        await registrationViewModel.signUpButtonPressed()
        XCTAssertEqual(registrationViewModel.showAlert, true, "Signup alert test failed")
        
        service.signupSuccess = false
        await registrationViewModel.signUpButtonPressed()
        XCTAssertEqual(registrationViewModel.showAlert, true, "Sign up failure alert test failed")
    }
}
