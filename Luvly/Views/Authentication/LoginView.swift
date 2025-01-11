//
//  LoginView.swift
//  Luvly
//
//  Created by Hyungjae Kim on 25/10/2024.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                // Image
                Image("logoplaceholder")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .padding(.vertical, 32)

                // Form fields
                VStack(spacing: 16) {
                    InputView(text: $email,
                              title: "Email",
                              placeholder: "example@stanford.edu")
                    .autocapitalization(.none)
                    InputView(text: $password,
                              title: "Password",
                              placeholder: "Enter Your Password",
                              isSecureField: true)
                }
                .padding(.horizontal, 16)
                .padding(.top, 40)
                
                // Login button
                Button {
                    Task {
                        try await viewModel.logIn(email: email, password: password)
                    }
                } label: {
                    HStack {
                        Text("Log In")
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.black)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                }
                .background(Color(.systemGray).opacity(0.1))
                .disabled(!formIsValid)
                .opacity(formIsValid ? 1.0 : 0.5)
                .cornerRadius(10)
                .padding(.top, 32)
                
                Spacer()

                // Sign up button
                NavigationLink {
                    RegistrationView()
                        .navigationBarBackButtonHidden(true)
                } label: {
                    HStack(spacing: 5) {
                        Text("Dont have an account?")
                        Text("Sign Up")
                            .fontWeight(.bold)
                    }
                }
            }
        }
    }
}

extension LoginView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
        && !password.isEmpty
        && email.contains("@")
        
    }
}

#Preview {
    LoginView()
}
