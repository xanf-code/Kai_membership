//
//  PasswordViewController+Delegate.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 08/03/2021.
//

import UIKit

extension PasswordViewController: KAITextFieldDelegate {
    
    func kAITextFieldDidChange(_ textField: UITextField, for view: UIView) {
        isConfirmEnabled = (inputPasswordView.contentInput.count >= Constants.lengthPasswordMinimum) && !inputTokenView.contentInput.isEmpty && (confirmPasswordView.contentInput.count >= Constants.lengthPasswordMinimum)
    }
    
    func kAITextFieldShouldReturn(_ textField: UITextField, for view: UIView) -> Bool {
        return false
    }
    
    func kAITextFieldShouldClear(_ textField: UITextField, for view: UIView) -> Bool {
        return true
    }
}
