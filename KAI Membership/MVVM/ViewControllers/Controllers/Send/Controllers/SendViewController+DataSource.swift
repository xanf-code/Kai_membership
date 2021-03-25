//
//  SendViewController+DataSource.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 17/03/2021.
//

import UIKit

// MARK: UITableViewDataSource
extension SendViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sectionType = Section(rawValue: indexPath.section) else { return UITableViewCell() }
        
        switch sectionType {
        case .info:
            let cell = tableView.dequeueReusableCell(withIdentifier: CardCollapseTableViewCell.identifier, for: indexPath) as! CardCollapseTableViewCell
            cell.configure()
            
            return cell
        case .setting:
            let cell = tableView.dequeueReusableCell(withIdentifier: SendTableViewCell.identifier, for: indexPath) as! SendTableViewCell
            cell.delegate = self
            
            return cell
        }
    }
}
