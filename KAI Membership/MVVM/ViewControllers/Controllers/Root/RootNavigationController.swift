//
//  RootNavigationController.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 10/03/2021.
//

import UIKit

class RootNavigationController: UINavigationController {
    
    // MARK: Properties
    private let backgroundStatusBarView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    // MARK: Life’s cycle
    override func loadView() {
        super.loadView()
        view.addSubview(backgroundStatusBarView)
        
        NSLayoutConstraint.activate([
            backgroundStatusBarView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundStatusBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundStatusBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundStatusBarView.heightAnchor.constraint(equalToConstant: UIApplication.shared.statusBarFrame.height)
        ])
        
        let backIndicatorImage = UIImage(named: "ic_back")?.withRenderingMode(.alwaysOriginal)
        navigationBar.backIndicatorImage = backIndicatorImage
        navigationBar.backIndicatorTransitionMaskImage = backIndicatorImage
        navigationBar.isTranslucent = true
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.setBackgroundImage(UIImage(), for: .compact)
        navigationBar.shadowImage = UIImage()
        navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.workSansFont(ofSize: 20, weight: .regular),
            NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(0.87)
        ]
        navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.font: UIFont.workSansFont(ofSize: 36, weight: .regular),
            NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(0.87)
        ]
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: 0, vertical: -12), for: .default)
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: 0, vertical: -12), for: .compact)
    }
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        setBackgroundColor(.white)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        viewController.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        super.pushViewController(viewController, animated: animated)
    }
    
    // MARK: Methods
    func setBackgroundColor(_ color: UIColor) {
        backgroundStatusBarView.backgroundColor = color
        navigationBar.backgroundColor = color
    }
}
