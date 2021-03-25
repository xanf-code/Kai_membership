//
//  PasscodeViewController.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 23/02/2021.
//

import UIKit
import RxSwift
import RNLoadingButton_Swift

class PasscodeViewController: BaseViewController {

    // MARK: Properties
    struct Reset {
        let token: String
        let passcode: String
    }
    
    enum ConfirmType {
        case create(String)
        case reset(Reset)
    }
    
    enum `Type` {
        case register
        case login
        case reset(String)
        case changePassword
        case updateProfile
        case confirm(ConfirmType)
    }
    
    private let type: `Type`
    
    let viewModel: PasscodeViewModel
    
    let footerString1: String = "By creating a passcode, you agree with our \nTerms & Conditions and Privacy Policy"
    let footerString2: String = "Can’t remember my code. Click here"
    let termsAndConditions: String = "Terms & Conditions"
    let privacyPolicy: String = "Privacy Policy"
    let clickHere: String = " Click here"
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        
        return scrollView
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        
        return label
    }()
    
    private lazy var passcodeView: PasscodeView = {
        let view = PasscodeView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        
        return view
    }()
    
    private lazy var confirmButton: RNLoadingButton = {
        let button = RNLoadingButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false
        button.backgroundColor = .init(hex: "E1E4E8")
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 8
        button.activityIndicatorAlignment = RNActivityIndicatorAlignment.left
        button.activityIndicatorEdgeInsets.left = 16
        button.hideTextWhenLoading = false
        button.isLoading = false
        button.activityIndicatorColor = .black
        button.addTarget(self, action: #selector(onPressedConfirm), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var showPasscodeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setAttributedTitle(NSAttributedString(string: "Show Passcode", attributes: [
            NSAttributedString.Key.font: UIFont.workSansFont(ofSize: 14, weight: .medium),
            NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(0.87)
        ]), for: .normal)
        button.addTarget(self, action: #selector(onPressedShowPasscode), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var footerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        label.numberOfLines = 2
        label.textAlignment = .center
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapFooterLabel(_:))))
        
        return label
    }()
    
    private var contentInputBottomAnchor: NSLayoutConstraint?
    
    var isPasscodeShowed: Bool = false {
        didSet {
            guard isPasscodeShowed != oldValue else { return }
            
            passcodeView.isShowed = isPasscodeShowed
            
            showPasscodeButton.setAttributedTitle(NSAttributedString(string: isPasscodeShowed ? "Hide Passcode" : "Show Passcode", attributes: [
                NSAttributedString.Key.font: UIFont.workSansFont(ofSize: 14, weight: .medium),
                NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(0.87)
            ]), for: .normal)
        }
    }
    
    var isConfirmEnabled: Bool = false {
        didSet {
            guard isConfirmEnabled != oldValue else { return }
            
            confirmButton.isEnabled = isConfirmEnabled
            
            if isConfirmEnabled {
                confirmButton.gradientBackgroundColors([UIColor.init(hex: "394656").cgColor, UIColor.init(hex: "181E25").cgColor], direction: .vertical)
            } else {
                confirmButton.removeAllSublayers(withName: UIView.gradientLayerKey)
            }
        }
    }
    
    var completion: (() -> Void)?
    
    // MARK: Life cycle's
    init(with type: `Type`, email: String, token: String = "", _ completion: (() -> Void)? = nil) {
        self.type = type
        self.viewModel = PasscodeViewModel(email: email)
        self.completion = completion
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        setTitle()
        setupView()
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.handleSingleTap(_:)))
        singleTap.numberOfTapsRequired = 1
        singleTap.cancelsTouchesInView = true
        scrollView.addGestureRecognizer(singleTap)
        
        
        viewModel.showLoading.asObservable().observe(on: MainScheduler.instance).subscribe { [weak self] isLoading in
            guard let this = self else { return }
            
            this.isConfirmEnabled = !(isLoading.element ?? false)
            this.confirmButton.isLoading = isLoading.element ?? false
        }.disposed(by: disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        passcodeView.inputBecomeFirstResponder()
    }
    
    // MARK: Layout
    private func setTitle() {
        switch type {
        case .register:
            navigationItem.title = "Create Passcode"
        case .login:
            navigationItem.title = "Enter Passcode"
        case .reset:
            navigationItem.title = "New Passcode"
        case .changePassword:
            navigationItem.title = "Passcode"
        case .updateProfile:
            navigationItem.title = "Enter Passcode"
        case .confirm:
            navigationItem.title = "Confirm Passcode"
        }
    }
    
    private func setupView() {
        view.addSubview(descriptionLabel)
        view.addSubview(scrollView)
        view.addSubview(footerLabel)
        view.addSubview(confirmButton)
        
        scrollView.addSubview(passcodeView)
        scrollView.addSubview(showPasscodeButton)
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            scrollView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            passcodeView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 44),
            passcodeView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            passcodeView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            passcodeView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            showPasscodeButton.topAnchor.constraint(equalTo: passcodeView.bottomAnchor, constant: 18),
            showPasscodeButton.leadingAnchor.constraint(lessThanOrEqualTo: scrollView.leadingAnchor, constant: 20),
            showPasscodeButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            showPasscodeButton.heightAnchor.constraint(equalToConstant: 40),
            
            footerLabel.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 10),
            footerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            footerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            confirmButton.topAnchor.constraint(equalTo: footerLabel.bottomAnchor, constant: 20),
            confirmButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            confirmButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            confirmButton.heightAnchor.constraint(equalToConstant: 52)
        ])
        
        contentInputBottomAnchor = confirmButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(safeAreaInsets.bottom + 20))
        contentInputBottomAnchor?.isActive = true
        
        configureFooterLabel()
        
        descriptionLabel.attributedText = "Enter your passcode to continue.".setTextWithFormat(font: .workSansFont(ofSize: 14, weight: .medium), lineHeight: 28, textColor: UIColor.black.withAlphaComponent(0.54))
        
        switch type {
        case .register:
            confirmButton.setAttributedTitle(NSAttributedString(string: "Set Passcode", attributes: [
                NSAttributedString.Key.font: UIFont.workSansFont(ofSize: 16, weight: .medium),
                NSAttributedString.Key.foregroundColor: UIColor.white
            ]), for: .normal)
        case .login:
            confirmButton.setAttributedTitle(NSAttributedString(string: "Continue", attributes: [
                NSAttributedString.Key.font: UIFont.workSansFont(ofSize: 16, weight: .medium),
                NSAttributedString.Key.foregroundColor: UIColor.white
            ]), for: .normal)
        case .reset:
            confirmButton.setAttributedTitle(NSAttributedString(string: "Set Passcode", attributes: [
                NSAttributedString.Key.font: UIFont.workSansFont(ofSize: 16, weight: .medium),
                NSAttributedString.Key.foregroundColor: UIColor.white
            ]), for: .normal)
        case .changePassword:
            confirmButton.setAttributedTitle(NSAttributedString(string: "Continue", attributes: [
                NSAttributedString.Key.font: UIFont.workSansFont(ofSize: 16, weight: .medium),
                NSAttributedString.Key.foregroundColor: UIColor.white
            ]), for: .normal)
        case .updateProfile:
            confirmButton.setAttributedTitle(NSAttributedString(string: "Finish update", attributes: [
                NSAttributedString.Key.font: UIFont.workSansFont(ofSize: 16, weight: .medium),
                NSAttributedString.Key.foregroundColor: UIColor.white
            ]), for: .normal)
        case .confirm:
            confirmButton.setAttributedTitle(NSAttributedString(string: "Confirm", attributes: [
                NSAttributedString.Key.font: UIFont.workSansFont(ofSize: 16, weight: .medium),
                NSAttributedString.Key.foregroundColor: UIColor.white
            ]), for: .normal)
        }
    }
    
    private func configureFooterLabel() {
        switch type {
        case .register, .reset, .confirm:
            let mutableAttributedString = footerString1.setTextWithFormat(font: .workSansFont(ofSize: 14, weight: .medium), textAlignment: .center, lineHeight: 28, textColor: UIColor.black.withAlphaComponent(0.54))
            let termsAndConditionsRange = (footerString1 as NSString).range(of: termsAndConditions)
            mutableAttributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.workSansFont(ofSize: 14, weight: .medium), range: termsAndConditionsRange)
            mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.Link.normal, range: termsAndConditionsRange)
            
            let privacyPolicyRange = (footerString1 as NSString).range(of: privacyPolicy)
            mutableAttributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.workSansFont(ofSize: 14, weight: .medium), range: privacyPolicyRange)
            mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.Link.normal, range: privacyPolicyRange)
            
            footerLabel.attributedText = mutableAttributedString
        case .login, .updateProfile:
            let mutableAttributedString = footerString2.setTextWithFormat(font: .workSansFont(ofSize: 14, weight: .medium), textAlignment: .center, lineHeight: 28, textColor: UIColor.black.withAlphaComponent(0.54))
            let detectRange = (footerString2 as NSString).range(of: clickHere)
            mutableAttributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.workSansFont(ofSize: 14, weight: .medium), range: detectRange)
            mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.init(hex: "A2ACB9"), range: detectRange)
            
            footerLabel.attributedText = mutableAttributedString
        case .changePassword:
            footerLabel.attributedText = nil
        }
    }
    
    // MARK: Methods
    private func requestChangePassword() {
        viewModel.requestChangePassword().subscribe(on: MainScheduler.instance).subscribe(onNext: { [weak self] in
            guard let this = self else { return }
            
            this.viewModel.showLoading.accept(false)
            Navigator.navigateToPasswordVC(from: this, with: .change)
        }, onError: { [weak self] error in
            self?.viewModel.showLoading.accept(false)
            AlertManagement.shared.showToast(with: "🤔 Instruction sent to email failure!", position: .top)
        }).disposed(by: disposeBag)
    }
}

// MARK: Handle actions
extension PasscodeViewController {
    
    @objc private func handleKeyboardNotification(_ notification: NSNotification) {
        if notification.name == UIResponder.keyboardWillShowNotification {
            guard let userInfo = notification.userInfo, let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
            
            contentInputBottomAnchor?.constant = -(keyboardFrame.height + 20)
        } else {
            contentInputBottomAnchor?.constant = -(safeAreaInsets.bottom + 20)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func handleSingleTap(_ recognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc private func onPressedConfirm() {
        switch type {
        case .register:
            Navigator.navigateToPasscodeVC(from: self, with: .confirm(.create(passcodeView.code)), email: viewModel.email)
        case .login:
            viewModel.loginWithPasscode(passcodeView.code).subscribe(on: MainScheduler.instance).subscribe(onNext: { [weak self] in
                guard let this = self else { return }
                
                if let completion = this.completion {
                    if let loginIndex = this.navigationController?.viewControllers.firstIndex(where: { $0 is SignInViewController }), let count = this.navigationController?.viewControllers.count {
                        completion()
                        this.navigationController?.viewControllers.removeSubrange(loginIndex..<count)
                    } else {
                        this.navigationController?.popViewController(animated: true)
                        completion()
                    }
                } else {
                    Navigator.showRootTabbarController()
                }
            }, onError: { error in
                AlertManagement.shared.showToast(with: "🤔 Passcode incorrect!", position: .top)
            }).disposed(by: disposeBag)
        case .reset(let token):
            Navigator.navigateToPasscodeVC(from: self, with: .confirm(.reset(Reset(token: token, passcode: passcodeView.code))), email: viewModel.email)
        case .changePassword:
            viewModel.checkPasscode(passcodeView.code).subscribe(on: MainScheduler.instance).subscribe(onNext: { [weak self] in
                self?.requestChangePassword()
            }, onError: { [weak self] error in
                self?.viewModel.showLoading.accept(false)
                AlertManagement.shared.showToast(with: "🤔 Passcode incorrect!", position: .top)
            }).disposed(by: disposeBag)
        case .updateProfile:
            viewModel.checkPasscode(passcodeView.code).subscribe(on: MainScheduler.instance).subscribe(onNext: { [weak self] in
                self?.completion?()
            }, onError: { [weak self] error in
                self?.viewModel.showLoading.accept(false)
                AlertManagement.shared.showToast(with: "🤔 Passcode incorrect!", position: .top)
            }).disposed(by: disposeBag)
        case .confirm(let type):
            switch type {
            case .create(let passcode):
                guard passcodeView.code == passcode else {
                    AlertManagement.shared.showToast(with: "🤔 Confirm passcode incorrect!", position: .top)
                    return
                }
                
                viewModel.createPasscode(passcodeView.code).subscribe(on: MainScheduler.instance).subscribe(onNext: { [weak self] in
                    guard let this = self else { return }
                    
                    Navigator.showCongratsVC(from: this, with: .signUp)
                }, onError: { error in
                    AlertManagement.shared.showToast(with: "🤔 Create passcode failure!", position: .top)
                }).disposed(by: disposeBag)
            case .reset(let reset):
                guard passcodeView.code == reset.passcode else {
                    AlertManagement.shared.showToast(with: "🤔 Confirm passcode incorrect!", position: .top)
                    return
                }
                
                viewModel.resetPasscode(token: reset.token, passcode: passcodeView.code).subscribe(on: MainScheduler.instance).subscribe(onNext: { [weak self] in
                    guard let this = self else { return }
                    
                    Navigator.showCongratsVC(from: this, with: .passcode)
                }, onError: { [weak self] error in
                    guard let this = self else { return }
                    
                    if let verificationVC = this.navigationController?.viewControllers.first(where: { $0 is VerificationViewController }) {
                        this.navigationController?.popToViewController(verificationVC, animated: true)
                    } else {
                        this.navigationController?.popToRootViewController(animated: true)
                    }
                    
                    AlertManagement.shared.showToast(with: "🤔 Verification token incorrect!", position: .top)
                }).disposed(by: disposeBag)
            }
        }
    }
    
    @objc private func onPressedShowPasscode() {
        isPasscodeShowed = !isPasscodeShowed
    }
    
    @objc private func onTapFooterLabel(_ recognizer: UITapGestureRecognizer) {
        switch type {
        case .register, .reset, .confirm:
            let termsAndConditionsRange = (footerString1 as NSString).range(of: "Terms & Conditions")
            let privacyPolicyRange = (footerString1 as NSString).range(of: privacyPolicy)

            if recognizer.didTapAttributedTextInLabel(label: footerLabel, inRange: termsAndConditionsRange) {
                
            } else if recognizer.didTapAttributedTextInLabel(label: footerLabel, inRange: privacyPolicyRange) {
                
            }
        case .login, .updateProfile:
            let clickHereRange = (footerString2 as NSString).range(of: clickHere)

            if recognizer.didTapAttributedTextInLabel(label: footerLabel, inRange: clickHereRange) {
                Navigator.navigateToResetPasscodeVC(from: self, with: viewModel.email)
            }
        case .changePassword:
            break
        }
    }
}
