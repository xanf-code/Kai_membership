//
//  AlertManager.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 17/03/2021.
//

import Foundation
import BLTNBoard
import Toast_Swift

class AlertManagement {
    
    static let shared = AlertManagement()
    
    private lazy var bulletin: BLTNItemManager? = {
            let rootItem = BLTNItem()
            return BLTNItemManager(rootItem: rootItem)
        }()
    
    func showBulletin(with title: String, image: UIImage?, descriptionText: String?, fromController: UIViewController, isDismissable: Bool = true, primaryButtonTitle: String? = nil, primaryHandler: ((BLTNActionItem) -> Void)? = nil, secondaryButtonTitle: String? = nil, secondaryHandler: ((BLTNActionItem) -> Void)? = nil) {
        
        let bulletinItem = BLTNPageItem(title: title)
        
        bulletinItem.image = image
        bulletinItem.imageView?.contentMode = .scaleAspectFit

        bulletinItem.descriptionText = descriptionText
        bulletinItem.requiresCloseButton = false
        bulletinItem.isDismissable = isDismissable
        
        bulletinItem.actionButtonTitle = primaryButtonTitle
        bulletinItem.actionHandler = { [weak self] item in
            self?.bulletin?.dismissBulletin(animated: true)
            primaryHandler?(item)
            self?.bulletin = nil
        }
        
        bulletinItem.alternativeButtonTitle = secondaryButtonTitle
        bulletinItem.alternativeHandler = secondaryHandler
        
        bulletinItem.appearance.titleTextColor = UIColor.init(hex: "000000").withAlphaComponent(0.87)
        bulletinItem.appearance.titleFontSize = 28
        bulletinItem.appearance.titleFont = UIFont.workSansFont(ofSize: 28, weight: .semiBold)
        
        bulletinItem.appearance.descriptionTextColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.54)
        bulletinItem.appearance.descriptionFontSize = 14
        bulletinItem.appearance.descriptionFont = UIFont.workSansFont(ofSize: 14, weight: .medium)
        
        bulletinItem.appearance.actionButtonTitleColor = .white
        bulletinItem.appearance.actionButtonColor = UIColor.init(hex: "181E25")
        bulletinItem.appearance.actionButtonFontSize = 16
        bulletinItem.appearance.actionButtonCornerRadius = 8
        bulletinItem.appearance.buttonFont = UIFont.workSansFont(ofSize: 16, weight: .medium)
        
        bulletinItem.appearance.alternativeButtonTitleColor = UIColor.init(hex: "000000").withAlphaComponent(0.87)
        bulletinItem.appearance.alternativeButtonBorderColor = UIColor.init(hex: "C9CED6")
        bulletinItem.appearance.alternativeButtonBorderWidth = 1
        bulletinItem.appearance.alternativeButtonFontSize = 16
        bulletinItem.appearance.alternativeButtonCornerRadius = 8
        
        
        bulletin = BLTNItemManager(rootItem: bulletinItem)
        bulletin?.cardCornerRadius = 12
        bulletin?.backgroundColor = .white
        bulletin?.backgroundViewStyle = .blurredDark
        
        bulletin?.showBulletin(above: fromController, animated: true, completion: nil)
    }
    
    func showToast(with text: String, textColor: UIColor? = nil, backgroundColor: UIColor? = nil, position: ToastPosition = ToastManager.shared.position, from controller: UIViewController? = nil) {
        var style = ToastStyle()
        style.titleFont = UIFont.workSansFont(ofSize: 12, weight: .medium)
        style.messageColor = textColor ?? .black
        style.backgroundColor = backgroundColor ?? .white
        
        if let viewcontroller = controller {
            viewcontroller.view.makeToast(text, duration: 2.0, position: position, style: style)
        } else {
            Navigator.window?.makeToast(text, duration: 2.0, position: position, style: style)
        }
    }
}
