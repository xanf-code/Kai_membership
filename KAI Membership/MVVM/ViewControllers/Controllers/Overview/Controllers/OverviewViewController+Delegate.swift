//
//  OverviewViewController+Delegate.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 16/03/2021.
//

import UIKit

// MARK: UITableViewDelegate
extension OverviewViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionType = Section(rawValue: section), sectionType == .info else { return nil }
        
        let View = UIView()
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textColor = UIColor.black.withAlphaComponent(0.87)
        label.font = .workSansFont(ofSize: 20, weight: .regular)
        
        switch type {
        case .topup:
            label.text = "Topup Settings"
        case .send:
            label.text = "Sender Info."
        }
        
        View.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: View.topAnchor, constant: 20),
            label.leadingAnchor.constraint(equalTo: View.leadingAnchor, constant: 20),
            label.bottomAnchor.constraint(equalTo: View.bottomAnchor),
            label.trailingAnchor.constraint(equalTo: View.trailingAnchor, constant: -20)
        ])
        
        return View
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let sectionType = Section(rawValue: section), sectionType == .info else { return 0 }
        
        return 56
    }
}
