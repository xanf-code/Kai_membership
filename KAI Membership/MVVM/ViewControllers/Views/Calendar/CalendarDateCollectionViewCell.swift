//
//  CalendarDateCollectionViewCell.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 23/03/2021.
//

import UIKit

class CalendarDateCollectionViewCell: UICollectionViewCell {
    
    private lazy var selectionBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.backgroundColor = nil
        
        return view
    }()
    
    private lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .workSansFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor.black.withAlphaComponent(0.12)
        
        return label
    }()
    
    private lazy var accessibilityDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.setLocalizedDateFormatFromTemplate("EEEE, MMMM d")
        
        return dateFormatter
    }()
    
    var day: Day? {
        didSet {
            guard let day = day else { return }
            
            numberLabel.text = day.number
            accessibilityLabel = accessibilityDateFormatter.string(from: day.date)
            updateSelectionStatus()
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
        isAccessibilityElement = true
        accessibilityTraits = .button
        contentView.addSubview(selectionBackgroundView)
        contentView.addSubview(numberLabel)
        
        NSLayoutConstraint.deactivate(selectionBackgroundView.constraints)
    
        let size = traitCollection.horizontalSizeClass == .compact ?
            min(min(frame.width, frame.height) - 10, 60) : 45
        
        NSLayoutConstraint.activate([
            numberLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            numberLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            selectionBackgroundView.centerYAnchor.constraint(equalTo: numberLabel.centerYAnchor),
            selectionBackgroundView.centerXAnchor.constraint(equalTo: numberLabel.centerXAnchor),
            selectionBackgroundView.widthAnchor.constraint(equalToConstant: size),
            selectionBackgroundView.heightAnchor.constraint(equalTo: selectionBackgroundView.widthAnchor)
        ])
        
        selectionBackgroundView.layer.cornerRadius = size / 2
    }
    
    /*override func layoutSubviews() {
        super.layoutSubviews()
        
        NSLayoutConstraint.deactivate(selectionBackgroundView.constraints)
    
        let size = traitCollection.horizontalSizeClass == .compact ?
            min(min(frame.width, frame.height) - 10, 60) : 45
        
        NSLayoutConstraint.activate([
            numberLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            numberLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            selectionBackgroundView.centerYAnchor.constraint(equalTo: numberLabel.centerYAnchor),
            selectionBackgroundView.centerXAnchor.constraint(equalTo: numberLabel.centerXAnchor),
            selectionBackgroundView.widthAnchor.constraint(equalToConstant: size),
            selectionBackgroundView.heightAnchor.constraint(equalTo: selectionBackgroundView.widthAnchor)
        ])
        
        selectionBackgroundView.layer.cornerRadius = size / 2
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        layoutSubviews()
    }*/
}

// MARK: Appearance
private extension CalendarDateCollectionViewCell {
    
    func updateSelectionStatus() {
        guard let day = day else { return }
        
        if day.isSelected {
            applySelectedStyle()
        } else {
            if day.isNow {
                applyNowStyle()
            } else {
                applyDefaultStyle(isWithinDisplayedMonth: day.isWithinDisplayedMonth, isSunday: day.isSunday)
            }
        }
    }
    
    /*var isSmallScreenSize: Bool {
        let isCompact = traitCollection.horizontalSizeClass == .compact
        let smallWidth = UIScreen.main.bounds.width <= 350
        let widthGreaterThanHeight = UIScreen.main.bounds.width > UIScreen.main.bounds.height
        
        return isCompact && (smallWidth || widthGreaterThanHeight)
    }*/
    
    func applySelectedStyle() {
        accessibilityTraits.insert(.selected)
        accessibilityHint = nil
        
        numberLabel.textColor = .white
        selectionBackgroundView.backgroundColor = .init(hex: "29323D")
    }
    
    func applyNowStyle() {
        accessibilityTraits.remove(.selected)
        accessibilityHint = nil
        
        numberLabel.textColor = UIColor.Base.x500
        selectionBackgroundView.backgroundColor = UIColor.Base.x100
    }
    
    func applyDefaultStyle(isWithinDisplayedMonth: Bool, isSunday: Bool) {
        accessibilityTraits.remove(.selected)
        accessibilityHint = "Tap to select"
        
        if isWithinDisplayedMonth {
            numberLabel.textColor = isSunday ? .init(hex: "94A2B2") : UIColor.black.withAlphaComponent(0.54)
        } else {
            numberLabel.textColor = UIColor.black.withAlphaComponent(0.12)
        }
        
        selectionBackgroundView.backgroundColor = nil
    }
}
