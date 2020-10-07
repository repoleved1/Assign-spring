//
//  LoginViewController.swift
//  Sem4
//
//  Created by Feitan on 10/4/20.
//

import UIKit
import AnimatedField

class LoginViewController: UIViewController {

    @IBOutlet weak var animatedFieldEmail: AnimatedField!
    @IBOutlet weak var AnimatedFieldPassword: AnimatedField!
    @IBOutlet weak var tfEmailUser: UITextField!
    @IBOutlet weak var tfPasswordUser: UITextField!
    @IBOutlet weak var btLogin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        hideKeyboardWhenTap()
        setupUI()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
      self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    private func checkInputText() -> Bool {
        if animatedFieldEmail.text?.count == 0 || AnimatedFieldPassword.text?.count == 0 {
            btLogin.setTitleColor(UIColor.init(white: 1, alpha: 0.5))
            return false
        } else {
            btLogin.setTitleColor(UIColor.init(white: 1, alpha: 1))
            return true
        }
    }
    
    func setupUI() {
        var format = AnimatedFieldFormat()
        format.titleFont = UIFont(name: "AvenirNext-Regular", size: 14)!
        format.textFont = UIFont(name: "AvenirNext-Regular", size: 16)!
        format.alertColor = .red
        format.alertFieldActive = false
        format.titleAlwaysVisible = true
        format.alertFont = UIFont(name: "AvenirNext-Regular", size: 14)!
        
        animatedFieldEmail.format = format
        animatedFieldEmail.placeholder = "Write your email"
        animatedFieldEmail.dataSource = self
        animatedFieldEmail.delegate = self
        animatedFieldEmail.type = .email
        animatedFieldEmail.tag = 0
        
        AnimatedFieldPassword.format = format
        AnimatedFieldPassword.placeholder = "Password"
        AnimatedFieldPassword.dataSource = self
        AnimatedFieldPassword.delegate = self
        AnimatedFieldPassword.secureField(true)
        AnimatedFieldPassword.showVisibleButton = true
        AnimatedFieldPassword.type = .password(4, 20)
        AnimatedFieldPassword.tag = 1
        
    }
    
    @IBAction func forgotPassword(_ sender: Any) {
    }
    
    @IBAction func signIn(_ sender: Any) {
        guard let email = animatedFieldEmail.text else {return}
        guard let password = AnimatedFieldPassword.text else {return}
        let modelLogin = LoginModel(login: email, password: password)
        APIManager.shareInstance.callingLoginApi(login: modelLogin) { (result) in
            switch result {
            case .success(let json):
                print(json as AnyObject)
                let email = (json as! ResponseModel).email
    //            let email = (json as AnyObject).value(forKey: "email") as! String
    //            let modelLoginResponse = LoginResponseModel(email: email)
    //            print(modelLoginResponse)
                
//                let homeVC = HomeViewController()
                let storyboard = UIStoryboard.init(name: "HomeVC", bundle: nil)
                let homeVC = storyboard.instantiateViewController(withIdentifier: "BubbleTabBarController")
                homeVC.modalPresentationStyle = .fullScreen
                self.navigationController?.present(homeVC, animated: true, completion: nil)
                
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    @IBAction func openSignUpVC(_ sender: Any) {
        let SignupVC = SignUpViewController()
        self.navigationController?.pushViewController(SignupVC, animated: true)
    }

}

extension LoginViewController {
  
  func showPopup(isSuccess: Bool) {
    let successMessage = "User was sucessfully logged in."
    let errorMessage = "Something went wrong. Please try again"
    let alert = UIAlertController(title: isSuccess ? "Success": "Error", message: isSuccess ? successMessage: errorMessage, preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: "Done", style: UIAlertAction.Style.default, handler: nil))
    self.present(alert, animated: true, completion: nil)
  }
}

extension LoginViewController: AnimatedFieldDelegate {
    
    func animatedFieldDidBeginEditing(_ animatedField: AnimatedField) {
        let offset = animatedField.frame.origin.y + animatedField.frame.size.height - (view.frame.height - 350)
    }
    
    func animatedFieldDidEndEditing(_ animatedField: AnimatedField) {
    }
    
    func animatedField(_ animatedField: AnimatedField, didResizeHeight height: CGFloat) {
        view.layoutIfNeeded()
        
    }
    
    func animatedField(_ animatedField: AnimatedField, didSecureText secure: Bool) {
        
    }
    
    func animatedField(_ animatedField: AnimatedField, didChangePickerValue value: String) {
    }
    
    func animatedFieldDidChange(_ animatedField: AnimatedField) {
        print("text: \(animatedField.text ?? "")")
    }
}

extension LoginViewController: AnimatedFieldDataSource {
    
    func animatedFieldLimit(_ animatedField: AnimatedField) -> Int? {
        switch animatedField.tag {
        case 1: return 10
        case 8: return 30
        default: return nil
        }
    }
    
    func animatedFieldValidationError(_ animatedField: AnimatedField) -> String? {
        if animatedField == animatedFieldEmail {
            return "Email invalid! Please check again ;)"
        }
        return nil
    }
}
