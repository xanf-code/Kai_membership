//
//  KAITextField.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 11/03/2021.
//

import UIKit

protocol KAITextFieldDelegate: class {
    func kAITextFieldDidBeginEditing(_ textField: UITextField, for view: UIView)
    func kAITextFieldDidEndEditing(_ textField: UITextField, for view: UIView)
    func kAITextFieldDidChange(_ textField: UITextField, for view: UIView)
    func kAITextFieldShouldReturn(_ textField: UITextField, for view: UIView) -> Bool
    func kAITextFieldShouldClear(_ textField: UITextField, for view: UIView) -> Bool
}

extension KAITextFieldDelegate {
    func kAITextFieldDidBeginEditing(_ textField: UITextField, for view: UIView) {}
    func kAITextFieldDidEndEditing(_ textField: UITextField, for view: UIView) {}
    func kAITextFieldDidChange(_ textField: UITextField, for view: UIView) {}
}

class KAITextField: UIView {
    
    // MARK: Properties
    enum `Type` {
        case `default`
        case password
    }
    
    enum State {
        case normal
        case disabled
        case failed
        case success
    }
    
    private let type: `Type`
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .init(hex: "FAFBFB")
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.init(hex: "E1E4E8").cgColor
        
        return view
    }()
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = false
        label.numberOfLines = 1
        label.font = .workSansFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor.black.withAlphaComponent(0.54)
        
        return label
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = nil
        textField.tintColor = .init(hex: "ED9771")
        textField.autocorrectionType = .no
        textField.textContentType = nil
        textField.isSecureTextEntry = isSecureTextEntry
        textField.textColor = UIColor.black.withAlphaComponent(0.84)
        textField.font = .workSansFont(ofSize: 14, weight: .medium)
//        textField.clearButtonMode = .always
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        textField.delegate = self
        
        return textField
    }()
    
    private lazy var actionButton: UIButton = {
        let view = UIButton(type: .system)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentEdgeInsets = .init(top: 14, left: 14, bottom: 14, right: 14)
        view.setImage(UIImage(named: "ic_show_password")?.withRenderingMode(.alwaysOriginal), for: .normal)
        view.addTarget(self, action: #selector(onPressedAction), for: .touchUpInside)
        
        return view
    }()
    
    private let placeholder: String?
    
    private var isSecureTextEntry: Bool
    
    var state: State {
        didSet {
            switch type {
            case .default:
                updateTypeDefault()
            case .password:
                updateTypePassword()
            }
        }
    }
    
    var contentInput: String = ""
    
    private var textFieldTrailingAnchor: NSLayoutConstraint?
    
    weak var delegate: KAITextFieldDelegate?
    
    // MARK: Life cycle's
    init(with type: `Type`, isEnabled: Bool = false, isSelected: Bool = true, returnKeyType: UIReturnKeyType = .default, keyboardType: UIKeyboardType = .default, placeholder: String? = nil, textAlignment: NSTextAlignment = .left, frame: CGRect = .zero) {
        self.type = type
        self.state = isEnabled ? .disabled : .normal
        self.isSecureTextEntry = type == .password
        self.placeholder = placeholder
        
        super.init(frame: frame)
        
        placeholderLabel.text = placeholder
        placeholderLabel.textAlignment = textAlignment
        textField.textAlignment = textAlignment
        textField.returnKeyType = returnKeyType
        textField.keyboardType = keyboardType
        textField.isUserInteractionEnabled = isSelected
        actionButton.isUserInteractionEnabled = isSelected
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    func setupView() {
        addSubview(containerView)
        
        containerView.addSubview(textField)
        containerView.addSubview(placeholderLabel)
        containerView.addSubview(actionButton)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 44),
            
            textField.topAnchor.constraint(equalTo: containerView.topAnchor),
            textField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            textField.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            placeholderLabel.topAnchor.constraint(greaterThanOrEqualTo: containerView.topAnchor),
            placeholderLabel.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
            placeholderLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            placeholderLabel.widthAnchor.constraint(equalTo: textField.widthAnchor),
            
            actionButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            actionButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            actionButton.widthAnchor.constraint(equalToConstant: 44),
            actionButton.heightAnchor.constraint(equalToConstant: 44),
        ])
        
        switch type {
        case .default:
            updateTypeDefault()
            textFieldTrailingAnchor = textField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16)
        case .password:
            updateTypePassword()
            textFieldTrailingAnchor = textField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -44)
        }
        
        textFieldTrailingAnchor?.isActive = true
    }
    
    private func updateTypeDefault() {
        switch state {
        case .normal:
            textFieldTrailingAnchor?.constant = -16
            textField.isEnabled = true
            actionButton.isHidden = true
            containerView.layer.borderColor = UIColor.init(hex: "E1E4E8").cgColor
            containerView.backgroundColor = .init(hex: "FAFBFB")
        case .disabled:
            textFieldTrailingAnchor?.constant = -16
            textField.isEnabled = false
            actionButton.isHidden = true
            containerView.layer.borderColor = UIColor.init(hex: "E1E4E8").cgColor
            containerView.backgroundColor = .init(hex: "F1F2F4")
        case .failed:
            textFieldTrailingAnchor?.constant = -44
            actionButton.setImage(UIImage(named: "ic_failed")?.withRenderingMode(.alwaysOriginal), for: .normal)
            textField.isEnabled = true
            actionButton.isHidden = false
            actionButton.isEnabled = false
            containerView.layer.borderColor = UIColor.init(hex: "C42C15").cgColor
            containerView.backgroundColor = .init(hex: "FAFBFB")
        case .success:
            textFieldTrailingAnchor?.constant = -44
            actionButton.setImage(UIImage(named: "ic_success")?.withRenderingMode(.alwaysOriginal), for: .normal)
            textField.isEnabled = true
            actionButton.isHidden = false
            actionButton.isEnabled = false
            containerView.layer.borderColor = UIColor.init(hex: "0E8C31").cgColor
            containerView.backgroundColor = .init(hex: "FAFBFB")
        }
    }
    
    private func updateTypePassword() {
        switch state {
        case .normal:
            textField.isSecureTextEntry = isSecureTextEntry
            actionButton.setImage(UIImage(named: isSecureTextEntry ? "ic_show_password" : "ic_hide_password")?.withRenderingMode(.alwaysOriginal), for: .normal)
            textField.isEnabled = true
            actionButton.isEnabled = true
            containerView.layer.borderColor = UIColor.init(hex: "E1E4E8").cgColor
            containerView.backgroundColor = .init(hex: "FAFBFB")
        case .disabled:
            textField.isSecureTextEntry = true
            actionButton.setImage(UIImage(named: "ic_show_password")?.withRenderingMode(.alwaysOriginal), for: .normal)
            textField.isEnabled = false
            actionButton.isEnabled = false
            containerView.layer.borderColor = UIColor.init(hex: "E1E4E8").cgColor
            containerView.backgroundColor = .init(hex: "F1F2F4")
        case .failed:
            textField.isSecureTextEntry = true
            actionButton.setImage(UIImage(named: "ic_failed")?.withRenderingMode(.alwaysOriginal), for: .normal)
            textField.isEnabled = true
            actionButton.isEnabled = false
            containerView.layer.borderColor = UIColor.init(hex: "C42C15").cgColor
            containerView.backgroundColor = .init(hex: "FAFBFB")
        case .success:
            textField.isSecureTextEntry = true
            actionButton.setImage(UIImage(named: "ic_success")?.withRenderingMode(.alwaysOriginal), for: .normal)
            textField.isEnabled = true
            actionButton.isEnabled = false
            containerView.layer.borderColor = UIColor.init(hex: "0E8C31").cgColor
            containerView.backgroundColor = .init(hex: "FAFBFB")
        }
    }
    
    // MARK: Methods
    func inputBecomeFirstResponder() {
        textField.becomeFirstResponder()
    }
    
    func inputResignFirstResponder() {
        textField.resignFirstResponder()
    }
    
    func reset() {
        textField.text = nil
        textField.becomeFirstResponder()
        state = .normal
    }
    
    func setText(_ text: String) {
        contentInput = text
        textField.text = text
        placeholderLabel.isHidden = !text.isEmpty
    }
    
    func setAttributedText(_ attributedText: NSAttributedString) {
        contentInput = attributedText.string
        textField.attributedText = attributedText
        placeholderLabel.isHidden = !contentInput.isEmpty
    }
    
    // MARK: Handle actions
    @objc private func onPressedAction() {
        switch state {
        case .normal:
            isSecureTextEntry = !isSecureTextEntry
            textField.isSecureTextEntry = isSecureTextEntry
            actionButton.setImage(UIImage(named: isSecureTextEntry ? "ic_show_password" : "ic_hide_password")?.withRenderingMode(.alwaysOriginal), for: .normal)
        case .disabled:
            debugPrint("Không cho tương tác")
        case .failed:
            debugPrint("Không cho tương tác")
        case .success:
            debugPrint("Không cho tương tác")
        }
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        if state == .failed || state == .success {
            state = .normal
        }
        
        contentInput = textField.text ?? ""
        placeholderLabel.isHidden = !contentInput.isEmpty
        delegate?.kAITextFieldDidChange(textField, for: self)
    }
}

// MARK: UITextFieldDelegate
extension KAITextField: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.kAITextFieldDidBeginEditing(textField, for: self)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.kAITextFieldDidEndEditing(textField, for: self)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return delegate?.kAITextFieldShouldReturn(textField, for: self) ?? false
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return delegate?.kAITextFieldShouldClear(textField, for: self) ?? true
    }
}
