//
//  SignInViewController.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 19/02/2021.
//

import UIKit
import RxSwift

class SignInViewController: BaseViewController {

    // MARK: Properties
    let viewModel = SignInViewModel()
    
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
        label.attributedText = "Sign in and start our journey with KAI.".setTextWithFormat(font: .workSansFont(ofSize: 14, weight: .medium), lineHeight: 28, textColor: UIColor.black.withAlphaComponent(0.54))
        
        return label
    }()
    
    private lazy var signInView: SignInInputView = {
        let view = SignInInputView()
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
    
    var completion: (() -> Void)?
    
    // MARK: Life cycle's
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Welcome!"
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        setupView()
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.handleSingleTap(_:)))
        singleTap.numberOfTapsRequired = 1
        singleTap.cancelsTouchesInView = true
        scrollView.addGestureRecognizer(singleTap)
    }
    
    // MARK: Layout
    private func setupView() {
        view.addSubview(descriptionLabel)
        view.addSubview(scrollView)
        view.addSubview(trialButton)
        
        scrollView.addSubview(signInView)
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            scrollView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            signInView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            signInView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            signInView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            signInView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            trialButton.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 8),
            trialButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            trialButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(safeAreaInsets.bottom + 24)),
            trialButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            trialButton.heightAnchor.constraint(equalToConstant: 52),
        ])
    }
    
    // MARK: Login
    func login() {
        signInView.isLoading = true
        let email = signInView.emailTextField.contentInput
        viewModel.login(with: email, and: signInView.passwordTextField.contentInput).subscribe(on: MainScheduler.instance).subscribe(onNext: { [weak self] info in
            guard let this = self else { return }
            
            this.signInView.isLoading = false
            Navigator.navigateToPasscodeVC(from: this, with: .login, email: email, this.completion)
        }, onError: { [weak self] error in
            self?.signInView.isLoading = false
            AlertManagement.shared.showToast(with: "🤔 Login failure!", position: .top)
        }).disposed(by: disposeBag)
    }
}

// MARK: Handle actions
extension SignInViewController {
    
    @objc private func handleKeyboardNotification(_ notification: NSNotification) {
        if notification.name == UIResponder.keyboardWillShowNotification {
            guard let userInfo = notification.userInfo, let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
            
            let bottomOffset = Constants.Device.screenBounds.height - (scrollView.frame.origin.y + signInView.frame.origin.y + signInView.frame.height + 10)
            
            if keyboardFrame.height > bottomOffset {
                self.scrollView.setContentOffset(CGPoint(x: 0, y: keyboardFrame.height - bottomOffset), animated: true)
            }
        } else {
            self.scrollView.setContentOffset(.zero, animated: true)
        }
    }
    
    @objc private func onPressedTrail() {
        Navigator.showRootTabbarController()
    }
    
    @objc private func handleSingleTap(_ recognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}
