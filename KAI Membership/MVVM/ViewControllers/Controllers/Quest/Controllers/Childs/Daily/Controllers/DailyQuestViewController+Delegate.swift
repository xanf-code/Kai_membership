//
//  DailyQuestViewController+Delegate.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 18/03/2021.
//

import UIKit
import DZNEmptyDataSet

// MARK: DZNEmptyDataSetDelegate
extension DailyQuestViewController: DZNEmptyDataSetDelegate {
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
}
