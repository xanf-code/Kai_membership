//
//  HistoryTableViewCell.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 17/03/2021.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    
    // MARK: Properties
    private let contentImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "ic_money_bag"))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .workSansFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor.black.withAlphaComponent(0.87)
        
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        
        return label
    }()
    
    private let infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.distribution = .fill
        
        return stackView
    }()
    
    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.Base.x100
        button.setAttributedTitle(NSAttributedString(string: "Redeem", attributes: [
            NSAttributedString.Key.font: UIFont.workSansFont(ofSize: 12, weight: .medium),
            NSAttributedString.Key.foregroundColor: UIColor.init(hex: "29323D")
        ]), for: .normal)
        button.contentEdgeInsets = .init(top: 6, left: 12, bottom: 6, right: 12)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(onPressedAction), for: .touchUpInside)
        
        return button
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillProportionally
        
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
        backgroundColor = .clear
        
        contentView.addSubview(containerView)
        
        containerView.addSubview(contentImageView)
        containerView.addSubview(stackView)
        
        stackView.addArrangedSubview(infoStackView)
        
        infoStackView.addArrangedSubview(titleLabel)
//        infoStackView.addArrangedSubview(descriptionLabel)
        
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
            
            stackView.topAnchor.constraint(greaterThanOrEqualTo: containerView.topAnchor, constant: 12),
            stackView.leadingAnchor.constraint(equalTo: contentImageView.trailingAnchor, constant: 8),
            stackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
        ])
    }
    
    // MARK: Methods
    func configure(_ history: HistoryRemote) {
        titleLabel.text = history.rewardName
        /*stackView.removeArrangedSubview(actionButton)
        
        if history.status == .inProgress {
            stackView.addArrangedSubview(actionButton)
        }
        
        let mutableAttributedString = NSMutableAttributedString(string: "Received on: ", attributes: [
            NSAttributedString.Key.font: UIFont.workSansFont(ofSize: 10, weight: .medium),
            NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(0.54)
        ])
        mutableAttributedString.append(NSAttributedString(string: "Tue, 20/11/2020", attributes: [
            NSAttributedString.Key.font: UIFont.workSansFont(ofSize: 10, weight: .medium),
            NSAttributedString.Key.foregroundColor: UIColor.init(hex: "98A1B1")
        ]))
        
        descriptionLabel.attributedText = mutableAttributedString*/
    }
    
    // MARK: Handle actions
    @objc private func onPressedAction() {
        AlertManagement.shared.showToast(with: "Your received \(titleLabel.text ?? "KAI")", position: .top)
    }
}
