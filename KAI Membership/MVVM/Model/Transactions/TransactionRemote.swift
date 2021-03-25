//
//  TransactionRemote.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 02/03/2021.
//

import Foundation

enum TransactionType: String {
    case get = "GET"
    case buy = "BUY"
    case send = "SEND"
}

class TransactionRemote: BaseModel {
    
    var id: String?
    var createdDate: String?
    var updatedDate: String?
    var historyId: String?
    var value: Double?
    var email: String?
    var walletReceive: String?
    var walletSend: String?
    var status: String?
    var category: String?
    var type: TransactionType
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case createdDate
        case updatedDate
        case historyId = "history_id"
        case value
        case email
        case walletReceive = "wallet_receive"
        case walletSend = "wallet_send"
        case status
        case type
        case category
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decodeIfPresent(String.self, forKey: .id)
        createdDate = try container.decodeIfPresent(String.self, forKey: .createdDate)
        updatedDate = try container.decodeIfPresent(String.self, forKey: .updatedDate)
        historyId = try container.decodeIfPresent(String.self, forKey: .historyId)
        value = try container.decodeIfPresent(Double.self, forKey: .value)
        email = try container.decodeIfPresent(String.self, forKey: .email)
        walletReceive = try container.decodeIfPresent(String.self, forKey: .walletReceive)
        walletSend = try container.decodeIfPresent(String.self, forKey: .walletSend)
        status = try container.decodeIfPresent(String.self, forKey: .status)
        category = try container.decodeIfPresent(String.self, forKey: .category)
        
        if let type = try container.decodeIfPresent(String.self, forKey: .type) {
            self.type = TransactionType(rawValue: type) ?? .get
        } else {
            self.type = .get
        }
    }
    
    func encode(to encoder: Encoder) throws { }
}
