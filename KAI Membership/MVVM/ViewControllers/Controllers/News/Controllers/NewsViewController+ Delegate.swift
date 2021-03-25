//
//  NewsViewController+ Delegate.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 04/03/2021.
//

import UIKit

// MARK: KAIBarButtonItemViewDelegate
extension NewsViewController: KAIBarButtonItemViewDelegate {
    
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
extension NewsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionType = Section(rawValue: section), sectionType == .lastest else { return nil }
        
        let footerView = UIView()
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.attributedText = NSAttributedString(string: "Lastest News", attributes: [
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
        guard let sectionType = Section(rawValue: section), sectionType == .lastest else { return 0 }
        
        return 64
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let sectionType = Section(rawValue: indexPath.section) else { return 0 }
        
        switch sectionType {
        case .suggestion:
            return NewsSuggestionTableViewCell.height
        case .lastest:
            return NewsLastestTableViewCell.height
        }
    }
}
