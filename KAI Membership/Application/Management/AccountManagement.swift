//
//  AccountManagement.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 24/03/2021.
//

import UIKit

class AccountManagement {
    
    static var isLoggedIn: Bool {
        return AccountManagement.accessToken != nil//&& AccountManagement.userId != nil
    }
    
    static var accessToken: String? {
        get {
            guard let data = KeyChain.load(forKey: .authorizationToken) else { return nil }

            return String(data: data, encoding: .utf8) ?? nil
        }
        set {
            guard let data = newValue?.data(using: .utf8) else {
                KeyChain.delete(forKey: .authorizationToken)
                return
            }

            KeyChain.save(forKey: .authorizationToken, data: data)
        }
    }
    
    static var refreshToken: String? {
        get {
            guard let data = KeyChain.load(forKey: .refreshToken) else { return nil }

            return String(data: data, encoding: .utf8)
        }
        set {
            guard let data = newValue?.data(using: .utf8) else {
                KeyChain.delete(forKey: .refreshToken)
                return
            }

            KeyChain.save(forKey: .refreshToken, data: data)
        }
    }
    
    static var userID: String? {
        get {
            guard let data = KeyChain.load(forKey: .userID) else { return nil }

            return String(data: data, encoding: .utf8)
        }
        set {
            guard let data = newValue?.data(using: .utf8) else {
                KeyChain.delete(forKey: .userID)
                return
            }

            KeyChain.save(forKey: .userID, data: data)
        }
    }
    
    static var accountID: String {
        get {
            return userID ?? "guest"
        }
    }
    
    static var email: String {
        get {
            guard let data = KeyChain.load(forKey: .email) else { return "" }

            return String(data: data, encoding: .utf8) ?? ""
        }
        set {
            guard let data = newValue.data(using: .utf8) else {
                KeyChain.delete(forKey: .email)
                return
            }

            KeyChain.save(forKey: .email, data: data)
        }
    }
    
    static var accountInfo: AccountInfoRemote? {
        get {
            guard let data = KeyChain.load(forKey: .AccountInfo), let jsonString = String(data: data, encoding: .utf8) else { return nil }
            
            return Helper.toObject(ofType: AccountInfoRemote.self, jsonString: jsonString)
        }
        set {
            guard let data = Helper.toJSONString(newValue)?.data(using: .utf8) else {
                KeyChain.delete(forKey: .AccountInfo)
                return
            }
            
            KeyChain.save(forKey: .AccountInfo, data: data)
        }
    }
    
    class func logout() {
        KeyChain.delete(forKey: .email)
        KeyChain.delete(forKey: .userID)
        KeyChain.delete(forKey: .AccountInfo)
        KeyChain.delete(forKey: .authorizationToken)
        KeyChain.delete(forKey: .refreshToken)
    }
    
    class func getInfoUser(_ completion: @escaping (APIResult<AccountInfoRemote, APIErrorResult>) -> Void) {
        UserServices.getInfo() {
            switch $0 {
            case .success(let result):
                if let data = result.data {
                    AccountManagement.userID = data.user?.id
                    AccountManagement.accountInfo = data
                    completion(.success(data))
                } else {
                    completion(.failure(APIErrorResult(with: .emptyResults)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    class func login(with email: String, and password: String, _ completion: @escaping (APIResult<AccountInfoRemote, APIErrorResult>) -> Void) {
        UserServices.login(email: email, password: password) {
            switch $0 {
            case .success(let result):
                if let data = result.data {
                    AccountManagement.accessToken = data.accessToken
                    AccountManagement.refreshToken = data.refreshToken
                    AccountManagement.getInfoUser {
                        switch $0 {
                        case .success(let info):
                            completion(.success(info))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                } else {
                    completion(.failure(APIErrorResult(with: .emptyResults)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    class func register(username: String, email: String, password: String, _ completion: @escaping (APIResult<AccountInfoRemote, APIErrorResult>) -> Void) {
        UserServices.register(username: username, email: email, password: password) {
            switch $0 {
            case .success(let result):
                if let referrerID = AppSetting.referrerID, !referrerID.isEmpty {
                    ReferralsServices.create(referrerID: referrerID)
                }
                
                if let data = result.data {
                    AccountManagement.accessToken = data.accessToken
                    AccountManagement.refreshToken = data.refreshToken
                    AccountManagement.getInfoUser {
                        switch $0 {
                        case .success(let info):
                            completion(.success(info))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                } else {
                    completion(.failure(APIErrorResult(with: .emptyResults)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    class func loginWithPascode(with email: String, and passcode: String, _ completion: @escaping (APIResult<AccountInfoRemote, APIErrorResult>) -> Void) {
        PasscodeServices.loginWithPasscode(passcode, email: email) {
            switch $0 {
            case .success(let result):
                if let data = result.data {
                    AppSetting.haveFreeSpin = data.isFirst
                    AccountManagement.accessToken = data.accessToken
                    AccountManagement.refreshToken = data.refreshToken
                    AccountManagement.getInfoUser {
                        switch $0 {
                        case .success(let info):
                            completion(.success(info))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                } else {
                    completion(.failure(APIErrorResult(with: .emptyResults)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    class func updateUserInfomation(name: String, phoneNumber: String, birthday: Double? = nil, _ completion: @escaping (APIResult<AccountInfoRemote, APIErrorResult>) -> Void) {
        UserServices.updateInfomation(name: name, phoneNumber: phoneNumber, birthday: birthday) {
            switch $0 {
            case .success:
                if let currentInfo = AccountManagement.accountInfo, let user = currentInfo.user, let kai = currentInfo.kai {
                    kai.firstName = name
                    user.phone = phoneNumber
                    
                    if let birthday = birthday {
                        user.birthday = birthday
                    }
                    
                    AccountManagement.accountInfo = currentInfo
                    
                    completion(.success(currentInfo))
                } else {
                    AccountManagement.getInfoUser {
                        switch $0 {
                        case .success(let info):
                            completion(.success(info))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    class func updateAvatar(_ image: UIImage, _ completion: @escaping (APIResult<APIDataResults<String>, APIErrorResult>) -> Void) {
        UserServices.updateAvatar(image) {
            switch $0 {
            case .success(let result):
                completion(.success(result))
                /*if let currentInfo = AccountManagement.accountInfo, let user = currentInfo.user {
                    AccountManagement.accountInfo = currentInfo
                    
                    completion(.success(currentInfo))
                } else {
                    AccountManagement.getInfoUser {
                        switch $0 {
                        case .success(let info):
                            completion(.success(info))
                        case .failure(let error):
                            completion(.success(AccountManagement.accountInfo ?? AccountInfoRemote()))
                        }
                    }
                }*/
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    class func sendKAI(walletAddress: String, kai: Double, _ completion: @escaping (APIResult<AccountInfoRemote, APIErrorResult>) -> Void) {
        TransactionServices.send(walletAddress: walletAddress, amount: kai) {
            switch $0 {
            case .success:
                if let currentInfo = AccountManagement.accountInfo, let kaiInfo = currentInfo.kai, let wallet = kaiInfo.wallet {
                    if let balance = wallet.balance {
                        wallet.balance = balance - kai
                    }

                    AccountManagement.accountInfo = currentInfo
                    NotificationCenter.default.post(name: .kaiValueChanged, object: currentInfo.kai)
                    completion(.success(currentInfo))
                } else {
                    AccountManagement.getInfoUser {
                        switch $0 {
                        case .success(let info):
                            NotificationCenter.default.post(name: .kaiValueChanged, object: info.kai)
                            completion(.success(info))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
