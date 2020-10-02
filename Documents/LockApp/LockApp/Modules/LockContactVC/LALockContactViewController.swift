//
//  LALockContactViewController.swift
//  LockApp
//
//  Created by Feitan on 8/18/20.
//  Copyright © 2020 SingleViewApp. All rights reserved.
//

import UIKit
import CarbonKit
import Contacts
import ContactsUI
import AddressBook
import SwiftyContextMenu


class LALockContactViewController: BaseVC, PopupContactViewControllerDelegate {
    
    
    //MARK: - IBOutlet
    @IBOutlet weak var viewPopup: UIView!
    @IBOutlet weak var navi: NavigationView!
    @IBOutlet var contextMenuButtons: [UIButton]!
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var constraintTop: NSLayoutConstraint!
    @IBOutlet weak var heightViewContent: NSLayoutConstraint!
    
    let contactViewController: CNContactViewController = CNContactViewController(forNewContact: nil)
    var arrContact = [ItemFavorites]()
    let getContact = GetContact()
    
    override func viewDidLoad() {
        
        constraintTop = heightViewContent
        
        // View Layout
//        viewContent.clipsToBounds = true
//        viewContent.layer.cornerRadius = 50
//        viewContent.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
                
        super.viewDidLoad()
//        navi.handleBack = {
//            self.clickBack()
//        }
//        
//        navi.title = ""
        
        // Tab Navigation
        let items = ["CONTACTS", "GROUPS"]
        
        let carbonTabSwipeNavigation = CarbonTabSwipeNavigation(items: items, delegate: self)
        
        carbonTabSwipeNavigation.setIndicatorHeight(2)
        carbonTabSwipeNavigation.setIndicatorColor(UIColor.init("B82FD9", alpha: 1.0))
        carbonTabSwipeNavigation.setTabBarHeight(isIPad ? 60 : 40)
        carbonTabSwipeNavigation.setNormalColor(UIColor.init("ECDCFE", alpha: 1.0), font: .boldSystemFont(ofSize: isIPad ? 23 : 16) )
        carbonTabSwipeNavigation.setSelectedColor(UIColor.init("B82FD9", alpha: 1.0), font: .boldSystemFont(ofSize: isIPad ? 23 : 16))
        carbonTabSwipeNavigation.carbonSegmentedControl?.setWidth(UIScreen.main.bounds.size.width/2, forSegmentAt: 0)
        carbonTabSwipeNavigation.carbonSegmentedControl?.setWidth(UIScreen.main.bounds.size.width/2, forSegmentAt: 1)
        
        carbonTabSwipeNavigation.carbonSegmentedControl?.backgroundColor = .white
        //                carbonTabSwipeNavigation.carbonSegmentedControl?.setWidth(UIScreen.main.bounds.size.width/3, forSegmentAt: 2)
                
        carbonTabSwipeNavigation.insert(intoRootViewController: self, andTargetView: viewContent)
        
        carbonTabSwipeNavigation.carbonSegmentedControl?.indicatorWidth = 20
        //
        //
//                navi.handleActionRight = { (tag) in
//                    if tag == 3 {
//                        self.navigationController?.pushViewController(AddContactToGroupViewController(ShareData.sharedInstance.arrContact, titleStr: ""), animated: true)
//                    }
//                }
    }
    
    func setupUI() {
        
        // add more
//        let addContact = ContextMenuAction(title: "Add New Contact",
//                                           image: UIImage(named: "heart.fill"),
//                                           action: { _ in  })
//        let addGroup = ContextMenuAction(title: "Add New Group",
//                                         image: UIImage(named: "square.and.arrow.up.fill"),
//                                         action: { _ in print("square") })
//        let actions = [addContact, addGroup]
//        let contextMenu = ContextMenu(
//            title: nil,
//            actions: actions,
//            delegate: self)
//        contextMenuButtons.forEach {
//            $0.addContextMenu(contextMenu, for: .tap(numberOfTaps: 1), .longPress(duration: 0.3))
//        }
    }
    
    func openVC(index: Int) {
        switch index {
        case 1:
            self.dismiss(animated: true, completion: nil)
            let addGroupVC = AddContactToGroupViewController()
            navigationController?.pushViewController(addGroupVC, animated: true)
            break
        case 2:
            self.dismiss(animated: true, completion: nil)
            self.showNewContactViewController()
            break
        default:
            break
        }
      }
    
    func showNewContactViewController() {
           let contactViewController1: CNContactViewController = CNContactViewController(forNewContact: nil)
           contactViewController1.contactStore = CNContactStore()
           contactViewController1.delegate = self
           self.navigationController?.setNavigationBarHidden(false, animated: true)
           
           self.navigationController?.pushViewController(contactViewController1, animated: true)
       }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    @IBAction func editContact(_ sender: Any) {
        let addContactVC = AddContactViewController(ShareData.sharedInstance.arrContact, titleStr: "")
        navigationController?.pushViewController(addContactVC, animated: true)
    }
    
    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addMore(_ sender: Any) {
        //        setupUI()
        let contentVC = PopupContactViewController.init(nibName: "PopupContactViewController", bundle: nil)
        
        let popupVC = PopupViewController(contentController: contentVC, popupWidth: ScreenSize.SCREEN_WIDTH, popupHeight: ScreenSize.SCREEN_HEIGHT)
        contentVC.handleDismissVC = {
            popupVC.dismiss(animated: true, completion: {
                
            })
        }
        
        contentVC.delegate = self
        self.present(popupVC, animated: true)
    }
    
    
}

extension LALockContactViewController: CarbonTabSwipeNavigationDelegate {
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        return localDataShared.viewController[Int(index)]
    }
}

extension LALockContactViewController: UIContextMenuInteractionDelegate {
    
    @available(iOS 13.0, *)
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        
        let contact = UIAction(title: "Looooooooooooong title", image: UIImage(systemName: "heart.fill"), handler: { _ in })
        let group = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up.fill"), handler: { _ in })
        
        let actions = [contact, group]
        
        return UIContextMenuConfiguration(identifier: nil,
                                          previewProvider: nil) { _ in UIMenu(title: "Actions", children: actions) }
    }
    
}

extension LALockContactViewController: ContextMenuDelegate {
    
    func contextMenuWillAppear(_ contextMenu: ContextMenu) {
        print("context menu will appear")
    }
    
    func contextMenuDidAppear(_ contextMenu: ContextMenu) {
        print("context menu did appear")
    }
}

extension LALockContactViewController: CNContactViewControllerDelegate{
    
    func contactViewController(_ viewController: CNContactViewController, didCompleteWith contact: CNContact?) {
        
        self.navigationController?.popViewController(animated: true)
        getContact.showContact {
            NotificationCenter.default.post(name: NSNotification.Name("reloadContact"), object: nil)
        }
    }
    
    func contactViewController(_ viewController: CNContactViewController, shouldPerformDefaultActionFor property: CNContactProperty) -> Bool {
        return true
    }
    
}
