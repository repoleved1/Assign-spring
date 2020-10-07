//
//  SBCustomButton.swift
//  Lending
//
//  Created by Phạm Huy on 3/2/20.
//  Copyright © 2020 Phạm Huy. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
@objc class NSGExtButton: ZFRippleButton {
    
    
    // MARK: - Override
    @objc override open var backgroundColor: UIColor? {
        didSet {
            super.backgroundColor = isEnabled ? enableBackgroundColor : disableBackgroundColor
        }
    }
    
    @objc override var isEnabled: Bool {
        didSet {
            backgroundColor = isEnabled ? enableBackgroundColor : disableBackgroundColor
        }
    }
    
    @objc @IBInspectable var cornerRadius: CGFloat = 5.0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
    @objc @IBInspectable var borderWidth: CGFloat = 1.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @objc @IBInspectable var borderColor: UIColor = .mainColor {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @objc @IBInspectable var enableBackgroundColor: UIColor = .mainColor {
        didSet {
            guard isEnabled else { return }
            backgroundColor = enableBackgroundColor
        }
    }
    
    @objc @IBInspectable var disableBackgroundColor: UIColor = .gray {
        didSet {
            guard !isEnabled else { return }
            backgroundColor = disableBackgroundColor
        }
    }
    
    // MARK: - Style
    @objc func setTitleColor(_ color: UIColor) {
        setTitleColor(color, for: .normal)
    }
    
    func setFont(_ font: UIFont) {
        titleLabel?.font = font
    }
    
    @objc func setTitle(_ title: String?) {
        setTitle(title, for: .normal)
    }
    
    // MARK: - LifeCycle
    @objc override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    @objc fileprivate func setupUI() {
        isExclusiveTouch = true
    }
}

