//
//  Helper.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 24/03/2021.
//

import UIKit

class Helper {
    
    class func toJSONString<T: BaseModel>(_ object: T?) -> String? {
        guard let object = object else { return nil }
        
        do {
            let encodedData = try JSONEncoder().encode(object)
            let jsonString = String(data: encodedData, encoding: .utf8)
            
            return jsonString
        } catch let error {
            debugPrint("JSONEncoder Error: \(error.localizedDescription)")
            return nil
        }
    }
    
    class func toObject<T: BaseModel>(ofType type: T.Type, jsonString: String) -> T? {
        guard let data = jsonString.data(using: .utf8) else { return nil }
        
        do {
            let object = try JSONDecoder().decode(type, from: data)
            
            return object
        } catch let error {
            debugPrint("JSONEncoder Error: \(error.localizedDescription)")
            return nil
        }
    }
    
    class func toObjects<T: BaseModel>(ofType type: [T].Type, jsonString: String) -> [T]? {
        guard let data = jsonString.data(using: .utf8) else { return nil }
        
        do {
            let objects = try JSONDecoder().decode(type, from: data)
            
            return objects
        } catch let error {
            debugPrint("JSONEncoder Error: \(error.localizedDescription)")
            return nil
        }
    }
    
    class func openSafari(_ link: String? = nil) {
        guard let link = link, let url = URL(string: link) else {
            debugPrint("Error: Invalid link")
            return
        }
        
        UIApplication.shared.open(url)
    }
    
    class func getConfig(forKey key: ConfigKey) -> [ConfigRemote] {
        return AppSetting.configures.first(where: { $0.name == key.rawValue })?.configs ?? []
    }
}

