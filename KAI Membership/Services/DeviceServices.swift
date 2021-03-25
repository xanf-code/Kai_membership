//
//  DeviceServices.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 03/03/2021.
//

import Foundation

class DeviceServices {
    
    // MARK: Get a list of accounts that have been logged in to the device
    class func getAccountsLoggedIntoDevice(_ completion: @escaping (APIResult<APIDataResults<DeviceRemote>, APIErrorResult>) -> Void) {
        let input = APIInput(withDomain: Constants.environment.domain, path: "/api/v1/devices/\(Constants.Device.id)", method: .get)
        
        APIServices.request(input: input, output: APIOutput.self, completion: completion)
    }
}
