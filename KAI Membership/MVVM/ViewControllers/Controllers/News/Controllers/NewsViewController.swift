//
//  NewsViewController.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 24/03/2021.
//

import UIKit

class NewsViewController: BaseViewController {

    // MARK: Properties
    enum Section: Int, CaseIterable {
        case suggestion
        case lastest
    }
    
    let viewModel = NewsViewModel()
    
    private lazy var rightBarButtonItemView: KAIBarButtonItemView = {
        let view = KAIBarButtonItemView()
        view.delegate = self
        
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.register(NewsSuggestionTableViewCell.self, forCellReuseIdentifier: NewsSuggestionTableViewCell.identifier)
        tableView.register(NewsLastestTableViewCell.self, forCellReuseIdentifier: NewsLastestTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        
        return tableView
    }()
    
    // MARK: Life cycle's
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Today News"
        navigationItem.setRightBarButton(UIBarButtonItem(customView: rightBarButtonItemView), animated: true)
        
        setupView()
        fetchData()
        
        if AppSetting.isRequestOpenSpin {
            Navigator.openSpin(from: self)
            AppSetting.isRequestOpenSpin = false
        }
    }
    
    // MARK: Layout
    private func setupView() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    // MARK: Data fetching
    func fetchData() {
        viewModel.createData()
        viewModel.getNewsFromMedium() { news in
            
        }
        
        viewModel.getNewsFromTwitter() { news in
            
        }
        tableView.reloadData()
    }
}
