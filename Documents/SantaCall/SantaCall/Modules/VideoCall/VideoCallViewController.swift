//
//  VideoCallViewController.swift
//  SantaCall
//
//  Created by Feitan on 11/3/20.
//

import UIKit

class VideoCallViewController: BaseViewController {

    //MARK: -- Outlet
    @IBOutlet weak var btCall: UIButton!
    
    //MARK: -- Varibles
    var typeCall: TypeCall = .phone
    
    //MARK: -- Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
    }

    private func setupUI() {
        btCall.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 3,
          delay: 0,
          usingSpringWithDamping: 0.2,
          initialSpringVelocity: 6.0,
          options: .allowUserInteraction,
          animations: { [weak self] in
            self?.btCall.transform = .identity
          },
          completion: { finished in
            self.setupUI()
          })
    }

    //MARK: -- Action
    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func openDetailVC(_ sender: Any) {
        let detailVC = GetCallViewController()
        detailVC.typeCall = typeCall
        navigationController?.pushViewController(detailVC, animated: true)
    }

}
