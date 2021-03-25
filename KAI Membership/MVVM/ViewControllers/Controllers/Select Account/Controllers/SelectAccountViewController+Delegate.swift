//
//  SelectAccountViewController+Delegate.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 01/03/2021.
//

import UIKit

// MARK: UITableViewDelegate
extension SelectAccountViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setAttributedTitle(NSAttributedString(string: "Sign in to another account", attributes: [
            NSAttributedString.Key.font: UIFont.workSansFont(ofSize: 14, weight: .medium),
            NSAttributedString.Key.foregroundColor: UIColor.init(hex: "017CAD")
        ]), for: .normal)
        button.addTarget(self, action: #selector(onPressedSignInAnotherAccount), for: .touchUpInside)
        footerView.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: footerView.topAnchor),
            button.leadingAnchor.constraint(equalTo: footerView.leadingAnchor),
            button.bottomAnchor.constraint(equalTo: footerView.bottomAnchor),
            button.trailingAnchor.constraint(equalTo: footerView.trailingAnchor)
        ])
        
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let email = users[indexPath.row].email else { return }
        
        Navigator.navigateToPasscodeVC(from: self, with: .login, email: email)
    }
}
