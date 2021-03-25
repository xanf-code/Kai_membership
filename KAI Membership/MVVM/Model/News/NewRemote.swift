//
//  NewRemote.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 04/03/2021.
//

import Foundation

class NewRemote: BaseModel {
    
    var id: String?
    var title: String?
    var description: String?
    var url: String?
    var imageLink: String?
    var publicDate: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title = "name"
        case description
        case url
        case imageLink = "imageUrl"
        case publicDate = "public_date"
    }
    
    init(with id: String? = nil, title: String? = nil, description: String? = nil, url: String? = nil, imageLink: String? = nil, publicDate: String? = nil) {
        self.id = id
        self.title = title
        self.description = description
        self.url = url
        self.imageLink = imageLink
        self.publicDate = publicDate
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decodeIfPresent(String.self, forKey: .id)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        url = try container.decodeIfPresent(String.self, forKey: .url)
        imageLink = try container.decodeIfPresent(String.self, forKey: .imageLink)
        publicDate = try container.decodeIfPresent(String.self, forKey: .publicDate)
    }
    
    func encode(to encoder: Encoder) throws { }
}

struct MediumNews {
    
    let title: String?
    let publicDate: String?
    let link: String?
    let guid: String?
    let author: String?
    let thumbnail: String?
    let description: String?
    let content: String?
    let categories: [String]
    
    init(title: String? = nil, publicDate: String? = nil, link: String? = nil, guid: String? = nil, author: String? = nil, thumbnail: String? = nil, description: String? = nil, content: String? = nil, categories: [String] = []) {
        self.title = title
        self.publicDate = publicDate
        self.link = link
        self.guid = guid
        self.author = author
        self.thumbnail = thumbnail
        self.description = description
        self.content = content
        self.categories = categories
    }
}

struct TwitterNews {
    
    let id: String?
    let createdAt: String?
    let title: String?
    let hashtags: [String]
    let mediaLink: String?
    let link: String?
    
    init(id: String? = nil, createdAt: String? = nil, title: String? = nil, hashtags: [String] = [], mediaLink: String? = nil, link: String? = nil) {
        self.id = id
        self.createdAt = createdAt
        self.title = title
        self.hashtags = hashtags
        self.mediaLink = mediaLink
        self.link = link
    }
}
