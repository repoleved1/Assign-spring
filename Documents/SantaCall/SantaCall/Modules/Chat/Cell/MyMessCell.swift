//
//  MyMessCell.swift
//  CallSanta
//
//  Created by feitan on 11/5/2020.

import UIKit

class MyMessCell: UITableViewCell {

    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var widthMessView: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        widthMessView.constant = 100
        setupView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupView(){
        viewContent.clipsToBounds = true
        viewContent.layer.cornerRadius = 20
        viewContent.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    
    func setupCell(mess: String) {
        widthMessView.constant = getWidthForMinecell(mess: mess)
        contentLabel.text = mess
        
        if IS_IPAD {
            contentLabel.font = UIFont.applicationFontRegular(23)
        } else {
            contentLabel.font = UIFont.applicationFontRegular(16)
        }
    }
    
    func getWidthForMinecell(mess: String) -> CGFloat{
        let texts = mess.split{ $0.isNewline}
        var maxWidth = CGFloat(0)
        for text in texts {
            let temp = String(text)
            var width = temp.width(withConstraintedHeight: 15, font: UIFont.applicationFontRegular(18))
            if IS_IPAD {
                width = temp.width(withConstraintedHeight: 15, font: UIFont.applicationFontRegular(23))
            }
            if maxWidth < width {
                maxWidth = width
            }
        }
        var space = CGFloat(100)
        if IS_IPAD {
            space = CGFloat(150)
        }
        if maxWidth + 35 < DEVICE_WIDTH - space {
            return maxWidth + 35
        }
        return DEVICE_WIDTH - space
    }
}
