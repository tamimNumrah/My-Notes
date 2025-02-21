//
//  RegistrationViewModelTests.swift
//  My NotesTests
//
//  Created by Tamim on 1/12/2023.
//

import XCTest
@testable import My_Notes

fileprivate actor MockAuthenticationService: AuthenticationServiceProtocol {
    var signupSuccess: Bool = false
    func authenticate(auth: Auth) async -> AuthenticationState {
        return .success
    }
    
    func register(auth: Auth) async -> Bool {
        return signupSuccess
    }
    
    func setSignupSuccessState(state: Bool) {
        guard signupSuccess != state else { return }
        signupSuccess = state
    }
}

final class RegistrationViewModelTests: XCTestCase {
    var registrationViewModel: RegistrationViewModel!
    fileprivate let service = MockAuthenticationService()
    
    override func setUp() async throws {
        try await super.setUp()
        registrationViewModel = await RegistrationViewModel(service: service)
    }
    
    override func tearDown() async throws {
        try await super.tearDown()
        registrationViewModel = nil
    }
    
    //Test Input fields validation
    @MainActor
    func testValidateCredentials() async {
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
    @MainActor
    func testSignup() async throws {
        await service.setSignupSuccessState(state: true)
        registrationViewModel.auth.password = "password"
        registrationViewModel.auth.username = "username"
        await registrationViewModel.signUpButtonPressed()
        
        XCTAssertEqual(registrationViewModel.registrationSuccessful, true, "Sign up success test failed")
        
        XCTAssertEqual(registrationViewModel.auth.username, "", "Username clearing after signup test failed")
        XCTAssertEqual(registrationViewModel.auth.password, "", "password clearing after signup test failed")

        
        await service.setSignupSuccessState(state: false)
        registrationViewModel.auth.password = "password"
        registrationViewModel.auth.username = "username"
        await registrationViewModel.signUpButtonPressed()
        
        XCTAssertEqual(registrationViewModel.registrationSuccessful, false, "Sign up failure test failed")
    }
    
    //Test if alert displayed after sign up
    @MainActor
    func testAlert() async {
        await service.setSignupSuccessState(state: true)
        registrationViewModel.auth.password = "password"
        registrationViewModel.auth.username = "username"
        await registrationViewModel.signUpButtonPressed()
        XCTAssertEqual(registrationViewModel.showAlert, true, "Signup alert test failed")
        
        await service.setSignupSuccessState(state: false)
        await registrationViewModel.signUpButtonPressed()
        XCTAssertEqual(registrationViewModel.showAlert, true, "Sign up failure alert test failed")
    }
}
