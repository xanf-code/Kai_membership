//
//  UserQuestRemote.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 12/03/2021.
//

import Foundation

class UserQuestRemote: BaseModel {
    
    var id: String?
    var createdDate: String?
    var updatedDate: String?
    var completedDate: String?
    var userID: String?
    var key: QuestKey = .signIn
    var progress: Int?
    var isCompleted: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case createdDate = "created_date"
        case updatedDate = "updated_date"
        case completedDate = "completed_date"
        case userID = "user_id"
        case key
        case progress = "process"
        case description
        case isCompleted = "is_completed"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decodeIfPresent(String.self, forKey: .id)
        createdDate = try container.decodeIfPresent(String.self, forKey: .createdDate)
        updatedDate = try container.decodeIfPresent(String.self, forKey: .updatedDate)
        completedDate = try container.decodeIfPresent(String.self, forKey: .completedDate)
        userID = try container.decodeIfPresent(String.self, forKey: .userID)
        
        if let key = try container.decodeIfPresent(String.self, forKey: .key) {
            self.key = QuestKey(rawValue: key) ?? .signIn
        } else {
            self.key = .signIn
        }
        
        progress = try container.decodeIfPresent(Int.self, forKey: .progress)
        isCompleted = try container.decodeIfPresent(Bool.self, forKey: .isCompleted)
    }
    
    func encode(to encoder: Encoder) throws { }
}
