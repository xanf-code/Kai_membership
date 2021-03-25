//
//  WalletViewController+Delegate.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 02/03/2021.
//

import UIKit
import DZNEmptyDataSet

// MARK: DZNEmptyDataSetDelegate
extension WalletViewController: DZNEmptyDataSetDelegate {
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
}

// MARK: KAIBarButtonItemViewDelegate
extension WalletViewController: KAIBarButtonItemViewDelegate {
    
    func kAIBarButtonItemViewDidSelecteSpin(_ kAIBarButtonItemView: KAIBarButtonItemView) {
        Navigator.openSpin(from: self)
    }
    
    func kAIBarButtonItemViewDidSelecteProfile(_ kAIBarButtonItemView: KAIBarButtonItemView) {
        if AccountManagement.isLoggedIn {
            Navigator.navigateToProfileVC(from: self)
        } else {
            Navigator.navigateToSignInVC(from: self) { [weak self] in
                guard let this = self else { return }
                
                kAIBarButtonItemView.refresh()
                Navigator.navigateToProfileVC(from: this)
            }
        }
    }
}

// MARK: UITableViewDelegate
extension WalletViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let footerView = UIView()
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.attributedText = NSAttributedString(string: "Recent Transactions", attributes: [
            NSAttributedString.Key.font: UIFont.workSansFont(ofSize: 20, weight: .regular),
            NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(0.87)
        ])
        footerView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: footerView.topAnchor),
            label.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 20),
            label.bottomAnchor.constraint(equalTo: footerView.bottomAnchor),
            label.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -20)
        ])
        
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}

