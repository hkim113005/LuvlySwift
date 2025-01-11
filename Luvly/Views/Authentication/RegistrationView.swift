//
//  RegistrationView.swift
//  Luvly
//
//  Created by Hyungjae Kim on 25/10/2024.
//

import SwiftUI

struct RegistrationView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var navigateToVerificationView = false
    
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
                    ZStack(alignment: .trailing) {
                        InputView(text: $confirmPassword,
                                  title: "Confirm Password",
                                  placeholder: "Confirm Your Password",
                                  isSecureField: true)
                        
                        if !password.isEmpty && !confirmPassword.isEmpty && password != confirmPassword {
                            Text("Passwords do not match")
                                .foregroundColor(.red)
                                .font(.caption)
                                .offset(y: -16)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 40)
                
                // Login button
                Button {
                    Task {
                        navigateToVerificationView = true
                        try await viewModel.createUser(email: email, password: password)
                    }
                } label: {
                    HStack {
                        Text("Sign Up")
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.black)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                }
                .background(Color(.systemGray).opacity(0.1))
                .opacity(formIsValid ? 1.0 : 0.5)
                .disabled(!formIsValid)
                .cornerRadius(10)
                .padding(.top, 32)
                .navigationDestination(isPresented: $navigateToVerificationView) {
                    VerificationView(email: $email, password: $password)
                }
                .navigationBarBackButtonHidden(true)
                
                
                Spacer()
                
                
                // Sign up button
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 5) {
                        Text("Already have an account?")
                        Text("Log in")
                            .fontWeight(.bold)
                    }
                }
            }
        }
    }
}

extension RegistrationView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
        && !password.isEmpty
        && !confirmPassword.isEmpty
        && email.contains("@")
        && password == confirmPassword
        
    }
}

#Preview {
    RegistrationView()
}
