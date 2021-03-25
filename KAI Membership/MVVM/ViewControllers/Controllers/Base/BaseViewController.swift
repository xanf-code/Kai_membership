//
//  BaseViewController.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 24/03/2021.
//

import UIKit
import RxSwift

/*
 Note: Muốn tạo NaviagtionItem.setRightBarButtonItem thì phải sử dụng hàm setRightBarButtonItem của class
 */

class BaseViewController: UIViewController {
    
    // MARK: Properties
    private enum NavigateType {
        case root
        case child
        case present
        case push
    }
    
    private lazy var _closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.frame.size = CGSize(width: 32, height: 32)
        button.setImage(UIImage(named: "ic_delete")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        button.createShadow(radius: 8)
        button.addTarget(self, action: #selector(_onPressedClose), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var _refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        
        return refreshControl
    }()
    
    private var _navigateType: NavigateType = .child
    
    let statusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.height
    
    var navigationBarHeight: CGFloat {
        return self.navigationController?.navigationBar.frame.height ?? 0
    }
    
    var tabbarHeight: CGFloat {
        return self.tabBarController?.tabBar.frame.height ?? 0
    }
    
    var statusBarStyle: UIStatusBarStyle = .default {
        didSet {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    var marginDefault: CGFloat {
        return 20
    }
    
    //    var isHiddenNavigationBar: Bool {
    //        return false
    //    }
    
    var navigationAlphaDefault: CGFloat {
        return 1
    }
    
    var backroundColorDefault: UIColor {
        return Constants.backroundColorDefault
    }
    
    private lazy var navigationAlpha: CGFloat = navigationAlphaDefault
    
    lazy var disposeBag = DisposeBag()
    
    var scroller: UIScrollView? {
        return nil
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }
    
    override func loadView() {
        super.loadView()
        
        if isBeingPresented {
            _navigateType = .present
        } else {
            if let navigationController = self.navigationController {
                if navigationController.isBeingPresented {
                    _navigateType = .present
                    navigationItem.setRightBarButton(UIBarButtonItem(customView: _closeButton), animated: true)
                } else {
                    if navigationController.viewControllers.last === self {
                        if navigationController.viewControllers.count < 2 {
                            _navigateType = .root
                        } else {
                            _navigateType = .push
                        }
                    } else {
                        _navigateType = .child
                    }
                }
            } else {
                _navigateType = .child
            }
        }
    }
    
    // MARK: Life cycle's
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = backroundColorDefault
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        if let scrollView = scroller {
            scrollView.addSubview(_refreshControl)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationBarAnimation(withAlpha: navigationAlpha, backgroundColor: backroundColorDefault)
    }
    
    // MARK: Layout
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if isBeingDismissed || isMovingFromParent {
            NotificationCenter.default.removeObserver(self)
        }
    }
    
    deinit {
        debugPrint("Deinit \(identifier)")
    }
    
    // MARK: Methods
    func navigationBarAnimation(withAlpha alpha: CGFloat, backgroundColor: UIColor = .white) {
        navigationAlpha = alpha
        (navigationController as? RootNavigationController)?.setBackgroundColor(backgroundColor.withAlphaComponent(alpha))
    }
    
    func setRightBarButtonItem(_ item: UIBarButtonItem) {
        var newItems: [UIBarButtonItem] = [UIBarButtonItem(customView: _closeButton)]
        newItems.append(item)
        navigationItem.setRightBarButtonItems(newItems, animated: true)
    }
    
    func setRightBarButtonItems(_ items: [UIBarButtonItem]) {
        var newItems: [UIBarButtonItem] = [UIBarButtonItem(customView: _closeButton)]
        newItems.append(contentsOf: items)
        navigationItem.setRightBarButtonItems(newItems, animated: true)
    }
    
    func endRefreshing() {
        _refreshControl.endRefreshing()
    }
    
    // MARK: Handle actions
    @objc private func _onPressedClose() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func refresh(_ sender: UIRefreshControl) {
        // Code to refresh table view
    }
}
