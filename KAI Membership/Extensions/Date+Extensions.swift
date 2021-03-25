//
//  Date+Extensions.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 17/03/2021.
//

import Foundation

extension Date {
    
    func toString(_ dateFormat: String, timeZone: TimeZone? = TimeZone(abbreviation: "GMT+7:00")) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = timeZone
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = dateFormat
        
        return dateFormatter.string(from: self)
    }
}
