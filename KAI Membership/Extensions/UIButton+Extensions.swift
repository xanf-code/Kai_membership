//
//  UIButton+Extensions.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 16/03/2021.
//

import UIKit
import Kingfisher

extension UIButton {
    func centerVertically(padding: CGFloat = 6.0) {
        guard
            let imageViewSize = self.imageView?.frame.size,
            let titleLabelSize = self.titleLabel?.frame.size else {
            return
        }
        
        let totalHeight = imageViewSize.height + titleLabelSize.height + padding
        
        self.imageEdgeInsets = UIEdgeInsets(
            top: -(totalHeight - imageViewSize.height),
            left: 0.0,
            bottom: 0.0,
            right: -titleLabelSize.width
        )
        
        self.titleEdgeInsets = UIEdgeInsets(
            top: 0.0,
            left: -imageViewSize.width,
            bottom: -(totalHeight - titleLabelSize.height),
            right: 0.0
        )
        
        self.contentEdgeInsets = UIEdgeInsets(
            top: 0.0,
            left: 0.0,
            bottom: titleLabelSize.height,
            right: 0.0
        )
    }
}

extension UIButton {
    
    func setImage(from link: String?, placeholder: UIImage? = nil, for state: UIControl.State = .normal) {
        guard let link = link, let url = URL(string: link) else {
            self.setImage(placeholder, for: state)
            return
        }
        
        setImage(from: url, placeholder: placeholder, for: state)
    }
    
    func setImage(from url: URL, placeholder: UIImage? = nil, for state: UIControl.State = .normal) {
        self.setImage(placeholder, for: state)
        
        ImageDownloader.default.downloadImage(with: url, completionHandler: {
            switch $0 {
            case .success(let result):
                self.setImage(result.image.withRenderingMode(.alwaysOriginal), for: state)
            case .failure(let error):
                debugPrint("ImageDownloader error: \(error)")
            }
        })
    }
}
