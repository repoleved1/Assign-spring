//
//  TouchIDTableViewCell.swift
//  LockApp
//
//  Created by Feitan on 8/10/20.
//  Copyright © 2020 SingleViewApp. All rights reserved.
//

import UIKit

protocol TouchIDTableViewCellDelegate {
    func onTouchID()
}

class TouchIDTableViewCell: UITableViewCell {

    @IBOutlet weak var swTouchID: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let defaults = UserDefaults.standard
        
        if (defaults.object(forKey: "SwitchState") != nil) {
            swTouchID.isOn = defaults.bool(forKey: "SwitchState")
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func useTouchID(_ sender: Any) {
        let defaults = UserDefaults.standard
        
        if swTouchID.isOn {
            defaults.set(true, forKey: "SwitchState")
        } else {
            defaults.set(false, forKey: "SwitchState")
        }
    }
    
}
