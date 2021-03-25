//
//  ReceiveViewController.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 16/03/2021.
//

import UIKit
import QRCode
import Toast_Swift

class ReceiveViewController: BaseViewController {
    
    // MARK: Properties
    private let qrCodeContainerView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 24
        view.createShadow(radius: 24, color: UIColor.black.withAlphaComponent(0.1), direction: .bottom)
        
        return view
    }()
    
    private let qrCodeImageView : UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        
        return view
    }()
    
    private let qrCodeTitleLabel : UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.workSansFont(ofSize: 10, weight: .medium)
        view.textColor = UIColor.init(hex: "364766")
        
        return view
    }()
    
    private let qrCodeValueLabel : UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.workSansFont(ofSize: 10, weight: .medium)
        view.textColor = UIColor.init(hex: "000000").withAlphaComponent(0.54)
        view.numberOfLines = 0
        
        return view
    }()
    
    private let qrCodeCopyButton : UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setImage(UIImage(named: "ic_copy"), for: .normal)
        
        return view
    }()
    
//    private let buttonContainerView : UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.layer.cornerRadius = 20
//        view.backgroundColor = .white
//        view.createShadow(radius: 20, color: UIColor.black.withAlphaComponent(0.1), direction: .bottom)
//
//        return view
//    }()
//
//    private let setAmountButton : UIButton = {
//        let view = UIButton()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.setImage(UIImage(named: "ic_set_amount"), for: .normal)
//        view.setTitle("Set amount", for: .normal)
//        view.setTitleColor(UIColor(red: 0.788, green: 0.808, blue: 0.839, alpha: 1), for: .normal)
//        view.titleLabel?.font = UIFont.workSansFont(ofSize: 12, weight: .medium)
//
//        return view
//    }()
//
//    private let shareButton : UIButton = {
//        let view = UIButton()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.setImage(UIImage(named: "ic_share_arrow")?.withRenderingMode(.alwaysTemplate), for: .normal)
//        view.tintColor = UIColor.init(hex: "8A94A6")
//        view.setTitle("Share", for: .normal)
//        view.setTitleColor(UIColor(red: 0.788, green: 0.808, blue: 0.839, alpha: 1), for: .normal)
//        view.titleLabel?.font = UIFont.workSansFont(ofSize: 12, weight: .medium)
//
//        return view
//    }()
//
//    private let separatorLine : UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = UIColor(red: 0.788, green: 0.808, blue: 0.839, alpha: 1)
//
//        return view
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Receive"
        visualize()
        bind()
        addTargets()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
//        setAmountButton.centerVertically()
//        shareButton.centerVertically()
    }
}

// MARK: Layout
extension ReceiveViewController {
    
    private func visualize() {
        view.addSubview(qrCodeContainerView)
//        view.addSubview(buttonContainerView)
        
        qrCodeContainerView.addSubview(qrCodeImageView)
        qrCodeContainerView.addSubview(qrCodeTitleLabel)
        qrCodeContainerView.addSubview(qrCodeValueLabel)
        qrCodeContainerView.addSubview(qrCodeCopyButton)
//
//        buttonContainerView.addSubview(setAmountButton)
//        buttonContainerView.addSubview(shareButton)
//        buttonContainerView.addSubview(separatorLine)
        
        let views = [
            "qrCodeContainer" : qrCodeContainerView,
//            "buttonContainer" : buttonContainerView,
            "qrCodeImage" : qrCodeImageView,
            "qrCodeTitle" : qrCodeTitleLabel,
            "qrCodeValue" : qrCodeValueLabel,
            "qrCodeCopy" : qrCodeCopyButton
//            "setAmount" : setAmountButton,
//            "share" : shareButton,
//            "separator" : separatorLine
        ]
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(top)-[qrCodeContainer]-(>=8@999)-|", options: [], metrics: ["top": safeAreaInsets.top + navigationBarHeight + 64], views: views))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-55-[qrCodeContainer]-55-|", options: [], metrics: nil, views: views))
//        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-55-[buttonContainer]-55-|", options: [], metrics: nil, views: views))
        
        qrCodeContainerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-36-[qrCodeImage]-16-[qrCodeTitle]-1-[qrCodeValue]-16-|", options: [], metrics: nil, views: views))
        qrCodeContainerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-36-[qrCodeImage]-36-|", options: [], metrics: nil, views: views))
        qrCodeContainerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-36-[qrCodeTitle]-36-|", options: [], metrics: nil, views: views))
        qrCodeContainerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-36-[qrCodeValue]-(>=8@999)-[qrCodeCopy(32)]-36-|", options: [.alignAllCenterY], metrics: nil, views: views))
        
        qrCodeContainerView.addConstraint(NSLayoutConstraint(item: qrCodeImageView, attribute: .width, relatedBy: .equal, toItem: qrCodeImageView, attribute: .height, multiplier: 1.0, constant: 0.0))
        qrCodeContainerView.addConstraint(NSLayoutConstraint(item: qrCodeCopyButton, attribute: .width, relatedBy: .equal, toItem: qrCodeCopyButton, attribute: .height, multiplier: 1.0, constant: 0.0))
        
//        buttonContainerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[setAmount(58)]-4-|", options: [], metrics: nil, views: views))
//        buttonContainerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[share(58)]-4-|", options: [], metrics: nil, views: views))
//        buttonContainerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[separator]-10-|", options: [], metrics: nil, views: views))
//
//        buttonContainerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-12-[setAmount]-0-[separator(1)]-0-[share]-12-|", options: [], metrics: nil, views: views))
//        buttonContainerView.addConstraint(NSLayoutConstraint(item: setAmountButton, attribute: .width, relatedBy: .equal, toItem: shareButton, attribute: .width, multiplier: 1.0, constant: 0.0))
    }
    
    private func bind() {
        guard let address = AccountManagement.accountInfo?.kai?.wallet?.address else { return }
        
        let qrCode = QRCode(address)
        qrCodeImageView.image = qrCode?.image
        
        qrCodeTitleLabel.text = "My Address"
        qrCodeValueLabel.text = address
    }
    
    private func addTargets() {
//        setAmountButton.addTarget(self, action: #selector(tapSetAmountButton), for: .touchUpInside)
//        shareButton.addTarget(self, action: #selector(tapShareButton), for: .touchUpInside)
        qrCodeCopyButton.addTarget(self, action: #selector(tapCopyButton), for: .touchUpInside)
    }
    
    @objc private func tapSetAmountButton() {
        
    }
    
    @objc private func tapShareButton() {
        
    }
    
    @objc private func tapCopyButton() {
        // TODO: show toast here
        AlertManagement.shared.showToast(with: "Copied!", from: self)
    }
}
