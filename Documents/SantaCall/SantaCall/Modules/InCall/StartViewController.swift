//
//  StartViewController.swift
//  SantaCall
//
//  Created by Feitan on 11/3/20.
//

import UIKit
import AVKit

class StartViewController: UIViewController {
    
    //MARK: -- Outlet
    @IBOutlet weak var lbCalling: UILabel!
    @IBOutlet weak var lbTypeCall: UILabel!
    @IBOutlet weak var lbWidthTypeCall: NSLayoutConstraint!
    @IBOutlet weak var btEndCall: UIButton!
    @IBOutlet weak var btStartCall: UIButton!
    @IBOutlet weak var lbTimeCall: UILabel!
    
    //MARK: -- Varibles
    var santaClaus = santaClauses[0]
    var player: AVAudioPlayer?
    let lables = [".", "..", "..."]
    var typeCall: TypeCall = .phone
    
    var playerSanta = AVPlayer()
    var timer: Timer?
    var timeCall = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // start animate image view
        var index = 0
        Timer.scheduledTimer(withTimeInterval: 0.4, repeats: true) { [self] (timer) in
            self.lbCalling.text = lables[index]
            index += 1
            if index == self.lables.count {
                index = 0
            }
        }
        playSound()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // check type call
        switch typeCall {
        case .phone:
            lbTypeCall.text = "is calling"
        default:
            lbTypeCall.text = "is video calling"
            lbWidthTypeCall.constant = 150
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        player?.stop()
    }
    
    private func setupUI() {
//        UIView.animate(withDuration: 1.0,
//                       delay: 0,
//                       usingSpringWithDamping: 0.2,
//                       initialSpringVelocity: 6.0,
//                       options: .allowUserInteraction,
//                       animations: { [weak self] in
//                        self?.btStartCall.frame.origin.y = 50
//                        self?.btStartCall.frame.origin.y = -50
//                       }, completion: {finished in
//                        self.setupUI()
//                       })
        UIView.animate(withDuration: 1.0, animations:{
            self.btStartCall.frame.origin.y = 25
            self.btStartCall.frame.origin.y = -25
           }, completion: {finished in
                                    self.setupUI()
                                   })
    }
    
    //MARK: -- Actions
    @IBAction func startCall(_ sender: Any) {
        
        switch typeCall {
        case .phone:
            print("call phone")
            let callingPhoneVC = CallingSantaViewController()
            callingPhoneVC.santaClaus = santaClaus
            self.navigationController?.pushViewController(callingPhoneVC, animated: true)
        default:
            print("call video")
            let callingVideoVC = CallingVideoViewController()
            callingVideoVC.santaClaus = santaClaus
            self.navigationController?.pushViewController(callingVideoVC, animated: true)
        }
    }
    
    @IBAction func endCall(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: -- Methods support
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "tone_ring_ring", withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
            if #available(iOS 11.0, *) {
                /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
                player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
                
                player?.numberOfLoops = -1
            } else {
                // iOS 10 and earlier require the following line:
                player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
                player?.numberOfLoops = -1
            }
            guard let player = player else { return }
            
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
