//
//  LAAddAppViewController.swift
//  LockApp
//
//  Created by Feitan on 8/4/20.
//  Copyright © 2020 SingleViewApp. All rights reserved.
//

import UIKit

class LAAddAppViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
    }
    
     func setupUI() {
         searchBar.backgroundImage = UIImage()

         if let textfield = searchBar.value(forKey: "searchField") as? UITextField {

         textfield.backgroundColor = UIColor.white
             textfield.attributedPlaceholder = NSAttributedString(string: textfield.placeholder ?? "Search App", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])

         if let leftView = textfield.leftView as? UIImageView {
             leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
             leftView.tintColor = UIColor.white
         }
     }
    }

    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
