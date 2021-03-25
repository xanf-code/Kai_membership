//
//  LoginRemote.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 05/03/2021.
//

import Foundation

class LoginRemote: BaseModel {
    
    var accessToken: String?
    var refreshToken: String?
    var expiresIn: Double?
    var isFirst: Bool
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case expiresIn = "expires_in"
        case isFirst = "is_first"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        accessToken = try container.decodeIfPresent(String.self, forKey: .accessToken)
        refreshToken = try container.decodeIfPresent(String.self, forKey: .refreshToken)
        expiresIn = try container.decodeIfPresent(Double.self, forKey: .expiresIn)
        isFirst = try container.decodeIfPresent(Bool.self, forKey: .isFirst) ?? false
    }
}
