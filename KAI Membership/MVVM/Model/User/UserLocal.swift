//
//  UserLocal.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 24/02/2021.
//

import RealmSwift

class UserLocal: RealmSwift.Object {
    
    @objc dynamic var id: String?
    @objc dynamic var email: String?
    @objc dynamic var avatarLink: String?
    
    override public static func primaryKey() -> String? {
        return "id"
    }
    
    required override init() { }
    
    init(with id: String? = nil, email: String? = nil, avatarLink: String? = nil) {
        self.id = id
        self.email = email
        self.avatarLink = avatarLink
    }
}
