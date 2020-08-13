//
//  PaymentManager.swift
//  MasterCleaner
//
//  Created by Nhuom Tang on 7/15/19.
//  Copyright © 2019 Nhuom Tang. All rights reserved.
//

import UIKit

let PRODUCT_ID_ALL = "tueanhoang.com.Notes.Allfeatures"
let PRODUCT_ID_STORE = "tueanhoang.com.Notes.Store"
let PRODUCT_ID_CONTACT = "tueanhoang.com.Notes.Backup"
let PRODUCT_ID_ALBUM = "tueanhoang.com.Notes.Album"
let PRODUCT_ID_REMOVE_ADS = "tueanhoang.com.Notes.Removeads"

let PRODUCT_IDS = [PRODUCT_ID_ALL,PRODUCT_ID_STORE,PRODUCT_ID_CONTACT,PRODUCT_ID_ALBUM,PRODUCT_ID_REMOVE_ADS]


let DEVICE_WIDTH = UIScreen.main.bounds.width
let DEVICE_HEIGHT = UIScreen.main.bounds.height
let IS_IPAD = UIDevice.current.userInterfaceIdiom == .pad

class PaymentManager: NSObject {
    static let shared = PaymentManager()
    
    func isPurchase(id: String)->Bool{
        let isPurchase = UserDefaults.standard.bool(forKey: id.replacingOccurrences(of: ".", with: ""))
        return isPurchase
    }
    
    func savePurchase(id: String){
        UserDefaults.standard.setValue(true, forKey: id.replacingOccurrences(of: ".", with: ""))
    }
    
    func isPurchaseStore()->Bool{
//        if PaymentManager.shared.isPurchase(id: PRODUCT_ID_STORE)
//            || PaymentManager.shared.isPurchase(id: PRODUCT_ID_ALL) {
//            return true
//        }
        return true
    }
    
    func isPurchaseContact()->Bool{
//        if PaymentManager.shared.isPurchase(id: PRODUCT_ID_CONTACT)
//            || PaymentManager.shared.isPurchase(id: PRODUCT_ID_ALL) {
//            return true
//        }
        return true
    }
    
    func isPurchaseAlbum()->Bool{
//        if PaymentManager.shared.isPurchase(id: PRODUCT_ID_ALBUM)
//            || PaymentManager.shared.isPurchase(id: PRODUCT_ID_ALL) {
//            return true
//        }
        return true
    }
    
    func isPurchaseRemoveAds()->Bool{
        if PaymentManager.shared.isPurchase(id: PRODUCT_ID_REMOVE_ADS)
            || PaymentManager.shared.isPurchase(id: PRODUCT_ID_ALL) {
            return true
        }
        return false
    }
}

