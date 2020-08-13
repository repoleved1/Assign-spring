//
//  KHView.swift
//  Design
//
//  Created by Hoa on 6/21/17.
//  Copyright © 2017 SDC. All rights reserved.
//

import UIKit

//@IBDesignable
class KHView: UIView {
    
    @IBInspectable var shadow: Bool = false {
        didSet {
            if shadow {
                layer.shadowColor = UIColor.black.cgColor
                layer.shadowOffset = CGSize.zero
                layer.shadowOpacity = 0.1
                layer.shadowRadius = 4.0
                layer.masksToBounds = false
            }
        }
    }
    
    @IBInspectable var circle: Bool = false {
        didSet {
            if circle {
                layer.cornerRadius = self.bounds.height/2
                layer.masksToBounds = true
            }
        }
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        layoutIfNeeded()
        if circle {
            layer.cornerRadius = self.bounds.height/2
            layer.masksToBounds = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if circle {
            layer.cornerRadius = self.bounds.height/2
            layer.masksToBounds = true
        }
    }
}
