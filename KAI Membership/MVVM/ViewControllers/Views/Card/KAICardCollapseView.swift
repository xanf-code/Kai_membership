//
//  KAICardCollapseView.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 04/03/2021.
//

import UIKit

class KAICardCollapseView: UIView {
    
    // MARK: Properties
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.layer.borderColor = UIColor.init(hex: "F1F2F4").cgColor
        view.layer.borderWidth = 1
        
        return view
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "image_card_collapse"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textColor = UIColor.black.withAlphaComponent(0.54)
        label.font = .workSansFont(ofSize: 16, weight: .medium)
        label.text = "My Balance"
        
        return label
    }()
    
    private let kaiLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        
        return label
    }()
    
    private let monetaryValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textColor = UIColor.black.withAlphaComponent(0.87)
        label.font = .workSansFont(ofSize: 14, weight: .medium)
        label.isHidden = true
        
        return label
    }()
    
    private let profitStatusButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false
        button.titleLabel?.font = .workSansFont(ofSize: 12, weight: .medium)
        button.isHidden = true
        
        return button
    }()
    
    var profit: Double = 0 {
        didSet {
            profitStatusButton.setTitle("\(profit)%", for: .normal)
            
            if profit == 0 {
                profitStatusButton.setTitleColor(UIColor.black.withAlphaComponent(0.87), for: .normal)
            } else if profit < 0 {
                profitStatusButton.setTitleColor(UIColor.init(hex: "DD3832"), for: .normal)
            } else {
                profitStatusButton.setTitleColor(UIColor.init(hex: "0E8C31"), for: .normal)
            }
        }
    }
    
    // MARK: Life cycle's
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    private func setupView() {
        addSubview(containerView)
        addSubview(imageView)
        
        containerView.addSubview(label)
        containerView.addSubview(kaiLabel)
        containerView.addSubview(monetaryValueLabel)
        containerView.addSubview(profitStatusButton)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            imageView.widthAnchor.constraint(equalToConstant: 110),
            
            label.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            label.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(greaterThanOrEqualTo: imageView.leadingAnchor),
            
            kaiLabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8),
            kaiLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            kaiLabel.trailingAnchor.constraint(greaterThanOrEqualTo: imageView.leadingAnchor),
            
            monetaryValueLabel.topAnchor.constraint(equalTo: kaiLabel.bottomAnchor, constant: 8),
            monetaryValueLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            monetaryValueLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
            
            profitStatusButton.centerYAnchor.constraint(equalTo: monetaryValueLabel.centerYAnchor),
            profitStatusButton.leadingAnchor.constraint(equalTo: monetaryValueLabel.trailingAnchor, constant: 4),
            profitStatusButton.trailingAnchor.constraint(lessThanOrEqualTo: imageView.leadingAnchor),
        ])
    }
    
    // MARK: Methods
    func configure() {
        kaiLabel.attributedText = AccountManagement.accountInfo?.kai?.wallet?.balance?.formatCurrencyToAttributedString(unit: .kai, font: .workSansFont(ofSize: 28, weight: .medium), textColor: UIColor.Base.x500)
//        monetaryValueLabel.text = "0,033 USD/ KAI"
//        profit = 35.5
    }
}
