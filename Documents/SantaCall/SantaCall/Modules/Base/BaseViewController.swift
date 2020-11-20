//
//  BaseViewController.swift
//  BitEclipse
//
//  Created by Nhuom Tang on 23/4/19.
//  Copyright © 2019 Nhuom Tang. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    var popRecognizer: InteractivePopRecognizer?
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInteractiveRecognizer()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func setInteractiveRecognizer() {
           guard let controller = navigationController else { return }
           popRecognizer = InteractivePopRecognizer(controller: controller)
           controller.interactivePopGestureRecognizer?.delegate = popRecognizer
    }
    
    func setRightBarButton(icon: String = "ic_back", title: String = "") {
        let width = 50
        
        let savedButton = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: width, height: 50))
        if icon.count > 0 {
            savedButton.setImage(UIImage.init(named: icon), for: .normal)
            savedButton.imageView?.image = savedButton.imageView?.image?.withRenderingMode(.alwaysTemplate)
            savedButton.imageView?.tintColor = UIColor.white
        }
        
        savedButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        if title.count > 0 {
            savedButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        } else {
            savedButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        }
        
        savedButton.setTitle(title, for: .normal)
        savedButton.setTitleColor(UIColor.white, for: .normal)
        savedButton.addTarget(self, action: #selector(didSelectRightBarButtonAction(sender:)), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: savedButton)
    }
    
    func setLeftBarButton(icon: String = "ic_back") {
        let width = 50
        
        let leftBarButton = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: width, height: 50))
        leftBarButton.setImage(UIImage.init(named: icon), for: .normal)
        leftBarButton.imageView?.image = leftBarButton.imageView?.image?.withRenderingMode(.alwaysTemplate)
        leftBarButton.imageView?.tintColor = UIColor.white
        leftBarButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        leftBarButton.addTarget(self, action: #selector(didSelectLeftBarButtonAction(sender:)), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: leftBarButton)
    }
    
    func setLeftBarButton(icon: UIImage) {
        let width = 50
        
        let leftBarButton = UIButton(type: .custom)
        leftBarButton.frame = CGRect.init(x: 0, y: 0, width: width, height: 50)
        leftBarButton.setImage(icon, for: .normal)
        leftBarButton.imageView?.contentMode = .scaleAspectFit
        leftBarButton.heightAnchor.constraint(equalToConstant: 36).isActive = true
        leftBarButton.widthAnchor.constraint(equalToConstant: 36).isActive = true
        leftBarButton.addTarget(self, action: #selector(didSelectLeftBarButtonAction(sender:)), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: leftBarButton)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    func setNavigation(isHidden: Bool) {
        navigationController?.setNavigationBarHidden(isHidden, animated: false)
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
        return .portrait
    }
   
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .portrait
    }
    
    @objc func didSelectRightBarButtonAction(sender: UIButton) {
        print("delete in basecontroller")
    }
    
    @objc func didSelectLeftBarButtonAction(sender: UIButton) {
        
    }
}
