//
//  SignUpViewController.swift
//  Sem4
//
//  Created by Feitan on 10/4/20.
//

import UIKit
import Alamofire
import AnimatedField

class SignUpViewController: UIViewController {

 
    @IBOutlet weak var animatedFieldEmail: AnimatedField!
    @IBOutlet weak var animatedFieldPassword: AnimatedField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTap()
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
      self.navigationController?.setNavigationBarHidden(false, animated: false)
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
        
        animatedFieldPassword.format = format
        animatedFieldPassword.placeholder = "Password"
        animatedFieldPassword.dataSource = self
        animatedFieldPassword.delegate = self
        animatedFieldPassword.secureField(true)
        animatedFieldPassword.showVisibleButton = true
        animatedFieldPassword.type = .password(4, 20)
        animatedFieldPassword.tag = 0
    }

    @IBAction func signUp(_ sender: Any) {
      //        if let email = emailTextField.text, let password = passwordTextField.text {
      //            signUpManager.createUser(email: email, password: password) {[weak self] (success) in
      //                guard let `self` = self else { return }
      //                var message: String = ""
      //                if (success) {
      //                    message = "User was sucessfully created."
      //                } else {
      //                    message = "There was an error."
      //                }
      //                let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
      //                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
      //                self.display(alertController: alertController)
      //            }
      //        }
              let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)

              alert.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
              
              guard let email = self.animatedFieldEmail.text else {return}
              guard let password = self.animatedFieldPassword.text else {return}
              let register = RegisterModel(email: email, password: password)
              APIManager.shareInstance.callingRegisterApi(register: register)
              { (inSuccess, str) in
                  if inSuccess {
                      alert.message = str
                      self.present(alert, animated: true)
                    let LoginVC = LoginViewController()
                    self.navigationController?.pushViewController(LoginVC, animated: true)
                    
                  } else {
                      alert.message = str
                      self.present(alert, animated: true)
                    
                  }
              }
    }
    
    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}

extension SignUpViewController: AnimatedFieldDelegate {
    
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

extension SignUpViewController: AnimatedFieldDataSource {
    
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
