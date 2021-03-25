//
//  PasscodeViewController+Delegate.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 04/03/2021.
//

import UIKit

// MARK: PasscodeViewDelegate
extension PasscodeViewController: PasscodeViewDelegate {
    
    func passcodeViewDelegateStatusEntered(with status: PasscodeView.CodeStatus, _ passcodeView: PasscodeView) {
        switch status {
        case .enoughCode:
            isConfirmEnabled = true
        case .haveNotEnoughCode:
            isConfirmEnabled = false
        }
    }
}
