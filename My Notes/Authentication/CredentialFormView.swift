//
//  CredentialFormView.swift
//  My Notes
//
//  Created by Tamim on 1/12/2023.
//

import SwiftUI

struct CredentialFormView: View {
    @Binding var auth: Auth
    var body: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 11) {
                Text("Username")
                    .font(.system(size: 13, weight: .light))
                    .foregroundColor(.white)
                    .frame(height: 15, alignment: .leading)
                TextField("", text: $auth.username)
                    .font(.system(size: 17, weight: .light))
                    .foregroundColor(.primary)
                    .frame(height: 44)
                    .background(.white)
                    .cornerRadius(4.0)
            }
            VStack(alignment: .leading, spacing: 11) {
                Text("Password")
                    .font(.system(size: 13, weight: .light))
                    .foregroundColor(.white)
                    .frame(height: 15, alignment: .leading)
                SecureField("", text: $auth.password)
                    .font(.system(size: 17, weight: .light))
                    .foregroundColor(.primary)
                    .frame(height: 44)
                    .background(Color.white)
                    .cornerRadius(4.0)
            }
        }
    }
}

#Preview {
    CredentialFormView(auth: .constant(Auth(username: "", password: ""))).preferredColorScheme(.dark)
}
