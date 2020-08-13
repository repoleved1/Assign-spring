//
//  Define.swift
//  Carenefit
//
//  Created by Tony Tuan on 9/4/17.
//  Copyright © 2017 sdc. All rights reserved.
//

import UIKit

let isIPad = DeviceType.IS_IPAD
let heightRatio = (isIPad) ? 1.3 : ScreenSize.SCREEN_HEIGHT/736
let widthRatio = (isIPad) ? 1.4 : ScreenSize.SCREEN_WIDTH/414

enum ErrorCode: String {
    case NoCode
}

enum NetworkConnection {
    case available
    case notAvailable
}

enum SaveKey: String {
    case deviceToken = "deviceToken"
    case tokenType = "tokenType"
    case accessToken = "accessToken"
    case email = "email"
    case pass = "pass"
    case isLogin = "isLogin"
    case CheckUpdateCategory = "CheckUpdateCategory"
}

class NotificationCenterKey {
    static let SelectedMenu = "SelectedMenu"
    static let DismissAllAlert = "DismissAllAlert"
}

class TColor {
    static let purpleColor = UIColor("#522B83", alpha: 1.0)
    static let whiteColor = UIColor("#FFFFFF", alpha: 1.0)
    static let vangNhat = UIColor("#F5B133", alpha: 1.0)
}

protocol EnumCollection : Hashable {}
extension EnumCollection {
    static func cases() -> AnySequence<Self> {
        typealias S = Self
        return AnySequence { () -> AnyIterator<S> in
            var raw = 0
            return AnyIterator {
                let current : Self = withUnsafePointer(to: &raw) { $0.withMemoryRebound(to: S.self, capacity: 1) { $0.pointee } }
                guard current.hashValue == raw else { return nil }
                raw += 1
                return current
            }
        }
    }
}

final class SwipeNavigationController: UINavigationController {
    
    // MARK: - Lifecycle
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // This needs to be in here, not in init
        interactivePopGestureRecognizer?.delegate = self
    }
    
    deinit {
        delegate = nil
        interactivePopGestureRecognizer?.delegate = nil
    }
    
    // MARK: - Overrides
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        duringPushAnimation = true
        
        super.pushViewController(viewController, animated: animated)
//        AdmobManager.shared.logEvent()
    }
    
    // MARK: - Private Properties
    
    fileprivate var duringPushAnimation = false
    
}

// MARK: - UINavigationControllerDelegate

extension SwipeNavigationController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let swipeNavigationController = navigationController as? SwipeNavigationController else { return }
        
        swipeNavigationController.duringPushAnimation = false
    }
    
}

// MARK: - UIGestureRecognizerDelegate

extension SwipeNavigationController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard gestureRecognizer == interactivePopGestureRecognizer else {
            return true // default value
        }
        
        // Disable pop gesture in two situations:
        // 1) when the pop animation is in progress
        // 2) when user swipes quickly a couple of times and animations don't have time to be performed
        return viewControllers.count > 1 && duringPushAnimation == false
    }
}


let keyAdmod = ""
let keyBanner = "ca-app-pub-4480769647336188/6133762032"
let keyInterstitial = "ca-app-pub-4480769647336188/5067667340"
var numberToShowAd = 3
let sharetext = "https://itunes.apple.com/app/id?mt=8"
let appId = "1474423044"

let COLOR_NAVI = UIColor(red: 7.0/255.0, green: 116.0/255.0, blue: 255.0/255.0, alpha: 1)

struct Constant {
    static let FULLFORMATDATE = "dd/MM/yyyy HH:mm:ss"
}

class FilePaths {
    static let documentsPath : AnyObject = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask,true)[0] as AnyObject
    struct videoPaths {
        static var path = FilePaths.documentsPath.appending("/data/video/")
        func urlVideoFileName(_ fileName: String) -> URL {
            return URL(fileURLWithPath: FilePaths.videoPaths.path+fileName)
        }
    }
    struct imagePaths {
        static var path = FilePaths.documentsPath.appending("/data/image/")
        func urlImageFileName(_ fileName: String) -> URL {
            return URL(fileURLWithPath: FilePaths.imagePaths.path+fileName)
        }
    }
    
    struct filePaths {
        static var path = FilePaths.documentsPath.appending("/data/")
        func urlImageFileName(_ fileName: String) -> URL {
            return URL(fileURLWithPath: FilePaths.imagePaths.path+fileName)
        }
    }
}
