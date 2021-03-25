//
//  AccountInfoRemote.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 24/03/2021.
//

import Foundation

class AccountInfoRemote: BaseModel {
    
    var user: UserRemote?
    var kai: KAIRemote?
    
    enum CodingKeys: String, CodingKey {
        case user = "user_info"
        case kai = "kai_info"
    }
    
    init(user: UserRemote? = nil, kai: KAIRemote? = nil) {
        self.user = user
        self.kai = kai
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        user = try container.decodeIfPresent(UserRemote.self, forKey: .user)
        kai = try container.decodeIfPresent(KAIRemote.self, forKey: .kai)
    }
}
