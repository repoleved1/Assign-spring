//
//  SettingTableViewCell.swift
//  LockApp
//
//  Created by Feitan on 8/10/20.
//  Copyright © 2020 SingleViewApp. All rights reserved.
//

import UIKit

class SettingTableViewCell: UITableViewCell {

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var imageBack: UIImageView!
    
    var setting: SettingModel? {
           didSet {
               if let setting = setting {
                labelTitle.text = setting.title
               }
           }
       }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
