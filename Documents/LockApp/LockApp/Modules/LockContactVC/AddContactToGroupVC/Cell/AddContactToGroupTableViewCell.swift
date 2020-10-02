//
//  AddContactToGroupTableViewCell.swift
//  LockApp
//
//  Created by Feitan on 9/3/20.
//  Copyright © 2020 SingleViewApp. All rights reserved.
//

import UIKit

class AddContactToGroupTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameNumber: UILabel!
    @IBOutlet weak var lbNamePeople: UILabel!
    @IBOutlet weak var viewNamePeople: UIView!
    @IBOutlet weak var viewImageSelect: UIView!
    
    var isSearch = false
    var isSeletedAll = false
    
    var handleSelect: (() -> Void)?
    var handleUnselect: (() -> Void)?
    var imageChecks = UIImageView()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        config()
        
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        imageChecks.image = selected ? UIImage(named: "ic_selected") : UIImage(named: "ic_select")
        if selected {
            handleSelect?()
        }else{
            handleUnselect?()
        }
    }
    
    func config() {
        let imageCheck: UIImageView = {
            let imageCheck = UIImageView()
            imageCheck.frame = CGRect(x: 0, y: 0 , width: viewImageSelect.frame.width, height: viewImageSelect.frame.height)
            imageCheck.image = UIImage(named: ShareData.sharedInstance.nameImageTick)
            return imageCheck
        }()
        imageChecks = imageCheck
        viewImageSelect.addSubview(imageChecks)
    }
    
}
