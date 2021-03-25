//
//  UtilitiesViewController+DataSource.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 02/03/2021.
//

import UIKit

// MARK: UITableViewDataSource
extension UtilitiesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UtilitiesTableViewCell.identifier, for: indexPath) as! UtilitiesTableViewCell
        cell.configure(with: .mobileTopup)
        cell.didFinishTouchingAction = { [weak self] in
            self?.mobileTopup()
        }
        
        return cell
    }
}
