//
//  InputCodeView.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 24/03/2021.
//

import UIKit

class InputCodeView: UIView {
    
    // MARK: Properties
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let codeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = .workSansFont(ofSize: 20, weight: .bold)
        label.textColor = .init(hex: "181E25")
        label.isHidden = true
        
        return label
    }()
    
    private let emptyView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = false
        view.backgroundColor = UIColor.Base.x500
        view.layer.cornerRadius = 2
        
        return view
    }()
    
    private let codeView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        view.backgroundColor = .init(hex: "181E25")
        view.layer.cornerRadius = 8
        
        return view
    }()
    
    var code: String? = nil {
        didSet {
            codeLabel.text = code
            showCode()
        }
    }
    
    var isCodeShowed: Bool = false {
        didSet {
            showCode()
        }
    }
    
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
        backgroundColor = .white
        
        addSubview(containerView)
        
        containerView.addSubview(emptyView)
        containerView.addSubview(codeLabel)
        containerView.addSubview(codeView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            emptyView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            emptyView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            emptyView.widthAnchor.constraint(equalToConstant: 16),
            emptyView.heightAnchor.constraint(equalToConstant: 4),
            
            codeLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            codeLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            codeView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            codeView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            codeView.widthAnchor.constraint(equalToConstant: 16),
            codeView.heightAnchor.constraint(equalToConstant: 16),
        ])
    }
    
    private func showCode() {
        if let code = code, !code.isEmpty {
            emptyView.isHidden = true
            
            if isCodeShowed {
                codeView.isHidden = true
                codeLabel.isHidden = false
            } else {
                codeLabel.isHidden = true
                codeView.isHidden = false
            }
        } else {
            codeLabel.isHidden = true
            codeView.isHidden = true
            emptyView.isHidden = false
        }
    }
}
