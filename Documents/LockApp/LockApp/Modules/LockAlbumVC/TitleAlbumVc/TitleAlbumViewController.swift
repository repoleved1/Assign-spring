//
//  TitleAlbumViewController.swift
//  LockApp
//
//  Created by Feitan on 8/12/20.
//  Copyright © 2020 SingleViewApp. All rights reserved.
//

import UIKit

class TitleAlbumViewController: UIViewController {
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var textFieldAlbum: UITextField!
    
    var value = ""
    var isEdits = false
    var handleDismissVC: (() ->Void)?
    var handleChangerText: ((String) ->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelTitle.text = isEdits ? "Edit Album" : "Create new Album"
        textFieldAlbum.text = isEdits ? value : ""
    }

    @IBAction func dissmiss(_ sender: Any) {
        handleDismissVC?()
    }
    
    @IBAction func createAlbum(_ sender: Any) {
        handleChangerText?(textFieldAlbum.text ?? "")
        handleDismissVC?()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
