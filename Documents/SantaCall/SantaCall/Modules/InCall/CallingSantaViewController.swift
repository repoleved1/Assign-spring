//
//  CallingSantaViewController.swift
//  SantaCall
//
//  Created by Feitan on 11/3/20.
//

import UIKit
import AVKit

class CallingSantaViewController: UIViewController {

    //MARK: -- Outlet
    @IBOutlet weak var lbTimeCall: UILabel!
    
    //MARK: -- Variables
    let record = RecordPhone()
    var santaClaus = santaClauses[0]
    var player = AVPlayer()
    var timer: Timer?
    var timeCall = 0
    
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        playVideo()
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() {allowed in
                DispatchQueue.main.async {
                    if allowed {
                        print("yes, can record")
                    } else {
                        // failed to record!
                    }
                }
            }
        } catch {
            // failed to record!
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(countTimeCall), userInfo: nil, repeats: true)
        
        startRecording()
    }
    
    private func playVideo() {
        guard let path = Bundle.main.path(forResource: santaClaus.videoLink, ofType:"mp4") else {
            debugPrint("video.m4v not found")
            return
        }
        
        player = AVPlayer(url: URL(fileURLWithPath: path))
        player.volume = 60
        player.play()
    }

    //MARK: Action
    @IBAction func endCall(_ sender: Any) {
        //TODO - save record of call
        timer?.invalidate()
        timer = nil
        finishRecording(success: true)
        for viewController in self.navigationController?.viewControllers ?? []{
            if viewController is DetailGetCallViewController {
                self.navigationController?.popToViewController(viewController, animated: true)
                break
            }
        }
        record.timeCount = lbTimeCall.text
        record.date = Date()
        DataManager.shared.addObject(object: record)

    }
    
    //MARK: -- Methods support
    @objc func countTimeCall() {
        timeCall += 1
        
        let minutes = timeCall / 60
        let seconds = timeCall % 60
        
        lbTimeCall.text = String(format: "%02d:%02d", minutes, seconds)
    }

}

//MARK: -- Record
extension CallingSantaViewController: AVAudioRecorderDelegate{
    func startRecording() {
        
        //TODO save to realm
        let id = UUID.init().uuidString
        let name = "Record_" + id.split(separator: "-")[0] + ".mp4"
        record.id = id
        record.name = name
        record.date = Date()
        
        //create path to save record into document
        let path = DataManager.shared.getDocumentPath() + "/" + name
        print("------path:  \(path)")
        guard let audioFilename = URL(string: path) else {
            return
        }
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
        } catch {
            finishRecording(success: false)
        }
    }
    
    func finishRecording(success: Bool) {
        audioRecorder.stop()
        audioRecorder = nil
        
        if success {
            print("your phone record was saved!")
//            showSuccess(message: "")
        } else {
            print(" we have some problem with your phone record")
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
}
