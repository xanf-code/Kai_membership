//
//  SignUpViewController+Delegate.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 07/03/2021.
//

import UIKit

extension SignUpViewController: SignUpInputViewDelegate {
    
    func signUpInputViewTextFieldValueChange(_ signUpInputView: SignUpInputView, textField: UITextField, inputType: SignUpInputView.InputType) {}
    
    func signUpInputViewDidFinishTouchingAction(_ signUpInputView: SignUpInputView, actionKey: SignUpInputView.ActionKey) {
        switch actionKey {
        case .signIn:
//            navigationController?.viewControllers.removeAll { return $0 is SignInViewController }
            Navigator.navigateToSignInVC(from: self)
        case .createAccount:
            createAccount()
        }
    }
    
    func signUpInputViewRequestCaptcha(_ signUpInputView: SignUpInputView) {
        generateCaptcha()
    }
}
