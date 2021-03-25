//
//  QuestViewController.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 23/02/2021.
//

import UIKit
import RxSwift

class QuestViewController: BaseViewController {
    
    // MARK: Properties
    let viewModel = QuestViewModel()
    
    private lazy var rightBarButtonItemView: KAIBarButtonItemView = {
        let view = KAIBarButtonItemView()
        view.delegate = self
        
        return view
    }()
    
    private(set) lazy var childViewController: NestedScrollViewController = {
        let childVC = NestedScrollViewController(with: self)
        childVC.delegate = self
        
        return childVC
    }()
    
    let dailyVC = DailyQuestViewController()
    let monthlyVC = MonthlyQuestViewController()
    
    private(set) lazy var headerView: QuestHeaderView = {
        let view = QuestHeaderView()
        view.selectedSegmentIndexChanged = { [weak self] in
            guard let this = self else { return }
            
            let containerScrollView = this.childViewController.containerScrollView
//            lastContentOffsetX = containerScrollView.contentOffset.x
            let y = containerScrollView.contentOffset.y
            this.childViewController.containerScrollView.setContentOffset(CGPoint(x: containerScrollView.frame.width * CGFloat($0), y: y), animated: true)
        }
        
        return view
    }()
    
    override var navigationAlphaDefault: CGFloat {
        return 0
    }
    
    override var scroller: UIScrollView? {
        return childViewController.overlayScrollView
    }
    
    // MARK: Life cycle's
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.setRightBarButton(UIBarButtonItem(customView: rightBarButtonItemView), animated: true)
        self.add(childViewController)
        fetchData()
    }
    
    // MARK: Data fetching
    private func fetchData() {
        viewModel.getTheQuestsList().subscribe(on: MainScheduler.instance).subscribe(onNext: { [weak self] quests in
            guard let this = self else { return }
            
            this.dailyVC.configure(quests.filter { $0.type == .daily })
            this.monthlyVC.configure(quests.filter { $0.type == .monthly })
            this.endRefreshing()
        }, onError: { [weak self] error in
            self?.endRefreshing()
            debugPrint("Get the quests list error: \((error as? APIErrorResult)?.message ?? "ERROR")")
        }).disposed(by: disposeBag)
    }
    
    // MARK: Handle actions
    override func refresh(_ sender: UIRefreshControl) {
        super.refresh(sender)
        fetchData()
    }
}
