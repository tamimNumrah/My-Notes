//
//  Authentication.swift
//  My Notes
//
//  Created by Tamim on 1/12/2023.
//

import Foundation

struct Auth: Equatable {
    var username: String
    var password: String
}
enum AuthenticationState: String {
    case success = "successful"
    case failed = "failed"
}


let authenticationUserDefaultsKey = "authCollection"

//Authentication Service Protocol
protocol AuthenticationServiceProtocol: Sendable {
    func authenticate(auth: Auth) async -> AuthenticationState
    func register(auth: Auth) async -> Bool
}

final actor AuthenticationService: AuthenticationServiceProtocol {
    static let shared = AuthenticationService()
    
    //Login API call
    func authenticate(auth: Auth) async -> AuthenticationState {
#if DEBUG
        if CommandLine.arguments.contains("-passAuthentication") {
            return .success
        } else if CommandLine.arguments.contains("-failAuthentication") {
            return .failed
        }
#endif
        let storedDictionary = UserDefaults.standard.dictionary(forKey: authenticationUserDefaultsKey) as? [String: String] ?? [String:String]()
        if let password = storedDictionary[auth.username], password == auth.password {
            return .success
        }
        return .failed
    }
    //Sign up API call
    func register(auth: Auth) async -> Bool {
#if DEBUG
        if CommandLine.arguments.contains("-passSignUp") {
            return true
        } else if CommandLine.arguments.contains("-failSignUp"){
            return false
        }
#endif
        var storedDictionary = UserDefaults.standard.dictionary(forKey: authenticationUserDefaultsKey) as? [String: String] ?? [String:String]()
        if storedDictionary[auth.username] == nil {
            storedDictionary[auth.username] = auth.password
            UserDefaults.standard.setValue(storedDictionary, forKey: authenticationUserDefaultsKey)
            return true
        }
        return false
    }
}

