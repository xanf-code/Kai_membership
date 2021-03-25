//
//  CardCollapseTableViewCell.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 11/03/2021.
//

import UIKit

class CardCollapseTableViewCell: UITableViewCell {
    
    // MARK: Properties
    private let cardCollapseView: KAICardCollapseView = {
        let view = KAICardCollapseView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    // MARK: Life cycle's
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    private func setupView() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.addSubview(cardCollapseView)
        
        NSLayoutConstraint.activate([
            cardCollapseView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardCollapseView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            cardCollapseView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            cardCollapseView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
        ])
    }
    
    // MARK: Layout
    func configure() {
        cardCollapseView.configure()
    }
}
