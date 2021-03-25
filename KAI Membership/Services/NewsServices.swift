//
//  NewsServices.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 25/03/2021.
//

import Foundation
import Alamofire

class NewsServices {
    
    // MARK: Get news from twitter
    class func getNewsFromTwitter(_ completion: @escaping ((APIResult<[TwitterNews], APIErrorResult>) -> Void)) {
        let parameters: Parameters = [
            "q" : "from:kardiachain AND -filter:retweets AND -filter:replies",
            "count" : 20,
            "result_type" : "recent",
            "tweet_mode" : "extended"
        ]
        
        let headers: HTTPHeaders = [
            HTTPHeader.authorization(bearerToken: "AAAAAAAAAAAAAAAAAAAAAMHMNwEAAAAATHxIoEgKUYhdcjDBnVGJIpgPL54%3Dane0BGzcZ6gJjEYChdCayhs4wKN1KEgwZRGPM44HOxMOz32Kli"),
            HTTPHeader(name: "Cookie", value: "guest_id=v1%3A161649292642249147; personalization_id=\"v1_MV5B2SyubHXwyQDfCs3EXw==\"")
        ]
        
        AF.request("https://api.twitter.com/1.1/search/tweets.json", method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers).validate().responseJSON(queue: .main) {
            switch $0.result {
            case .success(let data):
                guard let result = data as? [String : Any], let dicts = result["statuses"] as? [[String : Any]] else {
                    completion(.success([]))
                    return
                }
                
                let news = dicts.map { (dict) -> TwitterNews in
                    if let entities = dict["entities"] as? [String : Any] {
                        var hashtags = [String]()
                        var mediaLink: String?
                        var link: String?
                        
                        if let entitiesTags = entities["hashtags"] as? [[String : Any]] {
                            hashtags = entitiesTags.compactMap { $0["text"] as? String }
                        }
                        
                        if let media = (entities["media"] as? [[String : Any]])?.first {
                            mediaLink = media["media_url_https"] as? String
                            link = media["url"] as? String
                        }
                        
                        return TwitterNews(id: dict["id"] as? String, createdAt: dict["created_at"] as? String, title: dict["full_text"] as? String, hashtags: hashtags, mediaLink: mediaLink, link: link)
                    } else {
                        return TwitterNews(id: dict["id"] as? String, createdAt: dict["created_at"] as? String, title: dict["full_text"] as? String)
                    }
                }
                
                completion(.success(news))
            case .failure(let error):
                completion(.failure(APIErrorResult(code: "AF", message: error.localizedDescription)))
            }
        }
    }
    
    class func getNewsFromMedium(_ completion: @escaping ((APIResult<[MediumNews], APIErrorResult>) -> Void)) {
        AF.request("https://api.rss2json.com/v1/api.json", method: .get, parameters: ["rss_url" : "https://medium.com/feed/kardiachain"], encoding: URLEncoding.default).validate().responseJSON(queue: .main) {
            switch $0.result {
            case .success(let data):
                guard let result = data as? [String : Any], let dicts = result["items"] as? [[String : Any]] else {
                    completion(.success([]))
                    return
                }
                
                let news = dicts.map { MediumNews(title: $0["title"] as? String, publicDate: $0["pubDate"] as? String, link: $0["link"] as? String, guid: $0["guid"] as? String, author: $0["author"] as? String, thumbnail: $0["thumbnail"] as? String, description: $0["description"] as? String, content: $0["content"] as? String, categories: $0["categories"] as? [String] ?? []) }
                
                completion(.success(news))
            case .failure(let error):
                completion(.failure(APIErrorResult(code: "AF", message: error.localizedDescription)))
            }
        }
    }
}
