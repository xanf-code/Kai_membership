//
//  TabPageView.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 04/03/2021.
//

import UIKit

class TabPageView: UIView {
    
    // MARK: Properties
    struct Font {
        let normal: UIFont
        let selected: UIFont
        
        init(normal: UIFont = .workSansFont(ofSize: 14, weight: .medium), selected: UIFont = .workSansFont(ofSize: 14, weight: .medium)) {
            self.normal = normal
            self.selected = selected
        }
    }
    
    struct TextColor {
        let normal: UIColor
        let selected: UIColor
        
        init(normal: UIColor = .init(hex: "8A94A6"), selected: UIColor = UIColor.black.withAlphaComponent(0.87)) {
            self.normal = normal
            self.selected = selected
        }
    }
    
    struct BackgroundColor {
        let normal: UIColor?
        let selected: UIColor?
        
        init(normal: UIColor? = nil, selected: UIColor? = nil) {
            self.normal = normal
            self.selected = selected
        }
    }
    
    struct Setting {
        let font: Font
        let textColor: TextColor
        let backgroundColor: BackgroundColor
        
        init(font: Font = Font(), textColor: TextColor = TextColor(), backgroundColor: BackgroundColor = BackgroundColor()) {
            self.font = font
            self.textColor = textColor
            self.backgroundColor = backgroundColor
        }
    }
    
    private let setting: Setting
    private let tabName: String
    
    private lazy var titleButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.numberOfLines = 1
        button.contentEdgeInsets = .init(top: 8, left: 12, bottom: 8, right: 12)

        return button
    }()
    
    // MARK: Life cycle's
    init(with tabName: String, setting: Setting = Setting(), isSelected: Bool = false, frame: CGRect = .zero) {
        self.tabName = tabName
        self.setting = setting
        
        super.init(frame: frame)
        
        setupView()
        configure(isSelected)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    private func setupView() {
        
    }
    
    // MARK: Configure
    func configure(_ isSelected: Bool) {
        if isSelected {
            titleButton.backgroundColor = setting.backgroundColor.selected
            titleButton.setAttributedTitle(NSAttributedString(string: tabName, attributes: [
                NSAttributedString.Key.foregroundColor: setting.textColor.selected,
                NSAttributedString.Key.font: setting.font.selected
            ]), for: .normal)
        } else {
            titleButton.backgroundColor = setting.backgroundColor.normal
            titleButton.setAttributedTitle(NSAttributedString(string: tabName, attributes: [
                NSAttributedString.Key.foregroundColor: setting.textColor.normal,
                NSAttributedString.Key.font: setting.font.normal
            ]), for: .normal)
        }
    }
}
