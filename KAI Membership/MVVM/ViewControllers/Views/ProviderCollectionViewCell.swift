//
//  ProviderCollectionViewCell.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 15/03/2021.
//

import UIKit

class ProviderCollectionViewCell: UICollectionViewCell {
    
    // MARK: Properties
    private let providerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.createShadow(radius: 8)
        view.layer.borderWidth = 1
        
        return view
    }()
    
    private let providerImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    var isProviderSelected: Bool = false {
        didSet {
            providerView.layer.borderColor = UIColor.init(hex: isProviderSelected ? "CED6DE" : "F1F2F4").cgColor
        }
    }
    
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
        contentView.addSubview(providerView)
        
        providerView.addSubview(providerImageView)
        
        NSLayoutConstraint.activate([
            providerView.topAnchor.constraint(equalTo: topAnchor),
            providerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            providerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            providerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            providerImageView.centerXAnchor.constraint(equalTo: providerView.centerXAnchor),
            providerImageView.centerYAnchor.constraint(equalTo: providerView.centerYAnchor),
            providerImageView.leadingAnchor.constraint(lessThanOrEqualTo: providerView.leadingAnchor),
        ])
    }
    
    // MARK: Configure
    func configure(_ image: UIImage? = nil) {
        providerImageView.image = image
    }
}
