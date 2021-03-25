//
//  KAIBarButtonItemView.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 08/03/2021.
//

import UIKit

protocol KAIBarButtonItemViewDelegate: class {
    func kAIBarButtonItemViewDidSelecteSpin(_ kAIBarButtonItemView: KAIBarButtonItemView)
    func kAIBarButtonItemViewDidSelecteProfile(_ kAIBarButtonItemView: KAIBarButtonItemView)
}

class KAIBarButtonItemView: UIView {
    
    // MARK: Properties
    private lazy var spinButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: (AccountManagement.accountInfo?.user?.spinTurn ?? 0) > 0 ? "ic_spin_original" : "ic_spin")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        button.createShadow(radius: 8)
        button.addTarget(self, action: #selector(onPressedSpin), for: .touchUpInside)
        
        return button
    }()
    
    private let dotView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .init(hex: "C42C15")
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 2
        view.layer.cornerRadius = 7
        view.isHidden = (AccountManagement.accountInfo?.user?.spinTurn ?? 0) <= 0
        
        return view
    }()
    
    private lazy var profileButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(from: AccountManagement.accountInfo?.user?.avatarLink, placeholder: UIImage(named: "ic_profile")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.backgroundColor = .white
        button.contentEdgeInsets = .init(top: 2, left: 2, bottom: 2, right: 2)
        button.imageView?.layer.cornerRadius = 8
        button.layer.cornerRadius = 8
        button.createShadow(radius: 8)
        button.addTarget(self, action: #selector(onPressedProfile), for: .touchUpInside)
        
        return button
    }()
    
    weak var delegate: KAIBarButtonItemViewDelegate?
    
    // MARK: Life cycle's
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Configure
    func setupView() {
        addSubview(spinButton)
        addSubview(profileButton)
        addSubview(dotView)
        
        NSLayoutConstraint.activate([
            profileButton.topAnchor.constraint(equalTo: topAnchor),
            profileButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            profileButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            profileButton.widthAnchor.constraint(equalToConstant: 36),
            profileButton.heightAnchor.constraint(equalToConstant: 36),
            
            spinButton.topAnchor.constraint(equalTo: profileButton.topAnchor),
            spinButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            spinButton.bottomAnchor.constraint(equalTo: profileButton.bottomAnchor),
            spinButton.trailingAnchor.constraint(equalTo: profileButton.leadingAnchor, constant: -4),
            spinButton.widthAnchor.constraint(equalTo: profileButton.widthAnchor),
            spinButton.heightAnchor.constraint(equalTo: profileButton.heightAnchor),
            
            dotView.topAnchor.constraint(equalTo: spinButton.topAnchor, constant: -4),
            dotView.trailingAnchor.constraint(equalTo: spinButton.trailingAnchor, constant: 4),
            dotView.widthAnchor.constraint(equalToConstant: 14),
            dotView.heightAnchor.constraint(equalToConstant: 14),
        ])
    }
    
    // MARK: Methods
    func refresh() {
        profileButton.setImage(from: AccountManagement.accountInfo?.user?.avatarLink, placeholder: UIImage(named: "ic_profile")?.withRenderingMode(.alwaysOriginal), for: .normal)
        dotView.isHidden = (AccountManagement.accountInfo?.user?.spinTurn ?? 0) <= 0
        spinButton.setImage(UIImage(named: dotView.isHidden ? "ic_spin" : "ic_spin_original")?.withRenderingMode(.alwaysOriginal), for: .normal)
    }
    
    // MARK: Handle actions
    @objc private func onPressedSpin() {
        delegate?.kAIBarButtonItemViewDidSelecteSpin(self)
    }
    
    @objc private func onPressedProfile() {
        delegate?.kAIBarButtonItemViewDidSelecteProfile(self)
    }
}
