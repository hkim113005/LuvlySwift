//
//  SelectView.swift
//  Luvly
//
//  Created by Hyungjae Kim on 26/10/2024.
//

import SwiftUI

struct SelectView: View {
    @State private var luvEmail = ""
    @Environment(\.dismiss) var dismiss
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
                    InputView(text: $luvEmail,
                              title: "Their email",
                              placeholder: "example@stanford.edu")
                    .autocapitalization(.none)
                }
                .padding(.horizontal, 16)
                .padding(.top, 80)
                
                // Submit button
                Button {
                    Task {
                        try await viewModel.updateLuv(luvEmail: luvEmail)
                        dismiss()
                    }
                } label: {
                    HStack {
                        Text("Submit")
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.black)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                }
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 1)
                .padding(.top, 32)
                
                Spacer()
            }
        }
    }
}

#Preview {
    SelectView()
}
