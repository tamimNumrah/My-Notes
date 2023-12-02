//
//  RegistrationView.swift
//  My Notes
//
//  Created by Tamim on 1/12/2023.
//

import SwiftUI

struct RegistrationView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var model: RegistrationViewModel
    var body: some View {
        VStack {
            CredentialFormView(auth: $model.auth)
                .onChange(of: model.auth) { newValue in
                    model.validateCredentials()
                }
            Button {
                Task {
                    await model.signUpButtonPressed()
                }
            } label: {
                Text("Sign Up")
                    .foregroundColor(.white)
                    .font(.system(size: 18))
                    .frame(width: 215, height: 44, alignment: .center)
                    .opacity(model.signUpButtonEnabled ? 1.0 : 0.5)
            }
            .background(.secondary)
            .cornerRadius(4)
            .padding(.top, 40)
            .disabled(!model.signUpButtonEnabled)
            Spacer()
        }
        .padding()
        .background(Color.viewBackground)
        .alert(isPresented: $model.showAlert) {
            Alert(
                title: Text("Sign up \(model.registrationSuccess ? "successful":"failed")"),
                dismissButton: .default(Text("Okay"), action: {
                    if model.registrationSuccess {
                        self.dismiss()
                    }
                })
            )
        }
    }
}

#Preview {
    RegistrationView(model: RegistrationViewModel(service: AuthenticationService()))
}
