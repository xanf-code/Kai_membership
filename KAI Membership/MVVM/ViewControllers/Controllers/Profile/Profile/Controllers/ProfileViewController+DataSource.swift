//
//  ProfileViewController+DataSource.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 24/03/2021.
//

import UIKit

// MARK: UITableViewDataSource
extension ProfileViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionType = Section(rawValue: section) else { return 0 }
        
        switch sectionType {
        case .personal:
            return PersonalItem.allCases.count
        case .others:
            return OthersItem.allCases.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sectionType = Section(rawValue: indexPath.section) else { return UITableViewCell() }
        
        switch sectionType {
        case .personal:
            guard let itemType = PersonalItem(rawValue: indexPath.row) else { return UITableViewCell() }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.identifier, for: indexPath) as! ProfileTableViewCell
            
            switch itemType {
            case .profile:
                cell.configure(with: .profile)
            case .rewards:
                cell.configure(with: .rewards)
            case .changePassword:
                cell.configure(with: .changePassword)
            }
            
            return cell
        case .others:
            guard let itemType = OthersItem(rawValue: indexPath.row) else { return UITableViewCell() }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.identifier, for: indexPath) as! ProfileTableViewCell
            
            switch itemType {
            case .switchAccount:
                cell.configure(with: .switchAccount)
            case .signOut:
                cell.configure(with: .signOut)
            }
            
            return cell
        }
    }
}
