//
//  LikeCount.swift
//  Luvly
//
//  Created by Hyungjae Kim on 25/10/2024.
//

import SwiftUI

struct LuvCountView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @Binding var locationModel: LocationModel
    
    var body: some View {
        NavigationStack {
            VStack {
                // Image
                Image("logoplaceholder")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .padding(.vertical, 32)
                
                VStack(spacing: 16) {
                    Text("Luvs")
                        .font(.system(size: 48))
                        .bold()

                    if let luvCount = viewModel.luvCount {
                        Text("\(luvCount)")
                            .font(.system(size: 48))
                            .bold()
                    }
                }
                .padding(.top, 80)
                .task {
                    if viewModel.userSession {
                        viewModel.startLuvCount()
                        locationModel.startUpdatingLocation(userID: viewModel.userID!)
                    }
                }
            }
            
            Spacer()
            
            /*
            NavigationLink {
                SelectView()
                    .navigationBarBackButtonHidden(true)
            } label: {
                Text("Select Your Luv")
                    .fontWeight(.bold)
            }
             */
        }
    }
}

#Preview {
}
