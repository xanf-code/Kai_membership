//
//  TrackingManagement+Registration.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 19/03/2021.
//

import Foundation

extension TrackingManagement {
    
    // MARK: User start the registration screen
    class func startRegistration() {
        AppsFlyerManagement.shared.logEvent(with: "af_start")
    }
    
    // MARK: User completes registration successfully
    class func registrationSuccessfully(registrationMethod: RegistrationMethod, userID: String, email: String, time: Int) {
        AppsFlyerManagement.shared.logEvent(with: "af_complete_registration", params: [
            "af_registration_method" : registrationMethod.rawValue,
            "af_user_id" : userID,
            "af_email" : email,
            "af_time" : time
        ])
    }
}
