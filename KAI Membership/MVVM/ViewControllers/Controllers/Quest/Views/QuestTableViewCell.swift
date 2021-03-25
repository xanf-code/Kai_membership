//
//  QuestTableViewCell.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 05/03/2021.
//

import UIKit

class QuestTableViewCell: UITableViewCell {
    
    // MARK: Properties
    enum `Type` {
        case inProgress
        case completed
    }
    
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
        
        return label
    }()
    
    private let progressBar: UIProgressView = {
        let view = UIProgressView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.progressTintColor = .init(hex: "0E8C31")
        view.trackTintColor = .init(hex: "F7F8F9")
        
        return view
    }()
    
    private let descriptionStackVỉew: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.distribution = .fill
        
        return stackView
    }()
    
    private let infoStackVỉew: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 6
        
        return stackView
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
        backgroundColor = .init(hex: "F7F8F9")
        
        contentView.addSubview(containerView)
        
        containerView.addSubview(contentImageView)
        containerView.addSubview(infoStackVỉew)
        
        infoStackVỉew.addArrangedSubview(titleLabel)
        infoStackVỉew.addArrangedSubview(descriptionStackVỉew)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            contentImageView.topAnchor.constraint(greaterThanOrEqualTo: containerView.topAnchor, constant: 12),
            contentImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            contentImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            contentImageView.widthAnchor.constraint(equalToConstant: 52),
            contentImageView.heightAnchor.constraint(equalToConstant: 52),
            
            infoStackVỉew.topAnchor.constraint(greaterThanOrEqualTo: containerView.topAnchor, constant: 12),
            infoStackVỉew.leadingAnchor.constraint(equalTo: contentImageView.trailingAnchor, constant: 8),
            infoStackVỉew.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            infoStackVỉew.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -32),
            
            progressBar.heightAnchor.constraint(equalToConstant: 4),
        ])
    }
    
    // MARK: Methods
    func configure(_ quest: QuestRemote) {
        switch quest.key {
        case .highestScores:
            contentImageView.image = UIImage(named: "ic_mission_progress")
            let mutableAttributedString = NSMutableAttributedString(attributedString: NSAttributedString(string: "Top score: ", attributes: [
                NSAttributedString.Key.font: UIFont.workSansFont(ofSize: 10, weight: .medium),
                NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(0.54)
            ]))
            
            mutableAttributedString.append(NSAttributedString(string: "\((quest.userQuest?.progress ?? 0).formatToString()) (Flying Bird)", attributes: [
                NSAttributedString.Key.font: UIFont.workSansFont(ofSize: 10, weight: .medium),
                NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(0.87)
            ]))
            
            descriptionLabel.attributedText = mutableAttributedString
        case .thiryMinutes, .inviteFriend, .signIn:
            let progress = quest.userQuest?.progress ?? 0
            
            if let totalProgress = quest.progress, totalProgress > 0, progress < totalProgress {
                progressBar.progress = Float(progress) / Float(totalProgress)
                descriptionStackVỉew.addArrangedSubview(progressBar)
                contentImageView.image = UIImage(named: "ic_mission_progress")
                descriptionLabel.attributedText = NSAttributedString(string: "\(progress)/\(totalProgress)", attributes: [
                    NSAttributedString.Key.font: UIFont.workSansFont(ofSize: 10, weight: .medium),
                    NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(0.87)
                ])
            } else {
                contentImageView.image = UIImage(named: "ic_mission_completed")
                descriptionLabel.attributedText = NSAttributedString(string: "Completed", attributes: [
                    NSAttributedString.Key.font: UIFont.workSansFont(ofSize: 10, weight: .medium),
                    NSAttributedString.Key.foregroundColor: UIColor.init(hex: "0E8C31")
                ])
            }
        }
        
        descriptionStackVỉew.addArrangedSubview(descriptionLabel)
        titleLabel.text = quest.name
    }
}
