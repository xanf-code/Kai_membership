//
//  Int+Extensions.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 18/03/2021.
//

import Foundation

extension Int {
    
    func formatToString(groupingSeparator: CurrencySeparator = .comma, decimalSeparator: CurrencySeparator = .dots) -> String {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = groupingSeparator.rawValue
        formatter.decimalSeparator = decimalSeparator.rawValue
        formatter.numberStyle = .decimal
        
        return formatter.string(for: self) ?? "0"
    }
}
