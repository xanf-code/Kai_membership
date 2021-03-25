//
//  QuestViewController+Delegate.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 05/03/2021.
//

import UIKit

// MARK: KAIBarButtonItemViewDelegate
extension QuestViewController: KAIBarButtonItemViewDelegate {
    
    func kAIBarButtonItemViewDidSelecteSpin(_ kAIBarButtonItemView: KAIBarButtonItemView) {
        Navigator.openSpin(from: self)
    }
    
    func kAIBarButtonItemViewDidSelecteProfile(_ kAIBarButtonItemView: KAIBarButtonItemView) {
        if AccountManagement.isLoggedIn {
            Navigator.navigateToProfileVC(from: self)
        } else {
            Navigator.navigateToSignInVC(from: self) { [weak self] in
                guard let this = self else { return }
                
                kAIBarButtonItemView.refresh()
                Navigator.navigateToProfileVC(from: this)
            }
        }
    }
}

// MARK: NestedScrollDelegate
extension QuestViewController: NestedScrollDelegate {
    
    func selectedIndexChanged(for pagerTabPageController: NestedScrollViewController, previousIndex: Int, currentIndex: Int) {
        headerView.segmentView.selectedSegmentIndex = currentIndex
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView, didUpdate: NestedScrollViewController.ScrollType) {
//        switch didUpdate {
//        case .parent:
//
//        case .child:
//
//        }
        
        let y: CGFloat = scrollView.contentOffset.y
        
        if y <= 0 {
            headerView.zoomImage(with: y)
//            navigationBarAnimation(withAlpha: 0)
        } else {
            /*let headerHeight: CGFloat = safeAreaInsets.top + navigationBarHeight
            let tmp = y / headerHeight
            let alpha = y > headerHeight || tmp >= 1 ? 1 : tmp
            navigationBarAnimation(withAlpha: alpha)*/
        }
    }
    
    func scrollViewDidLoad(_ scrollView: UIScrollView) {
        /*refresh.tintColor = .black
        refresh.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
        let refreshView = UIView(frame: CGRect(x: 0, y: Constants.Values.NavigationHeight, width: 0, height: 0))
        scrollView.addSubview(refreshView)
        refreshView.addSubview(refresh)
        self.scrollView = scrollView*/
    }
}
