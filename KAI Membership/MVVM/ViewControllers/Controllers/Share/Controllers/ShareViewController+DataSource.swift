//
//  ShareViewController+DataSource.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 22/03/2021.
//

import UIKit

// MARK: UICollectionViewDataSource
extension ShareViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ShareItem.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShareCollectionViewCell.identifier, for: indexPath) as! ShareCollectionViewCell
        
        return cell
    }
}
