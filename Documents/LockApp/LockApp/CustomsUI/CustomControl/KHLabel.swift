//
//  KHLabel.swift
//  Design
//
//  Created by Hoa on 6/21/17.
//  Copyright © 2017 SDC. All rights reserved.
//

import UIKit

//@IBDesignable
class KHLabel: UILabel {
    
    
    @IBInspectable var circle: Bool = false {
        didSet {
            if circle {
                layer.cornerRadius = self.bounds.height/2
                layer.masksToBounds = true
            }
        }
    }
    
    @IBInspectable var gradionColor: Bool = false {
        didSet {
            if gradionColor {
                self.applyGradientWith(startColor: UIColor.init(named: "ff00ea")!, endColor: UIColor.init(named: "6300ff")!)
            }
        }
    }
    
    @IBInspectable var isAttributeString: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if !isAttributeString {
            font = Common.getFontForDeviceWithFontDefault(fontDefault: font)
        }
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        if !isAttributeString {
            text = text?.localized
        }
        layoutIfNeeded()
        if circle {
            layer.cornerRadius = self.bounds.height/2
            layer.masksToBounds = true
        }
    }
}
