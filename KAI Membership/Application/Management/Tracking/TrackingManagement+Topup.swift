//
//  TrackingManagement+Topup.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 19/03/2021.
//

import Foundation

extension TrackingManagement {
    
    // MARK: User top up mobile successfully
    class func topupMobileSuccessfully(userID: String) {
        AppsFlyerManagement.shared.logEvent(with: "af_topup", params: [
            "af_user_id": userID
//            "af_order_id": orderID
        ])
    }
}
