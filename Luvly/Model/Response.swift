//
//  Response.swift
//  Luvly
//
//  Created by Hyungjae Kim on 26/10/2024.
//

import Foundation

struct CredentialsResponse: Decodable {
    let status: String
    let user_id: String?
}

struct MatchesResponse: Decodable {
    let send_id: String
    let receive_id: String
    let distance: Double
    let date_time: String
}
