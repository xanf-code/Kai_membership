//
//  NestedScrollViewController+Protocol.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 04/03/2021.
//

import UIKit

protocol TabPageIndicatorInfo: class {
    func tabPageInfo(for viewController: UIViewController) -> String
}

protocol PannableViewsProtocol {
    func panView() -> UIView
}

extension UIViewController: PannableViewsProtocol { }

extension PannableViewsProtocol where Self: UIViewController {
    
    func panView() -> UIView {
        if let scrollView = self.view.subviews.first(where: { $0 is UIScrollView }) {
            return scrollView
        } else {
            return self.view
        }
    }
}

protocol NestedScrollDataSource: class {
    func viewControllers(for pagerTabPageController: NestedScrollViewController) -> [UIViewController]
    func defaultSelectedIndex(for pagerTabPageController: NestedScrollViewController) -> Int
    func pagerTabHeight() -> CGFloat
    func configureTitle() -> TabPageView.Setting
    func headerView(for pagerTabPageController: NestedScrollViewController) -> UIView
}

extension NestedScrollDataSource {
    
    func viewControllers(for pagerTabPageController: NestedScrollViewController) -> [UIViewController] {
        return []
    }
    
    func defaultSelectedIndex(for pagerTabPageController: NestedScrollViewController) -> Int {
        return 0
    }
    
    func pagerTabHeight() -> CGFloat {
        return 0
    }
    
    func configureTitle() -> TabPageView.Setting {
        return .init()
    }
    
    func headerView(for pagerTabPageController: NestedScrollViewController) -> UIView {
        return UIView()
    }
}

protocol NestedScrollDelegate: class {
    func selectedIndexChanged(for pagerTabPageController: NestedScrollViewController, previousIndex: Int, currentIndex: Int)
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView)
    func scrollViewDidScroll(_ scrollView: UIScrollView, didUpdate: NestedScrollViewController.ScrollType)
    func scrollViewDidLoad(_ scrollView: UIScrollView)
}

extension NestedScrollDelegate {
    func selectedIndexChanged(for pagerTabPageController: NestedScrollViewController, previousIndex: Int, currentIndex: Int) {}
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {}
    func scrollViewDidScroll(_ scrollView: UIScrollView, didUpdate: NestedScrollViewController.ScrollType) {}
    func scrollViewDidLoad(_ scrollView: UIScrollView) {}
}
