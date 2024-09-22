//
//  File.swift
//  WeatherSDK
//
//  Created by Sushant Shinde on 22/09/24.
//

import Foundation

extension DateFormatter {
    static let hourMinute: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = TimeZone.current
        return formatter
    }()
    
    static let iso8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone.current
        return formatter
    }()
}


extension Date {
    
    func toHourMinuteString(timeZone: TimeZone = .current) -> String {
        let formatter = DateFormatter.hourMinute
        let mutableFormatter = formatter
        mutableFormatter.timeZone = timeZone
        return mutableFormatter.string(from: self)
    }
    
    func nextFullHour() -> Date? {
        let calendar = Calendar.current
        return calendar.nextDate(after: self, matching: DateComponents(minute: 0, second: 0), matchingPolicy: .nextTime)
    }
    
    init?(iso8601String: String) {
        guard let date = DateFormatter.iso8601.date(from: iso8601String) else {
            return nil
        }
        self = date
    }
}
