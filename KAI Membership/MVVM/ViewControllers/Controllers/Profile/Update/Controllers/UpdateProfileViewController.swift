//
//  UpdateProfileViewController.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 10/03/2021.
//

import UIKit
import RxSwift
import RNLoadingButton_Swift

class UpdateProfileViewController: BaseViewController {
    
    // MARK: Properties
    let viewModel: UpdateProfileViewModel
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.showsVerticalScrollIndicator = false
        
        return scrollView
    }()
    
    private(set) lazy var inputFullNameView: KAIInputTextFieldView = {
        let view = KAIInputTextFieldView(with: .default, title: "FULL NAME", placeholder: "Full Name")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        
        return view
    }()
    
    private let inputDOBLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = .workSansFont(ofSize: 10, weight: .medium)
        label.textColor = .init(hex: "364766")
        label.text = "DATE OF BIRTH"
        
        return label
    }()
    
    private lazy var inputCalendarPicker: KAIInputCalendarPicker = {
        let view = KAIInputCalendarPicker(baseTimeInterval: viewModel.birthday) { [weak self] date in
            guard let this = self else { return }
            
            this.viewModel.birthday = date.timeIntervalSince1970
            this.isConfirmEnabled = this.viewModel.hasChanged
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private(set) lazy var inputPhoneNumberView: KAIInputTextFieldView = {
        let view = KAIInputTextFieldView(with: .default, title: "PHONE NO.", placeholder: "e.g 0903509786", keyboardType: .phonePad)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        
        return view
    }()
    
    private lazy var updateButton: RNLoadingButton = {
        let button = RNLoadingButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setAttributedTitle(NSAttributedString(string: "Update Profile", attributes: [
            NSAttributedString.Key.font: UIFont.workSansFont(ofSize: 16, weight: .medium),
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]), for: .normal)
        button.isEnabled = false
        button.backgroundColor = .init(hex: "E1E4E8")
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 8
        button.activityIndicatorAlignment = RNActivityIndicatorAlignment.left
        button.activityIndicatorEdgeInsets.left = 16
        button.hideTextWhenLoading = false
        button.isLoading = false
        button.activityIndicatorColor = .black
        button.addTarget(self, action: #selector(onPressedUpdateProfile), for: .touchUpInside)
        
        return button
    }()
    
    private var updateButtonBottomAnchor: NSLayoutConstraint?
    
    var isConfirmEnabled: Bool = false {
        didSet {
            guard isConfirmEnabled != oldValue else { return }
            
            updateButton.isEnabled = isConfirmEnabled
            
            if isConfirmEnabled {
                updateButton.gradientBackgroundColors([UIColor.init(hex: "394656").cgColor, UIColor.init(hex: "181E25").cgColor], direction: .vertical)
            } else {
                updateButton.removeAllSublayers(withName: UIView.gradientLayerKey)
            }
        }
    }
    
    var datePicker = UIDatePicker()
    var completion: ((AccountInfoRemote) -> Void)?
    
    var isLoading: Bool = false {
        didSet {
            guard isLoading != oldValue else { return }
            
            isConfirmEnabled = !isLoading
            updateButton.isLoading = isLoading
        }
    }
    
    // MARK: Life cycle's
    init(fullName: String? = nil, birthday: Double? = nil, phoneNumber: String? = nil) {
        self.viewModel = UpdateProfileViewModel(fullName: fullName, birthday: birthday, phoneNumber: phoneNumber)
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "My Profile"
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        setupView()
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.handleSingleTap(_:)))
        singleTap.numberOfTapsRequired = 1
        singleTap.cancelsTouchesInView = true
        scrollView.addGestureRecognizer(singleTap)
    }
    
    // MARK: Layout
    private func setupView() {
        view.addSubview(scrollView)
        view.addSubview(updateButton)
        
        scrollView.addSubview(inputFullNameView)
        scrollView.addSubview(inputDOBLabel)
        scrollView.addSubview(inputCalendarPicker)
        scrollView.addSubview(inputPhoneNumberView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            updateButton.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 8),
            updateButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            updateButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            updateButton.heightAnchor.constraint(equalToConstant: 52),
            
            inputFullNameView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            inputFullNameView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            inputFullNameView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            inputFullNameView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40),
            
            inputDOBLabel.topAnchor.constraint(equalTo: inputFullNameView.bottomAnchor, constant: 12),
            inputDOBLabel.leadingAnchor.constraint(equalTo: inputFullNameView.leadingAnchor),
            inputDOBLabel.trailingAnchor.constraint(equalTo: inputFullNameView.trailingAnchor),
            
            inputCalendarPicker.topAnchor.constraint(equalTo: inputDOBLabel.bottomAnchor, constant: 4),
            inputCalendarPicker.leadingAnchor.constraint(equalTo: inputFullNameView.leadingAnchor),
            inputCalendarPicker.trailingAnchor.constraint(equalTo: inputFullNameView.trailingAnchor),
            inputCalendarPicker.heightAnchor.constraint(equalToConstant: 44),
            
            inputPhoneNumberView.topAnchor.constraint(equalTo: inputCalendarPicker.bottomAnchor, constant: 12),
            inputPhoneNumberView.leadingAnchor.constraint(equalTo: inputFullNameView.leadingAnchor),
            inputPhoneNumberView.bottomAnchor.constraint(greaterThanOrEqualTo: scrollView.bottomAnchor),
            inputPhoneNumberView.trailingAnchor.constraint(equalTo: inputFullNameView.trailingAnchor),
        ])
        
        updateButtonBottomAnchor = updateButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(safeAreaInsets.bottom + 20))
        updateButtonBottomAnchor?.isActive = true
        
        configure()
    }
    
    // MARK: Methods
    private func configure() {
        inputFullNameView.setText(viewModel.fullName)
        inputPhoneNumberView.setText(viewModel.phoneNumber)
    }
}

// MARK: Handle actions
extension UpdateProfileViewController {
    
    @objc private func handleKeyboardNotification(_ notification: NSNotification) {
        if notification.name == UIResponder.keyboardWillShowNotification {
            guard let userInfo = notification.userInfo, let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
            
            updateButtonBottomAnchor?.constant = -(keyboardFrame.height + 20)
        } else {
            updateButtonBottomAnchor?.constant = -(safeAreaInsets.bottom + 20)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func onPressedUpdateProfile() {
        guard inputPhoneNumberView.contentInput.isPhoneNumber else {
            inputPhoneNumberView.setMessage("🤔 Phone number invalid!")
            return
        }
        
        Navigator.navigateToPasscodeVC(from: self, with: .updateProfile, email: AccountManagement.email) { [weak self] in
            guard let this = self else { return }
            
            this.isLoading = true
            this.viewModel.udpateProfile().subscribe(on: MainScheduler.instance).subscribe(onNext: { [weak self] accountInfo in
                guard let this = self else { return }
                
                if let profileVC = this.navigationController?.viewControllers.first(where: { $0 is ProfileViewController }) {
                    this.completion?(accountInfo)
                    this.navigationController?.popToViewController(profileVC, animated: true)
                } else {
                    this.navigationController?.popToRootViewController(animated: true)
                }
                
                AlertManagement.shared.showToast(with: "👍 Update successfully!", position: .top)
            }, onError: { [weak self] error in
                self?.navigationController?.popViewController(animated: true)
                self?.isLoading = false
                AlertManagement.shared.showToast(with: "🤔 Update failure!", position: .top)
            }).disposed(by: this.disposeBag)
        }
    }
    
    @objc private func handleSingleTap(_ recognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}
