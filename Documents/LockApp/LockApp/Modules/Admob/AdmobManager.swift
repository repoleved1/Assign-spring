////
////  AdmobManager.swift
////  MangaReader
////
////  Created by Nhuom Tang on 9/9/18.
////  Copyright © 2018 Nhuom Tang. All rights reserved.
////
//
//import UIKit
//import FirebaseDatabase
//import GoogleMobileAds
//
//let adSize = UIDevice.current.userInterfaceIdiom == .pad ? kGADAdSizeLeaderboard: kGADAdSizeBanner
//
//class AdmobManager: NSObject {
//
//    static let shared = AdmobManager()
//
//    var interstitial: GADInterstitial!
//    var loadBannerError = true
//    var isShowAds = false
//    var counter = 1
//    var loadFullAdError = false
//    var apps:[[String:String]] = []
//
//    var fullRootViewController: UIViewController!
//
//    func getOpenApp() -> [String]{
//        if let array = UserDefaults.standard.value(forKey: "openApp") as? [String]{
//            return array
//        }
//        return []
//    }
//
//    func openApp(appId: String){
//        let text = "https://apps.apple.com/us/app/id" + appId
//        if let url = URL.init(string: text){
//            if UIApplication.shared.canOpenURL(url){
//                UIApplication.shared.open(url, options: [:], completionHandler: nil)
//            }
//        }
//        var openApp = getOpenApp()
//        openApp.append(appId)
//        UserDefaults.standard.set(openApp, forKey: "openApp")
//    }
//
//    func getMoreApp(){
//        let data = "LockPhoto"
//        apps.removeAll()
//        let childRef = Database.database().reference(withPath: data)
//        childRef.observeSingleEvent(of: .value) {(shapshot) in
//            if let spams = shapshot.value as? [String: Any]{
//                for  key in spams.keys{
//                    if let app = spams[key] as? [String: String]{
//                        if let id = app["appId"]{
//                            if !self.getOpenApp().contains(id){
//                                self.apps.append(app)
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }
//
//    func showMoreApp(inVC: UIViewController){
//        if apps.count > 0 {
//            //            let moreApp = MoreAppViewController()
//            //            moreApp.modalPresentationStyle = .overFullScreen
//            //            inVC.present(moreApp, animated: true, completion: nil)
//            print("1")
//        }
//    }
//
//    func setBannerViewToBottom(inVC: UIViewController, banerView: GADBannerView){
//        let witdh = UIScreen.main.bounds.size.width
//        let height: CGFloat = inVC.view.bounds.size.height
//        var bottomSafe: CGFloat = 0.0
//        if #available(iOS 11.0, *) {
//            let window = UIApplication.shared.keyWindow
//            if let bottomPadding = window?.safeAreaInsets.bottom{
//                bottomSafe = bottomPadding
//            }else{
//                bottomSafe = 0
//            }
//        }else{
//            bottomSafe = 0
//        }
//
//        let frame = CGRect.init(x: (witdh - adSize.size.width)/2 , y: height - adSize.size.height - bottomSafe, width: adSize.size.width, height: adSize.size.height)
//        banerView.frame = frame
//    }
//
//    func addBannerViewToBottom(inVC: UIViewController){
//        let witdh = UIScreen.main.bounds.size.width
//        let height: CGFloat = inVC.view.bounds.size.height
//        let frame = CGRect.init(x: (witdh - adSize.size.width)/2 , y: height - adSize.size.height, width: adSize.size.width, height: adSize.size.height)
//        self.addBannerView(frame: frame, inVC: inVC)
//    }
//
//    func addBannerViewToTop(inVC: UIViewController){
//        let witdh = UIScreen.main.bounds.size.width
//        let frame = CGRect.init(x: (witdh - adSize.size.width)/2 , y: 0, width: adSize.size.width, height: adSize.size.height)
//        self.addBannerView(frame: frame, inVC: inVC)
//    }
//
//    func statusBarHeight() -> CGFloat {
//        let statusBarSize = UIApplication.shared.statusBarFrame.size
//        return Swift.min(statusBarSize.width, statusBarSize.height)
//    }
//
//    override init() {
//        super.init()
//        self.createAndLoadInterstitial()
//        counter = numberToShowAd - 2
//        getMoreApp()
//    }
//
//    func openRateView(){
//        if #available(iOS 10.3, *) {
//            SKStoreReviewController.requestReview()
//        } else {
//            // Fallback on earlier versions
//        }
//    }
//
//    func addBannerView(frame: CGRect, inVC: UIViewController){
//        let bannerView = GADBannerView.init(adSize: adSize)
//        bannerView.adUnitID = keyBanner
//        bannerView.rootViewController = inVC
//        bannerView.delegate = self
//        bannerView.frame = frame
//        inVC.view.addSubview(bannerView)
//        bannerView.load(GADRequest())
//    }
//
//    func createBannerView(inVC: UIViewController) -> GADBannerView{
//        let witdh = UIScreen.main.bounds.size.width
//        let frame = CGRect.init(x: (witdh - adSize.size.width)/2 , y: 2000, width: adSize.size.width, height: adSize.size.height)
//        let bannerView = GADBannerView.init(adSize: adSize)
//        bannerView.adUnitID = keyBanner
//        bannerView.rootViewController = inVC
//        bannerView.delegate = self
//        bannerView.frame = frame
//        inVC.view.addSubview(bannerView)
//        let request = GADRequest()
//        request.testDevices = [ (kGADSimulatorID as! String), "c7f5d0314287e72fdcba00545320b656","48dc4326e9c28206e73446cdeeff5f86"]
//        bannerView.load(request)
//
//        return bannerView
//    }
//
//    func createAndLoadInterstitial() {
//        if !PaymentManager.shared.isPurchaseRemoveAds() {
//            interstitial = GADInterstitial(adUnitID: keyInterstitial)
//            interstitial.delegate = self
//            let request = GADRequest()
//            request.testDevices = [ (kGADSimulatorID as! String), "c7f5d0314287e72fdcba00545320b656","48dc4326e9c28206e73446cdeeff5f86"]
//            interstitial.load(request)
//        }
//    }
//
//    func logEvent(){
//        if PaymentManager.shared.isPurchaseRemoveAds() {
//            counter = counter + 1
//            if counter % 3 == 0{
//                self.openRateView()
//            }
//            return
//        }
//        if self.loadFullAdError {
//            self.createAndLoadInterstitial()
//            self.loadFullAdError = false
//        }
//        counter = counter + 1
//        if  counter >= numberToShowAd {
//            if interstitial.isReady{
//                interstitial.present(fromRootViewController: fullRootViewController)
//                counter = 1
//                isShowAds = true
//            }else{
//                self.openRateView()
//            }
//        }else{
//            if isShowAds{
//                isShowAds = false
//                self.openRateView()
//            }
//        }
//    }
//
//    func forceShowAdd(){
//        counter = numberToShowAd
//        self.logEvent()
//    }
//}
//
//extension AdmobManager: GADBannerViewDelegate{
//
//    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
//        print("adViewDidReceiveAd")
//        loadBannerError = false
//    }
//    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
//        print("didFailToReceiveAdWithError bannerView")
//        loadBannerError = true
//    }
//}
//
//extension AdmobManager: GADInterstitialDelegate{
//
//    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
//        self.createAndLoadInterstitial()
//    }
//
//    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
//        loadFullAdError = true
//        print("didFailToReceiveAdWithError GADInterstitial")
//    }
//
//    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
//        print("interstitialDidReceiveAd")
//    }
//}
//
