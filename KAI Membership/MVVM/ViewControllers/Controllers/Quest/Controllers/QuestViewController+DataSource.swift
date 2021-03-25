//
//  QuestViewController+DataSource.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 04/03/2021.
//

import UIKit

// MARK: NestedScrollDataSource
extension QuestViewController: NestedScrollDataSource {
    
    func viewControllers(for pagerTabPageController: NestedScrollViewController) -> [UIViewController] {
        return [dailyVC, monthlyVC]
    }
    
    func defaultSelectedIndex(for pagerTabPageController: NestedScrollViewController) -> Int {
        return 0
    }
    
    func configureTitle() -> TabPageView.Setting {
        return .init()
    }
    
    func headerView(for pagerTabPageController: NestedScrollViewController) -> UIView {
        return headerView
    }
}
