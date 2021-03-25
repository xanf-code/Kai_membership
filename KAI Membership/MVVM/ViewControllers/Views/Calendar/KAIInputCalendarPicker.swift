//
//  KAIInputCalendarPicker.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 23/03/2021.
//

import UIKit

class KAIInputCalendarPicker: UIView {
    
    // MARK: Properties
    private let transparentView = UIView()
    
    private let calendarImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "ic_calendar")?.withRenderingMode(.alwaysTemplate))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .init(hex: "C9CED6")
        
        return imageView
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textColor = UIColor.black.withAlphaComponent(0.87)
        label.font = .workSansFont(ofSize: 14, weight: .medium)
        
        return label
    }()
    
    private lazy var selectedButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .init(hex: "FAFBFB")
        button.layer.cornerRadius = 8
        button.layer.borderColor = UIColor.Base.x100.cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(onPressedCalendar), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var calendarPicker: KAICalendarPicker = {
        let view = KAICalendarPicker(baseDate: baseDate) { [weak self] date in
            guard let this = self else { return }
            
            let formatTime = date.timeIntervalSince1970.formatTimeIntervalToString("dd/MM/yyyy")
            this.setText(formatTime)
            this.selectedDateChanged(date)
            this.removeTransparentView()
        }
        view.clipsToBounds = true
        view.backgroundColor = .white
        
        return view
    }()
    
    private let selectedDate: Date
    private let baseDate: Date
    
    private let selectedDateChanged: ((Date) -> Void)
    
    private var isOpenCalendar: Bool = false {
        didSet {
            calendarImageView.tintColor = isOpenCalendar ? UIColor.Base.x500 : .init(hex: "C9CED6")
        }
    }
    
    // MARK: Life cycle's
    init(baseDate: Date, frame: CGRect = .zero, _ selectedDateChanged: @escaping ((Date) -> Void)) {
        self.selectedDate = baseDate
        self.baseDate = baseDate
        self.selectedDateChanged = selectedDateChanged
        
        super.init(frame: frame)
        
        setupView()
    }
    
    init(baseTimeInterval: Double? = nil, frame: CGRect = .zero, _ selectedDateChanged: @escaping ((Date) -> Void)) {
        let baseDate = (baseTimeInterval ?? 0) > 0 ? Date(timeIntervalSince1970: baseTimeInterval!) : Date()
        self.selectedDate = baseDate
        self.baseDate = baseDate
        self.selectedDateChanged = selectedDateChanged
        
        super.init(frame: frame)
        
        let formatTime = baseDate.timeIntervalSince1970.formatTimeIntervalToString("dd/MM/yyyy")
        setText(formatTime)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    func setupView() {
        addSubview(selectedButton)
        addSubview(valueLabel)
        addSubview(calendarImageView)
        
        NSLayoutConstraint.activate([
            selectedButton.topAnchor.constraint(equalTo: topAnchor),
            selectedButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            selectedButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            selectedButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            selectedButton.heightAnchor.constraint(equalToConstant: 44),
            
            valueLabel.centerYAnchor.constraint(equalTo: selectedButton.centerYAnchor),
            valueLabel.leadingAnchor.constraint(equalTo: selectedButton.leadingAnchor, constant: 16),
            
            calendarImageView.centerYAnchor.constraint(equalTo: selectedButton.centerYAnchor),
            calendarImageView.leadingAnchor.constraint(greaterThanOrEqualTo: valueLabel.trailingAnchor, constant: 8),
            calendarImageView.trailingAnchor.constraint(equalTo: selectedButton.trailingAnchor, constant: -14),
            calendarImageView.widthAnchor.constraint(equalToConstant: 16),
            calendarImageView.heightAnchor.constraint(equalToConstant: 16),
        ])
    }
    
    private func addTransparentView() {
        let frames: CGRect = selectedButton.convert(selectedButton.frame, to: nil)
        let window = Navigator.window
        transparentView.frame = window?.frame ?? CGRect(origin: .zero, size: Constants.Device.screenBounds.size)
        window?.addSubview(transparentView)
        
        calendarPicker.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        window?.addSubview(calendarPicker)
        calendarPicker.layer.cornerRadius = 8
        calendarPicker.createShadow(radius: 8)
        
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView))
        transparentView.addGestureRecognizer(tapgesture)
        transparentView.alpha = 0
        isOpenCalendar = true
        let itemWidth = frames.width / 7
        let height: CGFloat = itemWidth * CGFloat(calendarPicker.numberOfWeeksInBaseDate) + KAICalendarPicker.titleHeight
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0.5
            self.calendarPicker.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height + 5, width: frames.width, height: height)
        }, completion: nil)
    }
    
    func setAttributedTitle(_ attributedString: NSAttributedString) {
        valueLabel.attributedText = attributedString
    }
    
    func setText(_ text: String) {
        valueLabel.text = text
    }
    
    // MARK: Handle actions
    @objc func removeTransparentView() {
        let frames: CGRect = selectedButton.convert(selectedButton.frame, to: nil)
        isOpenCalendar = false
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0
            self.calendarPicker.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        }, completion: { finish in
            self.calendarPicker.removeFromSuperview()
            self.transparentView.removeFromSuperview()
        })
    }
    
    @objc private func onPressedCalendar() {
        addTransparentView()
        Navigator.window?.endEditing(true)
    }
}
