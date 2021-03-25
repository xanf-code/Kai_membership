//
//  RewardsEmptyView.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 10/03/2021.
//

import UIKit

class RewardsEmptyView: UIView {
    
    // MARK: Properties
    private let emptyImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "image_rewards_empty"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .center
        label.attributedText = NSAttributedString(string: "No Reward", attributes: [
            NSAttributedString.Key.font: UIFont.workSansFont(ofSize: 20, weight: .medium),
            NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(0.87)
        ])
        
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.attributedText = "You don’t have any reward to claim. \nStart doing missions now and earn valueable gifts".setTextWithFormat(font: .workSansFont(ofSize: 14, weight: .medium), textAlignment: .center, lineHeight: 28, textColor: UIColor.black.withAlphaComponent(0.54))
        
        return label
    }()
    
    private lazy var missionButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setAttributedTitle(NSAttributedString(string: "Go to Mission", attributes: [
            NSAttributedString.Key.font: UIFont.workSansFont(ofSize: 16, weight: .medium),
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]), for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(onPressedMission), for: .touchUpInside)
        
        return button
    }()
    
    var didFinishTouchingGoToMission: (() -> Void)?
    
    // MARK: Life cycle's
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    func setupView() {
        addSubview(emptyImageView)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(missionButton)

        NSLayoutConstraint.activate([
            emptyImageView.topAnchor.constraint(equalTo: topAnchor),
            emptyImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            emptyImageView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor),

            titleLabel.topAnchor.constraint(equalTo: emptyImageView.bottomAnchor, constant: 32),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            missionButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 32),
            missionButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            missionButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            missionButton.widthAnchor.constraint(equalToConstant: 246),
            missionButton.heightAnchor.constraint(equalToConstant: 52),
        ])
        
        DispatchQueue.main.async {
            self.missionButton.gradientBackgroundColors([UIColor.init(hex: "394656").cgColor, UIColor.init(hex: "181E25").cgColor], direction: .vertical)
        }
    }
    
    // MARK: Handle actions
    @objc private func onPressedMission() {
        didFinishTouchingGoToMission?()
    }
}
