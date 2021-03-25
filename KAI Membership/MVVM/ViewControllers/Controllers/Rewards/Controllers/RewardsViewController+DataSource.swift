//
//  RewardsViewController+DataSource.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 10/03/2021.
//

import UIKit
import DZNEmptyDataSet

// MARK: DZNEmptyDataSetSource
extension RewardsViewController: DZNEmptyDataSetSource {
    
    func customView(forEmptyDataSet scrollView: UIScrollView!) -> UIView! {
        return emptyView
    }
}

// MARK: UITableViewDataSource
extension RewardsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.histories.count > 0 ? Section.allCases.count : 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionType = Section(rawValue: section) else { return 0 }
        
        switch sectionType {
        case .rewards:
            return 0
        case .history:
            return viewModel.histories.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sectionType = Section(rawValue: indexPath.section) else { return UITableViewCell() }
        
        switch sectionType {
        case .rewards:
            let cell = tableView.dequeueReusableCell(withIdentifier: RewardsTableViewCell.identifier, for: indexPath) as! RewardsTableViewCell
            
            return cell
        case .history:
            let cell = tableView.dequeueReusableCell(withIdentifier: HistoryTableViewCell.identifier, for: indexPath) as! HistoryTableViewCell
            cell.configure(viewModel.histories[indexPath.row])
            
            return cell
        }
    }
}
