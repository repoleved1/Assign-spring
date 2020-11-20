//
//  CallingVideoViewController.swift
//  SantaCall
//
//  Created by Feitan on 11/5/20.
//

import UIKit
import AVKit
import ReplayKit

class CallingVideoViewController: UIViewController, RPPreviewViewControllerDelegate {
    
    // MARK: -- Outlet
    @IBOutlet weak var faceView: UIView!
    @IBOutlet weak var viewVideo: UIView!
    @IBOutlet weak var btVolume: UIButton!
    @IBOutlet weak var btCamera: UIButton!
    
    // MARK: -- Varibles
    let record = RecordVideo()
    var santaClaus = santaClauses[0]
    var playerLayer: AVPlayerLayer!
    var player = AVPlayer()
    var timer: Timer?
    var timeCall = 0
    var lbTimeCall = UILabel()
    
    //camera
    var videoDataOutput: AVCaptureVideoDataOutput!
    var videoDataOutputQueue: DispatchQueue!
    var previewLayer:AVCaptureVideoPreviewLayer!
    var captureDevice : AVCaptureDevice!
    let session = AVCaptureSession()
    var playerVideo: AVPlayer!
    var videoOutput: AVCaptureMovieFileOutput?
    
    //record
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    let recorder = RPScreenRecorder.shared()
    
    // MARK: -- View life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        playVideo()
        
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() {allowed in
                DispatchQueue.main.async {
                    if allowed {
                        //                        self.loadRecordingUI()
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupAVCapture()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(countTimeCall), userInfo: nil, repeats: true)
        startRecording()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        player.pause()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer.frame = self.viewVideo.bounds
    }
    
    //MARK: -- Methods support
    private func playVideo() {
        guard let path = Bundle.main.path(forResource: santaClaus.videoLink, ofType:"mp4") else {
            debugPrint("video not found")
            return
        }
        
        player = AVPlayer(url: URL(fileURLWithPath: path))
        self.player.volume = 40.0
        playerLayer = AVPlayerLayer(player: self.player)
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.frame = self.viewVideo.bounds
        self.viewVideo.layer.addSublayer(playerLayer)
        self.player.play()
    }
    
    @IBAction func endCall(_ sender: Any) {
        //TODO - save record of call
        finishRecording(success: true)
        for viewController in self.navigationController?.viewControllers ?? []{
            if viewController is DetailGetCallViewController {
                self.navigationController?.popToViewController(viewController, animated: true)
                break
            }
        }
        timer?.invalidate()
        timer = nil
        record.timeCount = lbTimeCall.text
        record.date = Date()
        DataManager.shared.addObject(object: record)
    }
    
    @IBAction func changeStatusMuted(_ sender: Any) {
        btVolume.isSelected = !btVolume.isSelected
        if  btVolume.isSelected {
            player.volume = 0
        } else {
            player.volume = 40
        }
    }
    
    @IBAction func changeCamera(_ sender: Any) {
        btCamera.isSelected = !btCamera.isSelected
        do{
            session.removeInput(session.inputs.first!)
            if(btCamera.isSelected){
                captureDevice = getBackCamera()
            }else{
                captureDevice = getFrontCamera()
            }
            let captureDeviceInput1 = try AVCaptureDeviceInput(device: captureDevice)
            session.addInput(captureDeviceInput1)
        }catch{
            print(error.localizedDescription)
        }
    }
    
    //MARK: -- Methods support
    @objc func countTimeCall() {
        timeCall += 1
        
        let minutes = timeCall / 60
        let seconds = timeCall % 60
        
        lbTimeCall.text = String(format: "%02d:%02d", minutes, seconds)
    }
}

//MARK: -- AVCaptureVideoDataOutputSampleBufferDelegate
extension CallingVideoViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func setupAVCapture() {
        session.sessionPreset = AVCaptureSession.Preset.cif352x288
        if #available(iOS 10.0, *) {
            guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else{return}
            captureDevice = device
        } else {
            for device in AVCaptureDevice.devices() {
                if (device as AnyObject).hasMediaType( AVMediaType.video ){
                    if (device as AnyObject).position == AVCaptureDevice.Position.front
                    {
                        captureDevice = device
                    }
                }
            }
        }
        beginSession()
    }
    
    func beginSession(){
        var err : NSError? = nil
        var deviceInput:AVCaptureDeviceInput?
        do {
            deviceInput = try AVCaptureDeviceInput(device: captureDevice)
        } catch let error as NSError {
            err = error
            deviceInput = nil
        }
        if err != nil {
            print("error: \(err?.localizedDescription ?? "")");
        }
        if self.session.canAddInput(deviceInput!){
            self.session.addInput(deviceInput!);
        }
        
        videoDataOutput = AVCaptureVideoDataOutput()
        videoDataOutput.alwaysDiscardsLateVideoFrames=true
        videoDataOutputQueue = DispatchQueue(label: "VideoDataOutputQueue")
        videoDataOutput.setSampleBufferDelegate(self, queue:self.videoDataOutputQueue)
        if session.canAddOutput(self.videoDataOutput){
            session.addOutput(self.videoDataOutput)
        }
        videoDataOutput.connection(with: AVMediaType.video)?.isEnabled = true
        
        self.previewLayer = AVCaptureVideoPreviewLayer(session: self.session)
        self.previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        
        let rootLayer :CALayer = self.faceView.layer
        rootLayer.masksToBounds = true
        self.previewLayer.frame = rootLayer.bounds
        rootLayer.addSublayer(self.previewLayer)
        session.startRunning()
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!,
                       didOutputSampleBuffer sampleBuffer: CMSampleBuffer!,
                       from connection: AVCaptureConnection!) {
    }
    func stopCamera(){
        session.stopRunning()
    }
    
    func getFrontCamera() -> AVCaptureDevice?{
        return AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .front).devices.first
    }
    
    func getBackCamera() -> AVCaptureDevice?{
        return AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back).devices.first
    }
}

//MARK: -- Record
extension CallingVideoViewController: AVAudioRecorderDelegate{
    
        func startRecording() {
            //TODO save to realm
            let id = UUID.init().uuidString
            let name = "Record_" + id.split(separator: "-")[0] + ".mp4"
            record.id = id
            record.name = name
            record.date = Date()
            record.videoName = santaClaus.videoLink
    //        record.titleName = recorder.

            //create path to save record into document
            let path = DataManager.shared.getDocumentVideoPath() + "/" + name

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
    
//            guard recorder.isAvailable else {
//                print("Recording is not available at this time.")
//                return
//            }
//            recorder.isMicrophoneEnabled = true
//
//            recorder.startRecording{ [unowned self] (error) in
//
//                guard error == nil else {
//                    print("There was an error starting the recording.")
//                    return
//                }
//
//                print("Started Recording Successfully")
//
//            }
            
    
            do {
                audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
                audioRecorder.delegate = self
                audioRecorder.record()
            } catch {
                finishRecording(success: false)
            }
        }
    
        func getDocumentsDirectory() -> URL {
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            print("------path: \(paths[0])")
            return paths[0]
        }
    
        func finishRecording(success: Bool) {
//            recorder.stopRecording { [unowned self] (preview, error) in
//                print("Stopped recording")
//
//                guard preview != nil else {
//                    print("Preview controller is not available.")
//                    return
//                }
//            }
            audioRecorder.stop()
            audioRecorder = nil
        }
    
        func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
            if !flag {
                finishRecording(success: false)
            }
        }
    
   
}
