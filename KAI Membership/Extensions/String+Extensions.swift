//
//  String+Extensions.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 20/02/2021.
//

import UIKit

extension String: BaseModel { }

extension String {
    
    func toImage(with size: CGSize, font: UIFont) -> UIImage? {
        let frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
         let nameLabel = UILabel(frame: frame)
         nameLabel.textAlignment = .center
         nameLabel.backgroundColor = .clear
         nameLabel.textColor = .white
         nameLabel.font = font
         nameLabel.text = self
         UIGraphicsBeginImageContext(frame.size)
          if let currentContext = UIGraphicsGetCurrentContext() {
             nameLabel.layer.render(in: currentContext)
             let nameImage = UIGraphicsGetImageFromCurrentImageContext()
             return nameImage
          }
          return nil
    }
    
    private func isAllDigits() -> Bool {
        let charcterSet  = NSCharacterSet(charactersIn: "0123456789").inverted
        let inputString = self.components(separatedBy: charcterSet)
        let filtered = inputString.joined(separator: "")
        
        return self == filtered
    }
    
    var isPhoneNumber: Bool {
        if self.isAllDigits() == true {
            let phoneRegex = "^(0[0-9]{9}|[1-9]{1}[0-9]{8})$"
            let predicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
    
            return predicate.evaluate(with: self)
        } else {
            return false
        }
    }
    
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: self)
        
        return result
    }
    
    func toUnsignedString() -> String {
        let mStringRef = NSMutableString(string: self) as CFMutableString
        CFStringTransform(mStringRef, nil, kCFStringTransformStripCombiningMarks, false)
        
        return mStringRef as String
    }
}

extension String {
    
    func setTextWithFormat(font: UIFont, textAlignment: NSTextAlignment = .left, letterSpacing: CGFloat = 0, lineHeight: CGFloat = 18, textColor: UIColor = .black, lineHeightMultiple: CGFloat? = nil) -> NSMutableAttributedString {
        let attributedText = NSMutableAttributedString(string: self)
        attributedText.addAttribute(.font, value: font, range: NSRange(location: 0, length: attributedText.length))
        attributedText.addAttribute(.kern, value: letterSpacing, range: NSRange(location: 0, length: attributedText.length))
        attributedText.addAttribute(.foregroundColor, value: textColor, range: NSRange(location: 0, length: attributedText.length))
        
        do {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.maximumLineHeight = lineHeight
            paragraphStyle.minimumLineHeight = lineHeight
            paragraphStyle.alignment = textAlignment
            
            if let lineHeightMultiple = lineHeightMultiple {
                paragraphStyle.lineHeightMultiple = lineHeightMultiple
            }
            
            attributedText.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedText.length))
        }
        
        return attributedText
    }
    
    func currencyToString(with unit: UnitCurrency = .none) -> String {
        let rawValue = unit.rawValue
        var cleanNumericString: String = self
        
        if !(cleanNumericString.isEmpty) && !(rawValue.isEmpty) {
            let tmp = cleanNumericString.components(separatedBy: rawValue)
            cleanNumericString = tmp.joined(separator: "")
        }
        
        return cleanNumericString
    }
}
