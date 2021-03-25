//
//  NewsViewController+DataSource.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 01/03/2021.
//

import UIKit

// MARK: UITableViewDataSource
extension NewsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sectionType = Section(rawValue: indexPath.section) else { return UITableViewCell() }
        
        switch sectionType {
        case .suggestion:
            let cell = tableView.dequeueReusableCell(withIdentifier: NewsSuggestionTableViewCell.identifier, for: indexPath) as! NewsSuggestionTableViewCell
            cell.reloadWithData(viewModel.suggestions)
            
            return cell
        case .lastest:
            let cell = tableView.dequeueReusableCell(withIdentifier: NewsLastestTableViewCell.identifier, for: indexPath) as! NewsLastestTableViewCell
            cell.reloadWithData(viewModel.lastests)
            
            return cell
        }
    }
}
