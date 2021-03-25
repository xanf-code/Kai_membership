//
//  SignUpInputView.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 07/03/2021.
//

import UIKit
import RNLoadingButton_Swift

protocol SignUpInputViewDelegate: class {
    func signUpInputViewTextFieldValueChange(_ signUpInputView: SignUpInputView, textField: UITextField, inputType: SignUpInputView.InputType)
    func signUpInputViewDidFinishTouchingAction(_ signUpInputView: SignUpInputView, actionKey: SignUpInputView.ActionKey)
    func signUpInputViewRequestCaptcha(_ signUpInputView: SignUpInputView)
}

class SignUpInputView: UIView {

    // MARK: Properties
    enum ActionKey {
        case signIn
        case createAccount
    }
    
    enum InputType {
        case email
        case password
        case confirm
        case captcha
    }
    
    private let signInText: String = "I’m already a Darshan Aswath ! Sign In"
    private let detechActionSignInText: String = "Sign In"
    
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
    
    private(set) lazy var confirmPasswordTextField: KAIInputTextFieldView = {
        let view = KAIInputTextFieldView(with: .password, title: "CONFIRM PASSWORD", placeholder: "Confirm password")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        
        return view
    }()
    
    private let captchaContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let captchaImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let activityCaptchaView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .gray)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Constants.backroundColorDefault.withAlphaComponent(0.5)
        view.hidesWhenStopped = true
        view.startAnimating()
        
        return view
    }()
    
    private lazy var refreshCaptchaButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "ic_refresh_rotate")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.contentEdgeInsets = .init(top: 8, left: 8, bottom: 8, right: 8)
        button.addTarget(self, action: #selector(onPressedRefreshCaptcha), for: .touchUpInside)
        
        return button
    }()
    
    private(set) lazy var captchaTextField: KAIInputTextFieldView = {
        let view = KAIInputTextFieldView(with: .default, title: "CONFIRM CAPTCHA", placeholder: "Confirm captcha")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        
        return view
    }()
    
    private lazy var createAccountButton: RNLoadingButton = {
        let button = RNLoadingButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setAttributedTitle(NSAttributedString(string: "Create Account", attributes: [
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
        button.addTarget(self, action: #selector(onPressedCreateAccount), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var signInLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        label.numberOfLines = 1
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapSignIn(_:))))
        
        return label
    }()
    
    var isConfirmEnabled: Bool = false {
        didSet {
            guard isConfirmEnabled != oldValue else { return }
            
            createAccountButton.isEnabled = isConfirmEnabled
            
            if isConfirmEnabled {
                createAccountButton.gradientBackgroundColors([UIColor.init(hex: "394656").cgColor, UIColor.init(hex: "181E25").cgColor], direction: .vertical)
            } else {
                createAccountButton.removeAllSublayers(withName: UIView.gradientLayerKey)
            }
        }
    }
    
    var isLoading: Bool = false {
        didSet {
            isConfirmEnabled = !isLoading
            createAccountButton.isLoading = isLoading
        }
    }
    
    weak var delegate: SignUpInputViewDelegate?
    
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
        addSubview(confirmPasswordTextField)
        addSubview(captchaContainerView)
        addSubview(refreshCaptchaButton)
        addSubview(captchaTextField)
        addSubview(createAccountButton)
        addSubview(signInLabel)
        
        captchaContainerView.addSubview(captchaImageView)
        captchaContainerView.addSubview(activityCaptchaView)
        
        NSLayoutConstraint.activate([
            emailTextField.topAnchor.constraint(equalTo: topAnchor),
            emailTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            emailTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 12),
            passwordTextField.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            
            confirmPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 12),
            confirmPasswordTextField.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            confirmPasswordTextField.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            
            refreshCaptchaButton.centerYAnchor.constraint(equalTo: captchaContainerView.centerYAnchor),
            refreshCaptchaButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            refreshCaptchaButton.widthAnchor.constraint(equalToConstant: 56),
            refreshCaptchaButton.heightAnchor.constraint(equalToConstant: 56),
            
            captchaContainerView.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant: 12),
            captchaContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            captchaContainerView.trailingAnchor.constraint(equalTo: refreshCaptchaButton.leadingAnchor),
            captchaContainerView.heightAnchor.constraint(equalToConstant: 80),
            
            captchaImageView.topAnchor.constraint(equalTo: captchaContainerView.topAnchor),
            captchaImageView.leadingAnchor.constraint(equalTo: captchaContainerView.leadingAnchor),
            captchaImageView.bottomAnchor.constraint(equalTo: captchaContainerView.bottomAnchor),
            captchaImageView.trailingAnchor.constraint(equalTo: captchaContainerView.trailingAnchor),
            
            activityCaptchaView.topAnchor.constraint(equalTo: captchaContainerView.topAnchor),
            activityCaptchaView.leadingAnchor.constraint(equalTo: captchaContainerView.leadingAnchor),
            activityCaptchaView.bottomAnchor.constraint(equalTo: captchaContainerView.bottomAnchor),
            activityCaptchaView.trailingAnchor.constraint(equalTo: captchaContainerView.trailingAnchor),
            
            captchaTextField.topAnchor.constraint(equalTo: captchaContainerView.bottomAnchor, constant: 12),
            captchaTextField.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            captchaTextField.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            
            createAccountButton.topAnchor.constraint(equalTo: captchaTextField.bottomAnchor, constant: 32),
            createAccountButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            createAccountButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            createAccountButton.heightAnchor.constraint(equalToConstant: 52),
            
            signInLabel.topAnchor.constraint(equalTo: createAccountButton.bottomAnchor, constant: 20),
            signInLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            signInLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
        ])
        
        configureSignInLabel()
    }

    private func configureSignInLabel() {
        let mutableAttributedString = NSMutableAttributedString(attributedString: NSAttributedString(string: signInText, attributes: [
            NSAttributedString.Key.font: UIFont.workSansFont(ofSize: 14, weight: .medium),
            NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(0.54)
        ]))
        
        let range = (signInText as NSString).range(of: detechActionSignInText)
        mutableAttributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.workSansFont(ofSize: 14, weight: .medium), range: range)
        mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.init(hex: "94A2B2"), range: range)
        
        signInLabel.attributedText = mutableAttributedString
    }
    
    // MARK: Methods
    func setCaptchaImage(_ url: URL) {
        captchaImageView.setImage(from: url)
        activityCaptchaView.isHidden = true
    }
}

// MARK: Handle actions
extension SignUpInputView {
    
    @objc private func onPressedCreateAccount() {
        delegate?.signUpInputViewDidFinishTouchingAction(self, actionKey: .createAccount)
    }

    @objc private func onTapSignIn(_ recognizer: UITapGestureRecognizer) {
        let range = (signInText as NSString).range(of: detechActionSignInText)

        guard recognizer.didTapAttributedTextInLabel(label: signInLabel, inRange: range) else { return }
        
        delegate?.signUpInputViewDidFinishTouchingAction(self, actionKey: .signIn)
    }
    
    @objc private func onPressedRefreshCaptcha() {
        guard activityCaptchaView.isHidden else { return }
        
        delegate?.signUpInputViewRequestCaptcha(self)
        activityCaptchaView.isHidden = false
    }
}

// MARK: KAITextFieldDelegate
extension SignUpInputView: KAITextFieldDelegate {
    
    func kAITextFieldDidChange(_ textField: UITextField, for view: UIView) {
        if textField == emailTextField {
            delegate?.signUpInputViewTextFieldValueChange(self, textField: textField, inputType: .email)
        } else if textField == passwordTextField {
            delegate?.signUpInputViewTextFieldValueChange(self, textField: textField, inputType: .password)
        } else if textField == confirmPasswordTextField {
            delegate?.signUpInputViewTextFieldValueChange(self, textField: textField, inputType: .confirm)
        } else if textField == captchaTextField {
            delegate?.signUpInputViewTextFieldValueChange(self, textField: textField, inputType: .captcha)
        }
        
        isConfirmEnabled = !emailTextField.contentInput.isEmpty && (passwordTextField.contentInput.count >= Constants.lengthPasswordMinimum) && (confirmPasswordTextField.contentInput.count >= Constants.lengthPasswordMinimum) && !(captchaTextField.contentInput.isEmpty)
    }
    
    func kAITextFieldShouldReturn(_ textField: UITextField, for view: UIView) -> Bool {
        return false
    }
    
    func kAITextFieldShouldClear(_ textField: UITextField, for view: UIView) -> Bool {
        return true
    }
}
