//
//  ProfileViewController+Delegate.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 24/03/2021.
//

import UIKit

// MARK: UIImagePickerControllerDelegate & UINavigationControllerDelegate
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 1)], for: UIControl.State())
        picker.dismiss(animated: true) {
            guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
            
            self.uploadImage(image)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 1)], for: UIControl.State())
        
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK: UIScrollViewDelegate
extension ProfileViewController {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y: CGFloat = scrollView.contentOffset.y
        
        if y <= 0 {
//            headerView.frame.size.height = 300 + y
//            navigationBarAnimation(withAlpha: 0)
            headerView.zoomImage(with: y)
        } else {
//            let headerHeight: CGFloat = headerView.originalHeaderHeight
//            let tmp = y / headerHeight
//            let alpha = y > headerHeight || tmp >= 1 ? 1 : tmp
//            navigationBarAnimation(withAlpha: alpha)
        }
    }
}

// MARK: UITableViewDelegate
extension ProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionType = Section(rawValue: section) else { return nil }
        
        let footerView = UIView()
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textColor = UIColor.black.withAlphaComponent(0.87)
        label.font = .workSansFont(ofSize: 20, weight: .regular)
        
        switch sectionType {
        case .personal:
            label.text = "Personal"
        case .others:
            label.text = "Others"
        }
        
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
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let sectionType = Section(rawValue: indexPath.section) else { return }
        
        switch sectionType {
        case .personal:
            guard let itemType = PersonalItem(rawValue: indexPath.row) else { return }
            
            switch itemType {
            case .profile:
                let user = AccountManagement.accountInfo
                Navigator.navigateToUpdateProfileVC(from: self, fullName: user?.kai?.firstName, birthday: user?.user?.birthday, phoneNumber: user?.user?.phone) { [weak self] accountInfo in
                    self?.headerView.configure(accountInfo)
                }
            case .rewards:
                Navigator.navigateToRewardsVC(from: self)
            case .changePassword:
                Navigator.navigateToPasscodeVC(from: self, with: .changePassword, email: AccountManagement.email)
            }
        case .others:
            guard let itemType = OthersItem(rawValue: indexPath.row) else { return }
            
            switch itemType {
            case .switchAccount:
                fetchAccountsLoggedIntoDevice()
            case .signOut:
                let alertController = UIAlertController(title: "Logout", message: "Do you want to logout?", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { [weak self] action in
                    AccountManagement.logout()
                    self?.fetchAccountsLoggedIntoDevice()
                }))
                alertController.addAction(UIAlertAction(title: "No", style: .cancel, handler: { action in }))
                
                if traitCollection.userInterfaceIdiom == .pad {
                    alertController.popoverPresentationController?.sourceView = view
                }
                
                present(alertController, animated: true, completion: nil)
            }
        }
    }
}
