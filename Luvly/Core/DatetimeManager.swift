//
//  DatetimeManager.swift
//  Luvly
//
//  Created by Hyungjae Kim on 26/10/2024.
//

import Foundation

class DatetimeManager {
    func getCurrentDatetime() -> String {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let fullDateTimeString = dateFormatter.string(from: currentDate)
        return fullDateTimeString
    }
}
