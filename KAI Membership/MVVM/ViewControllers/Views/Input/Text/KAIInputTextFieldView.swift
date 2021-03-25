//
//  KAIInputTextFieldView.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 20/02/2021.
//

import UIKit

class KAIInputTextFieldView: UIView {

    // MARK: Properties
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = .workSansFont(ofSize: 10, weight: .medium)
        label.textColor = .init(hex: "364766")
        
        return label
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        
        return label
    }()
    
    private var textFieldView: KAITextField!
    
    var contentInput: String = ""
    
    weak var delegate: KAITextFieldDelegate?
    
    // MARK: Life cycle's
    init(with type: KAITextField.`Type`, title: String, placeholder: String? = nil, returnKeyType: UIReturnKeyType = .default, keyboardType: UIKeyboardType = .default, frame: CGRect = .zero) {
        super.init(frame: frame)
        
        setupView(with: type, title: title, placeholder: placeholder, returnKeyType: returnKeyType, keyboardType: keyboardType)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    private func setupView(with type: KAITextField.`Type`, title: String, placeholder: String? = nil, returnKeyType: UIReturnKeyType = .default, keyboardType: UIKeyboardType = .default) {
        textFieldView = KAITextField(with: type, returnKeyType: returnKeyType, keyboardType: keyboardType, placeholder: placeholder)
        textFieldView.translatesAutoresizingMaskIntoConstraints = false
        textFieldView.delegate = self
        titleLabel.text = title
        
        addSubview(titleLabel)
        addSubview(textFieldView)
        addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
            
            textFieldView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            textFieldView.leadingAnchor.constraint(equalTo: leadingAnchor),
            textFieldView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            messageLabel.topAnchor.constraint(equalTo: textFieldView.bottomAnchor),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    func setMessage(_ message: String? = nil) {
        guard let message = message, !message.isEmpty else {
            messageLabel.attributedText = nil
            return
        }
        
        messageLabel.attributedText = message.setTextWithFormat(font: .workSansFont(ofSize: 12, weight: .medium), lineHeight: 16, textColor: UIColor.init(hex: "C42C15"))
    }
    
    func reset() {
        textFieldView.reset()
    }
    
    func inputBecomeFirstResponder() {
        textFieldView.inputBecomeFirstResponder()
    }
    
    func setText(_ text: String) {
        contentInput = text
        textFieldView.setText(text)
    }
    
    func setAttributedText(_ attributedText: NSAttributedString) {
        contentInput = attributedText.string
        textFieldView.setAttributedText(attributedText)
    }
}

// MARK: KAITextFieldDelegate
extension KAIInputTextFieldView: KAITextFieldDelegate {
    
    func kAITextFieldDidBeginEditing(_ textField: UITextField, for view: UIView) {
        delegate?.kAITextFieldDidBeginEditing(textField, for: self)
    }
    
    func kAITextFieldDidEndEditing(_ textField: UITextField, for view: UIView) {
        delegate?.kAITextFieldDidEndEditing(textField, for: self)
    }
    
    func kAITextFieldDidChange(_ textField: UITextField, for view: UIView) {
        contentInput = textField.text ?? ""
        messageLabel.attributedText = nil
        delegate?.kAITextFieldDidChange(textField, for: self)
    }
    
    func kAITextFieldShouldReturn(_ textField: UITextField, for view: UIView) -> Bool {
        return delegate?.kAITextFieldShouldReturn(textField, for: self) ?? false
    }
    
    func kAITextFieldShouldClear(_ textField: UITextField, for view: UIView) -> Bool {
        return delegate?.kAITextFieldShouldClear(textField, for: self) ?? true
    }
}
