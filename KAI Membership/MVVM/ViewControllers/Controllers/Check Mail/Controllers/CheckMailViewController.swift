//
//  CheckMailViewController.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 22/02/2021.
//

import UIKit

class CheckMailViewController: BaseViewController {

    // MARK: Properties
    private let footerString: String = "Did not receive any email? Check your spam filter, \nor resend another mail"
    private let detectActionFooter: String = "resend another mail"
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let iconTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = .workSansFont(ofSize: 64, weight: .bold)
        label.text = "📬"
        
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = UIColor.black.withAlphaComponent(0.87)
        label.font = .workSansFont(ofSize: 28, weight: .medium)
        label.text = "Instruction Sent"
        
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        label.numberOfLines = 3
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var openEmailAppButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setAttributedTitle(NSAttributedString(string: "Open email app", attributes: [
            NSAttributedString.Key.font: UIFont.workSansFont(ofSize: 16, weight: .medium),
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]), for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(onPressedOpenEmailApp), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var footerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        label.numberOfLines = 2
        label.textAlignment = .center
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapResendAnotherMail(_:))))
        
        return label
    }()
    
    private let email: String
    
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
        
        setupView()
    }
    
    // MARK: Layout
    private func setupView() {
        view.addSubview(containerView)
        
        containerView.addSubview(iconTitleLabel)
        containerView.addSubview(titleLabel)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(openEmailAppButton)
        containerView.addSubview(footerLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor, constant: statusBarHeight),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            iconTitleLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            iconTitleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: containerView.leadingAnchor, constant: 20),
            iconTitleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: iconTitleLabel.bottomAnchor, constant: 0),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            openEmailAppButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 32),
            openEmailAppButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            openEmailAppButton.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            openEmailAppButton.heightAnchor.constraint(equalToConstant: 52),
            
            footerLabel.topAnchor.constraint(equalTo: openEmailAppButton.bottomAnchor, constant: 12),
            footerLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            footerLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            footerLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor)
        ])
        
        let description: String = "We have sent you a email comfirmation to \(email) email. Please check."
        let descriptionAttributedString = description.setTextWithFormat(font: .workSansFont(ofSize: 14, weight: .medium), textAlignment: .center, lineHeight: 28, textColor: UIColor.black.withAlphaComponent(0.54))
        let range = (description as NSString).range(of: email) 
        descriptionAttributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.workSansFont(ofSize: 14, weight: .medium), range: range)
        descriptionAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.init(hex: "377AA9"), range: range)
        descriptionLabel.attributedText = descriptionAttributedString
        
        configureFooterLabel()
        
        DispatchQueue.main.async {
            self.openEmailAppButton.gradientBackgroundColors([UIColor.init(hex: "394656").cgColor, UIColor.init(hex: "181E25").cgColor], direction: .vertical)
        }
    }
    
    private func configureFooterLabel() {
        let mutableAttributedString = footerString.setTextWithFormat(font: .workSansFont(ofSize: 14, weight: .medium), textAlignment: .center, lineHeight: 28, textColor: UIColor.black.withAlphaComponent(0.54))
        let range = (footerString as NSString).range(of: detectActionFooter)
        mutableAttributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.workSansFont(ofSize: 14, weight: .medium), range: range)
        mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.init(hex: "94A2B2"), range: range)
        
        footerLabel.attributedText = mutableAttributedString
    }
}

// MARK: Handle actions
extension CheckMailViewController {
    
    @objc private func onPressedOpenEmailApp() {
        Navigator.navigateToVerificationVC(from: self, with: email)
    }
    
    @objc private func onTapResendAnotherMail(_ recognizer: UITapGestureRecognizer) {
        let range = (footerString as NSString).range(of: detectActionFooter)

        guard recognizer.didTapAttributedTextInLabel(label: footerLabel, inRange: range) else { return }
        
        navigationController?.viewControllers.removeAll { ($0 is ResetPasscodeViewController) || ($0 is CheckMailViewController) }
        Navigator.navigateToResetPasscodeVC(from: self, with: email)
    }
}
