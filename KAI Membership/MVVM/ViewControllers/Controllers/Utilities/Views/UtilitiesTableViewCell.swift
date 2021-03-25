//
//  UtilitiesTableViewCell.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 02/03/2021.
//

import UIKit

class UtilitiesTableViewCell: UITableViewCell {
    
    // MARK: Properties
    enum `Type` {
        case mobileTopup
        case getVouchers
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = .workSansFont(ofSize: 24, weight: .regular)
        label.textColor = UIColor.black.withAlphaComponent(0.87)
        
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        
        return label
    }()
    
    private let contentImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "image_mobile_topup"))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        
        return view
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.Base.x100
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(onPressedAction), for: .touchUpInside)
        
        return button
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.createShadow(radius: 12)
        
        return view
    }()
    
    var didFinishTouchingAction: (() -> Void)?
    
    // MARK: Life cycle's
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    private func setupView() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.addSubview(containerView)
        containerView.addSubview(contentImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(button)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            contentImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 32),
            contentImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            contentImageView.widthAnchor.constraint(equalToConstant: 141.632),
            contentImageView.heightAnchor.constraint(equalToConstant: 98.68),
            contentImageView.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -24),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 22),
            titleLabel.trailingAnchor.constraint(equalTo: contentImageView.leadingAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            button.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 32),
            button.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            button.widthAnchor.constraint(equalToConstant: 124),
            button.heightAnchor.constraint(equalToConstant: 32),
            button.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -22)
        ])
    }
    
    // MARK: Layout
    func configure(with type: `Type`) {
        switch type {
        case .mobileTopup:
            titleLabel.text = "Mobile Topup"
            descriptionLabel.attributedText = "Topup your mobile account \nwith KAI.".setTextWithFormat(font: .workSansFont(ofSize: 10, weight: .medium), lineHeight: 16, textColor: UIColor.black.withAlphaComponent(0.54))
            button.setAttributedTitle(NSAttributedString(string: "Topup Now", attributes: [
                NSAttributedString.Key.font: UIFont.workSansFont(ofSize: 12, weight: .medium),
                NSAttributedString.Key.foregroundColor: UIColor.init(hex: "29323D")
            ]), for: .normal)
        case .getVouchers:
            titleLabel.text = "Get Vouchers"
            descriptionLabel.attributedText = "Voucher here, vouchers there, \nvouchers everywhere.".setTextWithFormat(font: .workSansFont(ofSize: 10, weight: .medium), lineHeight: 16, textColor: UIColor.black.withAlphaComponent(0.54))
            button.setAttributedTitle(NSAttributedString(string: "Get my Vouchers", attributes: [
                NSAttributedString.Key.font: UIFont.workSansFont(ofSize: 12, weight: .medium),
                NSAttributedString.Key.foregroundColor: UIColor.init(hex: "29323D")
            ]), for: .normal)
        }
    }
}

// MARK: Handle actions
extension UtilitiesTableViewCell {
    
    @objc private func onPressedAction() {
        didFinishTouchingAction?()
    }
}
