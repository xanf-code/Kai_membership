//
//  OverviewViewController.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 04/03/2021.
//

import UIKit
import RxSwift
import RNLoadingButton_Swift

class OverviewViewController: BaseViewController {
    
    // MARK: Properties
    enum `Type` {
        case topup
        case send
    }
    
    enum Section: Int, CaseIterable {
        case title
        case info
    }
    
    let viewModel: OverviewViewModel
    
    let type: `Type`
    
    private(set) lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0.01, height: 0.01))
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0.01, height: 0.01))
        tableView.backgroundColor = Constants.backroundColorDefault
        tableView.contentInset = .init(top: 0, left: 0, bottom: safeAreaInsets.bottom, right: 0)
        tableView.register(CardCollapseTableViewCell.self, forCellReuseIdentifier: CardCollapseTableViewCell.identifier)
        tableView.register(OverviewTopupTableViewCell.self, forCellReuseIdentifier: OverviewTopupTableViewCell.identifier)
        tableView.register(OverviewSendTableViewCell.self, forCellReuseIdentifier: OverviewSendTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        
        return tableView
    }()
    
    private lazy var continueButton: RNLoadingButton = {
        let button = RNLoadingButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = true
        button.backgroundColor = .init(hex: "E1E4E8")
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 8
        button.activityIndicatorAlignment = RNActivityIndicatorAlignment.left
        button.activityIndicatorEdgeInsets.left = 16
        button.hideTextWhenLoading = false
        button.isLoading = false
        button.activityIndicatorColor = .black
        button.addTarget(self, action: #selector(onPressedTopup), for: .touchUpInside)
        
        return button
    }()
    
    var isConfirmEnabled: Bool = true {
        didSet {
            guard isConfirmEnabled != oldValue else { return }
            
            continueButton.isEnabled = isConfirmEnabled
            
            if isConfirmEnabled {
                continueButton.gradientBackgroundColors([UIColor.init(hex: "394656").cgColor, UIColor.init(hex: "181E25").cgColor], direction: .vertical)
            } else {
                continueButton.removeAllSublayers(withName: UIView.gradientLayerKey)
            }
        }
    }
    
    private let completion: (() -> Void)?
    
    // MARK: Life cycle's
    init(address: String, amount: Amount, _ completion: (() -> Void)? = nil) {
        self.type = .send
        self.completion = completion
        self.viewModel = OverviewViewModel(address: address, amount: amount)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    init(phoneNumber: String, providerCode: String, amount: Amount, _ completion: (() -> Void)? = nil) {
        self.type = .topup
        self.completion = completion
        self.viewModel = OverviewViewModel(phoneNumber: phoneNumber, providerCode: providerCode, amount: amount)
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Overview"
        setupView()
        
        viewModel.showLoading.asObservable().observe(on: MainScheduler.instance).subscribe { [weak self] isLoading in
            guard let this = self else { return }
            
            this.isConfirmEnabled = !(isLoading.element ?? false)
            this.continueButton.isLoading = isLoading.element ?? false
        }.disposed(by: disposeBag)
    }
    
    // MARK: Layout
    private func setupView() {
        view.addSubview(tableView)
        view.addSubview(continueButton)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            continueButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 8),
            continueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            continueButton.heightAnchor.constraint(equalToConstant: 52),
        ])
        
        switch type {
        case .topup:
            continueButton.setAttributedTitle(NSAttributedString(string: "Continue", attributes: [
                NSAttributedString.Key.font: UIFont.workSansFont(ofSize: 16, weight: .medium),
                NSAttributedString.Key.foregroundColor: UIColor.white
            ]), for: .normal)
        case .send:
            continueButton.setAttributedTitle(NSAttributedString(string: "Send Now", attributes: [
                NSAttributedString.Key.font: UIFont.workSansFont(ofSize: 16, weight: .medium),
                NSAttributedString.Key.foregroundColor: UIColor.white
            ]), for: .normal)
        }
        
        DispatchQueue.main.async {
            self.continueButton.gradientBackgroundColors([UIColor.init(hex: "394656").cgColor, UIColor.init(hex: "181E25").cgColor], direction: .vertical)
        }
    }
    
    // MARK: Handle actions
    @objc private func onPressedTopup() {
        switch type {
        case .topup:
            viewModel.createTopup().subscribe(on: MainScheduler.instance).subscribe(onNext: { [weak self] in
                self?.completion?()
            }, onError: { [weak self] error in
                guard let this = self else { return }
                
                AlertManagement.shared.showBulletin(with: "Fail?", image: "🤔".toImage(with: CGSize(width: 104, height: 104), font: UIFont.workSansFont(ofSize: 64, weight: .extraBold)), descriptionText: "Maybe the provider service is wrong. Check your inputed phone number also.", fromController: this, primaryButtonTitle: "Check again")
            }).disposed(by: disposeBag)
        case .send:
            viewModel.createSend().subscribe(on: MainScheduler.instance).subscribe(onNext: { [weak self] in
                self?.completion?()
            }, onError: { [weak self] error in
                guard let this = self else { return }
                
                AlertManagement.shared.showBulletin(with: "Fail?", image: "🙄".toImage(with: CGSize(width: 104, height: 104), font: UIFont.workSansFont(ofSize: 64, weight: .extraBold)), descriptionText: "Maybe the address is wrong somehow... Or you don't have enough $KAI.. Check both!", fromController: this, primaryButtonTitle: "Check again")
            }).disposed(by: disposeBag)
        }
    }
}
