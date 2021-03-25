//
//  Double+Extensions.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 27/02/2021.
//

import UIKit

extension Double {
    
    func formatTimeIntervalToString(_ dateFormat: String, addTime time: TimeInterval? = nil, timeZone: TimeZone = TimeZone.current) -> String {
        var day = Date(timeIntervalSince1970: self)
        
        if let time = time { day.addTimeInterval(time) }
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = timeZone
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = dateFormat
        
        return dateFormatter.string(from: day)
    }
    
    func formatCurrencyToString(unit: UnitCurrency = .kai, groupingSeparator: CurrencySeparator = .comma, decimalSeparator: CurrencySeparator = .dots) -> String {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = groupingSeparator.rawValue
        formatter.decimalSeparator = decimalSeparator.rawValue
        formatter.numberStyle = .decimal
        
        let numberStr: String = formatter.string(for: self) ?? "0"
        
        return "\(numberStr)\(unit.rawValue)"
    }
    
    func formatCurrencyToAttributedString(unit: UnitCurrency = .kai, groupingSeparator: CurrencySeparator = .comma, decimalSeparator: CurrencySeparator = .dots, font: UIFont, unitFont: UIFont? = nil, textColor: UIColor = .black) -> NSAttributedString {
        let groupString: String = formatCurrencyToString(unit: unit, groupingSeparator: groupingSeparator, decimalSeparator: decimalSeparator)
        let mutableAttributedString = NSMutableAttributedString(attributedString: NSAttributedString(string: groupString, attributes: [
            NSAttributedString.Key.foregroundColor: textColor,
            NSAttributedString.Key.font: font
        ]))
        
        if let unitFont = unitFont {
            let lengthUnit: Int = unit.rawValue.count
            mutableAttributedString.addAttribute(NSAttributedString.Key.font, value: unitFont, range: NSRange(location: groupString.count - lengthUnit, length: lengthUnit))
        }
        
        return mutableAttributedString
    }
    
    func formatToString(groupingSeparator: CurrencySeparator = .comma, decimalSeparator: CurrencySeparator = .dots) -> String {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = groupingSeparator.rawValue
        formatter.decimalSeparator = decimalSeparator.rawValue
        formatter.numberStyle = .decimal
        
        return formatter.string(for: self) ?? "0"
    }
}
