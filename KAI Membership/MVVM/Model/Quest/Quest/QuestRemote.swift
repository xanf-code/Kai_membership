//
//  QuestRemote.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 05/03/2021.
//

import Foundation

enum QuestType: String {
    case daily = "DAILY"
    case monthly = "MONTH"
}

enum QuestKey: String {
    case highestScores = "HIGHEST_SCORES"// Web
    case thiryMinutes = "THIRTY_MINUTES" // play game 30' // Web
    case inviteFriend = "INVITE_FRIEND" // share // mobile
    case signIn = "SIGN_IN" // activity => done
}

class QuestRemote: BaseModel {
    
    var id: String?
    var createdDate: String?
    var updatedDate: String?
    var name: String?
    var key: QuestKey = .signIn
    var type: QuestType = .daily
    var progress: Int?
    var userQuest: UserQuestRemote?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case createdDate = "created_date"
        case updatedDate = "updated_date"
        case name = "mission"
        case key
        case type
        case progress = "process"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decodeIfPresent(String.self, forKey: .id)
        createdDate = try container.decodeIfPresent(String.self, forKey: .createdDate)
        updatedDate = try container.decodeIfPresent(String.self, forKey: .updatedDate)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        
        if let key = try container.decodeIfPresent(String.self, forKey: .key) {
            self.key = QuestKey(rawValue: key) ?? .signIn
        } else {
            self.key = .signIn
        }
        
        if let type = try container.decodeIfPresent(String.self, forKey: .type) {
            self.type = QuestType(rawValue: type) ?? .daily
        } else {
            self.type = .daily
        }
        
        progress = try container.decodeIfPresent(Int.self, forKey: .progress)
    }
    
    func encode(to encoder: Encoder) throws { }
}

