//
//  TopupViewController.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 04/03/2021.
//

import UIKit

class TopupViewController: BaseViewController {

    // MARK: Properties
    enum Section: Int, CaseIterable {
        case info
        case setting
    }
    
    let viewModel = TopupViewModel()
    
    private(set) lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0.01, height: 0.01))
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0.01, height: 0.01))
        tableView.backgroundColor = Constants.backroundColorDefault
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInset = .init(top: 0, left: 0, bottom: safeAreaInsets.bottom, right: 0)
        tableView.register(CardCollapseTableViewCell.self, forCellReuseIdentifier: CardCollapseTableViewCell.identifier)
        tableView.register(TopupTableViewCell.self, forCellReuseIdentifier: TopupTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        
        return tableView
    }()
    
    private lazy var continueButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setAttributedTitle(NSAttributedString(string: "Continue", attributes: [
            NSAttributedString.Key.font: UIFont.workSansFont(ofSize: 16, weight: .medium),
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]), for: .normal)
        button.isEnabled = false
        button.backgroundColor = .init(hex: "E1E4E8")
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(onPressedTopup), for: .touchUpInside)
        
        return button
    }()
    
    private var continueButtonBottomAnchor: NSLayoutConstraint?
    
    var isConfirmEnabled: Bool = false {
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
    
    // MARK: Life cycle's
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        navigationItem.title = "Top-up"
        setupView()
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.handleSingleTap(_:)))
        singleTap.numberOfTapsRequired = 1
        singleTap.cancelsTouchesInView = true
        singleTap.delegate = self
        tableView.addGestureRecognizer(singleTap)
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
            continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            continueButton.heightAnchor.constraint(equalToConstant: 52),
        ])
        
        continueButtonBottomAnchor = continueButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(safeAreaInsets.bottom + 20))
        continueButtonBottomAnchor?.isActive = true
    }
}

// MARK: Handle actions
extension TopupViewController {
    
    @objc private func handleSingleTap(_ recognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc private func onPressedTopup() {
        guard viewModel.phoneNumber.isPhoneNumber else {
            if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: Section.setting.rawValue)) as? TopupTableViewCell {
                cell.inputPhoneNumberView.setMessage("🤔 Phone number invalid!")
            } else {
                AlertManagement.shared.showToast(with: "🤔 Phone number invalid!", position: .top)
            }
            
            return
        }
        
        view.endEditing(true)
        Navigator.navigateToOverviewVC(from: self, phoneNumber: viewModel.phoneNumber, providerCode: viewModel.serviceProviders[viewModel.serviceProviderIndex].value, amount: viewModel.amount) { [weak self] in
            guard let self = self else { return }
            
            TrackingManagement.topupMobileSuccessfully(userID: AccountManagement.accountID)
            AlertManagement.shared.showBulletin(with: "Success", image: "👏".toImage(with: CGSize(width: 104, height: 104), font: UIFont.workSansFont(ofSize: 64, weight: .extraBold)), descriptionText: "Happy Trading!", fromController: self, isDismissable: false, primaryButtonTitle: "Back to Utilities", primaryHandler: { [weak self] (item) in
                self?.dismiss(animated: true, completion: nil)
            })
        }
    }
    
    @objc private func handleKeyboardNotification(_ notification: NSNotification) {
        if notification.name == UIResponder.keyboardWillShowNotification {
            guard let userInfo = notification.userInfo, let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
            
            continueButtonBottomAnchor?.constant = -(keyboardFrame.height + 20)
        } else {
            continueButtonBottomAnchor?.constant = -(safeAreaInsets.bottom + 20)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}
