//
//  UIViewController+Extensions.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 24/03/2021.
//

import UIKit

// MARK: Properties
extension UIViewController {
    
    var window: UIWindow? {
        if #available(iOS 13, *) {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let delegate = windowScene.delegate as? SceneDelegate, let window = delegate.window else { return nil }

            return window
        }
        
        guard let delegate = UIApplication.shared.delegate as? AppDelegate, let window = delegate.window else { return nil }
        
        return window
    }
    
    var identifier: String {
        return String(describing: type(of: self))
    }
    
    var safeAreaInsets: UIEdgeInsets {
        return UIApplication.shared.keyWindow?.safeAreaInsets ?? view.safeAreaInsets
    }
}

// MARK: Methods
extension UIViewController {
    
    func add(_ child: UIViewController, to: UIView? = nil, frame: CGRect? = nil, belowSubview: UIView? = nil) {
        addChild(child)
        
        if let frame = frame { child.view.frame = frame }
        
        if let belowSubview = belowSubview {
            if let toView = to {
                toView.insertSubview(child.view, belowSubview: belowSubview)
            } else{
                view.insertSubview(child.view, belowSubview: belowSubview)
            }
        } else {
            if let toView = to {
                toView.addSubview(child.view)
            } else{
                view.addSubview(child.view)
            }
        }
        
        child.didMove(toParent: self)
    }
    
    func remove() {
        // Just to be safe, we check that this view controller
        // is actually added to a parent before removing it.
        guard parent != nil else { return }
        
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}
