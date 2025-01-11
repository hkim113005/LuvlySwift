//
//  VerificationInputView.swift
//  Luvly
//
//  Created by Hyungjae Kim on 29/10/2024.
//

import SwiftUI

struct VerificationInputView: View {
    let numberOfFields: Int
    @Binding var verificationCode: [String]
    @State var oldValue = ""
    @FocusState private var fieldFocus: Int?
    
    var body: some View {
        HStack {
            ForEach(0 ..< 6, id: \.self) { index in
                TextField("", text: $verificationCode[index], onEditingChanged: { editing in
                    if editing {
                        oldValue = verificationCode[index]
                    }
                })
                .keyboardType(.numberPad)
                .frame(width: 40, height: 50)
                .background(Color(.secondarySystemBackground).opacity(0.1))
                .cornerRadius(5)
                .multilineTextAlignment(.center)
                .focused($fieldFocus, equals: index)
                .tag(index)
                .onChange(of: verificationCode[index]) { newValue in
                    if verificationCode[index].count > 1 {
                        let currentValue = Array(verificationCode[index])
                        
                        if currentValue[0] == Character(oldValue) {
                            verificationCode[index] = String(verificationCode[index].suffix(1))
                        } else {
                            verificationCode[index] = String(verificationCode[index].prefix(1))
                        }
                    }
                    if !newValue.isEmpty {
                        if index == numberOfFields - 1 {
                            fieldFocus = nil
                        } else {
                            fieldFocus = (fieldFocus ?? 0) + 1
                        }
                    } else {
                        fieldFocus = (fieldFocus ?? 0) - 1
                    }
                }
            }
        }
        .onAppear {
            self.verificationCode = Array(repeating: "", count: numberOfFields)
        }
    }
}

#Preview {
}
