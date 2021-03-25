//
//  SignInViewController+Delegate.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 01/03/2021.
//

import UIKit

extension SignInViewController: SignInInputViewDelegate {
    
    func signInInputViewDidFinishTouchingAction(_ signInInputView: SignInInputView, actionKey: SignInInputView.ActionKey) {
        switch actionKey {
        case.forgotPassword:
            Navigator.navigateToForgotPasswordVC(from: self)
        case .signIn:
            login()
        case .createAccount:
            Navigator.navigateToSignUpVC(from: self)
        }
    }
}
