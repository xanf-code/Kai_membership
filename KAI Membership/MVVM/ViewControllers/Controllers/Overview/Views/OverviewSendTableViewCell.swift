//
//  OverviewSendTableViewCell.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 17/03/2021.
//

import UIKit

class OverviewSendTableViewCell: UITableViewCell {
    
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
    
    private let walletAddressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = .workSansFont(ofSize: 10, weight: .medium)
        label.textColor = .init(hex: "364766")
        label.text = "ADDRESS"
        
        return label
    }()
    
    private lazy var walletAddressTextField: KAITextField = {
        let view = KAITextField(with: .default, isSelected: false, placeholder: "Recipient Address")
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = .workSansFont(ofSize: 10, weight: .medium)
        label.textColor = .init(hex: "364766")
        label.text = "SEND AMOUNT"
        
        return label
    }()
    
    private lazy var amountTextField: KAITextField = {
        let view = KAITextField(with: .default, isSelected: false, placeholder: "KAI Amount")
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
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
            
        containerView.addSubview(walletAddressLabel)
        containerView.addSubview(walletAddressTextField)
        containerView.addSubview(amountLabel)
        containerView.addSubview(amountTextField)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            walletAddressLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            walletAddressLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            walletAddressLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),

            walletAddressTextField.topAnchor.constraint(equalTo: walletAddressLabel.bottomAnchor, constant: 4),
            walletAddressTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            walletAddressTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            amountLabel.topAnchor.constraint(equalTo: walletAddressTextField.bottomAnchor, constant: 12),
            amountLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            amountLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            amountTextField.topAnchor.constraint(equalTo: amountLabel.bottomAnchor, constant: 4),
            amountTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            amountTextField.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),
            amountTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
        ])
    }
    
    // MARK: Methods
    func configure(walletAddress: String, amount: Double) {
        walletAddressTextField.setText(walletAddress)
        amountTextField.setText("\(amount.formatCurrencyToString(unit: .kai))")
    }
}
