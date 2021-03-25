//
//  PasscodeServices.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 12/03/2021.
//

import Foundation

class PasscodeServices {
    
    // MARK: Reset passcode
    class func requestResetPasscode(with email: String, _ completion: ((APIResult<APIDataResults<String>, APIErrorResult>) -> Void)? = nil) {
        let input = APIInput(withDomain: Constants.environment.domain, path: "/api/v1/passcodes/forgot", method: .post)
        input.params["email"] = email
        input.params["mobile_unique_id"] = Constants.Device.id
        
        APIServices.request(input: input, output: APIOutput.self, completion: completion)
    }
    
    // MARK: Login with passcode
    class func loginWithPasscode(_ passcode: String, email: String, _ completion: @escaping (APIResult<APIDataResults<LoginRemote>, APIErrorResult>) -> Void) {
        let input = APIInput(withDomain: Constants.environment.domain, path: "/api/v1/passcodes/login", method: .post)
        input.params["passcode"] = passcode
        input.params["email"] = email
        input.params["device_id"] = Constants.Device.id
        input.params["os"] = "ios"
        
        APIServices.request(input: input, output: APIOutput.self, completion: completion)
    }
    
    // MARK: Create passcode
    class func createPasscode(with email: String, passcode: String, _ completion: @escaping (APIResult<APIDataResults<String>, APIErrorResult>) -> Void) {
        let input = APIInput(withDomain: Constants.environment.domain, path: "/api/v1/passcodes/register", method: .post)
        input.params["device_id"] = Constants.Device.id
        input.params["passcode"] = passcode
        input.params["refresh_token"] = AccountManagement.refreshToken
        input.params["email"] = email
        input.params["os"] = "ios"
        
        APIServices.request(input: input, output: APIOutput.self, completion: completion)
    }
    
    // MARK: Check passcode
    class func checkPasscode(_ passcode: String, _ completion: @escaping (APIResult<APIDataResults<String>, APIErrorResult>) -> Void) {
        let input = APIInput(withDomain: Constants.environment.domain, path: "/api/v1/passcodes/check", method: .post)
        input.params["mobile_unique_id"] = Constants.Device.id
        input.params["passcode"] = passcode
        
        APIServices.request(input: input, output: APIOutput.self, completion: completion)
    }
    
    // MARK: Reset passcode
    class func resetPasscode(token: String, passcode: String, email: String, _ completion: @escaping (APIResult<APIDataResults<String>, APIErrorResult>) -> Void) {
        let input = APIInput(withDomain: Constants.environment.domain, path: "/api/v1/passcodes/reset", method: .post)
        input.params["token"] = token
        input.params["mobile_unique_id"] = Constants.Device.id
        input.params["passcode"] = passcode
        input.params["email"] = email
        
        APIServices.request(input: input, output: APIOutput.self, completion: completion)
    }
}
