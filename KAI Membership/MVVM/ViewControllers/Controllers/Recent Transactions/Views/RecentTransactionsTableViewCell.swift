//
//  RecentTransactionsTableViewCell.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 28/02/2021.
//

import UIKit

class RecentTransactionsTableViewCell: UITableViewCell {
    
    // MARK: Properties
    private let transactionsImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = .workSansFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor.black.withAlphaComponent(0.87)
        
        return label
    }()
    
    private let transactionsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingMiddle
        label.font = .workSansFont(ofSize: 10, weight: .medium)
        label.textColor = UIColor.black.withAlphaComponent(0.26)
        
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .right
        label.font = .workSansFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor.black.withAlphaComponent(0.87)
        
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .right
        label.font = .workSansFont(ofSize: 10, weight: .medium)
        label.textColor = UIColor.black.withAlphaComponent(0.26)
        
        return label
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
        
        contentView.addSubview(transactionsImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(transactionsLabel)
        contentView.addSubview(valueLabel)
        contentView.addSubview(timeLabel)
        
        NSLayoutConstraint.activate([
            transactionsImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            transactionsImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            transactionsImageView.widthAnchor.constraint(equalToConstant: 16),
            transactionsImageView.heightAnchor.constraint(equalToConstant: 16),
            
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            titleLabel.leadingAnchor.constraint(equalTo: transactionsImageView.trailingAnchor, constant: 14),
            
            valueLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 40),
            valueLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            valueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            valueLabel.widthAnchor.constraint(equalToConstant: 124),
            
            transactionsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0),
            transactionsLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            transactionsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            
            timeLabel.leadingAnchor.constraint(equalTo: transactionsLabel.trailingAnchor, constant: 40),
            timeLabel.centerYAnchor.constraint(equalTo: transactionsLabel.centerYAnchor),
            timeLabel.trailingAnchor.constraint(equalTo: valueLabel.trailingAnchor),
            timeLabel.widthAnchor.constraint(equalToConstant: 124),
        ])
    }
    
    // MARK: Configure
    func configure(with transaction: TransactionRemote) {
        switch transaction.type {
        case .get:
            transactionsImageView.image = UIImage(named: "ic_transaction_get")
        case .buy:
            transactionsImageView.image = UIImage(named: "ic_transaction_buy")
        case .send:
            transactionsImageView.image = UIImage(named: "ic_transaction_send")
        }
        
        titleLabel.text = transaction.type.rawValue
        valueLabel.text = "+ \(transaction.value ?? 0)"
        transactionsLabel.text = "From: \(transaction.walletReceive ?? "")"
        timeLabel.text = transaction.createdDate
    }
}
