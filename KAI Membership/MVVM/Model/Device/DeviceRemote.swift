//
//  DeviceRemote.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 03/03/2021.
//

import Foundation

class DeviceRemote: BaseModel {
    
    var id: String?
    var users: [UserRemote]
    
    enum CodingKeys: String, CodingKey {
        case id = "device_id"
        case users = "user"
    }
    
    init(with id: String? = nil, users: [UserRemote] = []) {
        self.id = id
        self.users = users
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decodeIfPresent(String.self, forKey: .id)
        users = try container.decodeIfPresent([UserRemote].self, forKey: .users) ?? []
    }
    
    func encode(to encoder: Encoder) throws { }
}

