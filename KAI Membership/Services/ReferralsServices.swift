//
//  ReferralsServices.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 25/03/2021.
//

import Foundation

class ReferralsServices {
    
    // MARK: Create referrals
    class func create(referrerID: String, _ completion: ((APIResult<APIDataResults<String>, APIErrorResult>) -> Void)? = nil) {
        let input = APIInput(withDomain: Constants.environment.domain, path: "/api/v1/referrals", method: .post)
        input.params["code_user"] = referrerID
        
        APIServices.request(input: input, output: APIOutput.self, completion: completion)
    }
    
    // MARK: Create refarral  QR code
    class func QRCode(_ completion: ((APIResult<APIDataResults<String>, APIErrorResult>) -> Void)? = nil) {
        let input = APIInput(withDomain: Constants.environment.domain, path: "/api/v1/referrals-code", method: .post)
        
        APIServices.request(input: input, output: APIOutput.self, completion: completion)
    }
}
