//
//  SelectAccountViewController+DataSource.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 01/03/2021.
//

import UIKit

// MARK: UITableViewDataSource
extension SelectAccountViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SelectAccountTableViewCell.identifier, for: indexPath) as! SelectAccountTableViewCell
        cell.configure(with: users[indexPath.row])
        
        return cell
    }
}
