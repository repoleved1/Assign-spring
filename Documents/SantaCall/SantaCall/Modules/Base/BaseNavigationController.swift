//
//  BaseNavigationController.swift
//  RingtoneMaker
//
//  Created by ManhCuong on 9/23/20.
//

import UIKit

class BaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.isTranslucent = false
//        navigationBar.tintColor = UIColor.orange
        navigationBar.isHidden = true
        self.isNavigationBarHidden = false
        if IS_IPAD{
            navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black,
                                                 NSAttributedString.Key.font: UIFont.appplicationFontSemibold(30)]
        }else{
            navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black,
                                                 NSAttributedString.Key.font: UIFont.appplicationFontSemibold(20)]
        }
        self.delegate = self
        
        let imgBack = UIImage(named: "ic_back")
        navigationBar.backIndicatorImage = imgBack
        navigationBar.backIndicatorTransitionMaskImage = imgBack
        navigationItem.leftItemsSupplementBackButton = false

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            return .default
        }
    }
}

extension BaseNavigationController: UINavigationControllerDelegate{
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        let item = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        viewController.navigationItem.backBarButtonItem = item
    }
}
