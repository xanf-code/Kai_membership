//
//  NestedScrollViewController.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 04/03/2021.
//

import UIKit

class NestedScrollViewController: UIViewController, UITableViewDelegate {
    
    // MARK: Properties
    enum ScrollType {
        case parent
        case child
    }
    
    private var pagerTabHeight: CGFloat {
        return dataSource?.pagerTabHeight() ?? 0
    }
    
    private var originalHeaderHeight: CGFloat {
        return headerView.frame.height
    }
    
    private var setting: TabPageView.Setting {
        return dataSource?.configureTitle() ?? .init()
    }
    
    private(set) lazy var headerView: UIView = {
        let view = dataSource?.headerView(for: self) ?? UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private(set) lazy var containerTabPageView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private(set) lazy var containerScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isPagingEnabled = true
        scrollView.isScrollEnabled = true
        scrollView.bounces = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self

        return scrollView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isPagingEnabled = false
        scrollView.isScrollEnabled = false
        scrollView.bounces = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .never
        
        return scrollView
    }()
    
    private(set) lazy var overlayScrollView: UITableView = {
        let scrollView = UITableView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .clear
        scrollView.separatorStyle = .none
        scrollView.isPagingEnabled = false
        scrollView.isScrollEnabled = true
        scrollView.bounces = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.layer.zPosition = 999
        scrollView.delegate = self
        
        return scrollView
    }()
    
    private var tabTitles = [String]()
    private var viewControllers = [UIViewController]()
    private var containerViews = [UIView]()
    private var lastContentOffsetX: CGFloat = 0
    private var contentOffsets: [Int: CGFloat] = [:]
    private(set) var currentIndex = -1
    private(set) var previousIndex = 0
    
    var panViews: [Int: UIView] = [:]
    
    weak private var dataSource: NestedScrollDataSource?
    weak var delegate: NestedScrollDelegate?
    
    // MARK: Life cycle
    init(with dataSource: UIViewController) {
        self.dataSource = dataSource as? NestedScrollDataSource

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        debugPrint("Deinit Pager Tab Page Controller")
        self.panViews.forEach {
            if let scrollView = $0.value as? UIScrollView {
                scrollView.removeObserver(self, forKeyPath: #keyPath(UIScrollView.contentSize))
            }
        }
    }
    
    override func loadView() {
        super.loadView()
        view.addSubview(overlayScrollView)
        view.addSubview(scrollView)
        scrollView.addSubview(headerView)
        scrollView.addSubview(containerTabPageView)
        scrollView.addSubview(containerScrollView)
        
        NSLayoutConstraint.activate([
            overlayScrollView.topAnchor.constraint(equalTo: view.topAnchor),
            overlayScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlayScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            overlayScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            headerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),

            containerTabPageView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            containerTabPageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerTabPageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerTabPageView.heightAnchor.constraint(equalToConstant: pagerTabHeight),

            containerScrollView.topAnchor.constraint(equalTo: containerTabPageView.bottomAnchor),
            containerScrollView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerScrollView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerScrollView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerScrollView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            containerScrollView.heightAnchor.constraint(equalTo: scrollView.heightAnchor, constant: -pagerTabHeight)
        ])
        
        reloadViewControllers()
        delegate?.scrollViewDidLoad(overlayScrollView)
    }
    
    private func reloadViewControllers() {
        containerScrollView.delegate = nil
        tabTitles.removeAll()
        viewControllers = dataSource?.viewControllers(for: self) ?? []
        let index = dataSource?.defaultSelectedIndex(for: self) ?? 0
        let totalController: Int = viewControllers.count

        if index < totalController && index >= 0 {
            previousIndex = index
        } else {
            previousIndex = 0
        }

        currentIndex = previousIndex
        var leadingAnchor: NSLayoutXAxisAnchor = containerScrollView.leadingAnchor

        for i in 0..<totalController {
            let containerView: UIView = {
                let view = UIView()
                view.translatesAutoresizingMaskIntoConstraints = false

                return view
            }()

            containerScrollView.addSubview(containerView)
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            containerView.topAnchor.constraint(equalTo: containerScrollView.topAnchor).isActive = true
            containerView.bottomAnchor.constraint(equalTo: containerScrollView.bottomAnchor).isActive = true
            containerView.widthAnchor.constraint(equalTo: containerScrollView.widthAnchor).isActive = true
            containerView.heightAnchor.constraint(equalTo: containerScrollView.heightAnchor).isActive = true
            leadingAnchor = containerView.trailingAnchor

            if i >= totalController - 1 {
                containerView.trailingAnchor.constraint(equalTo: containerScrollView.trailingAnchor).isActive = true
            }

            containerViews.append(containerView)
            let childController = viewControllers[i]
            let tabTitle: String = (childController as? TabPageIndicatorInfo)?.tabPageInfo(for: self) ?? ""
            tabTitles.append(tabTitle)
        }

        setPanView(currentIndex)
        updateContentSize(currentIndex)
        self.scrollView.addGestureRecognizer(self.overlayScrollView.panGestureRecognizer)
        addChildController(currentIndex)
        containerScrollView.contentSize = CGSize(width: containerScrollView.frame.width * CGFloat(totalController), height: containerScrollView.frame.height)

        if currentIndex > 0 {
            containerScrollView.contentOffset.x = view.frame.width * CGFloat(currentIndex)
        }

        containerScrollView.delegate = self
    }
    
    private func addChildController(_ index: Int) {
        guard index >= 0 && index < viewControllers.count else { return }
        
        let childController = viewControllers[index]
        
        guard childController.parent == nil else { return }
        
        let containerView = self.containerViews[index]
        addChild(childController)
        containerView.addSubview(childController.view)
        childController.view.frame = containerView.bounds
        childController.didMove(toParent: self)
    }
    
    func selectedTabScript(_ indexPath: IndexPath) {
//        (pagerTabCollectionNode.nodeForItem(at: IndexPath(row: currentIndex, section: 0)) as? PagerTagPageCell)?.configure(false)
//
//        if let cellNode = pagerTabCollectionNode.nodeForItem(at: indexPath) as? PagerTagPageCell {
//            cellNode.configure(true)
//
//            if self.tabPageType == .auto {
//                pagerTabCollectionNode.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
//            }
//        }

        
        delegate?.selectedIndexChanged(for: self, previousIndex: currentIndex, currentIndex: indexPath.row)
        addChildController(indexPath.row)
        previousIndex = currentIndex
        currentIndex = indexPath.row
        setPanView(indexPath.row)
        updateContentSize(indexPath.row)
    }
    
    private func setPanView(_ index: Int) {
        guard self.panViews[index] == nil && viewControllers.count > 0 else { return }
        
        self.panViews[index] = viewControllers[index].panView()
    }
    
    func updateContentSize(_ index: Int) {
        if let scrollView = self.panViews[index] as? UIScrollView {
            scrollView.panGestureRecognizer.require(toFail: self.overlayScrollView.panGestureRecognizer)
            scrollView.contentInsetAdjustmentBehavior = .never
            self.overlayScrollView.contentSize = getContentSize(for: scrollView)
            scrollView.addObserver(self, forKeyPath: #keyPath(UIScrollView.contentSize), options: .new, context: nil)
        } else if let bottomView = self.panViews[index] {
            self.overlayScrollView.contentSize = getContentSize(for: bottomView)
        }
    }
    
    func getContentSize(for containerView: UIView) -> CGSize {
        if let scroll = containerView as? UIScrollView {
            let bottomHeight = min(scroll.contentSize.height, view.frame.height - (originalHeaderHeight + pagerTabHeight))
            
            return .init(width: scroll.contentSize.width, height: bottomHeight + originalHeaderHeight + pagerTabHeight)
        } else {
            let bottomHeight = view.frame.height - pagerTabHeight
            
            return .init(width: containerView.frame.width, height: bottomHeight + originalHeaderHeight + pagerTabHeight)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let obj = object as? UIScrollView, let scroll = self.panViews[currentIndex] as? UIScrollView, obj == scroll && keyPath == #keyPath(UIScrollView.contentSize) else { return }
            
        overlayScrollView.contentSize = getContentSize(for: scroll)
    }
}

// MARK: UIScrollViewDelegate
extension NestedScrollViewController: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        delegate?.scrollViewWillBeginDragging(scrollView)
        
        guard scrollView === self.containerScrollView else { return }
        
        lastContentOffsetX = scrollView.contentOffset.x
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView === self.overlayScrollView {
            contentOffsets[currentIndex] = scrollView.contentOffset.y
            
            if scrollView.contentOffset.y < originalHeaderHeight {
                self.scrollView.contentOffset.y = scrollView.contentOffset.y
                self.panViews.forEach {
                    ($0.value as? UIScrollView)?.contentOffset.y = 0
                }
                
                contentOffsets.removeAll()
            } else {
                self.scrollView.contentOffset.y = originalHeaderHeight
                (self.panViews[currentIndex] as? UIScrollView)?.contentOffset.y = scrollView.contentOffset.y - self.scrollView.contentOffset.y
            }

//            if scrollView.contentOffset.y < 0 {
//                headerView.frame = CGRect(x: headerView.frame.minX,
//                                          y: min(originalHeaderHeight, scrollView.contentOffset.y),
//                                          width: headerView.frame.width,
//                                          height: originalHeaderHeight - scrollView.contentOffset.y)
//
//            } else {
//                headerView.frame = CGRect(x: headerView.frame.minX,
//                                          y: 0,
//                                          width: headerView.frame.width,
//                                          height: originalHeaderHeight)
//            }

            let progress = self.scrollView.contentOffset.y / originalHeaderHeight

            if progress < 1 {
                self.delegate?.scrollViewDidScroll(self.scrollView, didUpdate: .parent)
            } else {
                self.delegate?.scrollViewDidScroll(self.overlayScrollView, didUpdate: .child)
            }
        } else {
            guard scrollView === self.containerScrollView && scrollView.contentOffset.x >= 0 && scrollView.contentOffset.x <= (scrollView.contentSize.width - view.frame.width) else { return }
            
            let x = scrollView.contentOffset.x
             
            if lastContentOffsetX < x { // Right
                let newIndex = Int((x - 1) / view.frame.width) + 1
                
                guard currentIndex != newIndex else { return }
                
                selectedTabScript(IndexPath(row: newIndex, section: 0))
            } else { // Left
                let newIndex = Int((x + 1) / view.frame.width)
                
                guard currentIndex != newIndex else { return }
                
                selectedTabScript(IndexPath(row: newIndex, section: 0))
            }
        }
    }
}
