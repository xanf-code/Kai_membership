//
//  SignUpViewController.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 20/02/2021.
//

import UIKit
import RxSwift

class SignUpViewController: BaseViewController {

    // MARK: Properties
    let viewModel = SignUpViewModel()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.attributedText = "1 step away to be a Kai member. We just need a few details from you.".setTextWithFormat(font: .workSansFont(ofSize: 14, weight: .medium), lineHeight: 28, textColor: UIColor.black.withAlphaComponent(0.54))
        
        return label
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        
        return scrollView
    }()
    
    private lazy var signUpView: SignUpInputView = {
        let view = SignUpInputView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        
        return view
    }()
    
    private lazy var trialButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        button.setAttributedTitle(NSAttributedString(string: "Let me take a tour", attributes: [
            NSAttributedString.Key.font: UIFont.workSansFont(ofSize: 16, weight: .medium),
            NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(0.87)
        ]), for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.init(hex: "C9CED6").cgColor
        button.addTarget(self, action: #selector(onPressedTrail), for: .touchUpInside)
        
        return button
    }()
    
    private var contentInputBottomAnchor: NSLayoutConstraint?
    
    // MARK: Life cycle's
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Be a Member"
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        TrackingManagement.startRegistration()
        setupView()
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.handleSingleTap(_:)))
        singleTap.numberOfTapsRequired = 1
        singleTap.cancelsTouchesInView = true
        view.addGestureRecognizer(singleTap)
        
        generateCaptcha()
    }
    
    // MARK: Layout
    private func setupView() {
        view.addSubview(descriptionLabel)
        view.addSubview(scrollView)
        view.addSubview(trialButton)
        
        scrollView.addSubview(signUpView)
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            scrollView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            signUpView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            signUpView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            signUpView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16),
            signUpView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            signUpView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            trialButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            trialButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(safeAreaInsets.bottom + 24)),
            trialButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            trialButton.heightAnchor.constraint(equalToConstant: 52),
        ])
        
        contentInputBottomAnchor = scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(safeAreaInsets.bottom + 84))
        contentInputBottomAnchor?.isActive = true
    }
    
    // MARK: Data fetching
    func generateCaptcha() {
        viewModel.generateCaptcha().subscribe(on: MainScheduler.instance).subscribe(onNext: { [weak self] in
            guard let this = self else { return }
            
            this.signUpView.setCaptchaImage($0)
        }, onError: { error in
            debugPrint("Generate captcha error: \((error as? APIErrorResult)?.message ?? "ERROR")")
        }).disposed(by: disposeBag)
    }
    
    // MARK: Methods
    func createAccount() {
        guard signUpView.confirmPasswordTextField.contentInput == signUpView.passwordTextField.contentInput else {
            AlertManagement.shared.showToast(with: "🤔 Confirm password incorrect!", position: .top)
            
            return
        }
        
        guard !signUpView.captchaTextField.contentInput.isEmpty else {
            AlertManagement.shared.showToast(with: "🥺 Please confirm the captcha!", position: .top)
            
            return
        }
        
        signUpView.isLoading = true
        let email = signUpView.emailTextField.contentInput
        viewModel.register(captcha: signUpView.captchaTextField.contentInput, username: email, email: email, password: signUpView.confirmPasswordTextField.contentInput).subscribe(on: MainScheduler.instance).subscribe(onNext: { [weak self] info in
            guard let this = self else { return }
            
            TrackingManagement.registrationSuccessfully(registrationMethod: .google, userID: AccountManagement.accountID, email: email, time: Int(Date().timeIntervalSince1970 * 1000))
            this.signUpView.isLoading = false
            Navigator.navigateToPasscodeVC(from: this, with: .register, email: email)
        }, onError: { [weak self] error in
            self?.signUpView.isLoading = false
            
            guard let error = error as? APIErrorResult else {
                AlertManagement.shared.showToast(with: "🤔 Register account failure!", position: .top)
                
                return
            }
            
            AlertManagement.shared.showToast(with: error.message, position: .top)
        }).disposed(by: disposeBag)
    }
}

// MARK: Handle actions
extension SignUpViewController {
    
    @objc private func handleKeyboardNotification(_ notification: NSNotification) {
        if notification.name == UIResponder.keyboardWillShowNotification {
            guard let userInfo = notification.userInfo, let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
            
            contentInputBottomAnchor?.constant = -(keyboardFrame.height)
        } else {
            contentInputBottomAnchor?.constant = -(safeAreaInsets.bottom + 84)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func onPressedTrail() {
        Navigator.showRootTabbarController()
    }
    
    @objc private func handleSingleTap(_ recognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}
