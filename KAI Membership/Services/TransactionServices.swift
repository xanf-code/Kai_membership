//
//  TransactionServices.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 02/03/2021.
//

import Foundation

class TransactionServices {
    
    // MARK: Get transactions
    class func getTransactions(_ completion: @escaping (APIResult<APIDataListResults<TransactionRemote>, APIErrorResult>) -> Void) {
        let input = APIInput(withDomain: Constants.environment.domain, path: "/api/v1/transactions", method: .get)
        
        APIServices.request(input: input, output: APIOutput.self, completion: completion)
    }
    
    // MARK: Create topup
    class func topup(phoneNumber: String, providerCode: String, amount: Double, _ completion: @escaping (APIResult<APIDataResults<String>, APIErrorResult>) -> Void) {
        let input = APIInput(withDomain: Constants.environment.domain, path: "/api/v1/topup", method: .post)
        input.params["phone_number"] = phoneNumber
        input.params["provider_code"] = providerCode
        input.params["amount"] = amount
        
        APIServices.request(input: input, output: APIOutput.self, completion: completion)
    }
    
    // MARK: Create send
    class func send(walletAddress: String, amount: Double, _ completion: @escaping (APIResult<APIDataResults<String>, APIErrorResult>) -> Void) {
        let input = APIInput(withDomain: Constants.environment.domain, path: "/api/v1/wallet/send", method: .post)
        input.params["wallet_address"] = walletAddress
        input.params["amount"] = amount
        
        APIServices.request(input: input, output: APIOutput.self, completion: completion)
    }
}
