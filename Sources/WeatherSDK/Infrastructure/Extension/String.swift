//
//  File.swift
//  WeatherSDK
//
//  Created by Sushant Shinde on 22/09/24.
//

import Foundation

extension String {
    
    /// Attempts to convert the string to a `Date` using the provided formatter.
    func toDate(with formatter: DateFormatter) -> Date? {
        return formatter.date(from: self)
    }
    
    /// Attempts to convert an ISO 8601 string to a `Date`.
    func toISO8601Date() -> Date? {
        return Date(iso8601String: self)
    }
}
