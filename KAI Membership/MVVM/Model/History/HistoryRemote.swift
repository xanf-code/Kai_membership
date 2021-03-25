//
//  HistoryRemote.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 11/03/2021.
//

import Foundation

enum HistoryStatus: String {
    case inProgress = "PROGRESS"
    case completed = "COMPLETED"
}

class HistoryRemote: BaseModel {
    
    var id: String?
    var createdDate: String?
    var updatedDate: String?
    var fullName: String?
    var phone: String?
    var email: String?
    var username: String?
    var rewardName: String?
    var codeCard: String?
    var seriCard: String?
    var expriedCard: String?
    var providerName: String?
    var infinity: Bool?
    var platfrom: String?
    var phoneNumberTopup: String?
    var formName: String?
    var formPhone: String?
    var formAddress: String?
    var formNote: String?
    var deviceID: String?
    var status: HistoryStatus
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdDate
        case updatedDate
        case fullName
        case phone
        case email
        case username
        case rewardName
        case codeCard
        case seriCard
        case expriedCard
        case providerName
        case infinity
        case platfrom = "os"
        case phoneNumberTopup
        case formName
        case formPhone
        case formAddress
        case formNote
        case deviceID
        case status
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decodeIfPresent(String.self, forKey: .id)
        createdDate = try container.decodeIfPresent(String.self, forKey: .createdDate)
        updatedDate = try container.decodeIfPresent(String.self, forKey: .updatedDate)
        fullName = try container.decodeIfPresent(String.self, forKey: .fullName)
        phone = try container.decodeIfPresent(String.self, forKey: .phone)
        email = try container.decodeIfPresent(String.self, forKey: .email)
        username = try container.decodeIfPresent(String.self, forKey: .username)
        rewardName = try container.decodeIfPresent(String.self, forKey: .rewardName)
        codeCard = try container.decodeIfPresent(String.self, forKey: .codeCard)
        seriCard = try container.decodeIfPresent(String.self, forKey: .seriCard)
        expriedCard = try container.decodeIfPresent(String.self, forKey: .expriedCard)
        providerName = try container.decodeIfPresent(String.self, forKey: .providerName)
        infinity = try container.decodeIfPresent(Bool.self, forKey: .infinity)
        platfrom = try container.decodeIfPresent(String.self, forKey: .platfrom)
        phoneNumberTopup = try container.decodeIfPresent(String.self, forKey: .phoneNumberTopup)
        formName = try container.decodeIfPresent(String.self, forKey: .formName)
        formPhone = try container.decodeIfPresent(String.self, forKey: .formPhone)
        formAddress = try container.decodeIfPresent(String.self, forKey: .formAddress)
        formNote = try container.decodeIfPresent(String.self, forKey: .formNote)
        deviceID = try container.decodeIfPresent(String.self, forKey: .deviceID)
        
        if let status = try container.decodeIfPresent(String.self, forKey: .status) {
            self.status = HistoryStatus(rawValue: status) ?? .completed
        } else {
            self.status = .completed
        }
    }
    
    func encode(to encoder: Encoder) throws { }
}
