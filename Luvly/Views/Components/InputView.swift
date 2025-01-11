//
//  InputeView.swift
//  Luvly
//
//  Created by Hyungjae Kim on 25/10/2024.
//

import SwiftUI

struct InputView: View {
    @Binding var text: String
    let title: String
    let placeholder: String
    var isSecureField = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .fontWeight(.semibold)
            
            if isSecureField {
                SecureField(placeholder, text: $text)
            } else {
                if title == "Email" {
                    TextField(placeholder, text: $text)
                        .keyboardType(.emailAddress)
                } else {
                    TextField(placeholder, text: $text)
                }
            }
        }
    }
}

#Preview {
    InputView(text: .constant(""), title: "Email", placeholder: "hyungjae@stanford.edu")
}
