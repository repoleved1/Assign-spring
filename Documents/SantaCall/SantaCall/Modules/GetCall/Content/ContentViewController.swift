//
//  ContentViewController.swift
//  SantaCall
//
//  Created by Feitan on 11/2/20.
//

import UIKit

protocol ContentViewControllerDelegate {
    func setTypePhoneCall()
}

class ContentViewController: UIViewController {

    //MARK: -- Outlet
    @IBOutlet weak var btSelect: UIButton!
    @IBOutlet weak var imageContent: UIImageView!
    
    //MARK: -- Varibles
    var nameImage = ""
    var delegate: ContentViewControllerDelegate?

    //MARK: -- Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imageContent.image = UIImage.init(named: nameImage)
    }

    // MARK: -- Actions
    @IBAction func openDetailVC(_ sender: Any) {

        delegate?.setTypePhoneCall()
    }
}
