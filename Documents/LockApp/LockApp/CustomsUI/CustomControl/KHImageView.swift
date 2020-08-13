//
//  KHImageView.swift
//  Design
//
//  Created by Hoa on 6/21/17.
//  Copyright © 2017 SDC. All rights reserved.
//

import UIKit

//@IBDesignable
class KHImageView: UIImageView {
    
    @IBInspectable var circle: Bool = false {
        didSet {
            if circle {
                layer.cornerRadius = self.bounds.height/2
                layer.masksToBounds = true
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if circle {
            layer.cornerRadius = self.bounds.height/2
            layer.masksToBounds = true
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if circle {
            layer.cornerRadius = self.bounds.height/2
            layer.masksToBounds = true
        }
    }
}
