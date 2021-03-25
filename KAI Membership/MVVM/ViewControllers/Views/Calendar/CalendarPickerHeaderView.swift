//
//  CalendarPickerHeaderView.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 23/03/2021.
//

import UIKit

protocol CalendarPickerHeaderDelegate: class {
    func calendarPickerHeaderDidTouchLastMonth(_ calendarPickerHeaderView: CalendarPickerHeaderView)
    func calendarPickerHeaderDidTouchNextMonth(_ calendarPickerHeaderView: CalendarPickerHeaderView)
}

class CalendarPickerHeaderView: UIView {
    
    // MARK: Properties
    private let monthLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .workSansFont(ofSize: 14, weight: .regular)
        label.text = "Month"
        label.accessibilityTraits = .header
        label.isAccessibilityElement = true
        
        return label
    }()
    
    private lazy var previousMonthButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "ic_previous")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .init(hex: "455571")
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        button.createShadow(radius: 8)
        button.addTarget(self, action: #selector(onPressedPreviousMonthButton), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var nextMonthButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "ic_next")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .init(hex: "455571")
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        button.createShadow(radius: 8)
        button.addTarget(self, action: #selector(onPressedNextMonthButton), for: .touchUpInside)
        
        return button
    }()
    
    private let dayOfWeekStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.locale = Locale.current
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMM y")
        
        return dateFormatter
    }()
    
    var baseDate: Date {
        didSet {
            monthLabel.text = dateFormatter.string(from: baseDate)
        }
    }
    
    weak var delegate: CalendarPickerHeaderDelegate?
    
    // MARK: Life cycle's
    init(baseDate: Date, frame: CGRect = .zero) {
        self.baseDate = baseDate
        
        super.init(frame: frame)
        
        monthLabel.text = dateFormatter.string(from: baseDate)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    private func setupView() {
        
        addSubview(monthLabel)
        addSubview(previousMonthButton)
        addSubview(nextMonthButton)
        addSubview(dayOfWeekStackView)
        
        for dayNumber in 1...7 {
            let dayLabel = UILabel()
            dayLabel.font = .workSansFont(ofSize: 12, weight: .regular)
            dayLabel.textColor = UIColor.init(hex: "4E5D78")
            dayLabel.textAlignment = .center
            dayLabel.text = DayOfWeek(rawValue: dayNumber)?.letter
            dayOfWeekStackView.addArrangedSubview(dayLabel)
        }
        
        NSLayoutConstraint.activate([
            monthLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            monthLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            
            nextMonthButton.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            nextMonthButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            nextMonthButton.heightAnchor.constraint(equalToConstant: 24),
            nextMonthButton.widthAnchor.constraint(equalToConstant: 24),
            
            previousMonthButton.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            previousMonthButton.heightAnchor.constraint(equalToConstant: 24),
            previousMonthButton.widthAnchor.constraint(equalToConstant: 24),
            previousMonthButton.trailingAnchor.constraint(equalTo: nextMonthButton.leadingAnchor, constant: -8),
            
            dayOfWeekStackView.topAnchor.constraint(equalTo: nextMonthButton.bottomAnchor, constant: 16),
            dayOfWeekStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dayOfWeekStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            dayOfWeekStackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    // MARK: Handle actions
    @objc private func onPressedPreviousMonthButton() {
        delegate?.calendarPickerHeaderDidTouchLastMonth(self)
    }
    
    @objc private func onPressedNextMonthButton() {
        delegate?.calendarPickerHeaderDidTouchNextMonth(self)
    }
}
