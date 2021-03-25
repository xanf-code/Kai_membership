//
//  CaptchaRemote.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 16/03/2021.
//

import Foundation

class CaptchaRemote: BaseModel {
    
    var id: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "captcha_id"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decodeIfPresent(String.self, forKey: .id)
    }
}
