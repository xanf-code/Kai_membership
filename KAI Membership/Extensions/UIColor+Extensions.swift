//
//  UIColor+Extensions.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 24/03/2021.
//

import UIKit

extension UIColor {
    
    @nonobjc convenience init(hex: String) {
        let characterSet = (CharacterSet.whitespacesAndNewlines as NSCharacterSet).mutableCopy() as! NSMutableCharacterSet
        characterSet.formUnion(with: CharacterSet(charactersIn: "#"))
        let cString = hex.trimmingCharacters(in: characterSet as CharacterSet).uppercased()
        if (cString.count != 6) {
            self.init(white: 1.0, alpha: 1.0)
        } else {
            var rgbValue: UInt32 = 0
            Scanner(string: cString).scanHexInt32(&rgbValue)
            
            self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                      green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                      blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                      alpha: CGFloat(1.0))
        }
    }
}

// MARK: Theme
extension UIColor {
    
    // TODO: Background color
    struct Background {
        static var BG: UIColor {
            if #available(iOS 13, *) {
                return UIColor.init { (trait) -> UIColor in
                    return trait.userInterfaceStyle == .dark ? UIColor.init(hex: "181719") : UIColor.init(hex: "F4F2F7")
                }
            } else {
                return UIColor.init(hex: "F4F2F7")
            }
        }
        
        static var FG1: UIColor {
            if #available(iOS 13, *) {
                return UIColor.init { (trait) -> UIColor in
                    return trait.userInterfaceStyle == .dark ? UIColor.init(hex: "27242C") : UIColor.init(hex: "FFFFFF")
                }
            } else {
                return UIColor.init(hex: "FFFFFF")
            }
        }
        
        static var FG2: UIColor {
            if #available(iOS 13, *) {
                return UIColor.init { (trait) -> UIColor in
                    return trait.userInterfaceStyle == .dark ? UIColor.init(hex: "3D3A41") : UIColor.init(hex: "F9F9F9")
                }
            } else {
                return UIColor.init(hex: "F9F9F9")
            }
        }
    }
    
    // TODO: Link color
    struct Link {
        static let normal: UIColor = UIColor.init(hex: "0F5DFA")
        static let hover: UIColor = UIColor.init(hex: "0044CC")
        static let visited: UIColor = UIColor.init(hex: "8CB0F8")
    }
    
    // TODO: Rainbow color
    struct Rainbow {
        static let x900: UIColor = UIColor.init(hex: "F63528")
        static let x800: UIColor = UIColor.init(hex: "FF8433")
        static let x700: UIColor = UIColor.init(hex: "FFD633")
        static let x600: UIColor = UIColor.init(hex: "2CC94B")
        static let x500: UIColor = UIColor.init(hex: "00C4F5")
        static let x400: UIColor = UIColor.init(hex: "591FFF")
        static let x300: UIColor = UIColor.init(hex: "A51FFF")
    }
    
    // TODO: Base color
    struct Base {
        static var x900: UIColor {
            if #available(iOS 13, *) {
                return UIColor.init { (trait) -> UIColor in
                    return trait.userInterfaceStyle == .dark ? UIColor.init(hex: "222B35") : UIColor.init(hex: "181E25")
                }
            } else {
                return UIColor.init(hex: "181E25")
            }
        }
        
        static var x800: UIColor {
            if #available(iOS 13, *) {
                return UIColor.init { (trait) -> UIColor in
                    return trait.userInterfaceStyle == .dark ? UIColor.init(hex: "333F4C") : UIColor.init(hex: "29323D")
                }
            } else {
                return UIColor.init(hex: "29323D")
            }
        }
        
        static var x700: UIColor {
            if #available(iOS 13, *) {
                return UIColor.init { (trait) -> UIColor in
                    return trait.userInterfaceStyle == .dark ? UIColor.init(hex: "415062") : UIColor.init(hex: "394656")
                }
            } else {
                return UIColor.init(hex: "394656")
            }
        }
        
        static var x600: UIColor {
            if #available(iOS 13, *) {
                return UIColor.init { (trait) -> UIColor in
                    return trait.userInterfaceStyle == .dark ? UIColor.init(hex: "53677E") : UIColor.init(hex: "495A6E")
                }
            } else {
                return UIColor.init(hex: "495A6E")
            }
        }
        
        static var x500: UIColor {
            if #available(iOS 13, *) {
                return UIColor.init { (trait) -> UIColor in
                    return trait.userInterfaceStyle == .dark ? UIColor.init(hex: "74869A") : UIColor.init(hex: "67798E")
                }
            } else {
                return UIColor.init(hex: "67798E")
            }
        }
        
        static var x400: UIColor {
            if #available(iOS 13, *) {
                return UIColor.init { (trait) -> UIColor in
                    return trait.userInterfaceStyle == .dark ? UIColor.init(hex: "A3AFBD") : UIColor.init(hex: "94A2B2")
                }
            } else {
                return UIColor.init(hex: "94A2B2")
            }
        }
        
        static var x300: UIColor {
            if #available(iOS 13, *) {
                return UIColor.init { (trait) -> UIColor in
                    return trait.userInterfaceStyle == .dark ? UIColor.init(hex: "BBC4CE") : UIColor.init(hex: "ACB7C3")
                }
            } else {
                return UIColor.init(hex: "ACB7C3")
            }
        }
        
        static var x200: UIColor {
            if #available(iOS 13, *) {
                return UIColor.init { (trait) -> UIColor in
                    return trait.userInterfaceStyle == .dark ? UIColor.init(hex: "DDE3E8") : UIColor.init(hex: "CED6DE")
                }
            } else {
                return UIColor.init(hex: "CED6DE")
            }
        }
        
        static var x100: UIColor {
            if #available(iOS 13, *) {
                return UIColor.init { (trait) -> UIColor in
                    return trait.userInterfaceStyle == .dark ? UIColor.init(hex: "F6F7F9") : UIColor.init(hex: "E6EAEF")
                }
            } else {
                return UIColor.init(hex: "E6EAEF")
            }
        }
        
        static var x050: UIColor {
            if #available(iOS 13, *) {
                return UIColor.init { (trait) -> UIColor in
                    return trait.userInterfaceStyle == .dark ? UIColor.init(hex: "FFFFFF") : UIColor.init(hex: "F3F5F6")
                }
            } else {
                return UIColor.init(hex: "F3F5F6")
            }
        }
    }
    
    // TODO: Danger color
    struct Danger {
        static var x900: UIColor {
            if #available(iOS 13, *) {
                return UIColor.init { (trait) -> UIColor in
                    return trait.userInterfaceStyle == .dark ? UIColor.init(hex: "610B16") : UIColor.init(hex: "490811")
                }
            } else {
                return UIColor.init(hex: "490811")
            }
        }
        
        static var x800: UIColor {
            if #available(iOS 13, *) {
                return UIColor.init { (trait) -> UIColor in
                    return trait.userInterfaceStyle == .dark ? UIColor.init(hex: "850F1E") : UIColor.init(hex: "6E0C19")
                }
            } else {
                return UIColor.init(hex: "6E0C19")
            }
        }
        
        static var x700: UIColor {
            if #available(iOS 13, *) {
                return UIColor.init { (trait) -> UIColor in
                    return trait.userInterfaceStyle == .dark ? UIColor.init(hex: "AA1327") : UIColor.init(hex: "931022")
                }
            } else {
                return UIColor.init(hex: "931022")
            }
        }
        
        static var x600: UIColor {
            if #available(iOS 13, *) {
                return UIColor.init { (trait) -> UIColor in
                    return trait.userInterfaceStyle == .dark ? UIColor.init(hex: "E72741") : UIColor.init(hex: "DC1833")
                }
            } else {
                return UIColor.init(hex: "DC1833")
            }
        }
        
        static var x500: UIColor {
            if #available(iOS 13, *) {
                return UIColor.init { (trait) -> UIColor in
                    return trait.userInterfaceStyle == .dark ? UIColor.init(hex: "EB4C62") : UIColor.init(hex: "E8354D")
                }
            } else {
                return UIColor.init(hex: "E8354D")
            }
        }
        
        static var x400: UIColor {
            if #available(iOS 13, *) {
                return UIColor.init { (trait) -> UIColor in
                    return trait.userInterfaceStyle == .dark ? UIColor.init(hex: "EF7081") : UIColor.init(hex: "ED5A6D")
                }
            } else {
                return UIColor.init(hex: "ED5A6D")
            }
        }
        
        static var x300: UIColor {
            if #available(iOS 13, *) {
                return UIColor.init { (trait) -> UIColor in
                    return trait.userInterfaceStyle == .dark ? UIColor.init(hex: "F495A2") : UIColor.init(hex: "F17E8E")
                }
            } else {
                return UIColor.init(hex: "F17E8E")
            }
        }
        
        static var x200: UIColor {
            if #available(iOS 13, *) {
                return UIColor.init { (trait) -> UIColor in
                    return trait.userInterfaceStyle == .dark ? UIColor.init(hex: "F8BAC2") : UIColor.init(hex: "F5A3AE")
                }
            } else {
                return UIColor.init(hex: "F5A3AE")
            }
        }
        
        static var x100: UIColor {
            if #available(iOS 13, *) {
                return UIColor.init { (trait) -> UIColor in
                    return trait.userInterfaceStyle == .dark ? UIColor.init(hex: "FEF0F2") : UIColor.init(hex: "FDD8DD")
                }
            } else {
                return UIColor.init(hex: "FDD8DD")
            }
        }
        
        static var x050: UIColor {
            if #available(iOS 13, *) {
                return UIColor.init { (trait) -> UIColor in
                    return trait.userInterfaceStyle == .dark ? UIColor.init(hex: "FFFFFF") : UIColor.init(hex: "FFEBED")
                }
            } else {
                return UIColor.init(hex: "FFEBED")
            }
        }
    }
    
    // TODO: Success color
    struct Success {
        static var x900: UIColor {
            if #available(iOS 13, *) {
                return UIColor.init { (trait) -> UIColor in
                    return trait.userInterfaceStyle == .dark ? UIColor.init(hex: "094E37") : UIColor.init(hex: "063727")
                }
            } else {
                return UIColor.init(hex: "063727")
            }
        }
        
        static var x800: UIColor {
            if #available(iOS 13, *) {
                return UIColor.init { (trait) -> UIColor in
                    return trait.userInterfaceStyle == .dark ? UIColor.init(hex: "0C7351") : UIColor.init(hex: "0A5C41")
                }
            } else {
                return UIColor.init(hex: "0A5C41")
            }
        }
        
        static var x700: UIColor {
            if #available(iOS 13, *) {
                return UIColor.init { (trait) -> UIColor in
                    return trait.userInterfaceStyle == .dark ? UIColor.init(hex: "109367") : UIColor.init(hex: "0E805A")
                }
            } else {
                return UIColor.init(hex: "0E805A")
            }
        }
        
        static var x600: UIColor {
            if #available(iOS 13, *) {
                return UIColor.init { (trait) -> UIColor in
                    return trait.userInterfaceStyle == .dark ? UIColor.init(hex: "15BD85") : UIColor.init(hex: "12A574")
                }
            } else {
                return UIColor.init(hex: "12A574")
            }
        }
        
        static var x500: UIColor {
            if #available(iOS 13, *) {
                return UIColor.init { (trait) -> UIColor in
                    return trait.userInterfaceStyle == .dark ? UIColor.init(hex: "17CE91") : UIColor.init(hex: "15B982")
                }
            } else {
                return UIColor.init(hex: "15B982")
            }
        }
        
        static var x400: UIColor {
            if #available(iOS 13, *) {
                return UIColor.init { (trait) -> UIColor in
                    return trait.userInterfaceStyle == .dark ? UIColor.init(hex: "27E7A8") : UIColor.init(hex: "18DC9B")
                }
            } else {
                return UIColor.init(hex: "18DC9B")
            }
        }
        
        static var x300: UIColor {
            if #available(iOS 13, *) {
                return UIColor.init { (trait) -> UIColor in
                    return trait.userInterfaceStyle == .dark ? UIColor.init(hex: "70EFC5") : UIColor.init(hex: "5AEDBC")
                }
            } else {
                return UIColor.init(hex: "5AEDBC")
            }
        }
        
        static var x200: UIColor {
            if #available(iOS 13, *) {
                return UIColor.init { (trait) -> UIColor in
                    return trait.userInterfaceStyle == .dark ? UIColor.init(hex: "A8F5DB") : UIColor.init(hex: "91F3D2")
                }
            } else {
                return UIColor.init(hex: "91F3D2")
            }
        }
        
        static var x100: UIColor {
            if #available(iOS 13, *) {
                return UIColor.init { (trait) -> UIColor in
                    return trait.userInterfaceStyle == .dark ? UIColor.init(hex: "DFFBF2") : UIColor.init(hex: "C8F9E8")
                }
            } else {
                return UIColor.init(hex: "C8F9E8")
            }
        }
        
        static var x050: UIColor {
            if #available(iOS 13, *) {
                return UIColor.init { (trait) -> UIColor in
                    return trait.userInterfaceStyle == .dark ? UIColor.init(hex: "FFFFFF") : UIColor.init(hex: "EDFDF7")
                }
            } else {
                return UIColor.init(hex: "EDFDF7")
            }
        }
    }
    
    // TODO: Warning color
    struct Warning {
        static var x900: UIColor {
            if #available(iOS 13, *) {
                return UIColor.init { (trait) -> UIColor in
                    return trait.userInterfaceStyle == .dark ? UIColor.init(hex: "8E3D06") : UIColor.init(hex: "753205")
                }
            } else {
                return UIColor.init(hex: "753205")
            }
        }
        
        static var x800: UIColor {
            if #available(iOS 13, *) {
                return UIColor.init { (trait) -> UIColor in
                    return trait.userInterfaceStyle == .dark ? UIColor.init(hex: "B54D08") : UIColor.init(hex: "9D4307")
                }
            } else {
                return UIColor.init(hex: "9D4307")
            }
        }
        
        static var x700: UIColor {
            if #available(iOS 13, *) {
                return UIColor.init { (trait) -> UIColor in
                    return trait.userInterfaceStyle == .dark ? UIColor.init(hex: "DD5D09") : UIColor.init(hex: "C45308")
                }
            } else {
                return UIColor.init(hex: "C45308")
            }
        }
        
        static var x600: UIColor {
            if #available(iOS 13, *) {
                return UIColor.init { (trait) -> UIColor in
                    return trait.userInterfaceStyle == .dark ? UIColor.init(hex: "F57119") : UIColor.init(hex: "EB640A")
                }
            } else {
                return UIColor.init(hex: "EB640A")
            }
        }
        
        static var x500: UIColor {
            if #available(iOS 13, *) {
                return UIColor.init { (trait) -> UIColor in
                    return trait.userInterfaceStyle == .dark ? UIColor.init(hex: "F78940") : UIColor.init(hex: "F67A28")
                }
            } else {
                return UIColor.init(hex: "F67A28")
            }
        }
        
        static var x400: UIColor {
            if #available(iOS 13, *) {
                return UIColor.init { (trait) -> UIColor in
                    return trait.userInterfaceStyle == .dark ? UIColor.init(hex: "F9A167") : UIColor.init(hex: "F8924F")
                }
            } else {
                return UIColor.init(hex: "F8924F")
            }
        }
        
        static var x300: UIColor {
            if #available(iOS 13, *) {
                return UIColor.init { (trait) -> UIColor in
                    return trait.userInterfaceStyle == .dark ? UIColor.init(hex: "FAB98F") : UIColor.init(hex: "F9AA76")
                }
            } else {
                return UIColor.init(hex: "F9AA76")
            }
        }
        
        static var x200: UIColor {
            if #available(iOS 13, *) {
                return UIColor.init { (trait) -> UIColor in
                    return trait.userInterfaceStyle == .dark ? UIColor.init(hex: "FDDEC9") : UIColor.init(hex: "FCCFB1")
                }
            } else {
                return UIColor.init(hex: "FCCFB1")
            }
        }
        
        static var x100: UIColor {
            if #available(iOS 13, *) {
                return UIColor.init { (trait) -> UIColor in
                    return trait.userInterfaceStyle == .dark ? UIColor.init(hex: "FEF6F0") : UIColor.init(hex: "FDE7D8")
                }
            } else {
                return UIColor.init(hex: "FDE7D8")
            }
        }
        
        static var x050: UIColor {
            if #available(iOS 13, *) {
                return UIColor.init { (trait) -> UIColor in
                    return trait.userInterfaceStyle == .dark ? UIColor.init(hex: "FFFFFF") : UIColor.init(hex: "FEF3EB")
                }
            } else {
                return UIColor.init(hex: "FEF3EB")
            }
        }
    }
}
