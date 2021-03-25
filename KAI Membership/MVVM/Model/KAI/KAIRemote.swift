//
//  KAIRemote.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 05/03/2021.
//

import Foundation

enum ProfitStatus {
    case up
    case down
}

class KAIRemote: BaseModel {
    
    var username: String?
    var email: String?
    var firstName: String?
    var lastName: String?
    var wallet: WalletRemote?
    
    enum CodingKeys: String, CodingKey {
        case username
        case email
        case firstName = "first_name"
        case lastName = "last_name"
        case wallet
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        username = try container.decodeIfPresent(String.self, forKey: .username)
        email = try container.decodeIfPresent(String.self, forKey: .email)
        firstName = try container.decodeIfPresent(String.self, forKey: .firstName)
        lastName = try container.decodeIfPresent(String.self, forKey: .lastName)
        wallet = try container.decodeIfPresent(WalletRemote.self, forKey: .wallet)
    }
}
