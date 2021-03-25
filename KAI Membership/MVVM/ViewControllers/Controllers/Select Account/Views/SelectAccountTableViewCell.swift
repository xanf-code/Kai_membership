//
//  SelectAccountTableViewCell.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 25/02/2021.
//

import UIKit

class SelectAccountTableViewCell: UITableViewCell {
    
    // MARK: Properties
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = .workSansFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor.init(hex: "455571")
        
        return label
    }()
    
    private let gmailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = .workSansFont(ofSize: 10, weight: .medium)
        label.textColor = UIColor.init(hex: "C9CED6")
        
        return label
    }()
    
    private let avatarImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 6
        
        return view
    }()
    
    private let nextImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "ic_right_arrow")
        
        return view
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
        containerView.addSubview(avatarImageView)
        containerView.addSubview(nextImageView)
        
        containerView.addSubview(infoView)
        infoView.addSubview(nameLabel)
        infoView.addSubview(gmailLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            avatarImageView.topAnchor.constraint(greaterThanOrEqualTo: containerView.topAnchor, constant: 18),
            avatarImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            avatarImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 22),
            avatarImageView.widthAnchor.constraint(equalToConstant: 36),
            avatarImageView.heightAnchor.constraint(equalToConstant: 36),
            
            infoView.topAnchor.constraint(greaterThanOrEqualTo: containerView.topAnchor, constant: 18),
            infoView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            infoView.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 18),
            
            nameLabel.topAnchor.constraint(equalTo: infoView.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: infoView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(greaterThanOrEqualTo: infoView.trailingAnchor),
            
            gmailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            gmailLabel.leadingAnchor.constraint(equalTo: infoView.leadingAnchor),
            gmailLabel.bottomAnchor.constraint(equalTo: infoView.bottomAnchor),
            gmailLabel.trailingAnchor.constraint(greaterThanOrEqualTo: infoView.trailingAnchor),
            
            nextImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            nextImageView.leadingAnchor.constraint(greaterThanOrEqualTo: infoView.trailingAnchor, constant: 18),
            nextImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant:  -22)
        ])
    }
    
    // MARK: Methods
    func configure(with user: UserRemote) {
        avatarImageView.setImage(from: user.avatarLink, placeholder: nil)
        nameLabel.text = user.email
        gmailLabel.text = user.email
    }
}
