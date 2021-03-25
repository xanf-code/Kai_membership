//
//  RootTabbarController.swift
//  Demo KAI
//
//  Created by Darshan Aswath on 22/01/2021.
//

import UIKit

class RootTabbarController: UITabBarController {
    
    // MARK: Properties
    enum TabbarType: Int, CaseIterable {
        case news = 0
        case quest
        case wallet
        case utilities
    }
    
    // MARK: Life cycle's
    override func loadView() {
        super.loadView()
        setViewControllers(viewControllers(), animated: true)
        tabBar.tintColor = .black
        tabBar.isTranslucent = false
        tabBar.layer.borderWidth = 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        requestUserQuestSignIn()
        TrackingServices.activity(userId: AccountManagement.accountID)
    }
    
    // MARK: Layout
    private func viewControllers() -> [UINavigationController] {
        var navigationControllers: [UINavigationController] = []
        
        TabbarType.allCases.forEach {
            switch $0 {
            case .news:
                let news = NewsViewController()
                let navigationController = RootNavigationController(rootViewController: news)
                navigationController.tabBarItem.title = "News"
                navigationController.tabBarItem.image = UIImage(named: "tabbar_news")?.withRenderingMode(.alwaysOriginal)
                navigationController.tabBarItem.selectedImage = UIImage(named: "tabbar_news_selected")?.withRenderingMode(.alwaysOriginal)
                navigationControllers.append(navigationController)
            case .quest:
                let quest = QuestViewController()
                let navigationController = RootNavigationController(rootViewController: quest)
                navigationController.tabBarItem.title = "Mission"
                navigationController.tabBarItem.image = UIImage(named: "tabbar_quests")?.withRenderingMode(.alwaysOriginal)
                navigationController.tabBarItem.selectedImage = UIImage(named: "tabbar_quests_selected")?.withRenderingMode(.alwaysOriginal)
                navigationControllers.append(navigationController)
            case .wallet:
                let wallet = WalletViewController()
                let navigationController = RootNavigationController(rootViewController: wallet)
                navigationController.tabBarItem.title = "My Wallet"
                navigationController.tabBarItem.image = UIImage(named: "tabbar_wallet")?.withRenderingMode(.alwaysOriginal)
                navigationController.tabBarItem.selectedImage = UIImage(named: "tabbar_wallet_selected")?.withRenderingMode(.alwaysOriginal)
                navigationControllers.append(navigationController)
            case .utilities:
                let utilities = UtilitiesViewController()
                let navigationController = RootNavigationController(rootViewController: utilities)
                navigationController.tabBarItem.title = "Utilities"
                navigationController.tabBarItem.image = UIImage(named: "tabbar_utilities")?.withRenderingMode(.alwaysOriginal)
                navigationController.tabBarItem.selectedImage = UIImage(named: "tabbar_utilities_selected")?.withRenderingMode(.alwaysOriginal)
                navigationControllers.append(navigationController)
            }
        }
        
        return navigationControllers
    }
    
    // MARK: Methods
    private func requestUserQuestSignIn() {
        if AccountManagement.accessToken != nil {
            QuestServices.requestUserQuest(with: .signIn) { [weak self] in
                switch $0 {
                case .success(let results):
                    if results.data?.isCompleted == true {
                        AlertManagement.shared.showToast(with: "🎁 You have 02 free spin", position: .top)
                    } else {
                        self?.showAlertYouHaveFreeSpinFirstLogin()
                    }
                case .failure(let error):
                    debugPrint("Error request user quest: \(error.message)")
                    self?.showAlertYouHaveFreeSpinFirstLogin()
                }
            }
        } else {
            showAlertYouHaveFreeSpinFirstLogin()
        }
    }
    
    private func showAlertYouHaveFreeSpinFirstLogin() {
        guard AppSetting.haveFreeSpin else { return }
            
        AlertManagement.shared.showToast(with: "🎁 You have 01 free spin", position: .top)
    }
}
