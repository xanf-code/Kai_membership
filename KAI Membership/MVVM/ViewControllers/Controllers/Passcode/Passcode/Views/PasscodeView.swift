//
//  PasscodeView.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 27/02/2021.
//

import UIKit

protocol PasscodeViewDelegate: class {
    func passcodeViewDelegateStatusEntered(with status: PasscodeView.CodeStatus, _ passcodeView: PasscodeView)
}

class PasscodeView: UIView {
    
    // MARK: Properties
    enum CodeStatus {
        case enoughCode
        case haveNotEnoughCode
    }
    
    private let codeOneView: InputCodeView = {
        let view = InputCodeView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        view.createShadow(radius: 8)
        
        return view
    }()
    
    private let codeTwoView: InputCodeView = {
        let view = InputCodeView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.createShadow(radius: 8)
        
        return view
    }()
    
    private let codeThreeView: InputCodeView = {
        let view = InputCodeView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.createShadow(radius: 8)
        
        return view
    }()
    
    private let codeFourView: InputCodeView = {
        let view = InputCodeView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.createShadow(radius: 8)
        
        return view
    }()
    
    private lazy var containerStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.spacing = 16
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(codeBecomeFirstResponder)))
        
        return view
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.autocorrectionType = .no
        textField.keyboardType = .numberPad
        textField.inputAccessoryView = UIView(frame: .zero)
        textField.isHidden = true
        textField.delegate = self
        
        if #available(iOS 12.0, *) {
            textField.textContentType = .oneTimeCode
        } else {
            // Fallback on earlier versions
        }
        
        return textField
    }()
    
    private lazy var codeViews: [InputCodeView] = [
        codeOneView,
        codeTwoView,
        codeThreeView,
        codeFourView
    ]
    
    var code: String = ""
    var isShowed: Bool = false {
        didSet {
            guard isShowed != oldValue else { return }
            
            for codeView in codeViews {
                codeView.isCodeShowed = isShowed
            }
        }
    }
    
    weak var delegate: PasscodeViewDelegate?
    
    // MARK: Life cycle's
    override init(frame: CGRect = .zero) {
        
        super.init(frame: frame)
        
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    func setupView() {
        addSubview(textField)
        addSubview(containerStackView)
        
        containerStackView.addArrangedSubview(codeOneView)
        containerStackView.addArrangedSubview(codeTwoView)
        containerStackView.addArrangedSubview(codeThreeView)
        containerStackView.addArrangedSubview(codeFourView)
        
        containerStackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        containerStackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        containerStackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        containerStackView.heightAnchor.constraint(equalToConstant: 64).isActive = true
        codeOneView.widthAnchor.constraint(equalToConstant: 48).isActive = true
    }
    
    func inputBecomeFirstResponder() {
        textField.becomeFirstResponder()
    }
    
    private func insertCode(_ number: String) {
        code.append(number)
        
        let count = code.count
        
        guard count > 0 else { return }
        
        let index = code.index(before: code.endIndex)
        codeViews[count - 1].code = String(code[index])
    }
    
    private func deleteCode() {
        let count = code.count
        
        guard count > 0 else { return }
        
        code.removeLast()
        codeViews[count - 1].code = nil
    }
    
    func reset() {
        textField.text = nil
        code.removeAll()
        
        for codeView in codeViews {
            codeView.code = nil
        }
    }
    
    // MARK: Handle actions
    @objc private func codeBecomeFirstResponder() {
        textField.becomeFirstResponder()
    }
}

// MARK: UITextFieldDelegate
extension PasscodeView: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentString = NSString(string: textField.text ?? "")
        let newString = currentString.replacingCharacters(in: range, with: string)
        
        if newString.count == codeViews.count {
            insertCode(string)
            delegate?.passcodeViewDelegateStatusEntered(with: .enoughCode, self)
            
            return true
        } else if newString.count <= codeViews.count {
            if string.isEmpty {
                deleteCode()
            } else {
                insertCode(string)
            }
            
            delegate?.passcodeViewDelegateStatusEntered(with: .haveNotEnoughCode, self)
            
            return true
        }
        
        return false
    }
}
