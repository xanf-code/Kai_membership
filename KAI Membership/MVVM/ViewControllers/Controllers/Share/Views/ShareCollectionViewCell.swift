//
//  ShareCollectionViewCell.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 22/03/2021.
//

import UIKit

class ShareCollectionViewCell: UICollectionViewCell {
    
    // MARK: Properties
    private let titleImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textColor = .init(hex: "596780")
        label.font = .workSansFont(ofSize: 14, weight: .regular)
        
        return label
    }()
    
    // MARK: Life cycle's
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    private func setupView() {
        contentView.addSubview(titleImageView)
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleImageView.topAnchor.constraint(equalTo: topAnchor),
            titleImageView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor),
            titleImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleImageView.widthAnchor.constraint(equalToConstant: 52),
            titleImageView.heightAnchor.constraint(equalToConstant: 52),
            
            titleLabel.topAnchor.constraint(equalTo: titleImageView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    // MARK: Configure
    func configure(title: String, image: UIImage? = nil) {
        titleLabel.text = title
        titleImageView.image = image
    }
}

