//
//  ProfileViewController.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 08/03/2021.
//

import UIKit
import RxSwift
import MobileCoreServices

class ProfileViewController: BaseViewController {
    
    // MARK: Properties
    enum Section: Int, CaseIterable {
        case personal = 0
        case others
    }
    
    enum PersonalItem: Int, CaseIterable {
        case profile = 0
        case rewards
        case changePassword
    }
    
    enum OthersItem: Int, CaseIterable {
        case switchAccount = 0
        case signOut
    }
    
    let viewModel = ProfileViewModel()
    
    private lazy var cameraButton: UIButton = {
        let button = UIButton(type: .system)
        button.frame.size = CGSize(width: 32, height: 32)
        button.setImage(UIImage(named: "ic_camera")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        button.createShadow(radius: 8)
        button.addTarget(self, action: #selector(onPressedCamera), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = Constants.backroundColorDefault
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: ProfileTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        
        return tableView
    }()
    
    private let versionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = UIColor.init(hex: "98A1B1")
        label.font = .workSansFont(ofSize: 10, weight: .medium)
        label.text = "KArdiachain © 2020 - Version \(Constants.appVersion)"
        
        return label
    }()
    
    private(set) lazy var headerView: ProfileHeaderView = {
        let view = ProfileHeaderView()
        view.configure(AccountManagement.accountInfo)
        view.didFinishTouchingShared = { [weak self] in
            self?.share()
        }
        
        return view
    }()
    
    override var navigationAlphaDefault: CGFloat {
        return 0
    }
    
    // MARK: Life cycle's
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.setRightBarButton(UIBarButtonItem(customView: cameraButton), animated: true)
        setupView()
        setupTableHeaderView()
        fetchData()
    }
    
    // MARK: Layout
    private func setupView() {
        view.addSubview(tableView)
        view.addSubview(versionLabel)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            versionLabel.topAnchor.constraint(equalTo: tableView.bottomAnchor),
            versionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            versionLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            versionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            versionLabel.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    private func setupTableHeaderView() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: Constants.Device.screenBounds.width, height: 361))
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 337)
        view.addSubview(headerView)
        
        tableView.tableHeaderView = view
    }
    
    // MARK: Data fetching
    func fetchData() {
        viewModel.getUserInfo().subscribe(on: MainScheduler.instance).subscribe(onNext: { [weak self] user in
            guard let this = self else { return }
            
            this.headerView.configure(user)
            this.tableView.reloadData()
        }, onError: { error in
            debugPrint("Get user errror: \((error as? APIErrorResult)?.message ?? "ERROR")")
        }).disposed(by: disposeBag)
    }
    
    func fetchAccountsLoggedIntoDevice() {
        viewModel.getAccountsLoggedIntoDevice().subscribe(on: MainScheduler.instance).subscribe { device in
            if let device = device, !device.users.isEmpty {
                Navigator.showSelectAccountVC(device.users)
            } else {
                Navigator.showSignInVC()
            }
        } onError: { error in
            debugPrint("Get accounts logged into device error: \((error as? APIErrorResult)?.message ?? "ERROR")")
            Navigator.showSignInVC()
        }.disposed(by: disposeBag)
    }
    
    // MARK: Methods
    func changeAvatar(_ image: UIImage? = nil) {
        let alertC = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertC.addAction(UIAlertAction(title: "New photo", style: .default, handler: { [weak self] action in
            guard let this = self else { return }
            
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .camera
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.delegate = self
            imagePicker.navigationBar.tintColor = UIColor.blue
            imagePicker.modalPresentationStyle = .fullScreen
            
            this.present(imagePicker, animated: true, completion: nil)
        }))
        alertC.addAction(UIAlertAction(title: "Choose picture from library", style: .default, handler: { [weak self] action in
            guard let this = self else { return }
            
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.delegate = self
            imagePicker.navigationItem.rightBarButtonItem?.title = "Exit"
            UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)], for: UIControl.State())
            imagePicker.modalPresentationStyle = .fullScreen
            
            this.present(imagePicker, animated: true, completion: nil)
        }))
        alertC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alertC, animated: true, completion: nil)
    }
    
    func uploadImage(_ image: UIImage) {
        viewModel.updateAvatar(image).subscribe(on: MainScheduler.instance).subscribe {
            AlertManagement.shared.showToast(with: "👍 Update avatar successfully!", position: .top)
        } onError: { error in
            AlertManagement.shared.showToast(with: "🤔 Update avatar failure!", position: .top)
        }.disposed(by: disposeBag)
    }
    
    private func share() {
        let items = [AccountManagement.accountInfo?.user?.refarralAppflyerLink ?? ""]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true)
    }
    
    // MARK: Handle actions
    @objc private func onPressedCamera() {
        changeAvatar()
    }
}
