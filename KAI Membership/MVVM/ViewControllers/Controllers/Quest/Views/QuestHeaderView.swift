//
//  QuestHeaderView.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 04/03/2021.
//

import UIKit

class QuestHeaderView: UIView {
    
    // MARK: Properties
    private let backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .init(hex: "0A1F44")
        
        return view
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "image_mission"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.attributedText = NSAttributedString(string: "Mission", attributes: [
            NSAttributedString.Key.font: UIFont.workSansFont(ofSize: 36, weight: .regular),
            NSAttributedString.Key.foregroundColor: UIColor.white
        ])
        
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 3
        label.attributedText = NSAttributedString(string: "01 spin for every finished mission. Get it now!", attributes: [
            NSAttributedString.Key.font: UIFont.workSansFont(ofSize: 16, weight: .semiBold),
            NSAttributedString.Key.foregroundColor: UIColor.white
        ])
        
        return label
    }()
    
    private(set) lazy var segmentView: UISegmentedControl = {
        let view = UISegmentedControl(items: ["Daily mission", "Monthly mission"])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .init(hex: "F7F8F9")
        view.selectedSegmentIndex = 0
        view.setWidth(115, forSegmentAt: 0)
        view.setWidth(136, forSegmentAt: 1)
        view.apportionsSegmentWidthsByContent = true
        view.layer.cornerRadius = 12
        view.addTarget(self, action: #selector(segmentedValueChanged(_:)), for: .valueChanged)
        
        return view
    }()
    
    private var bacgroundTopAnchor: NSLayoutConstraint?
    
    var selectedSegmentIndexChanged: ((Int) -> Void)?
    
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
        backgroundColor = .init(hex: "F7F8F9")
        
        addSubview(backgroundView)
        addSubview(titleLabel)
        addSubview(imageView)
        addSubview(descriptionLabel)
        addSubview(segmentView)
        
        bacgroundTopAnchor = backgroundView.topAnchor.constraint(equalTo: topAnchor, constant: 0)
        bacgroundTopAnchor?.isActive = true
        
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -22),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            titleLabel.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: 64),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),

            imageView.topAnchor.constraint(greaterThanOrEqualTo: titleLabel.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 23),
            descriptionLabel.widthAnchor.constraint(equalToConstant: 157),

            segmentView.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            segmentView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 20),
            segmentView.centerXAnchor.constraint(equalTo: centerXAnchor),
            segmentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            segmentView.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    // MARK: Configure
    func configure() {
        
    }
    
    func zoomImage(with value: CGFloat) {
        bacgroundTopAnchor?.constant = value
    }
    
    // MARK: Handle actions
    @objc private func segmentedValueChanged(_ sender: UISegmentedControl) {
        selectedSegmentIndexChanged?(sender.selectedSegmentIndex)
    }
}
