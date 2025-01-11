//
//  LocationModel.swift
//  Luvly
//
//  Created by Hyungjae Kim on 28/10/2024.
//

import Foundation
import CoreLocation

class LocationModel: NSObject, CLLocationManagerDelegate {
    private var locationManager: CLLocationManager?
    private var datetimeManager = DatetimeManager()
    private var userID = ""
    
    override init() {
        
    }
    
    func startUpdatingLocation (userID: String) {
        self.userID = userID
        getUserLocation()
    }
    
    func getUserLocation() {
        locationManager = CLLocationManager()
        locationManager?.requestAlwaysAuthorization()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.allowsBackgroundLocationUpdates = true
        locationManager?.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            Task {
                try await updateLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            }
        }
    }
    
    func updateLocation(latitude: Double, longitude: Double) async throws {
        // Define the URL
        guard let url = URL(string: "http://10.35.2.180:8000/update_location") else {
            throw URLError(.badURL)
        }
        
        // Prepare request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Create request body
        let requestBody: [String: Any] = ["user_id": self.userID, "latitude": String(latitude), "longitude": String(longitude), "date_time": datetimeManager.getCurrentDatetime()]
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
            print("Failed to update location")
        } else {
            print("Updated location successfully")
        }
    }
    
    func stopUpdatingLocation() {
        locationManager?.stopUpdatingLocation()
        print("Stop updating location")
    }
}
