//
//  ContentView.swift
//  Luvly
//
//  Created by Hyungjae Kim on 25/10/2024.
//

import SwiftUI
import UserNotifications

struct ContentView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State var locationModel = LocationModel()
    @State private var tabSelection = 2
    let notificationCenter = UNUserNotificationCenter.current()
    
    var body: some View {
        Group {
            if viewModel.userSession {
                // VerificationView()
                TabView(selection: $viewModel.tabSelection) {
                    SelectView()
                        .tabItem {
                            Image(systemName: "magnifyingglass")
                        }
                        .tag(0)
                    
                    Text("Matches")
                        .tabItem {
                            Image(systemName: "puzzlepiece.extension")
                        }
                        .tag(1)
                   
                    LuvCountView(locationModel: $locationModel)
                        .tabItem {
                            Image(systemName: "heart")
                        }
                        .tag(2)
                    
                    Text("Notes")
                        .tabItem {
                            Image(systemName: "paperplane")
                        }
                        .tag(3)
                    
                    ProfileView(locationModel: $locationModel)
                        .tabItem {
                            Image(systemName: "person")
                        }
                        .tag(4)
                }
                .accentColor(.red)
            } else {
                LoginView()
            }
        }
        .task {
            do {
                try await notificationCenter.requestAuthorization(options: [.alert, .badge, .sound])
            } catch {
                print("Request authorization error")
            }
        }
    }
}

#Preview {
    ContentView()
}
