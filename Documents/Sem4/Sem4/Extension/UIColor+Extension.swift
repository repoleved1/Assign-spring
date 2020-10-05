//
//  UIColor + Extension.swift
//  Lending
//
//  Created by Phạm Huy on 3/2/20.
//  Copyright © 2020 Phạm Huy. All rights reserved.
//

import Foundation
import UIKit
 
@objc extension UIColor {
   @objc convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
    @objc public class var mainColor: UIColor {
        return UIColor(hexString: "#0079B1")
    }
    
    @objc public class var greyColor: UIColor {
        return UIColor(hexString: "E7E7E7")
    }
    
    @objc public class var commonBlack: UIColor {
        return UIColor(hexString: "0C0033")
    }
    
    @objc public class var commonOrange: UIColor {
        return UIColor(hexString: "FE9A00")
    }
}

