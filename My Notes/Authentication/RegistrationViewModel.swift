//
//  RegistrationViewModel.swift
//  My Notes
//
//  Created by Tamim on 1/12/2023.
//

import Foundation

@MainActor
@Observable
class RegistrationViewModel {
    var auth: Auth = Auth.init(username: "", password: "")
    var signUpButtonEnabled = false
    var showAlert = false
    var registrationSuccessful = false
    
    let service: AuthenticationServiceProtocol
    
    init(service: AuthenticationServiceProtocol) {
        self.service = service
    }
    
    //Validate input fields
    func validateCredentials() {
        signUpButtonEnabled = !auth.username.isEmpty && !auth.password.isEmpty
    }
    
    //Handle sign up including showing alert for success/failure
    func signUpButtonPressed() async {
        let auth = self.auth
        let success = await service.register(auth: auth)
        self.showAlert = true
        self.registrationSuccessful = success
        if success {
            self.auth.username = ""
            self.auth.password = ""
        }
    }
}
