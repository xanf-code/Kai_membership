//
//  MainViewController.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 03/03/2021.
//

import UIKit
import RxSwift

class MainViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    let viewModel = MainViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    // MARK: Life cycle's
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            if overrideUserInterfaceStyle == .dark {
                imageView.image = UIImage(named: "launch_screen_white")
                activityIndicatorView.color = .white
            } else {
                imageView.image = UIImage(named: "launch_screen")
                activityIndicatorView.color = .black
            }
        } else {
            imageView.image = UIImage(named: "launch_screen")
            activityIndicatorView.color = .black
        }
        
        fetchData()
    }
    
    // MARK: Fetch data
    private func fetchData() {
        viewModel.getData().subscribe(on: MainScheduler.instance).subscribe { [weak self] configs, device in
            if let device = device, !device.users.isEmpty {
                Navigator.showSelectAccountVC(device.users)
                KeyChain.deleteAll()
                AppSetting.haveUsedTheApplicationOnce = true
            } else {
                self?.showSignInApp()
            }
        } onError: { [weak self] error in
            self?.showSignInApp()
        }.disposed(by: disposeBag)
    }
    
    private func showSignInApp() {
        if AppSetting.haveUsedTheApplicationOnce {
            Navigator.showSignInVC()
        } else {
            Navigator.showTutorialVC()
            KeyChain.deleteAll()
            AppSetting.haveUsedTheApplicationOnce = true
        }
    }
}
