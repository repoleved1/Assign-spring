//
//  SettingViewController.swift
//  SantaCall
//
//  Created by Feitan on 11/5/20.
//

import UIKit
import MessageUI

class SettingViewController: UIViewController {

    //MARK: -- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    //MARK: -- Actions
    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func openInAppVC(_ sender: Any) {
    }
    
    @IBAction func openPrivacyVC(_ sender: Any) {
        let privacyVC = PolicyViewController()
        navigationController?.pushViewController(privacyVC, animated: true)
    }
    
    @IBAction func rateApp(_ sender: Any) {
        
    }
    
    @IBAction func support(_ sender: Any) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([mailSupport])
            mail.setSubject("Regarding")
            present(mail, animated: true)
        } else {
            self.showError(message: "Mail services are not available")
        }
    }
    
    @IBAction func about(_ sender: Any) {
        let aboutVC = AboutViewController()
        navigationController?.pushViewController(aboutVC, animated: true)
    }
}

//MARK: -- MFMailComposeViewControllerDelegate
extension SettingViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
