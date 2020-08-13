//
//  LALockAlbumViewController.swift
//  LockApp
//
//  Created by Feitan on 8/10/20.
//  Copyright © 2020 SingleViewApp. All rights reserved.
//

import UIKit

class LALockAlbumViewController: BaseVC {
    
    //MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navi: NavigationView!
    @IBOutlet weak var viewLayout: UIView!
    
    var arr = [AlbumObj]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "LockAlbumsTableViewCell", bundle: nil), forCellReuseIdentifier: "LockAlbumsTableViewCell")
        setupUI()
    }
    
    
    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func createAlbums(_ sender: Any) {
//        if PaymentManager.shared.isPurchaseAlbum() {
            let contentVC = TitleAlbumViewController.init(nibName: "TitleAlbumViewController", bundle: nil)
            
            let popupVC = PopupViewController(contentController: contentVC, popupWidth: ScreenSize.SCREEN_WIDTH, popupHeight: ScreenSize.SCREEN_HEIGHT)
            contentVC.handleDismissVC = {
                popupVC.dismiss(animated: true, completion: {
                    
                })
            }
            contentVC.handleChangerText = { (text) in
                print("The new number is \(text)")
                let obj = AlbumObj()
                obj.name = text
                obj.saveAlbumList(true)
                self.initData()
            }
//
            self.present(popupVC, animated: true)
//        }else{
            //                let viewController = StoreViewController.init(nibName: String.init(describing: StoreViewController.self).nibWithNameiPad(), bundle: nil)
            //                self.present(viewController, animated: true, completion: nil)
//        }
    }
    
}

extension LALockAlbumViewController {
    func setupUI() {
        navi.title = ""
        navi.handleBack = {
            self.navigationController?.popViewController(animated: true)
        }
//        navi.handleActionRight = { (tag) in
//            if PaymentManager.shared.isPurchaseAlbum() {
//                let contentVC = TitleAlbumViewController.init(nibName: "TitleAlbumViewController", bundle: nil)
//
//                let popupVC = PopupViewController(contentController: contentVC, popupWidth: ScreenSize.SCREEN_WIDTH, popupHeight: ScreenSize.SCREEN_HEIGHT)
//                contentVC.handleDismissVC = {
//                    popupVC.dismiss(animated: true, completion: {
//
//                    })
//                }
//                contentVC.handleChangerText = { (text) in
//                    print("The new number is \(text)")
//                    let obj = AlbumObj()
//                    obj.name = text
//                    obj.saveAlbumList(true)
//                    self.initData()
//                }
//
//                self.present(popupVC, animated: true)
//            }else{
//                //                let viewController = StoreViewController.init(nibName: String.init(describing: StoreViewController.self).nibWithNameiPad(), bundle: nil)
//                //                self.present(viewController, animated: true, completion: nil)
//            }
//        }
        
        // View Layout
        viewLayout.clipsToBounds = true
        viewLayout.layer.cornerRadius = 50
        viewLayout.layer.maskedCorners = [.layerMinXMinYCorner]
    }
    
    func initData() {
        arr.removeAll()
        let obj = AlbumObj("All")
        obj.id = "-1"
        arr.append(obj)
        arr.append(contentsOf: albumManager.getAllAlbum())
        tableView.reloadData()
        tableView.backgroundView = arr.count > 0 ? nil : Common.viewNoData()
    }
}

extension LALockAlbumViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LockAlbumsTableViewCell", for: indexPath) as! LockAlbumsTableViewCell
        cell.config(arr[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(at: indexPath)
        let edit = editAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: indexPath.row == 0 ? [] : [delete,edit])
    }
    
    @available(iOS 11.0, *)
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction{
        let action = UIContextualAction(style: .normal, title: "") { (action, view, completion) in
            _ = UIAlertController.present(style: .alert, title: "app_name".localized, message: "txt_delete_selector".localized, attributedActionTitles: [("txt_ok".localized, .default), ("txt_cancel".localized, .cancel)], handler: { (action) in
                if action.title == "txt_ok".localized {
                    let obj = self.arr[indexPath.row]
                    obj.deleteAlbum()
                    self.initData()
                }
            })
            completion(true)
        }
        action.image = UIImage(named: "ic_delete")?.sd_resizedImage(with: CGSize(width: 25, height: 25), scaleMode: .aspectFit)
        action.backgroundColor = UIColor("FF3737", alpha: 1.0)
        
        return action
    }
    @available(iOS 11.0, *)
    func editAction(at indexPath: IndexPath) -> UIContextualAction{
        let action = UIContextualAction(style: .normal, title: "") { (action, view, completion) in
            let contentVC = TitleAlbumViewController.init(nibName: "TitleAlbumViewController", bundle: nil)
            contentVC.isEdits = true
            contentVC.value = self.arr[indexPath.row].name
            
            let popupVC = PopupViewController(contentController: contentVC, popupWidth: ScreenSize.SCREEN_WIDTH, popupHeight: ScreenSize.SCREEN_HEIGHT)
            contentVC.handleDismissVC = {
                popupVC.dismiss(animated: true, completion: {
                    
                })
            }
            contentVC.handleChangerText = { (text) in
                print("The new number is \(text)")
                let obj = self.arr[indexPath.row]
                obj.name = text
                obj.updateAlbum()
                self.initData()
            }
            
            self.present(popupVC, animated: true)
            completion(true)
        }
        action.image = UIImage(named: "ic_edit")?.sd_resizedImage(with: CGSize(width: 25, height: 25), scaleMode: .aspectFit)
        action.backgroundColor = UIColor("ECDCFE", alpha: 1.0)
        
        return action
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = LAGaleryViewController.init(nibName: "GalleryVC", bundle: nil)
        vc.idAlbum = arr[indexPath.item].id
        vc.objGallery = arr[indexPath.item]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension UIViewController {
    func showInputDialog(title:String? = nil,
                         subtitle:String? = nil,
                         actionTitle:String? = "Add",
                         cancelTitle:String? = "Cancel",
                         inputPlaceholder:String? = nil,
                         inputKeyboardType:UIKeyboardType = UIKeyboardType.default,
                         cancelHandler: ((UIAlertAction) -> Swift.Void)? = nil,
                         actionHandler: ((_ text: String?) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        alert.addTextField { (textField:UITextField) in
            textField.placeholder = inputPlaceholder
            textField.keyboardType = inputKeyboardType
        }
        alert.addAction(UIAlertAction(title: actionTitle, style: .destructive, handler: { (action:UIAlertAction) in
            guard let textField =  alert.textFields?.first else {
                actionHandler?(nil)
                return
            }
            actionHandler?(textField.text)
        }))
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: cancelHandler))
        
        self.present(alert, animated: true, completion: nil)
    }
}

