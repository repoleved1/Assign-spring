//
//  ContactTableViewCell.swift
//  LockApp
//
//  Created by Feitan on 8/20/20.
//  Copyright © 2020 SingleViewApp. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameNumber: UILabel!
    @IBOutlet weak var lbNamePeople: UILabel!
    @IBOutlet weak var viewNamePeople: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewNamePeople.layer.cornerRadius = viewNamePeople.frame.size.height / 2
        viewNamePeople.clipsToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
