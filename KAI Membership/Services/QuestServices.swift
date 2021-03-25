//
//  QuestServices.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 05/03/2021.
//

import Foundation

class QuestServices {
    
    // MARK: Get the quests list
    class func getList(_ completion: @escaping (APIResult<APIDataListResults<QuestRemote>, APIErrorResult>) -> Void) {
        let input = APIInput(withDomain: Constants.environment.domain, path: "/api/v1/quests", method: .get)
        
        APIServices.request(input: input, output: APIOutput.self, completion: completion)
    }
    
    // MARK: Get the quests list of user
    class func getUserQuests(_ completion: @escaping (APIResult<APIDataListResults<UserQuestRemote>, APIErrorResult>) -> Void) {
        let input = APIInput(withDomain: Constants.environment.domain, path: "/api/v1/quests/users", method: .get)
        
        APIServices.request(input: input, output: APIOutput.self, completion: completion)
    }
    
    // MARK: Get the quests list of user
    class func requestUserQuest(with key: QuestKey, _ completion: ((APIResult<APIDataResults<UserQuestRemote>, APIErrorResult>) -> Void)? = nil) {
        let input = APIInput(withDomain: Constants.environment.domain, path: "/api/v1/quests", method: .post)
        input.params["key"] = key.rawValue

        APIServices.request(input: input, output: APIOutput.self, completion: completion)
    }
}
