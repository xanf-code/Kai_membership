//
//  Navigator.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 19/02/2021.
//

import UIKit

final class Navigator {
    
    static weak var window: UIWindow? {
        if #available(iOS 13, *) {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let delegate = windowScene.delegate as? SceneDelegate, let window = delegate.window else { return nil }
            
            return window
        }
        
        guard let delegate = UIApplication.shared.delegate as? AppDelegate, let window = delegate.window else { return nil }
        
        return window
    }
    
    /* Hiện màn hình tương tác chính */
    class func showRootTabbarController() {
        guard let window = self.window else { return }
        
        window.rootViewController = RootTabbarController()
        UIView.transition(with: window, duration: 0.2, options: .transitionFlipFromRight, animations: nil, completion: nil)
    }
    
    /* Hiện màn hình giới thiệu */
    class func showTutorialVC() {
        guard let window = self.window else { return }
        
        let vc = TutorialViewController()
        window.rootViewController = RootNavigationController(rootViewController: vc)
        UIView.transition(with: window, duration: 0.2, options: .transitionFlipFromRight, animations: nil, completion: nil)
    }
    
    /*
     Hiện màn hình lựa chọn tài khoản sử dụng
     - parameter users: Danh sách tài khoản đã đăng nhập
     */
    class func showSelectAccountVC(_ users: [UserRemote]) {
        guard let window = self.window else { return }
        
        let vc = SelectAccountViewController(with: users)
        window.rootViewController = RootNavigationController(rootViewController: vc)
        UIView.transition(with: window, duration: 0.2, options: .transitionFlipFromRight, animations: nil, completion: nil)
    }
    
    /* Hiện màn hình đăng nhập */
    class func showSignInVC() {
        guard let window = self.window else { return }
        
        let vc = SignInViewController()
        window.rootViewController = RootNavigationController(rootViewController: vc)
        UIView.transition(with: window, duration: 0.2, options: .transitionFlipFromRight, animations: nil, completion: nil)
    }
    
    /* Điều hướng sang màn hình đăng nhập */
    class func navigateToSignInVC(from viewController: UIViewController? = nil, _ completion: (() -> Void)? = nil) {
        let vc = SignInViewController()
        vc.completion = completion
        vc.hidesBottomBarWhenPushed = true
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    /* Điều hướng sang màn hình đăng ký */
    class func navigateToSignUpVC(from viewController: UIViewController? = nil) {
        let vc = SignUpViewController()
        vc.hidesBottomBarWhenPushed = true
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    /*
     Điều hướng sang màn hình làm mới passcode
     - parameter email: Địa chỉ email
     */
    class func navigateToResetPasscodeVC(from viewController: UIViewController? = nil, with email: String) {
        let vc = ResetPasscodeViewController(with: email)
        vc.hidesBottomBarWhenPushed = true
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    /* Điều hướng sang màn hình quên mật khẩu */
    class func navigateToForgotPasswordVC(from viewController: UIViewController? = nil) {
        let vc = ForgotPasswordViewController()
        vc.hidesBottomBarWhenPushed = true
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    /*
     Điều hướng sang màn hình kiểm tra email
     - parameter email: Địa chỉ email
     */
    class func navigateToCheckMailVC(from viewController: UIViewController? = nil, with email: String) {
        let vc = CheckMailViewController(with: email)
        vc.hidesBottomBarWhenPushed = true
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    /*
     Điều hướng sang màn hình mật mã
     - parameter type: Loại hiển thị
     - parameter email: Địa chỉ email
     */
    class func navigateToPasscodeVC(from viewController: UIViewController? = nil, with type: PasscodeViewController.`Type`, email: String, _ completion: (() -> Void)? = nil) {
        let vc = PasscodeViewController(with: type, email: email)
        vc.completion = completion
        vc.hidesBottomBarWhenPushed = true
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    /*
     Điều hướng sang màn hình chúc mừng (đã đăng ký tài khoản hoăc đã cập nhật mật khẩu) thành công
     - parameter type: Loại hiển thị
     */
    class func navigateToCongratsVC(from viewController: UIViewController? = nil, with type: CongratsViewController.`Type`) {
        let vc = CongratsViewController(with: type)
        vc.hidesBottomBarWhenPushed = true
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    /*
     Hiển thị màn hình chúc mừng (đã đăng ký tài khoản hoăc đã cập nhật mật khẩu) thành công
     - parameter type: Loại hiển thị
     */
    class func showCongratsVC(from viewController: UIViewController? = nil, with type: CongratsViewController.`Type`) {
        let vc = CongratsViewController(with: type)
        vc.modalPresentationStyle = .fullScreen
        viewController?.present(vc, animated: true, completion: nil)
    }
    
    /*
     Điều hướng sang màn hình tạo mới mật khẩu
     - parameter type: Loại hiển thị
     */
    class func navigateToPasswordVC(from viewController: UIViewController? = nil, with type: PasswordViewController.`Type`) {
        let vc = PasswordViewController(with: type)
        vc.hidesBottomBarWhenPushed = true
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    /* Điều hướng sang màn hình thông tin tài khoản cá nhân */
    class func navigateToProfileVC(from viewController: UIViewController? = nil) {
        let vc = ProfileViewController()
        vc.hidesBottomBarWhenPushed = true
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    /*
     Điều hướng sang màn hình cập nhật thông tin tài khoản cá nhân
     - parameter fullName: tên đầy đủ
     - parameter birthday: ngày sinh
     - parameter phoneNumber: số điện thoại
     - parameter completion: khi update thành công
     */
    class func navigateToUpdateProfileVC(from viewController: UIViewController? = nil, fullName: String? = nil, birthday: Double? = nil, phoneNumber: String? = nil, completion: ((AccountInfoRemote) -> Void)? = nil) {
        let vc = UpdateProfileViewController(fullName: fullName, birthday: birthday, phoneNumber: phoneNumber)
        vc.completion = completion
        vc.hidesBottomBarWhenPushed = true
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    /* Điều hướng sang màn hình quà tặng cá nhân */
    class func navigateToRewardsVC(from viewController: UIViewController? = nil) {
        let vc = RewardsViewController()
        vc.hidesBottomBarWhenPushed = true
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    /* Điều hướng sang màn hình nhiệm vụ */
    class func navigateToQuestVC(from viewController: UIViewController? = nil) {
        let vc = QuestViewController()
        vc.hidesBottomBarWhenPushed = true
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    /* Điều hướng sang màn hình top up */
    class func navigateToTopupVC(from viewController: UIViewController? = nil) {
        let vc = TopupViewController()
        vc.hidesBottomBarWhenPushed = true
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    /*
     Điều hướng tới màn hình WebKit
     - parameter url: đường dẫn của trang web
     - parameter isMultipleTouchEnabled: 
     */
    class func navigateToWebKitVC(from viewController: UIViewController? = nil, url: URL, isMultipleTouchEnabled: Bool = true) {
        let vc = WebViewController(with: url, isMultipleTouchEnabled: isMultipleTouchEnabled)
        vc.modalPresentationStyle = .fullScreen
        viewController?.present(vc, animated: true, completion: nil)
    }
    
    /*
     Điều hướng tới màn hình xem tổng quát topup
     - parameter address: địa chỉ ví
     - parameter amount: giá trị
     */
    class func navigateToOverviewVC(from viewController: UIViewController? = nil, address: String, amount: Amount, completion: (() -> Void)? = nil) {
        let vc = OverviewViewController(address: address, amount: amount, completion)
        vc.hidesBottomBarWhenPushed = true
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    /*
     Điều hướng tới màn hình xem tổng quát topup
     - parameter phoneNumber: số điện thoại
     - parameter providerCode: nhà cung cấp dịch vụ
     - parameter phoneNumber: mệnh giá
     */
    class func navigateToOverviewVC(from viewController: UIViewController? = nil, phoneNumber: String, providerCode: String, amount: Amount, completion: (() -> Void)? = nil) {
        let vc = OverviewViewController(phoneNumber: phoneNumber, providerCode: providerCode, amount: amount, completion)
        vc.hidesBottomBarWhenPushed = true
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    /* Điều hướng tới màn hình Receive */
    class func navigateToReceiveVC(from viewController: UIViewController? = nil) {
        let vc = ReceiveViewController()
        let nv = RootNavigationController(rootViewController: vc)
        nv.modalPresentationStyle = .fullScreen
        viewController?.present(nv, animated: true, completion: nil)
    }
    
    /* Điều hướng tới màn hình Buy */
    class func navigateToBuyVC(from viewController: UIViewController? = nil) {
        let vc = BuyViewController()
        let nv = RootNavigationController(rootViewController: vc)
        nv.modalPresentationStyle = .fullScreen
        viewController?.present(nv, animated: true, completion: nil)
    }
    
    /* Điều hướng tới màn hình Send */
    class func navigateToSendVC(from viewController: UIViewController? = nil) {
        let vc = SendViewController()
        let nv = RootNavigationController(rootViewController: vc)
        nv.modalPresentationStyle = .fullScreen
        viewController?.present(nv, animated: true, completion: nil)
    }
    
    /* Show màn hình game vòng quay */
    class func openSpin(from viewController: UIViewController) {
        if let token = AccountManagement.accessToken {
            guard let url = URL(string: String(format: Constants.spinLink, arguments: [token, Constants.Device.languageCode, Constants.Device.id])) else { return }
            
            TrackingServices.gameSpin()
            let vc = WebViewController(with: url, isMultipleTouchEnabled: false)
            vc.modalPresentationStyle = .fullScreen
            viewController.present(vc, animated: true, completion: nil)
        } else {
            Navigator.navigateToSignInVC(from: viewController) {
                Navigator.openSpin(from: viewController)
            }
        }
    }
    
    /*
     Điều hướng tới màn hình Verification
     - parameter email: Địa chỉ email
     */
    class func navigateToVerificationVC(from viewController: UIViewController? = nil, with email: String) {
        let vc = VerificationViewController(with: email)
        vc.hidesBottomBarWhenPushed = true
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
