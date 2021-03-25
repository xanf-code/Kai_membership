//
//  UpdateProfileViewController+Delegate.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 10/03/2021.
//

import UIKit

// MARK: KAITextFieldDelegate
extension UpdateProfileViewController: KAITextFieldDelegate {
    
    func kAITextFieldDidChange(_ textField: UITextField, for view: UIView) {
        if view == inputFullNameView {
            viewModel.fullName = inputFullNameView.contentInput
        } else if view == inputPhoneNumberView {
            viewModel.phoneNumber = inputPhoneNumberView.contentInput
        }
        
        isConfirmEnabled = viewModel.hasChanged
    }
    
    func kAITextFieldShouldReturn(_ textField: UITextField, for view: UIView) -> Bool {
        return false
    }
    
    func kAITextFieldShouldClear(_ textField: UITextField, for view: UIView) -> Bool {
        return true
    }
}

