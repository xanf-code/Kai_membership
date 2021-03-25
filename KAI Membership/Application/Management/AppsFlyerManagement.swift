//
//  AppsFlyerManagement.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 19/03/2021.
//

import UIKit
import AppsFlyerLib

class AppsFlyerManagement: NSObject {
    
    // MARK: Properties
    static let shared = AppsFlyerManagement()
    
    // MARK: Methods
    func register() {
        AppsFlyerLib.shared().appsFlyerDevKey = "hf9GFLkT7jnwPGtGs3LQRW"
        AppsFlyerLib.shared().appleAppID = "1551610228"
        AppsFlyerLib.shared().delegate = self
        AppsFlyerLib.shared().isDebug = true
        
        AppsFlyerLib.shared().deepLinkDelegate = self
    }
    
    func start() {
        AppsFlyerLib.shared().start()
    }
    
    func handlePushNotification(_ userInfo: [AnyHashable : Any]) {
        AppsFlyerLib.shared().handlePushNotification(userInfo)
    }
    
    func `continue`(_ userActivity: NSUserActivity, restorationHandler: (([Any]?) -> Void)? = nil) {
        AppsFlyerLib.shared().continue(userActivity, restorationHandler: restorationHandler)
    }
    
    func handleOpen(_ url: URL, sourceApplication: String?, withAnnotation annotation: Any? = nil) {
        AppsFlyerLib.shared().handleOpen(url, sourceApplication: sourceApplication, withAnnotation: annotation)
    }
    
    func handleOpen(_ url: URL, options: [AnyHashable : Any]? = nil) {
        AppsFlyerLib.shared().handleOpen(url, options: options)
    }
    
    func logEvent(with name: String, params: [String : Any]? = nil) {
        AppsFlyerLib.shared().logEvent(name, withValues: params)
    }
    
    private func walkToSceneWithParams(params: [AnyHashable : Any]) {
        AppSetting.referrerID = params["user"] as? String
    }
    
    private func walkToSceneWithParams(deepLinkObj: DeepLink) {
        AppSetting.referrerID = deepLinkObj.clickEvent["user"] as? String
    }
}

//MARK: AppsFlyerTrackerDelegate
extension AppsFlyerManagement: AppsFlyerLibDelegate {
    
    // MARK: Deferred deep linking
    // Handle Organic/Non-organic installation
    func onConversionDataSuccess(_ installData: [AnyHashable: Any]) {
        debugPrint("onConversionDataSuccess data:")
        for (key, value) in installData {
            debugPrint(key, ":", value)
        }
        
        if let status = installData["af_status"] as? String {
            if (status == "Non-organic") {
                if let sourceID = installData["media_source"],
                   let campaign = installData["campaign"] {
                    debugPrint("This is a Non-Organic install. Media source: \(sourceID)  Campaign: \(campaign)")
                }
            } else {
                debugPrint("This is an organic install.")
            }
            
            if let is_first_launch = installData["is_first_launch"] as? Bool, is_first_launch {
                debugPrint("First Launch")
            } else {
                debugPrint("Not First Launch")
            }
        }
    }
    
    func onConversionDataFail(_ error: Error) {
        debugPrint(error)
    }
    
    // MARK: Direct deep linking
    //Handle Deep Link
    func onAppOpenAttribution(_ attributionData: [AnyHashable : Any]) {
        //Handle Deep Link Data
        debugPrint("onAppOpenAttribution data:")
        for (key, value) in attributionData {
            debugPrint(key, ":",value)
        }
        
        walkToSceneWithParams(params: attributionData)
    }
    
    func onAppOpenAttributionFailure(_ error: Error) {
        debugPrint(error)
    }
}

// MARK: DeepLinkDelegate
extension AppsFlyerManagement: DeepLinkDelegate {
    
    // Unified deep linking
    func didResolveDeepLink(_ result: DeepLinkResult) {
        switch result.status {
        case .notFound:
            debugPrint("Deep link not found")
        case .found:
            let deepLinkStr: String = result.deepLink!.toString()
            
            debugPrint("DeepLink data is: \(deepLinkStr)")
            
            if( result.deepLink?.isDeferred == true) {
                debugPrint("This is a deferred deep link")
            } else {
                debugPrint("This is a direct deep link")
            }
            
            walkToSceneWithParams(deepLinkObj: result.deepLink!)
        case .failure:
            debugPrint("Error %@", result.error!)
        }
    }
}
