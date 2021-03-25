//
//  UserServices.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 24/02/2021.
//

import Foundation
import UIKit

class UserServices {
    
    // MARK: Login
    class func login(email: String, password: String, _ completion: @escaping (APIResult<APIDataResults<LoginRemote>, APIErrorResult>) -> Void) {
        let input = APIInput(withDomain: Constants.environment.domain, path: "/api/v1/auth/login", method: .post)
        input.params["os"] = "ios"
        input.params["username"] = email
        input.params["password"] = password
        
        APIServices.request(input: input, output: APIOutput.self, completion: completion)
    }
    
    // MARK: Get infomation
    class func getInfo(_ completion: @escaping (APIResult<APIDataResults<AccountInfoRemote>, APIErrorResult>) -> Void) {
        let input = APIInput(withDomain: Constants.environment.domain, path: "/api/v1/users/info", method: .get)
        
        APIServices.request(input: input, output: APIOutput.self, completion: completion)
    }
    
    // MARK: Register
    class func register(username: String, email: String, password: String, _ completion: @escaping (APIResult<APIDataResults<LoginRemote>, APIErrorResult>) -> Void) {
        let input = APIInput(withDomain: Constants.environment.domain, path: "/api/v1/auth/register", method: .post)
        input.params["username"] = username
        input.params["password"] = password
        input.params["email"] = email
        input.params["first_name"] = username
        input.params["last_name"] = username
        
        APIServices.request(input: input, output: APIOutput.self, completion: completion)
    }
        
    // MARK: Request change password with email
    class func requestChangePassword(with email: String, _ completion: @escaping (APIResult<APIDataResults<String>, APIErrorResult>) -> Void) {
        let input = APIInput(withDomain: Constants.environment.domain, path: "/api/v1/auth/reset-password", method: .post)
        input.params["email"] = email
        
        APIServices.request(input: input, output: APIOutput.self, completion: completion)
    }
    
    // MARK: Confirm password when receive token from email
    class func confirmPassword(with token: String, password: String, _ completion: @escaping (APIResult<APIDataResults<String>, APIErrorResult>) -> Void) {
        let input = APIInput(withDomain: Constants.environment.domain, path: "/api/v1/auth/reset-password-confirm", method: .post)
        input.params["token"] = token
        input.params["password"] = password
        
        APIServices.request(input: input, output: APIOutput.self, completion: completion)
    }
    
    // MARK: Get histories
    class func getHistories(_ completion: @escaping (APIResult<APIDataListResults<HistoryRemote>, APIErrorResult>) -> Void) {
        let input = APIInput(withDomain: Constants.environment.domain, path: "/api/v1/users/history", method: .get)
        
        APIServices.request(input: input, output: APIOutput.self, completion: completion)
    }
    
    // MARK: Update infomation
    class func updateInfomation(name: String, phoneNumber: String, birthday: Double? = nil, _ completion: @escaping (APIResult<APIDataResults<String>, APIErrorResult>) -> Void) {
        let input = APIInput(withDomain: Constants.environment.domain, path: "/api/v1/users/info", method: .post)
        input.params["firstName"] = name
        input.params["lastName"] = name
        input.params["phone"] = phoneNumber
        
        if let birthday = birthday {
            input.params["birthday_time"] = birthday
        }
        
        APIServices.request(input: input, output: APIOutput.self, completion: completion)
    }
    
    // MARK: Update avatar
    class func updateAvatar(_ image: UIImage, _ completion: @escaping (APIResult<APIDataResults<String>, APIErrorResult>) -> Void) {
        let input = APIInput(withDomain: Constants.environment.domain, path: "/api/v1/users/avatar", method: .post)
        
        input.params = [
            "avatar" : image
        ]
        
        APIServices.upload(input: input, output: APIOutput.self, completion: completion)
    }

    // MARK: Change password
    class func changePassword(password: String, newPassword: String, _ completion: @escaping (APIResult<APIDataResults<String>, APIErrorResult>) -> Void) {
        let input = APIInput(withDomain: Constants.environment.domain, path: "/api/v1/users/change-password", method: .post)
        input.params["password"] = password
        input.params["new_password"] = newPassword
        
        APIServices.request(input: input, output: APIOutput.self, completion: completion)
    }
}
