//
//  File.swift
//  Welio
//
//  Created by Pham Khanh Hoa on 4/12/17.
//  Copyright © 2017 SDC. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration

let appleLanguages = "appleLanguages"

let TAppDelegate = UIApplication.shared.delegate as! AppDelegate
let TApp = UIApplication.shared

class Common {
    static func showAlert(_ strMessage: String){
        self.dismissAllAlert()
        let alert = AlertController(title: "app_name".localized, message: strMessage.localized, preferredStyle: UIAlertController.Style.alert)
        let okAction: UIAlertAction = UIAlertAction(title: "txt_ok".localized, style: .cancel) { action -> Void in
            
        }
        self.addNotificationCenter(observer: alert, selector: #selector(AlertController.hideAlertController), key: NotificationCenterKey.DismissAllAlert)
        alert.addAction(okAction)
        TAppDelegate.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    static func dismissAllAlert() {
        Common.postNotificationCenter(key: NotificationCenterKey.DismissAllAlert, object: nil)
    }
    
    class func getFontForDeviceWithFontDefault(fontDefault:UIFont) -> UIFont {
        var font:UIFont = fontDefault
        var sizeScale: CGFloat = 1
        if DeviceType.IS_IPAD {
            sizeScale = 1.5
        }else if DeviceType.IS_IPHONE_6 || DeviceType.IS_IPHONE_7 {
            sizeScale = 0.95
        }else if DeviceType.IS_IPHONE_5 {
            sizeScale = 0.9
        }
        font = UIFont(name: font.fontName, size: font.pointSize * sizeScale)!
        return font
    }
    
    class func heightOfText(_ text: String, width: CGFloat, font: UIFont) -> CGFloat {
        let size = CGSize(width: width, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let attributes = [NSAttributedString.Key.font: font]
        let rectangleHeight = String(text).boundingRect(with: size, options: options, attributes: attributes, context: nil).height
        return rectangleHeight
    }
    
    class func postNotificationCenter(key: String, object: Any?) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: key), object: object)
    }
    
    class func addNotificationCenter(observer: Any,selector: Selector, key: String) {
        removeNotificationCenter(observer: observer, key: key)
        NotificationCenter.default.addObserver(observer, selector: selector, name: NSNotification.Name(rawValue: key), object: nil)
    }
    
    class func removeNotificationCenter(observer: Any, key: String) {
        NotificationCenter.default.removeObserver(observer, name: NSNotification.Name(rawValue: key), object: nil)
    }
    
    class func formatNumber(number : Int) -> String {
        let formater = NumberFormatter()
        formater.groupingSeparator = ","
        formater.numberStyle = .decimal
        return formater.string(from: NSNumber(value:number))!
    }
    
    class func viewNoData(_ txt: String = "txt_no_data") -> UIView{
        if let window = UIApplication.shared.keyWindow {
            let view = UIView()
            window.addSubview(view)
            view.frame = window.bounds
            
            let img = UIImageView(image: #imageLiteral(resourceName: "nodata"))
            img.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(img)
            img.heightAnchor.constraint(equalToConstant: 66*heightRatio).isActive = true
            img.widthAnchor.constraint(equalTo: img.heightAnchor, multiplier: 360/206).isActive = true
            img.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            img.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -30).isActive = true
            
            let noDataLabel: UILabel  = UILabel()
            noDataLabel.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(noDataLabel)
            noDataLabel.text          = txt.localized
            noDataLabel.textColor     = UIColor("6C6C6C", alpha: 1)
            noDataLabel.textAlignment = .center
            let font = UIFont.init(name: "SFProDisplay-Regular", size: 16)
            noDataLabel.font = Common.getFontForDeviceWithFontDefault(fontDefault: font ?? UIFont.systemFont(ofSize: 16))
            noDataLabel.topAnchor.constraint(equalTo: img.bottomAnchor, constant: 12*heightRatio).isActive = true
            noDataLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            
            view.addSubview(noDataLabel)
            return view
        } else {
            return UIView()
        }
    }
    
    class func viewNoDataWithTitle() -> UIView{
        if let window = UIApplication.shared.keyWindow {
            let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: window.bounds.size.width, height: window.bounds.size.height))
            noDataLabel.text          = "txt_no_data".localized
            noDataLabel.textColor     = UIColor.gray
            noDataLabel.textAlignment = .center
            let font = UIFont.init(name: "SFProDisplay-Regular", size: 16)
            noDataLabel.font = Common.getFontForDeviceWithFontDefault(fontDefault: font ?? UIFont.systemFont(ofSize: 16))
            return noDataLabel
        } else {
            return UIView()
        }
    }
    
    class func generateID() -> String {
        return UUID().uuidString
    }
}

class RandomColor {
    
    func randomColor() -> UIColor {
        
        let randomRed:CGFloat = CGFloat(drand48())
        let randomGreen:CGFloat = CGFloat(drand48())
        let randomBlue:CGFloat = CGFloat(drand48())
        
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
}
