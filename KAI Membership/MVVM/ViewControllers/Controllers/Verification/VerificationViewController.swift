//
//  VerificationViewController.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 19/03/2021.
//

import UIKit
import RxSwift
import RNLoadingButton_Swift

class VerificationViewController: BaseViewController {

    // MARK: Properties
    private let email: String
    
    let viewModel = ResetPasscodeViewModel()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.attributedText = "Check your email for token".setTextWithFormat(font: .workSansFont(ofSize: 14, weight: .medium), lineHeight: 28, textColor: UIColor.black.withAlphaComponent(0.54))
        
        return label
    }()
    
    private lazy var tokenTextField: KAIInputTextFieldView = {
        let view = KAIInputTextFieldView(with: .default, title: "PASTE YOUR TOKEN HERE", placeholder: "Paste your token here")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        
        return view
    }()
    
    private lazy var sendButton: RNLoadingButton = {
        let button = RNLoadingButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setAttributedTitle(NSAttributedString(string: "Set new Passcode", attributes: [
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
    
    // MARK: Life cycle's
    init(with email: String) {
        self.email = email
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Verification"
        setupView()
    }
    
    // MARK: Layout
    private func setupView() {
        view.addSubview(descriptionLabel)
        view.addSubview(tokenTextField)
        view.addSubview(sendButton)
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            tokenTextField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 24),
            tokenTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tokenTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            sendButton.topAnchor.constraint(equalTo: tokenTextField.bottomAnchor, constant: 16),
            sendButton.leadingAnchor.constraint(equalTo: tokenTextField.leadingAnchor),
            sendButton.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -(safeAreaInsets.bottom + 24)),
            sendButton.trailingAnchor.constraint(equalTo: tokenTextField.trailingAnchor),
            sendButton.heightAnchor.constraint(equalToConstant: 52),
        ])
    }
}

// MARK: Handle actions
extension VerificationViewController {
    
    @objc private func onPressedSend() {
        Navigator.navigateToPasscodeVC(from: self, with: .reset(tokenTextField.contentInput), email: email)
    }
}
