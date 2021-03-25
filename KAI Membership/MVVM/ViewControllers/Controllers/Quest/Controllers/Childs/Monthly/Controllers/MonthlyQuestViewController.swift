//
//  MonthlyQuestViewController.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 05/03/2021.
//

import UIKit
import DZNEmptyDataSet

class MonthlyQuestViewController: UIViewController {

    // MARK: Properties
    private(set) var quests = [QuestRemote]()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.separatorStyle = .none
        tableView.backgroundColor = Constants.backroundColorDefault
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 12))
        tableView.register(QuestTableViewCell.self, forCellReuseIdentifier: QuestTableViewCell.identifier)
        tableView.dataSource = self
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        
        return tableView
    }()
    
    // MARK: Life cycle's
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    // MARK: Layout
    private func setupView() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    // MARK: Configure
    func configure(_ quests: [QuestRemote]) {
        self.quests = quests
        tableView.reloadData()
    }
}
