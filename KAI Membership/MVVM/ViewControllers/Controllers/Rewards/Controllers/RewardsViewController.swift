//
//  RewardsViewController.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 10/03/2021.
//

import UIKit
import RxSwift
import DZNEmptyDataSet

class RewardsViewController: BaseViewController {

    // MARK: Properties
    enum Section: Int, CaseIterable {
        case rewards
        case history
    }
    
    let viewModel = RewardsViewModel()
    
    private(set) lazy var emptyView: RewardsEmptyView = {
        let view = RewardsEmptyView()
        view.didFinishTouchingGoToMission = { [weak self] in
            guard let this = self else { return }
            
            Navigator.navigateToQuestVC(from: this)
        }
        
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.tableHeaderView = nil
        tableView.tableFooterView = nil
        tableView.backgroundColor = Constants.backroundColorDefault
        tableView.contentInset = .init(top: 0, left: 0, bottom: safeAreaInsets.bottom, right: 0)
        tableView.register(RewardsTableViewCell.self, forCellReuseIdentifier: RewardsTableViewCell.identifier)
        tableView.register(HistoryTableViewCell.self, forCellReuseIdentifier: HistoryTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        
        return tableView
    }()
    
    private(set) lazy var headerView: ProfileHeaderView = {
        let view = ProfileHeaderView()
        
        return view
    }()
    
    override var scroller: UIScrollView? {
        return tableView
    }
    
    // MARK: Life cycle's
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "My reward"
        setupView()
        fetchData()
    }
    
    // MARK: Layout
    private func setupView() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: Handle actions
    override func refresh(_ sender: UIRefreshControl) {
        super.refresh(sender)
        fetchData()
    }
}

// MARK: Data fetching
extension RewardsViewController {
    
    private func fetchData() {
        viewModel.getHistories().subscribe(on: MainScheduler.instance).subscribe(onNext: { [weak self] histories in
            guard let this = self else { return }
            
            this.tableView.reloadData()
            this.endRefreshing()
        }, onError: { [weak self] error in
            self?.endRefreshing()
            debugPrint("Get histories errror: \((error as? APIErrorResult)?.message ?? "ERROR")")
        }).disposed(by: disposeBag)
    }
}
