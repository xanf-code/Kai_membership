//
//  ResetPasscodeViewController.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 20/02/2021.
//

import UIKit
import RxSwift
import RNLoadingButton_Swift

class ResetPasscodeViewController: BaseViewController {

    // MARK: Properties
    private let email: String
    
    let viewModel = ResetPasscodeViewModel()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.attributedText = "We will send an email with instructions to your registed email.".setTextWithFormat(font: .workSansFont(ofSize: 14, weight: .medium), lineHeight: 28, textColor: UIColor.black.withAlphaComponent(0.54))
        
        return label
    }()
    
    private lazy var emailTextField: KAIInputTextFieldView = {
        let view = KAIInputTextFieldView(with: .default, title: "EMAIL", placeholder: "an.nguyen@kardiachain.io", keyboardType: .emailAddress)
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
    
    var isConfirmEnabled: Bool {
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
    init(with email: String) {
        self.email = email
        self.isConfirmEnabled = !email.isEmpty
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Reset Passcode"
        setupView()
    }
    
    // MARK: Layout
    private func setupView() {
        view.addSubview(descriptionLabel)
        view.addSubview(emailTextField)
        view.addSubview(sendButton)
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            emailTextField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 24),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            sendButton.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 16),
            sendButton.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            sendButton.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -(safeAreaInsets.bottom + 24)),
            sendButton.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            sendButton.heightAnchor.constraint(equalToConstant: 52),
        ])
        
        emailTextField.setText(email)
        
        if isConfirmEnabled {
            sendButton.isEnabled = true
            
            DispatchQueue.main.async {
                self.sendButton.gradientBackgroundColors([UIColor.init(hex: "394656").cgColor, UIColor.init(hex: "181E25").cgColor], direction: .vertical)
            }
        }
    }
}

// MARK: Handle actions
extension ResetPasscodeViewController {
    
    @objc private func onPressedSend() {
        let email = emailTextField.contentInput
        isLoading = true
        viewModel.requestResetPasscode(with: email).subscribe(on: MainScheduler.instance).subscribe(onNext: { [weak self] in
            guard let this = self else { return }
            
            Navigator.navigateToCheckMailVC(from: this, with: email)
            this.isLoading = false
        }, onError: { [weak self] error in
            AlertManagement.shared.showToast(with: "🤔 Request forgot passcode by email failure!", position: .top)
            self?.isLoading = false
        }).disposed(by: disposeBag)
    }
}
