//
//  DetailGetCallViewController.swift
//  SantaCall
//
//  Created by Feitan on 11/2/20.
//

import UIKit

class DetailGetCallViewController: UIViewController, UITextViewDelegate {
    
    //MARK: -- IBOutlet
    @IBOutlet weak var tfChooseTime: UITextField!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var lbContent: UILabel!
    @IBOutlet weak var tvContent: UITextView!
    @IBOutlet weak var btCall: UIButton!
    @IBOutlet weak var viewStyle: UIView!
    
    //MARK: -- Variables
    var santaClaus = santaClauses[0]
    var typeCall: TypeCall = .phone
    var timer: Timer!
    
    var countTime = TIME_WAIT_MAX * 1000
    
    var typeDuration: TimeInterval = 0.0325
    
    //MARK: -- View life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        image.image = UIImage(named: santaClaus.background)
        lbContent.text = santaClaus.textIntro
        tvContent.text = santaClaus.content
        countTime = Int(UserDefaults.standard.float(forKey: TIME_WAIT_CURRENT))
        tfChooseTime.isUserInteractionEnabled = true
        btCall.isEnabled = true
    }
    
    func configUI() {
        tfChooseTime.delegate = self
        tvContent.isUserInteractionEnabled = false
    }
    
    
    //MARK: -- Actions 
    @IBAction func back(_ sender: Any) {
//        navigationController?.popViewController(animated: true)
        for viewcontroller in self.navigationController?.viewControllers ?? [] {
            if viewcontroller is GetCallViewController {
                self.navigationController?.popToViewController(viewcontroller, animated: true)
            }
        }
    }
    
    @IBAction func openCallerVC(_ sender: Any) {
        let imageNamesArray = ["star1", "star2"]
        VKEmitter().emitParticles(superView: view, imageNamesArray: imageNamesArray, stopAfterSeconds: 5.0, type: 1)
        //        let startCallVC = StartViewController()
        //        navigationController?.pushViewController(startCallVC, animated: true)
        countTime = Int(Float(tfChooseTime.text ?? "3") ?? 0.0)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
        tfChooseTime.isUserInteractionEnabled = false
        btCall.isEnabled = false
    }
    
    //MARK: -- Methods support
    @objc func countDown() {
        countTime -= 1
        print(countTime)
        
        if countTime <= 99 && countTime >= 10 {
            tfChooseTime.text = String(format: "%02d", countTime)
        } else if countTime >= 0 && countTime < 10 {
            tfChooseTime.text = String(format: "%d", countTime)
        } else {
            killTime()
//            let startCallVC = StartViewController.init(nibName: String(describing: StartViewController.self).nibWithNameiPad(), bundle: nil)
            let startCallVC = StartViewController()
            startCallVC.santaClaus = santaClaus
            startCallVC.typeCall = typeCall
            self.navigationController?.pushViewController(startCallVC, animated: true)
        }
    }
    
    private func killTime() {
        timer.invalidate()
        timer = nil
        tfChooseTime.text = "3"
    }
}

extension DetailGetCallViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //For numers
        if textField == tfChooseTime {
            let allowedCharacters = CharacterSet(charactersIn:"0123456789")
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        return true
    }
}
