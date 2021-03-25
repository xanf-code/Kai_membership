//
//  SignInView.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 20/02/2021.
//

import UIKit
import RNLoadingButton_Swift

protocol SignInInputViewDelegate: class {
    func signInInputViewEmailValueChange(_ signInInputView: SignInInputView, textField: UITextField)
    func signInInputViewPasswordValueChange(_ signInInputView: SignInInputView, textField: UITextField)
    func signInInputViewDidFinishTouchingAction(_ signInInputView: SignInInputView, actionKey: SignInInputView.ActionKey)
}

extension SignInInputViewDelegate {
    func signInInputViewEmailValueChange(_ signInInputView: SignInInputView, textField: UITextField) {}
    func signInInputViewPasswordValueChange(_ signInInputView: SignInInputView, textField: UITextField) {}
}

class SignInInputView: UIView {

    // MARK: Properties
    enum ActionKey {
        case forgotPassword
        case signIn
        case createAccount
    }
    
    private let signUpText: String = "Not a Darshan Aswath yet? Create account"
    private let detechActionSignUpText: String = "Create account"
    
    private(set) lazy var emailTextField: KAIInputTextFieldView = {
        let view = KAIInputTextFieldView(with: .default, title: "EMAIL", placeholder: "eg. an.nguyen@kardianchain.io", keyboardType: .emailAddress)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        
        return view
    }()
    
    private(set) lazy var passwordTextField: KAIInputTextFieldView = {
        let view = KAIInputTextFieldView(with: .password, title: "PASSWORD", placeholder: "Your password")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        
        return view
    }()
    
    private lazy var forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setAttributedTitle(NSAttributedString(string: "Forgot password?", attributes: [
            NSAttributedString.Key.font: UIFont.workSansFont(ofSize: 12, weight: .medium),
            NSAttributedString.Key.foregroundColor: UIColor.init(hex: "94A2B2")
        ]), for: .normal)
        button.contentEdgeInsets = .init(top: 8, left: 0, bottom: 8, right: 0)
        button.addTarget(self, action: #selector(onPressedForgotPassword), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var signInButton: RNLoadingButton = {
        let button = RNLoadingButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setAttributedTitle(NSAttributedString(string: "Sign in", attributes: [
            NSAttributedString.Key.font: UIFont.workSansFont(ofSize: 16, weight: .medium),
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]), for: .normal)
        button.isEnabled = false
        button.backgroundColor = .init(hex: "E1E4E8")
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 8
        button.activityIndicatorAlignment = RNActivityIndicatorAlignment.left
        button.activityIndicatorEdgeInsets.left = 16
        button.hideTextWhenLoading = false
        button.isLoading = false
        button.activityIndicatorColor = .black
        button.addTarget(self, action: #selector(onPressedSignIn), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var signUpLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        label.numberOfLines = 1
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapCreateAccount(_:))))
        
        return label
    }()
    
    var isConfirmEnabled: Bool = false {
        didSet {
            guard isConfirmEnabled != oldValue else { return }
            
            signInButton.isEnabled = isConfirmEnabled
            
            if isConfirmEnabled {
                signInButton.gradientBackgroundColors([UIColor.init(hex: "394656").cgColor, UIColor.init(hex: "181E25").cgColor], direction: .vertical)
            } else {
                signInButton.removeAllSublayers(withName: UIView.gradientLayerKey)
            }
        }
    }
    
    var isLoading: Bool = false {
        didSet {
            isConfirmEnabled = !isLoading
            signInButton.isLoading = isLoading
        }
    }
    
    weak var delegate: SignInInputViewDelegate?
    
    // MARK: Life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    func setupView() {
        addSubview(emailTextField)
        addSubview(passwordTextField)
        addSubview(forgotPasswordButton)
        addSubview(signInButton)
        addSubview(signUpLabel)
        
        NSLayoutConstraint.activate([
            emailTextField.topAnchor.constraint(equalTo: topAnchor),
            emailTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            emailTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 12),
            passwordTextField.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            
            forgotPasswordButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 8),
            forgotPasswordButton.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 20),
            forgotPasswordButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            signInButton.topAnchor.constraint(equalTo: forgotPasswordButton.bottomAnchor, constant: 8),
            signInButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            signInButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            signInButton.heightAnchor.constraint(equalToConstant: 52),
            
            signUpLabel.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 20),
            signUpLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            signUpLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
        ])
        
        configureSignUpLabel()
    }

    private func configureSignUpLabel() {
        let mutableAttributedString = NSMutableAttributedString(attributedString: NSAttributedString(string: signUpText, attributes: [
            NSAttributedString.Key.font: UIFont.workSansFont(ofSize: 14, weight: .medium),
            NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(0.54)
        ]))
        
        let range = (signUpText as NSString).range(of: detechActionSignUpText)
        mutableAttributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.workSansFont(ofSize: 14, weight: .medium), range: range)
        mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.init(hex: "94A2B2"), range: range)
        
        signUpLabel.attributedText = mutableAttributedString
    }
}

// MARK: Handle actions
extension SignInInputView {
    
    @objc private func onPressedForgotPassword() {
        delegate?.signInInputViewDidFinishTouchingAction(self, actionKey: .forgotPassword)
    }
    
    @objc private func onPressedSignIn() {
        delegate?.signInInputViewDidFinishTouchingAction(self, actionKey: .signIn)
    }
    
    @objc private func onTapCreateAccount(_ recognizer: UITapGestureRecognizer) {
        let range = (signUpText as NSString).range(of: detechActionSignUpText)

        guard recognizer.didTapAttributedTextInLabel(label: signUpLabel, inRange: range) else { return }
        
        delegate?.signInInputViewDidFinishTouchingAction(self, actionKey: .createAccount)
    }
}

// MARK: KAITextFieldDelegate
extension SignInInputView: KAITextFieldDelegate {
    
    func kAITextFieldDidChange(_ textField: UITextField, for view: UIView) {
        if view == emailTextField {
            delegate?.signInInputViewEmailValueChange(self, textField: textField)
        } else if view == passwordTextField {
            delegate?.signInInputViewPasswordValueChange(self, textField: textField)
        }
        
        isConfirmEnabled = !emailTextField.contentInput.isEmpty && passwordTextField.contentInput.count >= Constants.lengthPasswordMinimum
    }
    
    func kAITextFieldShouldReturn(_ textField: UITextField, for view: UIView) -> Bool {
//        delegate?.signInViewDidFinishTouchingAction(self, actionKey: .signIn)
        return false
    }
    
    func kAITextFieldShouldClear(_ textField: UITextField, for view: UIView) -> Bool {
        return true
    }
}
