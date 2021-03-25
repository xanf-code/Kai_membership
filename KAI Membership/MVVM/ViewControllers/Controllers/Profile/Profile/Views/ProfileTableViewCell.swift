//
//  ProfileTableViewCell.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 24/03/2021.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    
    // MARK: Properties
    enum `Type`: String {
        case profile = "My Profile"
        case rewards = "My Rewards"
        case changePassword = "Change Password"
        case switchAccount = "Switch Account"
        case signOut = "Sign Out"
    
        var image: UIImage? {
            switch self {
            case .profile:
                return UIImage(named: "ic_profile")
            case .rewards:
                return UIImage(named: "ic_rewards")
            case .changePassword:
                return UIImage(named: "ic_locked")
            case .switchAccount:
                return UIImage(named: "ic_switch")
            case .signOut:
                return UIImage(named: "ic_log_out")
            }
        }
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = .workSansFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor.init(hex: "455571")
        
        return label
    }()
    
    private let titleImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    private let nextImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "ic_next")
        
        return view
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.layer.borderColor = UIColor.init(hex: "F1F2F4").cgColor
        view.layer.borderWidth = 1
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
        
        containerView.addSubview(titleImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(nextImageView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            titleImageView.topAnchor.constraint(greaterThanOrEqualTo: containerView.topAnchor, constant: 16),
            titleImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            titleImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            titleImageView.widthAnchor.constraint(equalToConstant: 20),
            titleImageView.heightAnchor.constraint(equalToConstant: 20),

            titleLabel.topAnchor.constraint(greaterThanOrEqualTo: containerView.topAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: titleImageView.trailingAnchor, constant: 16),
            
            nextImageView.topAnchor.constraint(greaterThanOrEqualTo: containerView.topAnchor, constant: 16),
            nextImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            nextImageView.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: 16),
            nextImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            nextImageView.widthAnchor.constraint(equalToConstant: 20),
            nextImageView.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
    
    // MARK: Methods
    func configure(with type: `Type`) {
        titleLabel.text = type.rawValue
        titleImageView.image = type.image
    }
}
