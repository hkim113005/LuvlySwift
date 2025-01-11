//
//  ProfileView.swift
//  Luvly
//
//  Created by Hyungjae Kim on 25/10/2024.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @Binding var locationModel: LocationModel
    
    var body: some View {
        VStack {
            Image("logoplaceholder")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .padding(.vertical, 32)
            List {
                
                Section {
                    Text("hyungjae@stanford.edu")
                        .fontWeight(.semibold)
                        .accentColor(.black)
                        .listRowBackground(Color(.systemGray).opacity(0.1))
                }
                
                Section("General") {
                    HStack {
                        SettingsRowView(imageName: "gear",
                                        title: "Version",
                                        tintColor: Color(.systemGray))
                        
                        Spacer()
                        
                        Text("1.0.0")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                    .listRowBackground(Color(.systemGray).opacity(0.1))
                }
                
                Section("Account") {
                    Button {
                        locationModel.stopUpdatingLocation()
                        viewModel.logOut()
                        print("Log out...")
                    } label: {
                        SettingsRowView(imageName: "arrow.left.circle.fill",
                                        title: "Log Out",
                                        tintColor: Color(.red))
                    }
                    .listRowBackground(Color(.systemGray).opacity(0.1))
                    
                    Button {
                        print("Delete account...")
                    } label: {
                        SettingsRowView(imageName: "xmark.circle.fill",
                                        title: "Delete Account",
                                        tintColor: Color(.red))
                    }
                    .listRowBackground(Color(.systemGray).opacity(0.1))
                }
            }
            .scrollContentBackground(.hidden) // Hides the gray background
            .background(Color(.systemBackground))
        }
    }
}

#Preview {
}
