//
//  LoginViewModel.swift
//  My Notes
//
//  Created by Tamim on 30/11/2023.
//

import Foundation

@MainActor 
@Observable class LoginViewModel {
    var auth: Auth = Auth.init(username: "", password: "")
    var loginButtonEnabled = false
    var showAlert = false
    var authenticationState: AuthenticationState = .failed

    let service: AuthenticationServiceProtocol
    let databaseService: DatabaseServiceProtocol
    init(service: AuthenticationServiceProtocol, databaseService: DatabaseServiceProtocol) {
        self.service = service
        self.databaseService = databaseService
    }
    
    //validate input fields
    func validateCredentials() {
        loginButtonEnabled = !auth.username.isEmpty && !auth.password.isEmpty
    }
    
    //handle authentication and show alert
    func loginButtonPressed() async {
        let state = await service.authenticate(auth: auth)
        self.showAlert = true
        self.authenticationState = state
    }
    
    //Move to Notes list by setting login status true
    func loginSuccessfullAlertPressed() {
        databaseService.setLoginStatus(isLoggedIn: true, username: auth.username)
    }
}
