//
//  DetailAppViewController.swift
//  LockApp
//
//  Created by Feitan on 9/10/20.
//  Copyright © 2020 SingleViewApp. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol DetailAppViewControllerDelegate {
    func useTouchIDForApp(index: Int, isOn: String)
    
}

class DetailAppViewController: BaseVC {
    
    
    //MARK: - IBOutlet
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var navi: NavigationView!
    @IBOutlet weak var textViewNote: KHTextView!
    @IBOutlet weak var tfWebsite: KHTextField!
    @IBOutlet weak var tfPasscode: KHTextField!
    @IBOutlet weak var tfUserName: KHTextField!
    @IBOutlet weak var lbChildNameApp: UILabel!
    @IBOutlet weak var lbNameApp: UILabel!
    @IBOutlet weak var swId: UISwitch!
    @IBOutlet weak var imgIconApp: CustomImageView!
    @IBOutlet weak var ctrHeightView: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var lbTitle: UILabel!
    
    var appObj: StoreAppObj?
    var storeObj = StoreObj()
    var isEdit = false
    var useTouchID = true
    let defaults = UserDefaults.standard
    var index = 0

    var delegate: DetailAppViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        
        if (defaults.object(forKey: "SwitchState") != nil) {
            swId.isOn = defaults.bool(forKey: "SwitchState")
        }
        
        tfUserName.tag = 1
        tfPasscode.tag = 2
        tfWebsite.tag = 3
        textViewNote.tag = 4
        
        // View Layout
        scrollView.clipsToBounds = true
        scrollView.layer.cornerRadius = 50
        scrollView.layer.maskedCorners = [.layerMinXMinYCorner]
        
        lbTitle.text = appObj?.trackName ?? ""
        
        
        //        navi.handleBack = {
        //            self.clickBack()
        //        }
        //
        //        navi.title = ""
        
        if isEdit == true {
            lbTitle.text = appObj?.trackName ?? "Store App Detail"
        }
        
        tfUserName.text = storeObj.username
        tfPasscode.text = storeObj.password
        
        swId.isOn = storeObj.touchID == "T"
        
        tfWebsite.placeHolderColor = UIColor.init(hex: "F4EAFF")
        tfWebsite.placeholderFont = UIFont.init(name: "Quicksand-Medium", size: 20)
        
        tfPasscode.placeHolderColor = UIColor.init(hex: "F4EAFF")
        tfPasscode.placeholderFont = UIFont.init(name: "Quicksand-Medium", size: 20)
        
        tfUserName.placeHolderColor = UIColor.init(hex: "F4EAFF")
        tfUserName.placeholderFont = UIFont.init(name: "Quicksand-Medium", size: 20)
        
        textViewNote.placeholder = "Add Notes"
        textViewNote.placeholderFont = UIFont.init(name: "Quicksand-Medium", size: 20)
        textViewNote.placeholderColor = UIColor.init(hex: "F4EAFF")
        textViewNote.text = storeObj.note
        
        if isEdit {
            appObj = StoreAppObj(trackId: storeObj.appID , bundleId: storeObj.buildID, trackName: storeObj.name, artistId: storeObj.aID , artistName: storeObj.developer, artworkUrl512: storeObj.imageUrl, sellerUrl: storeObj.website, trackViewUrl: storeObj.trackViewUrl, touchID: storeObj.touchID)
        }
        
        imgIconApp.loadImageUsingCache(withUrl: appObj?.artworkUrl512 ?? "", frame: imgIconApp.frame)
        lbNameApp.text = appObj?.trackName ?? ""
        //        lbChildNameApp.text = appObj?.artistName ?? ""
        tfWebsite.text = appObj?.sellerUrl ?? ""
        
        setupToolbar()
    }
    
    func setupToolbar(){
        //Create a toolbar
        let bar = UIToolbar()
        //Create a done button with an action to trigger our function to dismiss the keyboard
        let doneBtn = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissMyKeyboard))
        //Create a felxible space item so that we can add it around in toolbar to position our done button
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        //Add the created button items in the toobar
        bar.items = [flexSpace, flexSpace, doneBtn]
        bar.sizeToFit()
        //Add the toolbar to our textfield
        tfUserName.inputAccessoryView = bar
        tfPasscode.inputAccessoryView = bar
        tfWebsite.inputAccessoryView = bar
        textViewNote.inputAccessoryView = bar
    }
    @objc func dismissMyKeyboard(){
        view.endEditing(true)
    }
    
    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func changeSwitch(_ sender: Any) {
//        let defaults = UserDefaults.standard
//
//        if swId.isOn {
//            defaults.set(true, forKey: "SwitchState")
//        } else {
//            defaults.set(false, forKey: "SwitchState")
//        }
    }
    
    @IBAction func Save(_ sender: Any) {
        storeObj.aID = appObj?.artistId ?? 0
        storeObj.appID = appObj?.trackId ?? 0
        storeObj.name = appObj?.trackName ?? ""
        storeObj.developer = appObj?.artistName ?? ""
        storeObj.imageUrl = appObj?.artworkUrl512 ?? ""
        storeObj.trackViewUrl = appObj?.trackViewUrl ?? ""
        storeObj.username = tfUserName.text ?? ""
        storeObj.password = tfPasscode.text ?? ""
        storeObj.note = textViewNote.text
        storeObj.website = tfWebsite.text ?? ""
        if swId.isOn {
            storeObj.touchID = "T"
        } else {
            storeObj.touchID = "F"
        }
        
        delegate?.useTouchIDForApp(index: index, isOn: storeObj.touchID)
        // save or update
        storeObj.updateStore(true)
        
        let mainViewControllerVC = self.navigationController?.viewControllers.first(where: { (viewcontroller) -> Bool in
            return viewcontroller is LALockAppViewController
        })
        
        if let mainViewControllerVC = mainViewControllerVC {
            navigationController?.popToViewController(mainViewControllerVC, animated: true)
        }
    }
    
    func fecthScheme() -> [SchemeObj] {
        let path = Bundle.main.path(forResource: "data", ofType: "json")!
        let jsonString = try? String(contentsOfFile: path, encoding: String.Encoding.utf8)
        let json = JSON(parseJSON: jsonString!)
        
        let jsonArray = json.arrayValue
        var arr = [SchemeObj]()
        jsonArray.forEach { (json) in
            arr.append(SchemeObj(json))
        }
        return arr
    }
}

struct SchemeObj {
    var appName = ""
    var schemeURL = ""
    
    init(_ data: JSON) {
        self.appName = data["appName"].stringValue
        self.schemeURL = data["scheme"].stringValue
    }
}


