//
//  HomeViewController.swift
//  LockApp
//
//  Created by Feitan on 7/30/20.
//  Copyright © 2020 SingleViewApp. All rights reserved.
//

import UIKit
import Contacts
import MessageUI

class HomeViewController: BaseVC, SetTingViewControllerDelegate, MFMailComposeViewControllerDelegate {
    
    let transiton = SlideInTransition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    class func instance() -> HomeViewController {
        let vc = HomeViewController()
        return vc
    }
    
    @IBAction func openSetting(_ sender: UIButton) {
        let settingVC = SetTingViewController()
        settingVC.modalPresentationStyle = .overCurrentContext
        settingVC.transitioningDelegate = self
        settingVC.delegate = self
        present(settingVC, animated: true)
    }
    
    @IBAction func openLockApp(_ sender: Any) {
        let lockAppVC = LALockAppViewController()
        navigationController?.pushViewController(lockAppVC, animated: true)
    }
    
    @IBAction func openLockAlbum(_ sender: UIButton) {
        let lockAlbumsVC = LALockAlbumViewController()
        navigationController?.pushViewController(lockAlbumsVC, animated: true)
    }
    
    @IBAction func openLockContact(_ sender: UIButton) {
        let lockContactVC = LALockContactViewController()
        navigationController?.pushViewController(lockContactVC, animated: true)
//        let lockAlbumsVC = LALockAlbumViewController()
//        navigationController?.pushViewController(lockAlbumsVC, animated: true)
    }
    
    func openCellSlideRightMenu(index: Int) {
        switch index {
        case 0:
            self.dismiss(animated: false, completion: nil)
            TAppDelegate.initCode(type: 1)
            break
        case 1:
            self.dismiss(animated: false, completion: nil)
            break
        case 2:
            self.dismiss(animated: false, completion: nil)
            let privacyVC = PrivacyViewController()
            navigationController?.pushViewController(privacyVC, animated: true)
            break
        case 3:
            self.dismiss(animated: false, completion: nil)
            break
        case 4:
            self.dismiss(animated: false, completion: nil)
            if MFMailComposeViewController.canSendMail() {
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setToRecipients(["tueanhoang.devios2011@gmail.com"])
                mail.setSubject("Regarding")
                
                present(mail, animated: true)
            } else {
                Common.showAlert("Mail services are not available")
            }
            break
        case 5:
            self.dismiss(animated: false, completion: nil)
            let text = [ "http://itunes.apple.com/app/id" + appId ]
            let activityViewController = UIActivityViewController(activityItems: text , applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)
            break
        default:
            break
        }
        
    }
}

extension HomeViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transiton.isPresenting = true
        return transiton
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transiton.isPresenting = false
        return transiton
    }
}

