//
//  SendViewController+Delegate.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 17/03/2021.
//

import UIKit

// MARK: UITableViewDelegate
extension SendViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionType = Section(rawValue: section), sectionType == .setting else { return nil }
        
        let View = UIView()
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textColor = UIColor.black.withAlphaComponent(0.87)
        label.font = .workSansFont(ofSize: 20, weight: .regular)
        label.text = "Sender Info."
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
        guard let sectionType = Section(rawValue: section), sectionType == .setting else { return 0 }
        
        return 56
    }
}

// MARk: SendTableViewCellDelegate
extension SendViewController: SendTableViewCellDelegate {
    
    func sendTableViewCellWalletAddressValueChanged(_ sendTableViewCell: SendTableViewCell, textField: UITextField) {
        viewModel.walletAddress = textField.text ?? ""
        isConfirmEnabled = !viewModel.walletAddress.isEmpty && (viewModel.amount.kai > 0)
    }
    
    func sendTableViewCellAmountValueChanged(_ sendTableViewCell: SendTableViewCell, textField: UITextField, amount: Double?) {
        viewModel.amount = Amount(money: 0, kai: amount ?? 0)
        isConfirmEnabled = !viewModel.walletAddress.isEmpty && (viewModel.amount.kai > 0)
    }
}
