//
//  OverviewTopupTableViewCell.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 16/03/2021.
//

import UIKit

class OverviewTopupTableViewCell: UITableViewCell {
    
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
    
    private let contactLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = .workSansFont(ofSize: 10, weight: .medium)
        label.textColor = .init(hex: "364766")
        label.text = "PHONE NO."
        
        return label
    }()
    
    private let contactTextField: KAITextField = {
        let view = KAITextField(with: .default, isSelected: false, placeholder: "e.g 01669919308")
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let providerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = .workSansFont(ofSize: 10, weight: .medium)
        label.textColor = .init(hex: "364766")
        label.text = "SERVICE PROVIDER"
        
        return label
    }()
    
    private let providerTextField: KAITextField = {
        let view = KAITextField(with: .default, isSelected: false, placeholder: "Service provider")
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let comboboxLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = .workSansFont(ofSize: 10, weight: .medium)
        label.textColor = .init(hex: "364766")
        label.text = "TOP UP AMOUNT"
        
        return label
    }()
    
    private let amountTextField: KAITextField = {
        let view = KAITextField(with: .default, isSelected: false, placeholder: "Amount")
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
            
        containerView.addSubview(contactLabel)
        containerView.addSubview(contactTextField)
        containerView.addSubview(providerLabel)
        containerView.addSubview(providerTextField)
        containerView.addSubview(comboboxLabel)
        containerView.addSubview(amountTextField)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            contactLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            contactLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            contactLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),

            contactTextField.topAnchor.constraint(equalTo: contactLabel.bottomAnchor, constant: 4),
            contactTextField.leadingAnchor.constraint(equalTo: contactLabel.leadingAnchor),
            contactTextField.trailingAnchor.constraint(equalTo: contactLabel.trailingAnchor),
            
            providerLabel.topAnchor.constraint(equalTo: contactTextField.bottomAnchor, constant: 12),
            providerLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            providerLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            providerTextField.topAnchor.constraint(equalTo: providerLabel.bottomAnchor, constant: 4),
            providerTextField.leadingAnchor.constraint(equalTo: providerLabel.leadingAnchor),
            providerTextField.trailingAnchor.constraint(equalTo: providerLabel.trailingAnchor),
            
            comboboxLabel.topAnchor.constraint(equalTo: providerTextField.bottomAnchor, constant: 12),
            comboboxLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            comboboxLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            amountTextField.topAnchor.constraint(equalTo: comboboxLabel.bottomAnchor, constant: 4),
            amountTextField.leadingAnchor.constraint(equalTo: comboboxLabel.leadingAnchor),
            amountTextField.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),
            amountTextField.trailingAnchor.constraint(equalTo: comboboxLabel.trailingAnchor),
        ])
    }
    
    // MARK: Methods
    func configure(phoneNumber: String, providerCode: String, amount: Amount) {
        contactTextField.setText(phoneNumber)
        providerTextField.setText(providerCode)
        
        let title = amount.money.formatCurrencyToString(unit: .vnd, groupingSeparator: .comma, decimalSeparator: .dots)
        let sub = amount.kai.formatCurrencyToString(unit: .kai, groupingSeparator: .comma, decimalSeparator: .dots)
        let mutableAttributedString = NSMutableAttributedString(attributedString: NSAttributedString(string: title, attributes: [
            NSAttributedString.Key.font: UIFont.workSansFont(ofSize: 14, weight: .medium),
            NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(0.87)
        ]))
        
        mutableAttributedString.append(NSAttributedString(string: " \(sub)", attributes: [
            NSAttributedString.Key.font: UIFont.workSansFont(ofSize: 14, weight: .regular),
            NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(0.54)
        ]))
        
        amountTextField.setAttributedText(mutableAttributedString)
    }
}
