//
//  SantaClausMessCell.swift
//  CallSanta
//
//  Created by feitan on 11/5/2020.
//

import UIKit

class SantaClausMessCell: UITableViewCell {

    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setupView(){
        viewContent.clipsToBounds = true
        viewContent.layer.cornerRadius = 20
        viewContent.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    
    func setupCell(content: String) {
        contentLabel.text = content
        
        if IS_IPAD {
            contentLabel.font = UIFont.applicationFontRegular(23)
        } else {
            contentLabel.font = UIFont.applicationFontRegular(16)
        }
    }
    
}
