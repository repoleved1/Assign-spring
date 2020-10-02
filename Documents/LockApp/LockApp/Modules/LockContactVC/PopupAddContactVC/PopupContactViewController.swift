//
//  PopupContactViewController.swift
//  LockApp
//
//  Created by Feitan on 8/19/20.
//  Copyright © 2020 SingleViewApp. All rights reserved.
//

import UIKit

protocol PopupContactViewControllerDelegate {
    func openVC(index: Int)
}

class PopupContactViewController: UIViewController {

    var handleDismissVC: (() ->Void)?
    var delegate: PopupContactViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    @IBAction func dissmiss(_ sender: Any) {
        handleDismissVC?()
        
    }
    
    @IBAction func addGroup(_ sender: Any) {
        let addGroupVC = AddContactToGroupViewController()
//        navigationController?.pushViewController(addGroupVC, animated: true)
        
        delegate?.openVC(index: 1)
        
    }
    
    @IBAction func addContact(_ sender: Any) {
        delegate?.openVC(index: 2)
    }
    
}
