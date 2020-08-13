//
//  Extension.swift
//  Task
//
//  Created by Hoa on 3/31/18.
//  Copyright © 2018 SDC. All rights reserved.
//

import Foundation
//import Kingfisher
import UIKit
import CoreTelephony

extension Double {
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
    var toSting: String {
        return "\(self)"
    }
}

extension Int {
    var idString: String {
        return self == 0 ? "" : "\(self)"
    }
    func secondsToMinutesSeconds (seconds : Int) -> (String, String) {
        let m = (seconds % 3600) / 60
        let s = (seconds % 3600) % 60
        return (m > 9 ? "\(m)" : "0\(m)", s > 9 ? "\(s)" : "0\(s)")
    }
    func secondsToHoursMinutesSeconds (seconds : Int) -> (String, String, String) {
        let h = seconds / 3600
        let m = (seconds % 3600) / 60
        let s = (seconds % 3600) % 60
        return (h > 9 ? "\(h)" : "0\(h)", m > 9 ? "\(m)" : "0\(m)", s > 9 ? "\(s)" : "0\(s)")
    }
}

extension String {
    func nibWithNameiPad()->String{
        var str = self
        if IS_IPAD{
            str = str + "_iPad"
        }
        return str
    }
    subscript(value: PartialRangeUpTo<Int>) -> Substring {
        get {
            return self[..<index(startIndex, offsetBy: value.upperBound)]
        }
    }
    
    subscript(value: PartialRangeThrough<Int>) -> Substring {
        get {
            return self[...index(startIndex, offsetBy: value.upperBound)]
        }
    }
    
    subscript(value: PartialRangeFrom<Int>) -> Substring {
        get {
            return self[index(startIndex, offsetBy: value.lowerBound)...]
        }
    }
    func sizeOfString(_ font: UIFont) -> CGSize {
        let fontAttribute = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttribute)  // for Single Line
        return size;
    }
    
    func encode()-> String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
    }
    
    func date(_ format: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        if let date = dateFormatter.date(from: self) {
            return date
        }
        return Date()
    }
    
    var text: String {
        return (self.count > 0) ? self : "N/A".localized
    }
    
    var isAlphabet: Bool {
        return !isEmpty && range(of: "[^a-zA-Z]", options: .regularExpression) == nil
    }
    
    var isEmail: Bool{
        let emailRegEx = "^[_A-Za-z0-9-\\+]+(\\.[_A-Za-z0-9-]+)*@" + "[A-Za-z0-9-]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,})$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self.trimmingCharacters(in: .whitespacesAndNewlines))
    }
    
    func trim() -> String{
        return (self.trimmingCharacters(in: .whitespacesAndNewlines)).replacingOccurrences(of: "Không có", with: "")
    }
    
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
    
    func currency() -> String {
        let formatter = NumberFormatter()
        formatter.secondaryGroupingSize = 3
        formatter.groupingSize = 3
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        
        return formatter.string(from: NSNumber(value: Double(self.replacingOccurrences(of: ",", with: "")) != nil ? Double(self.replacingOccurrences(of: ",", with: ""))! : 0)) ?? "0"
    }
    
    func uncurrency() -> String? {
        return self.trim().replacingOccurrences(of: "$", with: "").replacingOccurrences(of: ",", with: "")
    }
    
    func addAttribute(boldArrString: Array<String>?, colorArrString: Array<String>?, underlineArrString: Array<String>?,fontName:String,fontNameType: String, fontSize: CGFloat!, boldColor: UIColor?, changeColor: UIColor?, _ isCenter: Bool = false) -> NSMutableAttributedString {
        let font = UIFont(name: fontName, size: fontSize)
        let fontBold = UIFont(name: fontNameType, size: fontSize)
        let nonBoldFontAttribute = [NSAttributedString.Key.font:Common.getFontForDeviceWithFontDefault(fontDefault: font ?? UIFont.systemFont(ofSize: fontSize))]
        let boldFontAttribute = [NSAttributedString.Key.font:Common.getFontForDeviceWithFontDefault(fontDefault: fontBold ?? UIFont.boldSystemFont(ofSize: fontSize))]
        
        let fullString = self as NSString
        let boldString = NSMutableAttributedString(string: fullString as String, attributes:nonBoldFontAttribute)
        if let arrBold = boldArrString {
            for i in 0 ..< arrBold.count {
                boldString.addAttributes(boldFontAttribute, range: fullString.range(of: arrBold[i]))
            }
        }
        
        let colorAttribute: [NSAttributedString.Key : Any] = [NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): changeColor as Any]
        if let arrColor = colorArrString {
            for i in 0 ..< arrColor.count {
                boldString.addAttributes(colorAttribute, range: fullString.range(of: arrColor[i]))
            }
        }
        
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
        if let arrUnderline = underlineArrString {
            for i in 0 ..< arrUnderline.count {
                boldString.addAttributes(underlineAttribute, range: fullString.range(of: arrUnderline[i]))
            }
        }
        let paragraphStyle = NSMutableParagraphStyle()
        if isCenter {
            paragraphStyle.alignment = NSTextAlignment.center
        }
        paragraphStyle.lineSpacing = 2
        boldString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, boldString.string.count))
        
        return boldString
    }
}

extension UIView {
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
        self.layer.masksToBounds = true
    }
    
    func blur()
    {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 0.8
        blurEffectView.frame = self.bounds
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        self.addSubview(blurEffectView)
    }
    
    func corner() {
        self.layer.cornerRadius = self.frame.size.height/2
        self.layer.masksToBounds = false
        self.clipsToBounds = true
    }
    
    func corner(_ value: CGFloat) {
        self.layer.cornerRadius = value
        self.clipsToBounds = true
    }
    
    func bolder(_ width: CGFloat) {
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = width
    }
    
    func bolderc(_ color: UIColor) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = 0.5
    }
    
    func animateIn() {
        self.alpha = 0
        self.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
        }
    }
    
    func animateOut() {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        }) { (finished) in
            self.isHidden = finished
        }
    }
    
    func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.2) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        
        animation.toValue = toValue
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        
        self.layer.add(animation, forKey: nil)
    }
    
    func pb_takeSnapshot() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(frame.size, false, UIScreen.main.scale)
        drawHierarchy(in: self.frame, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    @IBInspectable var cornerRadiusV: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidthV: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColorV: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
}

extension String  {
    var isnumberordouble: Bool { return Int(self) != nil || Double(self) != nil }
    
    enum RegularExpressions: String {
        case phone = "^\\s*(?:\\+?(\\d{1,3}))?([-. (]*(\\d{3})[-. )]*)?((\\d{3})[-. ]*(\\d{2,4})(?:[-.x ]*(\\d+))?)\\s*$"
    }
    
    func isValid(regex: RegularExpressions) -> Bool {
        return isValid(regex: regex.rawValue)
    }
    
    func isValid(regex: String) -> Bool {
        let matches = range(of: regex, options: .regularExpression)
        return matches != nil
    }
    
    func onlyDigits() -> String {
        let filtredUnicodeScalars = unicodeScalars.filter{CharacterSet.decimalDigits.contains($0)}
        return String(String.UnicodeScalarView(filtredUnicodeScalars))
    }
    
    func makeACall() {
        if canMakeACall() {
            if isValid(regex: .phone) {
                if let url = URL(string: "tel://\(self.onlyDigits())"), UIApplication.shared.canOpenURL(url) {
                    if #available(iOS 10, *) {
                        UIApplication.shared.open(url)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
            } else {
                Common.showAlert("txt_valid_phone")
            }
        }
    }
    
    func canMakeACall() -> Bool {
        if DeviceType.IS_IPAD {
            Common.showAlert("Thiết bị không hỗ trợ chức năng này")
            return false
        }
        let mobileNetworkCode = CTTelephonyNetworkInfo().subscriberCellularProvider?.mobileNetworkCode
        if mobileNetworkCode == nil || mobileNetworkCode!.count <= 0 || mobileNetworkCode == "65535" {
            Common.showAlert("Vui lòng gắn thẻ sim để thực hiện chức năng này")
            return false
        }
        
        return true
    }
}

extension Date {
    func string(_ format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.local
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self as Date)
    }
    
    func stringWithTimeZone(_ timeZone: String,_ format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: timeZone)
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self as Date)
    }
    
    var millisecondsSince1970: Double {
        return (self.timeIntervalSince1970 * 1000.0).rounded()
    }
    
    var secondsSince1970: Double {
        return (self.timeIntervalSince1970).rounded()
    }
    
    init(milliseconds: Double) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
    
    init(seconds: Double) {
        self = seconds == 0 ? Date() : Date(timeIntervalSince1970: TimeInterval(seconds)) 
    }
    
    init(string: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        self = dateFormatter.date(from: string)!
    }
    
    func getElapsedInterval() -> String {
        let unitFlags = Set<Calendar.Component>([.day, .weekOfMonth, .month, .year, .hour , .minute, .second])
        var interval = Calendar.current.dateComponents(unitFlags, from: self,  to: Date())
        if interval.year! > 0 {
            return "\(interval.year!)" + " " + "năm trước"
        }
        if interval.month! > 0 {
            return "\(interval.month!)" + " " + "tháng trước"
        }
        if interval.weekOfMonth! > 0 {
            return "\(interval.weekOfMonth!)" + " " + "tuần trước"
        }
        if interval.day! > 0 {
            return "\(interval.day!)" + " " + "ngày trước"
        }
        if interval.hour! > 0 {
            return "\(interval.hour!)" + " " + "giờ trước"
        }
        if interval.minute! > 0 {
            return "\(interval.minute!)" + " " + "phút trước"
        }
        
        if interval.second! > 0 {
            return "Vừa xong"
        }
        return "Vừa xong"
    }
    
    var startDate: Date {
        return Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: self) ?? self
    }
    var endDate: Date {
        return Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: self) ?? self
    }
    
    var year: Int {
        return Calendar.current.component(.year, from: self)
    }
    
    var month: Int {
        return Calendar.current.component(.month, from: self)
    }
    
    var day: Int {
        return Calendar.current.component(.day, from: self)
    }
}

extension UIColor {
    convenience init(_ hex:String, alpha: CGFloat) {
        let scanner = Scanner(string: hex)
        
        if (hex.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        
        var color:UInt32 = 0
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
}

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}

extension UIImage {
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func resizedTo1MB() -> UIImage? {
        guard let imageData = self.pngData() else { return nil }
        
        var resizingImage = self
        var imageSizeKB = Double(imageData.count) / 1000.0
        
        while imageSizeKB > 1000 {
            guard let resizedImage = resizingImage.resized(withPercentage: 0.9),
                let imageData = resizedImage.pngData()
                else { return nil }
            
            resizingImage = resizedImage
            imageSizeKB = Double(imageData.count) / 1000.0
        }
        
        return resizingImage
    }
    
    func resizeImage(_ withSize: CGSize) -> UIImage {
        var actualHeight: CGFloat = self.size.height
        var actualWidth: CGFloat = self.size.width
        let maxHeight: CGFloat = withSize.width
        let maxWidth: CGFloat = withSize.height
        var imgRatio: CGFloat = actualWidth/actualHeight
        let maxRatio: CGFloat = maxWidth/maxHeight
        let compressionQuality = 0.5//50 percent compression
        
        if (actualHeight > maxHeight || actualWidth > maxWidth) {
            if(imgRatio < maxRatio) {
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight
                actualWidth = imgRatio * actualWidth
                actualHeight = maxHeight
            } else if(imgRatio > maxRatio) {
                //adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth
                actualHeight = imgRatio * actualHeight
                actualWidth = maxWidth
            } else {
                actualHeight = maxHeight
                actualWidth = maxWidth
            }
        } else {
            return self
        }
        
        let rect: CGRect = CGRect(x: 0.0, y: 0.0, width: actualWidth, height: actualHeight)
        UIGraphicsBeginImageContext(rect.size)
        self.draw(in: rect)
        let image: UIImage  = UIGraphicsGetImageFromCurrentImageContext()!
        let imageData = image.jpegData(compressionQuality: CGFloat(compressionQuality))
        UIGraphicsEndImageContext()
        
        let resizedImage = UIImage(data: imageData!)
        return resizedImage!
        
    }
}

protocol NibReusable: class {
    static var reuseIdentifier: String { get }
    static var nibName: String { get }
}

extension NibReusable where Self: UIView {
    static var nibName: String {
        return String(describing: self)
    }
    static var reuseIdentifier: String {
        return nibName
    }
}

extension UITableViewCell: NibReusable { }

extension UICollectionViewCell: NibReusable { }

extension UITableViewHeaderFooterView: NibReusable { }

extension UICollectionView {
    func register<Cell: NibReusable>(_ cell: Cell.Type) {
        let nib = UINib(nibName: cell.nibName, bundle: Bundle(for: cell))
        register(nib, forCellWithReuseIdentifier: cell.reuseIdentifier)
    }
    func dequeueReusableCell<Cell: NibReusable>(forIndexPath indexPath: IndexPath) -> Cell {
        guard let cell = dequeueReusableCell(withReuseIdentifier: Cell.reuseIdentifier, for: indexPath) as? Cell else {
            fatalError("Could not dequeue cell with identifier: \(Cell.reuseIdentifier)")
        }
        return cell
    }
}

extension UITableView: UITableViewDelegate {
    func register<Cell: NibReusable>(_ cell: Cell.Type) {
        let nib = UINib(nibName: Cell.nibName, bundle: Bundle(for: cell))
        register(nib, forCellReuseIdentifier: Cell.reuseIdentifier)
    }
    
    func dequeueReusableCell<Cell: NibReusable>(forIndexPath indexPath: IndexPath) -> Cell {
        guard let cell = dequeueReusableCell(withIdentifier: Cell.reuseIdentifier, for: indexPath) as? Cell else {
            fatalError("Could not dequeue cell with identifier: \(Cell.reuseIdentifier)")
        }
        return cell
    }
    
    func registerHeaderFooterView<Cell: NibReusable>(_ cell: Cell.Type) {
        let nib = UINib(nibName: Cell.nibName, bundle: nil)
        register(nib, forHeaderFooterViewReuseIdentifier: Cell.reuseIdentifier)
    }
    
    func dequeueReusableHeaderFooterView<Cell: NibReusable>() -> Cell {
        guard let header = dequeueReusableHeaderFooterView(withIdentifier: Cell.reuseIdentifier) as? Cell else {
            fatalError("Could not dequeue header with identifier: \(Cell.reuseIdentifier)")
        }
        return header
    }
}

@IBDesignable class CustomButton: UIButton {
    
    var shadowAdded: Bool = false
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if shadowAdded { return }
        shadowAdded = true
        let shadowLayer = UIView(frame: self.frame)
        shadowLayer.backgroundColor = UIColor.clear
        shadowLayer.layer.shadowColor = UIColor.darkGray.cgColor
        shadowLayer.layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: self.cornerRadius).cgPath
        shadowLayer.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        shadowLayer.layer.shadowOpacity = 0.5
        shadowLayer.layer.shadowRadius = 1
        shadowLayer.layer.masksToBounds = true
        shadowLayer.clipsToBounds = false
        
        self.superview?.addSubview(shadowLayer)
        self.superview?.bringSubviewToFront(self)
    }
}

@IBDesignable class ShadowView: UIView {
    
    var shadowAdded: Bool = false
        
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if shadowAdded { return }
        shadowAdded = true
        let shadowLayer = UIView(frame: self.frame)
        shadowLayer.backgroundColor = UIColor.clear
        shadowLayer.layer.shadowColor = UIColor.darkGray.cgColor
        shadowLayer.layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: self.cornerRadius).cgPath
        shadowLayer.layer.shadowOffset = CGSize(width: 0.8, height: 0.8)
        shadowLayer.layer.shadowOpacity = 0.4
        shadowLayer.layer.shadowRadius = 1
        shadowLayer.layer.masksToBounds = true
        shadowLayer.clipsToBounds = false
        self.superview?.addSubview(shadowLayer)
        self.superview?.bringSubviewToFront(self)
    }
}

let imageCache = NSCache<NSString, UIImage>()

class CustomImageView: UIImageView {
    var urlImageString: String?
    
    func loadImageUsingCache(withUrl urlPath : String, frame: CGRect) {
        urlImageString = urlPath
        let urlString = URL(string: urlPath)
        if urlString == nil {return}
        self.image = nil
        
        // check cached image
        if let cachedImage = imageCache.object(forKey: urlPath as NSString)  {
            self.image = cachedImage
            return
        }
        
        let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView.init(style: .gray)
        addSubview(activityIndicator)
        activityIndicator.startAnimating()
        activityIndicator.center = center
        activityIndicator.frame = CGRect(x: frame.width/2 - 50/2, y: frame.height/2 - 50/2, width: 50, height: 50)
        activityIndicator.style = .gray
        // if not, download image from url
        
        URLSession.shared.dataTask(with: urlString!, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            DispatchQueue.main.async {
                if let imageToCache = UIImage(data: data!) {
                    if self.urlImageString == urlPath {
                        self.image = imageToCache
                        activityIndicator.stopAnimating()
                    }
                    imageCache.setObject(imageToCache, forKey: urlPath as NSString)
                }
            }
        }).resume()
    }
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}

extension String {
    /// Converts an ISO 8601 formatted `String` into `NSDateComponents`.
    ///
    /// - Note: Does not accept fractional input (e.g.: P3.5Y), must be integers (e.g.: P3Y6M).
    /// - SeeAlso: https://en.wikipedia.org/wiki/ISO_8601#Durations
    /// - Returns: If valid ISO 8601, an `NSDateComponents` representation, otherwise `nil`.
    func ISO8601DateComponents() -> String {
        // Regex adapted from Moment.js https://github.com/moment/moment/blame/develop/src/lib/duration/create.js#L16
        let pattern = "^P(?:(\\d*)Y)?(?:(\\d*)M)?(?:(\\d*)W)?(?:(\\d*)D)?(?:T(?:(\\d*)H)?(?:(\\d*)M)?(?:(\\d*)S)?)?$"
        let nsstringRepresentation = self as NSString
        let regex = try! NSRegularExpression(pattern: pattern, options: [.anchorsMatchLines])
        
        var h = 0
        var m = 0
        var s = 0
        guard let match = regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: nsstringRepresentation.length)) else { return "nil" }
        
        let dateComponents = NSDateComponents()
        
        if match.range(at: 1).location != NSNotFound, let years = Int(nsstringRepresentation.substring(with: match.range(at: 1)) as String) {
            dateComponents.year = years
        }
        
        if match.range(at: 2).location != NSNotFound, let month = Int(nsstringRepresentation.substring(with: match.range(at: 2)) as String) {
            dateComponents.month = month
        }
        
        if match.range(at: 3).location != NSNotFound, let week = Int(nsstringRepresentation.substring(with: match.range(at:3)) as String) {
            dateComponents.weekOfYear = week
        }
        
        if match.range(at: 4).location != NSNotFound, let day = Int(nsstringRepresentation.substring(with: match.range(at:4)) as String) {
            dateComponents.day = day
        }
        
        if match.range(at: 5).location != NSNotFound, let hour = Int(nsstringRepresentation.substring(with: match.range(at:5)) as String) {
            dateComponents.hour = hour
            h = hour
        }
        
        if match.range(at: 6).location != NSNotFound, let minute = Int(nsstringRepresentation.substring(with: match.range(at:6)) as String) {
            dateComponents.minute = minute
            m = minute
        }
        
        if match.range(at: 7).location != NSNotFound, let second = Int(nsstringRepresentation.substring(with: match.range(at:7)) as String) {
            dateComponents.second = second
            s = second
        }
        
        let time = h*3600 + m*60 + s
        
        if time == 0 {
            return "00:00"
        }else{
            if time >= 3600 {
                let (h,m,s) = Int().secondsToHoursMinutesSeconds(seconds: time)
                return "\(h):\(m):\(s)"
            }else{
                let (m,s) = Int().secondsToMinutesSeconds(seconds: time)
                return "\(m):\(s)"
            }
        }
    }
}

extension UIFont {
    var weight: UIFont.Weight {
        guard let weightNumber = traits[.weight] as? NSNumber else { return .regular }
        let weightRawValue = CGFloat(weightNumber.doubleValue)
        let weight = UIFont.Weight(rawValue: weightRawValue)
        return weight
    }
    
    private var traits: [UIFontDescriptor.TraitKey: Any] {
        return fontDescriptor.object(forKey: .traits) as? [UIFontDescriptor.TraitKey: Any]
            ?? [:]
    }
}

extension UIImage {
    func getCropRadio() -> CGFloat {
        let wightRadio = CGFloat(self.size.width / self.size.height)
        return wightRadio
    }
}

extension URL {
    func getImageSize(success : @escaping (CGSize) -> Void) {
        let queuce = DispatchQueue.init(label: self.absoluteString)
        queuce.async {
            if let imageSource = CGImageSourceCreateWithURL(self as CFURL, nil) {
                if let imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as Dictionary? {
                    let pixelWidth = imageProperties[kCGImagePropertyPixelWidth] as! Int
                    let pixelHeight = imageProperties[kCGImagePropertyPixelHeight] as! Int
                    print("the image width is: \(pixelWidth)")
                    print("the image height is: \(pixelHeight)")
                    success(CGSize(width: pixelWidth, height: pixelHeight))
                }
            }
        }
    }
}

extension Date {
    func toString(_ format: String) -> String {
        let df = DateFormatter()
        df.dateFormat = format
        return df.string(from: self)
    }
}

extension Array {
    
    func filterDuplicates( includeElement: (_ lhs:Element, _ rhs:Element) -> Bool) -> [Element]{
        var results = [Element]()
        
        forEach { (element) in
            let existingElements = results.filter {
                return includeElement(element, $0)
            }
            if existingElements.count == 0 {
                results.append(element)
            }
        }
        
        return results
    }
}

extension URL {
    func saveVideo(idAlbum: String, success:@escaping (Bool,URL?)->()){
        let dataPath = FilePaths.filePaths.path
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: dataPath) {
            try? fileManager.createDirectory(atPath: dataPath, withIntermediateDirectories: true, attributes: nil) //Create folder if not
        }
        let uuid = UUID().uuidString
        let fileName = uuid+".mp4"
        let fileURL = URL(fileURLWithPath:dataPath).appendingPathComponent(fileName)//Your image name
        print(fileURL)
        do {
            try fileManager.moveItem(atPath: self.path, toPath: fileURL.path)
            print("Coppy:\(fileURL.path)")
            let obj = GalleryObj()
            obj.id = uuid
            obj.fileName = fileName
            obj.isVideo = true
            obj.idAlbum = idAlbum
            obj.saveGalleryList(true)
            success(true,fileURL)
        }
        catch let error as NSError {
            success(false,fileURL)
            print("Ooops! Something went wrong: \(error)")
        }
    }
}

extension Int64 {
    func toMB() -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = ByteCountFormatter.Units.useMB
        formatter.countStyle = ByteCountFormatter.CountStyle.decimal
        formatter.includesUnit = false
        return formatter.string(fromByteCount: self) as String
    }
    
    func toGB() -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = ByteCountFormatter.Units.useGB
        formatter.countStyle = ByteCountFormatter.CountStyle.decimal
        formatter.includesUnit = false
        return formatter.string(fromByteCount: self) as String
    }
}

//
//  UIView+extension.swift
//  JinjerKeihi
//
//  Created by Tri iOS on 6/14/19.
//  Copyright © 2019 HR Tech - Neolab . All rights reserved.
//

import UIKit

extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
            layer.shadowOpacity = 0.5
            layer.shadowRadius = newValue
            layer.masksToBounds = false
        }
    }
}

extension UIView {
    func shadow(color: UIColor = .black, offset: CGSize = .zero, opacity: Float = 0.3, radius: CGFloat = 3.0) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
    }
    
    func gradient(color: UIColor) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [color.cgColor, UIColor.white.cgColor]
        gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.size.width, height: self.frame.size.height)
        self.layer.insertSublayer(gradient, at: 0)
    }
    
}

extension CALayer {
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        let border = CALayer()
        switch edge {
        case UIRectEdge.top:
            border.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: thickness)
            
        case UIRectEdge.bottom:
            border.frame = CGRect(x: 0, y: self.bounds.height - thickness,  width: UIScreen.main.bounds.width, height: thickness)
            
        case UIRectEdge.left:
            border.frame = CGRect(x: 0, y: 0,  width: thickness, height: self.bounds.height)
            
        case UIRectEdge.right:
            border.frame = CGRect(x: self.bounds.width - thickness, y: 0,  width: thickness, height: self.bounds.height)
        default:
            border.frame = CGRect.zero
        }
        border.backgroundColor = color.cgColor;
        self.addSublayer(border)
    }
}

extension UILabel {

    func applyGradientWith(startColor: UIColor, endColor: UIColor) -> Bool {

        var startColorRed:CGFloat = 0
        var startColorGreen:CGFloat = 0
        var startColorBlue:CGFloat = 0
        var startAlpha:CGFloat = 0

        if !startColor.getRed(&startColorRed, green: &startColorGreen, blue: &startColorBlue, alpha: &startAlpha) {
            return false
        }

        var endColorRed:CGFloat = 0
        var endColorGreen:CGFloat = 0
        var endColorBlue:CGFloat = 0
        var endAlpha:CGFloat = 0

        if !endColor.getRed(&endColorRed, green: &endColorGreen, blue: &endColorBlue, alpha: &endAlpha) {
            return false
        }

        let gradientText = self.text ?? ""
        
        let textSize: CGSize = gradientText.size(withAttributes: [NSAttributedString.Key.font:self.font ?? UIFont.systemFontSize])
        let width:CGFloat = textSize.width
        let height:CGFloat = textSize.height

        UIGraphicsBeginImageContext(CGSize(width: width, height: height))

        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return false
        }

        UIGraphicsPushContext(context)

        let glossGradient:CGGradient?
        let rgbColorspace:CGColorSpace?
        let num_locations:size_t = 2
        let locations:[CGFloat] = [ 0.0, 1.0 ]
        let components:[CGFloat] = [startColorRed, startColorGreen, startColorBlue, startAlpha, endColorRed, endColorGreen, endColorBlue, endAlpha]
        rgbColorspace = CGColorSpaceCreateDeviceRGB()
        glossGradient = CGGradient(colorSpace: rgbColorspace!, colorComponents: components, locations: locations, count: num_locations)
        let topCenter = CGPoint.zero
        let bottomCenter = CGPoint(x: 0, y: textSize.height)
        context.drawLinearGradient(glossGradient!, start: topCenter, end: bottomCenter, options: CGGradientDrawingOptions.drawsBeforeStartLocation)

        UIGraphicsPopContext()

        guard let gradientImage = UIGraphicsGetImageFromCurrentImageContext() else {
            UIGraphicsEndImageContext()
            return false
        }

        UIGraphicsEndImageContext()

        self.textColor = UIColor(patternImage: gradientImage)

        return true
    }

}
