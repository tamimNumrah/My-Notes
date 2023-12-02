//
//  LogInView.swift
//  My Notes
//
//  Created by Tamim on 30/11/2023.
//

import SwiftUI

struct LogInView: View {
    @ObservedObject var model: LoginViewModel
    var body: some View {
        NavigationView {
            VStack {
                CredentialFormView(auth: $model.auth)
                    .onChange(of: model.auth) { newValue in
                        model.validateCredentials()
                    }
                Button {
                    Task {
                        await model.loginButtonPressed()
                    }
                } label: {
                    Text("Login")
                        .foregroundColor(.white)
                        .font(.system(size: 18))
                        .frame(width: 215, height: 44, alignment: .center)
                        .opacity(model.loginButtonEnabled ? 1.0 : 0.5)
                }
                .background(.secondary)
                .cornerRadius(4)
                .padding(.top, 40)
                .disabled(!model.loginButtonEnabled)
                
                NavigationLink(destination: RegistrationView(model: RegistrationViewModel(service: model.service)), label: {
                    Text("Registration")
                        .foregroundColor(.white)
                        .font(.system(size: 13, weight: .light))
                        .padding(.top, 10)
                })
                
                Spacer()
            }
            .padding()
            .background(Color.viewBackground)
            .alert(isPresented: $model.showAlert) {
                Alert(
                    title: Text("Login \(model.authenticationState.rawValue)"),
                    dismissButton: .default(Text("Okay"), action: {
                        if model.authenticationState == .success {
                            withAnimation(.easeInOut) { // add animation
                                self.model.loginSuccessfullAlertPressed()
                            }
                        }
                    })
                )
            }
        }
    }
}

#Preview {
    LogInView(model: LoginViewModel(service: AuthenticationService(), databaseService: PersistenceController.shared))
}
