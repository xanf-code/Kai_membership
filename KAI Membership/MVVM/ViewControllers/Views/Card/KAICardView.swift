//
//  KAICardView.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 27/02/2021.
//

import UIKit

class KAICardView: UIView {
    
    // MARK: Properties
    private let cardImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "bg_card"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "logo_kai_right_white"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    private let balanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.attributedText = NSAttributedString(string: "BALANCE", attributes: [
            NSAttributedString.Key.font: UIFont.workSansFont(ofSize: 8, weight: .medium),
            NSAttributedString.Key.foregroundColor: UIColor.white
        ])
        
        return label
    }()
    
    private let kaiLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        
        return label
    }()
    
    private let walletAddressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingMiddle
        
        return label
    }()
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.spacing = 8
        
        return view
    }()
    
    private let holderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.attributedText = NSAttributedString(string: "HOLDER", attributes: [
            NSAttributedString.Key.font: UIFont.workSansFont(ofSize: 8, weight: .medium),
            NSAttributedString.Key.foregroundColor: UIColor.white
        ])
        
        return label
    }()
    
    private let holderValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        
        return label
    }()
    
    private let holderStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.spacing = 0
        
        return view
    }()
    
    private let memberSinceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.attributedText = NSAttributedString(string: "MEMBER SINCE", attributes: [
            NSAttributedString.Key.font: UIFont.workSansFont(ofSize: 8, weight: .medium),
            NSAttributedString.Key.foregroundColor: UIColor.white
        ])
        
        return label
    }()
    
    private let memberSinceValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        
        return label
    }()
    
    private let memberSinceStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.spacing = 0
        
        return view
    }()
    
    // MARK: Life cycle's
    init(with kai: KAIRemote? = nil, frame: CGRect = .zero) {
        super.init(frame: frame)
        
        setupView()
        configure(kai)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    func setupView() {
        addSubview(cardImageView)
        addSubview(logoImageView)
        addSubview(balanceLabel)
        addSubview(kaiLabel)
        addSubview(walletAddressLabel)
        addSubview(stackView)

        stackView.addArrangedSubview(holderStackView)
        holderStackView.addArrangedSubview(holderLabel)
        holderStackView.addArrangedSubview(holderValueLabel)

        stackView.addArrangedSubview(memberSinceStackView)
        memberSinceStackView.addArrangedSubview(memberSinceLabel)
        memberSinceStackView.addArrangedSubview(memberSinceValueLabel)
        
        NSLayoutConstraint.activate([
            cardImageView.topAnchor.constraint(equalTo: topAnchor),
            cardImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            cardImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            cardImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            logoImageView.topAnchor.constraint(equalTo: topAnchor, constant: 26),
            logoImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            logoImageView.widthAnchor.constraint(equalToConstant: 73.64),
            logoImageView.heightAnchor.constraint(equalToConstant: 24),
            
            balanceLabel.topAnchor.constraint(equalTo: topAnchor, constant: 26),
            balanceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            balanceLabel.trailingAnchor.constraint(greaterThanOrEqualTo: logoImageView.leadingAnchor, constant: 20),
            
            kaiLabel.topAnchor.constraint(equalTo: balanceLabel.bottomAnchor),
            kaiLabel.leadingAnchor.constraint(equalTo: balanceLabel.leadingAnchor),
            kaiLabel.trailingAnchor.constraint(greaterThanOrEqualTo: logoImageView.leadingAnchor, constant: 10),
            
            walletAddressLabel.topAnchor.constraint(greaterThanOrEqualTo: kaiLabel.bottomAnchor, constant: 24),
            walletAddressLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            walletAddressLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            
            stackView.topAnchor.constraint(equalTo: walletAddressLabel.bottomAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -26),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
        ])
    }
    
    // MARK: Configure
    func configure(_ kai: KAIRemote? = nil) {
        kaiLabel.attributedText = kai?.wallet?.balance?.formatCurrencyToAttributedString(unit: .kai, font: .workSansFont(ofSize: 20, weight: .medium), unitFont: .workSansFont(ofSize: 20, weight: .light), textColor: .white)
        
        walletAddressLabel.attributedText = NSAttributedString(string: kai?.wallet?.address ?? "", attributes: [
            NSAttributedString.Key.font: UIFont.workSansFont(ofSize: 16, weight: .regular),
            NSAttributedString.Key.foregroundColor: UIColor.white
        ])
        
        holderValueLabel.attributedText = NSAttributedString(string: kai?.firstName ?? "", attributes: [
            NSAttributedString.Key.font: UIFont.workSansFont(ofSize: 10, weight: .medium),
            NSAttributedString.Key.foregroundColor: UIColor.white
        ])
        
        memberSinceValueLabel.attributedText = NSAttributedString(string: 1598522428.formatTimeIntervalToString("MM/YYYY"), attributes: [
            NSAttributedString.Key.font: UIFont.workSansFont(ofSize: 10, weight: .medium),
            NSAttributedString.Key.foregroundColor: UIColor.white
        ])
    }
}
