//
//  RequestQuestUser.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 12/03/2021.
//

import Foundation

class RequestQuestUser: BaseModel {
    
    var key: String?
    var progress: Int = 0
    var description: String?
    
    enum CodingKeys: String, CodingKey {
        case key
        case process
        case description
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        key = try container.decodeIfPresent(String.self, forKey: .key)
        progress = try container.decodeIfPresent(Int.self, forKey: .process) ?? 0
        description = try container.decodeIfPresent(String.self, forKey: .description)
    }
    
    func encode(to encoder: Encoder) throws { }
}
