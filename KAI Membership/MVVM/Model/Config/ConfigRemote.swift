//
//  ConfigRemote.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 15/03/2021.
//

import Foundation

enum ConfigKey: String {
    case missionType = "Mission Type"
    case missionKey = "Mission Key"
    case mobileCard = "Mobile Card"
    case linkBuy = "Link Buy"
}

class ConfigGroupRemote: BaseModel {
    
    var name: String?
    var configs: [ConfigRemote] = []
    
    enum CodingKeys: String, CodingKey {
        case name = "group_name"
        case configs = "config"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try container.decodeIfPresent(String.self, forKey: .name)
        configs = try container.decodeIfPresent([ConfigRemote].self, forKey: .configs) ?? []
    }
}

class ConfigRemote: BaseModel {
    
    var key: String?
    var value: String
    
    enum CodingKeys: String, CodingKey {
        case key
        case value
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        key = try container.decodeIfPresent(String.self, forKey: .key)
        value = try container.decodeIfPresent(String.self, forKey: .value) ?? ""
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(key, forKey: .key)
        try container.encode(value, forKey: .value)
    }
    
    init(with key: String, value: String) {
        self.key = key
        self.value = value
    }
}
