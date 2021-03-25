//
//  NotificationManagement.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 19/03/2021.
//

import UIKit

class NotificationManagement {
    
    // MARK: Properties
    static let shared = NotificationManagement()
    
    // MARK: Methods
    func register() {
        if #available(iOS 10, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .alert, .sound]) { _, _ in }
            UIApplication.shared.registerForRemoteNotifications()
        } else {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
}
