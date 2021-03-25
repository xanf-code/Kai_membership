//
//  AppSetting.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 24/03/2021.
//

import Foundation

class AppSetting {
    
    static var isDarkMode: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: Key.UserDefault.darkMode.rawValue)
        }
        get {
            return UserDefaults.standard.bool(forKey: Key.UserDefault.darkMode.rawValue)
        }
    }
    
    static var haveUsedTheApplicationOnce: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: Key.UserDefault.haveUsedTheApplicationOnce.rawValue)
        }
        get {
            return UserDefaults.standard.bool(forKey: Key.UserDefault.haveUsedTheApplicationOnce.rawValue)
        }
    }
    
    static var serviceProviders: [ConfigRemote] {
        set {
            do {
                let encoder = JSONEncoder()
                let data = try encoder.encode(newValue)
                UserDefaults.standard.set(data, forKey: Key.UserDefault.serviceProviders.rawValue)
            } catch {
                debugPrint("Unable to Encode Service Providers (\(error))")
            }
        }
        get {
            guard let data = UserDefaults.standard.data(forKey: Key.UserDefault.serviceProviders.rawValue) else { return Constants.serviceProviderDefault }
            
            do {
                let decoder = JSONDecoder()
                let results = try decoder.decode([ConfigRemote].self, from: data)
                
                return results
            } catch {
                debugPrint("Unable to Decode Service Providers (\(error))")
                return Constants.serviceProviderDefault
            }
        }
    }
    
    static var linkBuyApp: String {
        set {
            UserDefaults.standard.set(newValue, forKey: Key.UserDefault.linkBuyApp.rawValue)
        }
        get {
            return UserDefaults.standard.string(forKey: Key.UserDefault.linkBuyApp.rawValue) ?? Constants.linkBuyAppDefault
        }
    }
    
    static var configures: [ConfigGroupRemote] {
        set {
            do {
                let encoder = JSONEncoder()
                let data = try encoder.encode(newValue)
                UserDefaults.standard.set(data, forKey: Key.UserDefault.configure.rawValue)
            } catch {
                debugPrint("Unable to Encode Configs (\(error))")
            }
        }
        get {
            guard let data = UserDefaults.standard.data(forKey: Key.UserDefault.configure.rawValue) else { return [] }
            
            do {
                let decoder = JSONDecoder()
                let results = try decoder.decode([ConfigGroupRemote].self, from: data)
                
                return results
            } catch {
                debugPrint("Unable to Decode Configs (\(error))")
                return []
            }
        }
    }
    
    static var haveFreeSpin: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: Key.UserDefault.haveFreeSpin.rawValue)
        }
        get {
            return UserDefaults.standard.bool(forKey: Key.UserDefault.haveFreeSpin.rawValue)
        }
    }
    
    static var isRequestOpenSpin: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: Key.UserDefault.isRequestOpenSpin.rawValue)
        }
        get {
            return UserDefaults.standard.bool(forKey: Key.UserDefault.isRequestOpenSpin.rawValue)
        }
    }
    
    static var referrerID: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: Key.UserDefault.referrerID.rawValue)
        }
        get {
            return UserDefaults.standard.string(forKey: Key.UserDefault.referrerID.rawValue)
        }
    }
}
