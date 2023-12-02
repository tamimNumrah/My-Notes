//
//  My_NotesApp.swift
//  My Notes
//
//  Created by Tamim on 30/11/2023.
//

import SwiftUI

@main
struct My_NotesApp: App {
    @ObservedObject var persistenceController = PersistenceController.shared
    let service = AuthenticationService.shared
    init() {
#if DEBUG
        if CommandLine.arguments.contains("-userLoggedIn") {
            persistenceController.setLoginStatus(isLoggedIn: true, username: "UITest")
        } else if CommandLine.arguments.contains("-userLoggedOut"){
            persistenceController.setLoginStatus(isLoggedIn: false, username: nil)
        }
#endif
    }
    var body: some Scene {
        WindowGroup {
            fetchRootView()
                .animation(.easeInOut, value: persistenceController.isLoggedIn)
        }
    }
    
    @ViewBuilder
    func fetchRootView() -> some View {
        if persistenceController.isLoggedIn, let username = UserDefaults.standard.string(forKey:loggedInUserNameUserDefaultsKey) {
            //Logged in. Show Notes List
            NotesListView(model: NotesListViewModel(viewContext: persistenceController.container.viewContext, username: username, databaseService: persistenceController))
                .transition(.slide)
        } else {
            //Not Logged in. Show Login View
            LogInView(model: LoginViewModel(service: service, databaseService: persistenceController))
                .transition(.slide)
        }
    }
}
