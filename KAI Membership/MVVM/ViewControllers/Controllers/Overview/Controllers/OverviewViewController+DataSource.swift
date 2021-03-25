//
//  OverviewViewController+DataSource.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 16/03/2021.
//

import UIKit

// MARK: UITableViewDataSource
extension OverviewViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sectionType = Section(rawValue: indexPath.section) else { return UITableViewCell() }
        
        switch sectionType {
        case .title:
            let cell = tableView.dequeueReusableCell(withIdentifier: CardCollapseTableViewCell.identifier, for: indexPath) as! CardCollapseTableViewCell
            cell.configure()
            
            return cell
        case .info:
            switch type {
            case .topup:
                let cell = tableView.dequeueReusableCell(withIdentifier: OverviewTopupTableViewCell.identifier, for: indexPath) as! OverviewTopupTableViewCell
                cell.configure(phoneNumber: viewModel.phoneNumber, providerCode: viewModel.providerCode, amount: viewModel.amount)
                
                return cell
            case .send:
                let cell = tableView.dequeueReusableCell(withIdentifier: OverviewSendTableViewCell.identifier, for: indexPath) as! OverviewSendTableViewCell
                cell.configure(walletAddress: viewModel.address, amount: viewModel.amount.kai)
                
                return cell
            }
        }
    }
}
