//
//  RegistrationViewModel.swift
//  My Notes
//
//  Created by Tamim on 1/12/2023.
//

import Foundation

@MainActor class RegistrationViewModel: ObservableObject {
    @MainActor @Published var auth: Auth = Auth.init(username: "", password: "")
    @MainActor @Published var signUpButtonEnabled = false
    @MainActor @Published var showAlert = false
    @MainActor @Published var registrationSuccess = false
    
    let service: AuthenticationServiceProtocol
    
    init(service: AuthenticationServiceProtocol) {
        self.service = service
    }
    
    //Validate input fields
    func validateCredentials() {
        signUpButtonEnabled = !auth.username.isEmpty && !auth.password.isEmpty
    }
    
    //Handle sign up including showing alert for success/failure
    func signUpButtonPressed() async{
        let success = await service.register(auth: auth)
        self.showAlert = true
        self.registrationSuccess = success
        if success {
            self.auth.username = ""
            self.auth.password = ""
        }
    }
}
