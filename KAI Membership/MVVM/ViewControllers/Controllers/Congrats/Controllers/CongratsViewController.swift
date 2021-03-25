//
//  CongratsViewController.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 23/02/2021.
//

import UIKit

class CongratsViewController: BaseViewController {

    // MARK: Properties
    enum `Type` {
        case signUp
        case passcode
        case password
    }
    
    private let type: `Type`
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let imageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "image_congrats"))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .center
        label.font = .workSansFont(ofSize: 28, weight: .medium)
        label.textColor = UIColor.black.withAlphaComponent(0.87)
        label.text = "Congrats!"
        
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        
        return label
    }()
    
    private lazy var spinLaterButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        button.setAttributedTitle(NSAttributedString(string: "Spin Later", attributes: [
            NSAttributedString.Key.font: UIFont.workSansFont(ofSize: 16, weight: .medium),
            NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(0.87)
        ]), for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.init(hex: "C9CED6").cgColor
        button.addTarget(self, action: #selector(onPressedSpinLater), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var spinNowButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(onPressedSpinNow), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: Life cycle's
    init(with type: `Type`) {
        self.type = type
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        setupView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.spinNowButton.gradientBackgroundColors([UIColor.init(hex: "394656").cgColor, UIColor.init(hex: "181E25").cgColor], direction: .vertical)
    }
    
    // MARK: Layout
    private func setupView() {
        view.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(spinNowButton)
        
        containerView.topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor, constant: statusBarHeight).isActive = true
        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        switch type {
        case .signUp:
            descriptionLabel.attributedText = "Welcome to Kai membership! \nYou have got 01 lucky spin".setTextWithFormat(font: .workSansFont(ofSize: 14, weight: .medium), textAlignment: .center, lineHeight: 28, textColor: UIColor.black.withAlphaComponent(0.54))
            spinNowButton.setAttributedTitle(NSAttributedString(string: "Spin Now", attributes: [
                NSAttributedString.Key.font: UIFont.workSansFont(ofSize: 16, weight: .medium),
                NSAttributedString.Key.foregroundColor: UIColor.white
            ]), for: .normal)
            
            containerView.addSubview(spinLaterButton)
            
            NSLayoutConstraint.activate([
                titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
                titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                
                descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
                descriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                
                spinLaterButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 32),
                spinLaterButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                spinLaterButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                spinLaterButton.heightAnchor.constraint(equalToConstant: 52),
                
                spinNowButton.topAnchor.constraint(equalTo: spinLaterButton.bottomAnchor, constant: 16),
                spinNowButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                spinNowButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
                spinNowButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                spinNowButton.heightAnchor.constraint(equalToConstant: 52)
            ])
        case .passcode, .password:
            descriptionLabel.attributedText = "Your new Passcode is ready.".setTextWithFormat(font: .workSansFont(ofSize: 14, weight: .medium), textAlignment: .center, lineHeight: 28, textColor: UIColor.black.withAlphaComponent(0.54))
            spinNowButton.setAttributedTitle(NSAttributedString(string: "Ok, I got it", attributes: [
                NSAttributedString.Key.font: UIFont.workSansFont(ofSize: 16, weight: .medium),
                NSAttributedString.Key.foregroundColor: UIColor.white
            ]), for: .normal)
            
            containerView.addSubview(imageView)
            
            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: containerView.topAnchor),
                imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                imageView.leadingAnchor.constraint(greaterThanOrEqualTo: containerView.leadingAnchor),
                
                titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 32),
                titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                
                descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
                descriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                
                spinNowButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
                spinNowButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                spinNowButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
                spinNowButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                spinNowButton.heightAnchor.constraint(equalToConstant: 52)
            ])
        }
    }
}

// MARK: Handle actions
extension CongratsViewController {
    
    @objc private func onPressedSpinLater() {
        Navigator.showRootTabbarController()
    }
    
    @objc private func onPressedSpinNow() {
        switch type {
        case .signUp:
            AppSetting.isRequestOpenSpin = true
            Navigator.showRootTabbarController()
        case .passcode, .password:
            Navigator.showRootTabbarController()
        }
    }
}
