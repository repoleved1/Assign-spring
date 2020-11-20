//
//  PolicyViewController.swift
//  SantaCall
//
//  Created by Feitan on 11/05/2020.
//

import UIKit

class AboutViewController: BaseViewController {

    @IBOutlet weak var textView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        textView.backgroundColor = UIColor.clear
        textView.textColor = UIColor.black.withAlphaComponent(0.7)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
