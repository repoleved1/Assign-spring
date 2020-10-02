//
//  SearchAppCellTableViewCell.swift
//  LockApp
//
//  Created by Feitan on 9/10/20.
//  Copyright © 2020 SingleViewApp. All rights reserved.
//

import UIKit

class SearchAppCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var img: CustomImageView!
    @IBOutlet weak var lbTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func config(_ obj : StoreAppObj) {
        img.loadImageUsingCache(withUrl: obj.artworkUrl512, frame: img.frame)
        lbTitle.text = obj.trackName
    }
    
}
