//
//  ConfigServices.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 15/03/2021.
//

import Foundation

class ConfigServices {
    
    // MARK: Get configs
    class func get(_ completion: ((APIResult<APIDataListResults<ConfigGroupRemote>, APIErrorResult>) -> Void)? = nil) {
        let input = APIInput(withDomain: Constants.environment.domain, path: "/api/v1/configs", method: .get)
        
        APIServices.request(input: input, output: APIOutput.self, completion: completion)
    }
}
