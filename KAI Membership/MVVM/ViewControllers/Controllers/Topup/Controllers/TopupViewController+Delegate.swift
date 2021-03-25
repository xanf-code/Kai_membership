//
//  TopupViewController+Delegate.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 11/03/2021.
//

import UIKit

// MARK: UITableViewDelegate
extension TopupViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionType = Section(rawValue: section), sectionType == .setting else { return nil }
        
        let View = UIView()
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textColor = UIColor.black.withAlphaComponent(0.87)
        label.font = .workSansFont(ofSize: 20, weight: .regular)
        label.text = "Topup Settings"
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

// MARK: TopupTableViewCellDelegate
extension TopupViewController: TopupTableViewCellDelegate {
    
    func topupTableViewCellPhoneValueChange(_ topupTableViewCell: TopupTableViewCell, textField: UITextField) {
        viewModel.phoneNumber = textField.text ?? ""
        isConfirmEnabled = !viewModel.phoneNumber.isEmpty
    }
    
    func topupTableViewCellProvider(_ topupTableViewCell: TopupTableViewCell, didSelectIndex index: Int) {
        viewModel.serviceProviderIndex = index
    }
    
    func topupTableViewCellDidValueMoney(_ topupTableViewCell: TopupTableViewCell, amount: Amount) {
        viewModel.amount = amount
    }
}

// MARK: UIGestureRecognizerDelegate
extension TopupViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let cell = tableView.cellForRow(at: IndexPath(row: 0, section: Section.setting.rawValue)) as? TopupTableViewCell else { return true }
        
        if touch.view?.isDescendant(of: cell.providerCollectionView) == true {
            return false
        }
        
        return true
    }
}
