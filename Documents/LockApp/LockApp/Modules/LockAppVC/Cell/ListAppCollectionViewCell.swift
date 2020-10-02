//
//  ListAppCollectionViewCell.swift
//  LockApp
//
//  Created by Feitan on 9/10/20.
//  Copyright © 2020 SingleViewApp. All rights reserved.
//

import UIKit

class ListAppCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var viewDelete: UIView!
    @IBOutlet weak var lbTitle: KHLabel!
    @IBOutlet weak var img: CustomImageView!
    @IBOutlet weak var imgTouchID: UIImageView!
    @IBOutlet weak var lblChild: KHLabel!

    var handleDeleteApp: (() -> Void)?
    var isPreview = false

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func config( _ obj : StoreObj, _ isDelete: Bool) {
        img.loadImageUsingCache(withUrl: obj.imageUrl, frame: img.frame)
        lbTitle.text = obj.name
        lblChild.text = obj.developer
        viewDelete.isHidden = !isDelete
        imgTouchID.isHidden = obj.touchID == "F"
    }

    @IBAction func handleDelete(_ sender: Any) {
        handleDeleteApp?()
    }
}
