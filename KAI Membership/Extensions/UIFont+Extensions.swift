//
//  UIFont+Extensions.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 24/03/2021.
//

import UIKit

extension UIFont {
    
    enum WorkSansFont: String {
        case black = "WorkSans-Black"
        case blackItalic = "WorkSans-BlackItalic"
        case bold = "WorkSans-Bold"
        case boldItalic = "WorkSans-BoldItalic"
        case extraBold = "WorkSans-ExtraBold"
        case extraBoldItalic = "WorkSans-ExtraBoldItalic"
        case extraLight = "WorkSans-ExtraLight"
        case extraLightItalic = "WorkSans-ExtraLightItalic"
        case hairline = "WorkSans-Hairline"
        case italicVF = "worksans-italic-vf"
        case italic = "WorkSans-Italic"
        case italicWeight = "WorkSans-Italic[wght]"
        case light = "WorkSans-Light"
        case lightItalic = "WorkSans-LightItalic"
        case medium = "WorkSans-Medium"
        case mediumItalic = "WorkSans-MediumItalic"
        case regular = "WorkSans-Regular"
        case romanVF = "worksans-roman-vf"
        case semiBold = "WorkSans-SemiBold"
        case semiBoldItalic = "WorkSans-SemiBoldItalic"
        case thin = "WorkSans-Thin"
        case thinItalic = "WorkSans-ThinItalic"
        case weight = "WorkSans[wght]"
    }
    
    class func workSansFont(ofSize fontSize: CGFloat, weight: WorkSansFont) -> UIFont {
        return UIFont(name: weight.rawValue, size: fontSize) ?? .systemFont(ofSize: fontSize, weight: .regular)
    }
}
