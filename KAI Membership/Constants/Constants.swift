//
//  Constants.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 24/02/2021.
//

import UIKit

enum CurrencySeparator: String {
    case dots = "."
    case comma = ","
}

enum UnitCurrency: String {
    case kai = " KAI"
    case vnd = " VNĐ"
    case none = ""
}

class Constants {
    
    static let appVersion: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "undefined"
    static let environment = Constants.isDebug ? Environment.development : Environment.development
    static let lengthPasswordMinimum: Int = 8
    static let backroundColorDefault: UIColor = .init(hex: "F7F8F9")
    static let spinLink: String = "https://game-003-tego022.bcms.tech?token=%@&lang=%@&device=%@&platfrom=ios"
    static let serviceProviderDefault: [ConfigRemote] = [
        ConfigRemote(with: "Viettel", value: "Viettel"),
        ConfigRemote(with: "Mobifone", value: "Mobifone"),
        ConfigRemote(with: "Vinaphone", value: "Vinaphone")
    ]
    static let linkBuyAppDefault: String = "itms-apps://itunes.apple.com/us/app/apple-store/nami-exchange-crypto-futures/id1480302334"
    
    static var isDebug: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }
    
    struct Device {
        static let id: String = UIDevice.current.identifierForVendor?.uuidString ?? "undefined"
        static let name: String = UIDevice.current.name.folding(options: .diacriticInsensitive, locale: .current)
        static let model: String = UIDevice.current.model
        static let version: String = UIDevice.current.systemVersion
        static let screenBounds = UIScreen.main.bounds
        static let languageCode = Locale.current.languageCode == "vi" ? "VN" : "EN"
    }
}

enum Environment {
    case production
    case development
    
    var domain: String {
        switch self {
        case .production:
            return API.Domain.production.rawValue
        case .development:
            return API.Domain.development.rawValue
        }
    }
}

struct API {
    enum Domain: String {
        case production = "https://membership.kardiachain.io"
        case development = "https://membership-backend.kardiachain.io"
    }
}

struct Amount {
    var money: Double
    var kai: Double
}

enum DayOfWeek: Int {
    case sun = 1
    case mon = 2
    case tue = 3
    case wed = 4
    case thu = 5
    case fri = 6
    case sat = 7
    
    var letter: String {
        switch self {
        case .sun:
            return "Sun"
        case .mon:
            return "Mon"
        case .tue:
            return "Tue"
        case .wed:
            return "Wed"
        case .thu:
            return "Thu"
        case .fri:
            return "Fri"
        case .sat:
            return "Sat"
        }
    }
}
