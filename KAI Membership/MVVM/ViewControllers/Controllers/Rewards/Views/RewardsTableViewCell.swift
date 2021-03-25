//
//  RewardsTableViewCell.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 15/03/2021.
//

import UIKit

class RewardsTableViewCell: UITableViewCell {
    
    // MARK: Properties    
    private let contentImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        
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
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = .workSansFont(ofSize: 10, weight: .medium)
        label.textColor = UIColor.init(hex: "0E8C31")
        
        return label
    }()
    
    private let infoView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.createShadow(radius: 8)
        
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
        
        containerView.addSubview(contentImageView)
        containerView.addSubview(infoView)
        
        infoView.addSubview(titleLabel)
        infoView.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            contentImageView.topAnchor.constraint(greaterThanOrEqualTo: containerView.topAnchor, constant: 12),
            contentImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            contentImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            contentImageView.widthAnchor.constraint(equalToConstant: 45),
            contentImageView.heightAnchor.constraint(equalToConstant: 45),
            
            infoView.topAnchor.constraint(greaterThanOrEqualTo: containerView.topAnchor, constant: 12),
            infoView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            infoView.leadingAnchor.constraint(equalTo: contentImageView.trailingAnchor, constant: 8),
            
            titleLabel.topAnchor.constraint(equalTo: infoView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: infoView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(greaterThanOrEqualTo: infoView.trailingAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            descriptionLabel.leadingAnchor.constraint(equalTo: infoView.leadingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: infoView.bottomAnchor),
            descriptionLabel.trailingAnchor.constraint(greaterThanOrEqualTo: infoView.trailingAnchor),
        ])
    }
    
    // MARK: Methods
    func configure(_ history: HistoryRemote) {
        titleLabel.text = history.rewardName
    }
}
