//
//  CaptchaServices.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 16/03/2021.
//

import Foundation

class CaptchaServices {
    
    // MARK: Get captcha image link
    class func getCaptchaImageLink(with id: String) -> String {
        return "\(Constants.environment.domain)/api/v1/captcha/\(id)"
    }
    
    // MARK: Generate captcha
    class func generateCaptcha(_ completion: @escaping ((APIResult<APIDataResults<CaptchaRemote>, APIErrorResult>) -> Void)) {
        let input = APIInput(withDomain: Constants.environment.domain, path: "/api/v1/captcha", method: .post)
        
        APIServices.request(input: input, output: APIOutput.self, completion: completion)
    }
    
    // MARK: Verify captcha
    class func verifyCaptcha(with id: String, captcha: String, _ completion: ((APIResult<APIDataResults<String>, APIErrorResult>) -> Void)? = nil) {
        let input = APIInput(withDomain: Constants.environment.domain, path: "/api/v1/captcha/verify", method: .post)
        input.params["captcha_id"] = id
        input.params["captcha"] = captcha
        
        APIServices.request(input: input, output: APIOutput.self, completion: completion)
    }
}
