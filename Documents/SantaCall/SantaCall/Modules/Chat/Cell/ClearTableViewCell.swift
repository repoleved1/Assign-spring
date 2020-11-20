//
//  ClearTableViewCell.swift
//  SantaCall
//
//  Created by Feitan on 11/6/20.
//

import UIKit

class ClearTableViewCell: UITableViewCell {

    @IBOutlet weak var lbInputing: UILabel!
    
    let lables = [".", "..", "..."]

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        var index = 0
        Timer.scheduledTimer(withTimeInterval: 0.4, repeats: true) { [self] (timer) in
            self.lbInputing.text = lables[index]
            index += 1
            if index == self.lables.count {
                index = 0
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
