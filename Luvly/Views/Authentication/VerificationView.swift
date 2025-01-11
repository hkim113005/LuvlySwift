//
//  VerificationView.swift
//  Luvly
//
//  Created by Hyungjae Kim on 29/10/2024.
//

import SwiftUI

struct VerificationView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthViewModel
    @Binding var email: String
    @Binding var password: String
    @State private var verificationCode = Array(repeating: "", count: 6)
    
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
                    Text("Please Enter Your Verification Code")
                        .fontWeight(.semibold)
                    VerificationInputView(numberOfFields: 6, verificationCode: $verificationCode)
                }
                .padding(.horizontal, 16)
                .padding(.top, 40)
                
                // Verify button
                Button {
                    Task {
                        try await viewModel.verifyUser(email: email, password: password, verificationCode: verificationCode.joined())
                    }
                } label: {
                    HStack {
                        Text("Verify")
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.black)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                }
                .background(Color(.systemGray).opacity(0.1))
                .cornerRadius(10)
                .padding(.top, 32)
                
                Spacer()
                
                // Sign up button
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 5) {
                        Text("Didn't receive your code?")
                        Text("Request again")
                            .fontWeight(.bold)
                    }
                }
            }
        }
    }
}

#Preview {
}
