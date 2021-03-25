//
//  NewsLastestCollectionViewCell.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 05/03/2021.
//

import UIKit

class NewsLastestCollectionViewCell: UICollectionViewCell {
    
    // MARK: Properties
    private let coverImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.backgroundColor = .init(hex: "C4C4C4")
        view.layer.cornerRadius = 8
        
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        
        return label
    }()
    
    private let publicDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = .workSansFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor.white.withAlphaComponent(0.7)
        
        return label
    }()
    
    private let infoView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
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
        contentView.addSubview(coverImageView)
        contentView.addSubview(infoView)
        
        infoView.addSubview(titleLabel)
        infoView.addSubview(publicDateLabel)
        
        NSLayoutConstraint.activate([
            coverImageView.topAnchor.constraint(equalTo: topAnchor),
            coverImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            coverImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            coverImageView.widthAnchor.constraint(equalToConstant: 64),
            coverImageView.heightAnchor.constraint(equalToConstant: 64),
            
            infoView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor),
            infoView.centerYAnchor.constraint(equalTo: centerYAnchor),
            infoView.leadingAnchor.constraint(equalTo: coverImageView.trailingAnchor, constant: 12),
            infoView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: infoView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: infoView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: infoView.trailingAnchor),
            
            publicDateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            publicDateLabel.leadingAnchor.constraint(equalTo: infoView.leadingAnchor),
            publicDateLabel.bottomAnchor.constraint(equalTo: infoView.bottomAnchor),
            publicDateLabel.trailingAnchor.constraint(equalTo: infoView.trailingAnchor)
        ])
    }
    
    // MARK: Configure
    func configure(_ new: NewRemote) {
        publicDateLabel.text = new.publicDate
        titleLabel.attributedText = new.title?.setTextWithFormat(font: .workSansFont(ofSize: 14, weight: .semiBold), lineHeight: 20, textColor: UIColor.black.withAlphaComponent(0.87), lineHeightMultiple: 1.22)
    }
}
