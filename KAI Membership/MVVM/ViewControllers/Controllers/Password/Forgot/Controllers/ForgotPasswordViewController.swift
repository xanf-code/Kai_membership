//
//  ForgotPasswordViewController.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 20/02/2021.
//

import UIKit
import RxSwift
import RNLoadingButton_Swift

class ForgotPasswordViewController: BaseViewController {
    
    // MARK: Properties
    let viewModel = ForgotPasswordViewModel()
    
    private let sendCodeToEmail: String = "Did not receive any email?\nCheck your spam filter, or resend another mail"
    private let detectActionSendCodeToEmail: String = "resend another mail"
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.attributedText = "We will send an instruction to your email.".setTextWithFormat(font: .workSansFont(ofSize: 14, weight: .medium), lineHeight: 28, textColor: UIColor.black.withAlphaComponent(0.54))
        
        return label
    }()
    
    private lazy var emailTextField: KAIInputTextFieldView = {
        let view = KAIInputTextFieldView(with: .default, title: "EMAIL", placeholder: "Enter your email", keyboardType: .emailAddress)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        
        return view
    }()
    
    private lazy var sendButton: RNLoadingButton = {
        let button = RNLoadingButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setAttributedTitle(NSAttributedString(string: "Send Instructions", attributes: [
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
        button.addTarget(self, action: #selector(onPressedSend), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var sendCodeToEmailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        label.numberOfLines = 2
        label.textAlignment = .center
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapSendCodeToEmail(_:))))
        
        return label
    }()
    
    var isConfirmEnabled: Bool = false {
        didSet {
            guard isConfirmEnabled != oldValue else { return }
            
            sendButton.isEnabled = isConfirmEnabled
            
            if isConfirmEnabled {
                sendButton.gradientBackgroundColors([UIColor.init(hex: "394656").cgColor, UIColor.init(hex: "181E25").cgColor], direction: .vertical)
            } else {
                sendButton.removeAllSublayers(withName: UIView.gradientLayerKey)
            }
        }
    }
    
    var isLoading: Bool = false {
        didSet {
            isConfirmEnabled = !isLoading
            sendButton.isLoading = isLoading
        }
    }
    
    // MARK: Life cycle's
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Forgot Password"
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        emailTextField.inputBecomeFirstResponder()
    }
    
    // MARK: Layout
    private func setupView() {
        view.addSubview(descriptionLabel)
        view.addSubview(emailTextField)
        view.addSubview(sendButton)
        view.addSubview(sendCodeToEmailLabel)
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            emailTextField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 32),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            sendButton.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 16),
            sendButton.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            sendButton.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            sendButton.heightAnchor.constraint(equalToConstant: 52),
            
            sendCodeToEmailLabel.topAnchor.constraint(equalTo: sendButton.bottomAnchor, constant: 24),
            sendCodeToEmailLabel.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            sendCodeToEmailLabel.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -(safeAreaInsets.bottom + 24)),
            sendCodeToEmailLabel.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor)
        ])
        
        configureSendCodeToEmailLabel()
    }
    
    private func configureSendCodeToEmailLabel() {
        let mutableAttributedString = sendCodeToEmail.setTextWithFormat(font: .workSansFont(ofSize: 14, weight: .medium), textAlignment: .center, lineHeight: 28, textColor: UIColor.black.withAlphaComponent(0.54))
        let range = (sendCodeToEmail as NSString).range(of: detectActionSendCodeToEmail)
        mutableAttributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.workSansFont(ofSize: 14, weight: .medium), range: range)
        mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.init(hex: "94A2B2"), range: range)
        
        sendCodeToEmailLabel.attributedText = mutableAttributedString
    }
}

// MARK: Handle actions
extension ForgotPasswordViewController {
    
    @objc private func onPressedSend() {
        isLoading = true
        viewModel.requestChangePassword(with: emailTextField.contentInput).subscribe(on: MainScheduler.instance).subscribe(onNext: { [weak self] _ in
            guard let this = self else { return }
            
            Navigator.navigateToPasswordVC(from: this, with: .new)
            this.isLoading = false
        }, onError: { [weak self] error in
            self?.isLoading = false
            AlertManagement.shared.showToast(with: "🤔 Request forgot password by email failure!", position: .top)
        }).disposed(by: disposeBag)
    }
    
    @objc private func onTapSendCodeToEmail(_ recognizer: UITapGestureRecognizer) {
        let range = (sendCodeToEmail as NSString).range(of: detectActionSendCodeToEmail)
        
        guard recognizer.didTapAttributedTextInLabel(label: sendCodeToEmailLabel, inRange: range) else { return }
        
        emailTextField.reset()
        isConfirmEnabled = false
    }
}
