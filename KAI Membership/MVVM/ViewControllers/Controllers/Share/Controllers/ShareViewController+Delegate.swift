//
//  ShareViewController+Delegate.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 22/03/2021.
//

import UIKit

// MARK: UICollectionViewDelegateFlowLayout
extension ShareViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 74, height: 82)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
