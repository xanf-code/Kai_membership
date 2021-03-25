//
//  NewsLastestTableViewCell.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 04/03/2021.
//

import UIKit

class NewsLastestTableViewCell: UITableViewCell {
    
    // MARK: Properties
    static let height: CGFloat = 252
    
    private let minimumInteritemSpacing: CGFloat = 20
    private let sectionInset: UIEdgeInsets = .init(top: 0, left: 20, bottom: 20, right: 20)
    private var lastests = [NewRemote]()
    
    private lazy var itemSize: CGSize = {
        let width: CGFloat = collectionView.frame.width - (sectionInset.left + sectionInset.right)
        let height: CGFloat = ((NewsLastestTableViewCell.height - (sectionInset.top + sectionInset.bottom)) - (minimumInteritemSpacing * 2)) / 3
        
        return CGSize(width: width, height: height)
    }()
    
    private(set) lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = minimumInteritemSpacing
        layout.sectionInset = sectionInset
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.showsHorizontalScrollIndicator = false
        view.isPagingEnabled = true
        view.register(NewsLastestCollectionViewCell.self, forCellWithReuseIdentifier: NewsLastestCollectionViewCell.identifier)
        view.dataSource = self
        view.delegate = self
        
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
        contentView.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
    
    // MARK: Configure
    func reloadWithData(_ lastests: [NewRemote]) {
        self.lastests = lastests
        collectionView.reloadData()
    }
}

// MARK: UICollectionViewDataSource
extension NewsLastestTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lastests.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsLastestCollectionViewCell.identifier, for: indexPath) as! NewsLastestCollectionViewCell
        cell.configure(lastests[indexPath.row])
        
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension NewsLastestTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
