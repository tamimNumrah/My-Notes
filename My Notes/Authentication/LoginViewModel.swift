//
//  LoginViewModel.swift
//  My Notes
//
//  Created by Tamim on 30/11/2023.
//

import Foundation

@MainActor class LoginViewModel: ObservableObject {
    @MainActor @Published var auth: Auth = Auth.init(username: "", password: "")
    @MainActor @Published var loginButtonEnabled = false
    @MainActor @Published var showAlert = false
    @MainActor @Published var authenticationState: AuthenticationState = .failed

    let service: AuthenticationServiceProtocol
    let databaseService: DatabaseServiceProtocol
    init(service: AuthenticationServiceProtocol, databaseService: DatabaseServiceProtocol) {
        self.service = service
        self.databaseService = databaseService
    }
    func validateCredentials() {
        loginButtonEnabled = !auth.username.isEmpty && !auth.password.isEmpty
    }
    
    func loginButtonPressed() async{
        let state = await service.authenticate(auth: auth)
        self.showAlert = true
        self.authenticationState = state
    }
    
    func loginSuccessfullAlertPressed() {
        databaseService.setLoginStatus(isLoggedIn: true, username: auth.username)
    }
}