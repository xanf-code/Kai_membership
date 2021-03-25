//
//  VerificationViewController+Delegate.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 19/03/2021.
//

import UIKit

// MARK: KAITextFieldDelegate
extension VerificationViewController: KAITextFieldDelegate {
    
    func kAITextFieldDidChange(_ textField: UITextField, for view: UIView) {
        isConfirmEnabled = !(textField.text ?? "").isEmpty
    }
    
    func kAITextFieldShouldReturn(_ textField: UITextField, for view: UIView) -> Bool {
        return false
    }
    
    func kAITextFieldShouldClear(_ textField: UITextField, for view: UIView) -> Bool {
        return true
    }
}
