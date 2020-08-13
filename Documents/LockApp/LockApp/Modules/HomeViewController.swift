//
//  HomeViewController.swift
//  LockApp
//
//  Created by Feitan on 7/30/20.
//  Copyright © 2020 SingleViewApp. All rights reserved.
//

import UIKit
import Contacts

class HomeViewController: BaseVC, SetTingViewControllerDelegate {
    
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
    
    @IBAction func openLockAlbum(_ sender: Any) {
        let lockAlbumsVC = LALockAlbumViewController()
        navigationController?.pushViewController(lockAlbumsVC, animated: true)
    }
    
    @IBAction func openLockContact(_ sender: Any) {
    }
    
    func openCellSlideRightMenu(index: Int) {
        switch index {
        case 0:
            self.dismiss(animated: false, completion: nil)
            TAppDelegate.initCode(type: 1)
            break
        case 1:
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

