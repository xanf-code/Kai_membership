//
//  ShareViewController.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 22/03/2021.
//

import UIKit

class ShareViewController: BaseViewController {
    
    // MARK: Properties
    enum ShareItem: Int, CaseIterable {
        case facebook
    }
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 24
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.createShadow(radius: 24)
        
        return view
    }()
    
    private(set) lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 20
        layout.sectionInset = .init(top: 20, left: 20, bottom: 20, right: 20)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.showsHorizontalScrollIndicator = false
        view.isPagingEnabled = true
        view.register(ShareCollectionViewCell.self, forCellWithReuseIdentifier: ShareCollectionViewCell.identifier)
        view.dataSource = self
        view.delegate = self
        
        return view
    }()
    
    override var backroundColorDefault: UIColor {
        return UIColor.black.withAlphaComponent(0.1)
    }
    
    // MARK: Life cycle's
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    // MARK: Layout
    private func setupView() {
        
    }
}
