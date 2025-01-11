//
//  AuthViewModel.swift
//  Luvly
//
//  Created by Hyungjae Kim on 25/10/2024.
//

import Foundation

protocol AuthenticationFormProtocol {
    var formIsValid: Bool { get }
}

@MainActor
class AuthViewModel: ObservableObject {
    static let shared = AuthViewModel()
    @Published var userSession: Bool = false
    @Published var user: User?
    @Published var userID: String?
    private var timer: Timer?
    @Published var luvCount: Int?
    private var datetimeManager = DatetimeManager()
    @Published var tabSelection: Int = 2
    
    init() {
        let defaults = UserDefaults.standard
        self.userSession = defaults.object(forKey:"userSession") as? Bool ?? false
        if let userData = defaults.data(forKey: "user") {
            let decoder = JSONDecoder()
            
            if let decodedUser = try? decoder.decode(User.self, from: userData) {
                self.user = decodedUser
            }
        }
        self.userID = defaults.object(forKey:"userID") as? String
    }
    
    func startLuvCount() {
        Task {
            try await getLuvCount()
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            Task {
                try await self.getLuvCount()
            }
        }
    }
    
    func logIn(email: String, password: String) async throws {
        // Define the URL
        guard let url = URL(string: "http://10.35.2.180:8000/login") else {
            throw URLError(.badURL)
        }
        
        // Prepare request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Create request body
        let requestBody: [String: Any] = ["email": email, "password": password]
        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        
        // Perform request
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Check response
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        // Decode response
        let decoder = JSONDecoder()
        let logInResponse = try decoder.decode(CredentialsResponse.self, from: data)
        
        // Handle response
        if logInResponse.status == "200", let userID = logInResponse.user_id {
            print("User login with ID: \(userID)")
            DispatchQueue.main.async {
                self.userSession = true
                self.user = User(userID: userID, email: email)
                self.userID = userID
                self.tabSelection = 2
                let defaults = UserDefaults.standard
                defaults.set(self.userSession, forKey: "userSession")
                let encoder = JSONEncoder()
                if let encoded = try? encoder.encode(self.user) {
                    defaults.set(encoded, forKey: "user")
                }
                defaults.set(self.userID, forKey: "userID")
            }
        } else {
            print("Failed to login user: Status code \(logInResponse.status)")
            throw NSError(domain: "CreateUserError", code: Int(logInResponse.status) ?? 0, userInfo: nil)
        }
        
    }
    
    func createUser(email: String, password: String) async throws {
        // Define the URL
        guard let url = URL(string: "http://10.35.2.180:8000/register") else {
            throw URLError(.badURL)
        }
        
        // Prepare request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Create request body
        let requestBody: [String: Any] = ["email": email, "password": password]
        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        
        // Perform request
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Check response
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        // Decode response
        let decoder = JSONDecoder()
        let registerResponse = try decoder.decode(CredentialsResponse.self, from: data)
        
        // Handle response
        if registerResponse.status == "200" {
            print("User waiting for email verification")
        } else {
            print("Failed to create user: Status code \(registerResponse.status)")
            throw NSError(domain: "CreateUserError", code: Int(registerResponse.status) ?? 0, userInfo: nil)
        }
    }
    
    func verifyUser(email: String, password: String, verificationCode: String) async throws {
        // Define the URL
        guard let url = URL(string: "http://10.35.2.180:8000/verify_email") else {
            throw URLError(.badURL)
        }
        
        // Prepare request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Create request body
        let requestBody: [String: Any] = ["email": email, "password": password, "verification_code": verificationCode]
        // print(requestBody)
        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        
        // Perform request
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Check response
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        // Decode response
        let decoder = JSONDecoder()
        let verifyResponse = try decoder.decode(CredentialsResponse.self, from: data)
        
        if verifyResponse.status == "200", let userID = verifyResponse.user_id {
            print("User created with ID: \(userID)")
            DispatchQueue.main.async {
                self.userSession = true
                self.user = User(userID: userID, email: email)
                self.userID = userID
                self.tabSelection = 2
                let defaults = UserDefaults.standard
                defaults.set(self.userSession, forKey: "userSession")
                let encoder = JSONEncoder()
                if let encoded = try? encoder.encode(self.user) {
                    defaults.set(encoded, forKey: "user")
                }
                defaults.set(self.userID, forKey: "userID")
            }
        } else {
            print("Failed to create user: Status code \(verifyResponse.status)")
            throw NSError(domain: "CreateUserError", code: Int(verifyResponse.status) ?? 0, userInfo: nil)
        }
    }
    
    func logOut() {
        self.userSession = false
        self.user = nil
        self.userID = nil
        
        let defaults = UserDefaults.standard
        defaults.set(self.userSession, forKey: "userSession")
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(self.user) {
            defaults.set(encoded, forKey: "user")
        }
        defaults.set(self.userID, forKey: "userID")
        
        timer?.invalidate()
        timer = nil
    }
    
    func deleteAccount() {
        
    }
    
    func fetchUser() async {
        
    }
    
    func getLuvCount() async throws {
        print("getLuvCount called")
        // Define the URL
        guard let url = URL(string: "http://10.35.2.180:8000/get_matches/\(self.userID!)") else {
            throw URLError(.badURL)
        }
        
        // Prepare request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Perform request
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Check response
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        // Decode response
        let decoder = JSONDecoder()
        let matchesResponse = try decoder.decode([MatchesResponse].self, from: data)
        print(matchesResponse)
        // Handle response
        if matchesResponse.isEmpty {
            self.luvCount = 0
        } else {
            self.luvCount = matchesResponse.count
        }
        // print("getLuvCount successful")
    }
    
    func updateLuv(luvEmail: String) async throws {
        // Define the URL
        guard let url = URL(string: "http://10.35.2.180:8000/update_luv") else {
            throw URLError(.badURL)
        }
        
        // Prepare request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Create request body
        let requestBody: [String: Any] = ["user_id": self.userID!, "luv_email": luvEmail, "date_time": datetimeManager.getCurrentDatetime()]
        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        
        // Perform request
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Check response
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        // Decode response
        let decoder = JSONDecoder()
        let registerResponse = try decoder.decode(CredentialsResponse.self, from: data)
        
        // Handle response
        if registerResponse.status != "200" {
            print("Failed to update luv")
        } else {
            print("Update luv successfully")
        }
    }
}
