//
//  Extensions.swift
//  SwidgetsMaker
//
//  Created by ManhCuong on 9/29/20.
//

import Foundation
import UIKit
import Photos
import UIColor_Hex_Swift
import Toast_Swift
import MBProgressHUD

private var __maxLengths = [UITextField: Int]()
extension UITextField {
    @IBInspectable var maxLength: Int {
        get {
            guard let l = __maxLengths[self] else {
               return 150 // (global default-limit. or just, Int.max)
            }
            return l
        }
        set {
            __maxLengths[self] = newValue
            addTarget(self, action: #selector(fix), for: .editingChanged)
        }
    }
    @objc func fix(textField: UITextField) {
        let t = textField.text
        textField.text = String((t?.prefix(maxLength))!)
    }
}

extension String {
    var characterArray: [Character]{
        var characterArray = [Character]()
        for character in self {
            characterArray.append(character)
        }
        return characterArray
    }
    //MARK: -- caculate width height of string
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return boundingBox.height
    }
    
    func width(withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return boundingBox.width
    }
   
    func nibWithNameiPad()->String{
        var str = self
        if IS_IPAD{
            str = str + "_iPad"
        }
        return str
    }
    
   
    func CGFloatValue() -> CGFloat? {
        guard let doubleValue = Double(self) else {
            return nil
        }
        
        return CGFloat(doubleValue)
    }
    
    func boldItalicAttribute() -> NSMutableAttributedString {
        return NSMutableAttributedString(string: self, attributes:
                                            [NSAttributedString.Key.font : UIFont.appplicationFontSemibold(18),
             NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
             NSAttributedString.Key.underlineColor: UIColor.lightGray])
    }
    
    func normalAttribute() -> NSMutableAttributedString {
        return NSMutableAttributedString(string: self, attributes:
                                            [NSAttributedString.Key.font : UIFont.applicationFontRegular(18)])
    }

}

extension Int {
    func asStringFormattime() -> String {
        let minute = self / 60
        let second = self % 60
        let minuteString = "\(minute)"
        var secondString = "\(second)"
        
        if second < 10 {
            secondString = "0\(second)"
        }
        
        let formattedString = minuteString + ":" + secondString
        return formattedString
    }
}

extension NSObject {
    var className: String {
        
        return String(describing: type(of: self))
    }
    
    class var className: String {
        
        return String(describing: self)
    }
}

extension UIView {
    class func fromNib<T: UIView>() -> T {
        guard let view = Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)?.first as? T else {
            return T()
        }
        return view
    }
    func addTapGesture(callBack: Selector) -> Void {
        let tap = UITapGestureRecognizer.init(target: self, action: callBack)
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tap)
    }
    func addTapGesture(callBack: Selector,parent:AnyObject?) -> Void {
        let tap = UITapGestureRecognizer.init(target: parent, action: callBack)
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tap)
    }
    func addTapGesture(callBack: Selector,parent:AnyObject?,delegate:UIGestureRecognizerDelegate) -> Void {
        let tap = UITapGestureRecognizer.init(target: parent, action: callBack)
        tap.delegate = delegate
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tap)
    }
    func addTapGesture(callBack: Selector,viewController:UIViewController) -> Void {
        let tap = UITapGestureRecognizer.init(target: viewController, action: callBack)
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tap)
    }
    @IBInspectable var isOnShadowV: Bool {
        get {
            return layer.masksToBounds
        }
        set {
            layer.masksToBounds = !newValue
            layer.shadowColor = UIColor.lightGray.cgColor
            layer.shadowOpacity = 0.5
            layer.shadowOffset = CGSize(width: 0, height: 0)
            layer.shadowRadius = 2
        }
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

extension UIFont {
    class func applicationFontRegular(_ size: CGFloat) -> UIFont {
        return UIFont(name: "DMSans-Regular", size: size)!
    }
    class func appplicationFontSemibold(_ size: CGFloat) -> UIFont {
        return UIFont(name: "DMSans-Bold", size: size)!
    }
    
    class func customFont(fontName: String, size: CGFloat) -> UIFont {
        return UIFont(name: fontName, size: size) ?? appplicationFontSemibold(size)
    }
}
extension UIColor {
    class func customColor(hex: String) -> UIColor {
        return UIColor(hex)
    }
}

extension Date {
    func convertDatetoString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter.string(from: self)
    }
    func hour() -> String {
        return String(Calendar.current.component(.hour, from: self))
    }
    func minute() -> String {
        return String(Calendar.current.component(.minute, from: self))
    }
}

extension UIViewController {
    class func exclusiveTouchAllBtns(exclusiveTouch: Bool) -> Void {
        // exclusiveTouchAllBtns(exclusiveTouch, inView: _view)
    }
    
    class func exclusiveTouchAllBtns(exclusiveTouch: Bool, inView: UIView) -> Void {
        for obj: AnyObject in inView.subviews {
            if (obj is UIButton) {
                (obj as? UIButton)!.isExclusiveTouch = exclusiveTouch
            } else if (obj is UIView) {
                exclusiveTouchAllBtns(exclusiveTouch: exclusiveTouch, inView: (obj as?UIView)!)
            }
        }
    }
    func isModal() -> Bool {
        if self.presentingViewController != nil {
            return true
        } else if self.navigationController?.presentingViewController?.presentedViewController == self.navigationController  {
            return true
        } else if self.tabBarController?.presentingViewController is UITabBarController {
            return true
        }
        
        return false
    }
    
    func showLoading(){
        MBProgressHUD.showAdded(to: view, animated: true)
    }
    
    func hideLoading(){
        MBProgressHUD.hide(for: view, animated: true)
    }
    
    func showError(message: String){
        var style = ToastStyle()
        style.backgroundColor = UIColor.red.withAlphaComponent(1)
        currentView().view.makeToast(message, duration: 3.0, position: .top, style: style)
    }
    
    func showSuccess(message: String){
        var style = ToastStyle()
        style.backgroundColor = UIColor.green.withAlphaComponent(1)
        currentView().view.makeToast(message, duration: 3.0, position: .top, style: style)
    }
    
    func currentView() -> UIViewController{
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        }
        return (UIApplication.shared.keyWindow?.rootViewController)!
    }
    
    func initializeHideKeyboard(){
     //Declare a Tap Gesture Recognizer which will trigger our dismissMyKeyboard() function
     let tap: UITapGestureRecognizer = UITapGestureRecognizer(
     target: self,
     action: #selector(dismissMyKeyboard))
     //Add this tap gesture recognizer to the parent view
     view.addGestureRecognizer(tap)
     }
    
     @objc func dismissMyKeyboard(){
     //endEditing causes the view (or one of its embedded text fields) to resign the first responder status.
     //In short- Dismiss the active keyboard.
     view.endEditing(true)
     }
}

extension UITextView {
    func typeOn(string: String, typeInterval: TimeInterval) {
        let characterArray = string.characterArray
        var characterIndex = 0
        Timer.scheduledTimer(withTimeInterval: typeInterval, repeats: true) { (timer) in
            while characterArray[characterIndex] == " " {
                self.text.append(" ")
                characterIndex += 1
                if characterIndex == characterArray.count {
                    timer.invalidate()
                    return
                }
            }
            UIView.transition(with: self,
                              duration: typeInterval,
                              options: .transitionCrossDissolve,
                              animations: {
                                self.text.append(characterArray[characterIndex])
            })
            characterIndex += 1
            if characterIndex == characterArray.count {
                timer.invalidate()
                self.delegate?.textViewDidEndEditing?(self)
            }
        }
    }
}

//MARK: -- UITapGestureRecognizer
extension UITapGestureRecognizer {
    
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        //let textContainerOffset = CGPointMake((labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
        //(labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
        
        //let locationOfTouchInTextContainer = CGPointMake(locationOfTouchInLabel.x - textContainerOffset.x,
        // locationOfTouchInLabel.y - textContainerOffset.y);
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
    
}
