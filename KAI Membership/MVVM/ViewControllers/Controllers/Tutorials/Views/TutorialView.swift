//
//  TutorialView.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 24/03/2021.
//

import UIKit

class TutorialView: UIView {

    // MARK: Properties
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        
        return view
    }()
    
    private let contentView: TutorialContentView = {
        let view = TutorialContentView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 24
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.createShadow(radius: 24)
        
        return view
    }()
    
    // MARK: Life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    func setupView() {
        backgroundColor = .white
        addSubview(imageView)
        addSubview(contentView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
//            contentView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -24),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 337)
        ])
    }
}

// MARK: Configure
extension TutorialView {

    func configure(image: UIImage? = nil, title: String? = nil, body: String? = nil, imageBackgroundColor: UIColor? = nil) {
        imageView.image = image
        contentView.configure(title: title, body: body)
        imageView.backgroundColor = imageBackgroundColor
    }
}
