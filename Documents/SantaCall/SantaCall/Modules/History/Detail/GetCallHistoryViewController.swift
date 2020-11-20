//
//  GetCallHistoryViewController.swift
//  SantaCall
//
//  Created by Feitan on 11/10/20.
//

import UIKit
import AVKit

protocol GetCallHistoryViewControllerDelegate {
    func changedName(index: Int)
}

class GetCallHistoryViewController: UIViewController, IQ_FDWaveformViewDelegate {
    
    //MARK: -- IBOutlet
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var viewSoundWave: UIView!
    
    @IBOutlet weak var viewVideoSanta: UIView!
    @IBOutlet weak var viewLayoutVideoCall: UIView!
    @IBOutlet weak var viewLayoutGetCall: UIView!
    @IBOutlet weak var viewMyVideo: UIView!
    
    @IBOutlet weak var btPlayPause: UIButton!
    @IBOutlet weak var lbCurrentTime: UILabel!
    @IBOutlet weak var lbRangerTime: UILabel!
    
    //MARK: -- Varibles
    private var trimView: TrimAudioView!
    private var currentBeginValue: CGFloat?
    private var currentEndValue: CGFloat?
    private var cropTime = 0.0
    
    var recordPhone = [RecordPhone]()
    var recordVideo = [RecordVideo]()
    
    var typeCall: TypeCall = .phone
    var _audioURL: URL?
    var videoOutput: AVCaptureMovieFileOutput?
    
    var index: Int = 0
    var currentIndex = -1
    var isPlay: Bool = false
    var isReStart = false
    
    var player = AVPlayer()
    var playerLayer: AVPlayerLayer!
    var player2 = AVPlayer()
    var playerLayer2: AVPlayerLayer!
    
    var delegate: GetCallHistoryViewControllerDelegate?
    
    //MARK: -- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getRecorderFromDocument()
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: nil)
        //        if lbTitle.text == "" {
        //            lbTitle.text = recordPhone[index].name
        //        } else {
        //            lbTitle.text = recordPhone[index].titleName
        //        }
        setupUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if lbTitle.text == "" {
            lbTitle.text = recordPhone[index].name
        } else {
            if typeCall == .phone {
                lbTitle.text = recordPhone[index].titleName
            } else {
                lbTitle.text = recordVideo[index].titleName
            }
        }
    }
    
    @objc private func playerDidFinishPlaying() {
        self.player.pause()
    }
    
    private func setupUI() {
        //Button Play Pause
//        btPlayPause.setImage(!isPlay ? UIImage(named: "ic_play") : UIImage(named: "ic_pause"), for: .normal)
        
        //Text title
        if IS_IPAD {
            lbTitle.font = .appplicationFontSemibold(30)
        } else {
            lbTitle.font = .appplicationFontSemibold(23)
        }
        
        //View sound wave
        if typeCall == .phone {
            viewLayoutVideoCall.isHidden = true
            viewSoundWave.frame.size = CGSize(width: DEVICE_WIDTH, height: DEVICE_HEIGHT)
            trimView = TrimAudioView(frame: viewSoundWave.bounds)
            trimView.setupView()
            trimView.delegate = self
            trimView.waveformView.delegate = self
            viewSoundWave.insertSubview(trimView, at: 0)
            setAudioUrl(name: recordPhone[index].name ?? "Null")
            updateView(audioURL: _audioURL!)
        } else {
            viewLayoutGetCall.isHidden = true
        }

    }
    
    func getRecorderFromDocument() {
        
        switch typeCall {
        case .phone:
            recordPhone.removeAll()
            recordPhone = DataManager.shared.getAllRecord()
        default:
            recordVideo.removeAll()
            recordVideo = DataManager.shared.getAllRecordVideo()
        }
    }
    
    private func playVideo(name: String) {
        print("play video")
        if typeCall == .phone {
            isPlay = !trimView.audioPlayer.isPlaying
            if trimView.audioPlayer.isPlaying{
                btPlayPause.setImage(UIImage(named: "ic_play"), for: .normal)
                trimView.pauseAction()
            } else {
                btPlayPause.setImage(UIImage(named: "ic_pause"), for: .normal)
                trimView.playAction()
            }
        } else {
            
            //Video Santa
//            guard let path = Bundle.main.path(forResource: DataManager.shared.getDocumentPath(), ofType:"mp4") else {
//                debugPrint("video not found")
//                return
//            }
            guard let path = Bundle.main.path(forResource: recordVideo[index].videoName, ofType:"mp4") else {
                debugPrint("video not found")
                return
            }
            player = AVPlayer(url: URL(fileURLWithPath: path))
            self.player.volume = 0.0
            playerLayer = AVPlayerLayer(player: self.player)
            playerLayer.videoGravity = .resizeAspectFill
            playerLayer.frame = self.viewVideoSanta.bounds
            self.viewVideoSanta.layer.addSublayer(playerLayer)
            self.player.play()
            
            
            //Video me
            let path2 = DataManager.shared.getDocumentVideoPath() + "/" + name
            player2 = AVPlayer(url: URL(fileURLWithPath: path2))
            playerLayer2 = AVPlayerLayer(player: self.player2)
            self.player2.volume = 40.0
            playerLayer2.frame = self.viewMyVideo.bounds
            playerLayer2.videoGravity = .resizeAspectFill
            self.viewMyVideo.layer.addSublayer(playerLayer2)
            self.player2.play()
        }
    }
    
    private func updateView(audioURL: URL) {
        self._audioURL = audioURL
        self.trimView.setAudioFile(urlAudio: audioURL)
        
        currentBeginValue = 0
        currentEndValue = CGFloat(trimView.audioPlayer.duration)
        lbCurrentTime.text = 0.asStringFormattime()
        lbRangerTime.text = "\(Int(trimView.audioPlayer.duration - 0).asStringFormattime())"
    }
    
    func setAudioUrl(name: String) {
        print("play video")
        let path = DataManager.shared.getDocumentPath() + "/" + name
        print("----path: \(path)")
        let url = URL(fileURLWithPath: path)
        _audioURL = url
    }
    
    func changeNameRecord(index: Int, mess: String) {
        let alert = UIAlertController(title: "Rename record", message: mess, preferredStyle: .alert)
        
        alert.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Record's name"
        }
        let actionSave = UIAlertAction(title: "SAVE", style: .default) { [weak self](action) in
            
            let tfName = alert.textFields![0] as UITextField
            let name = tfName.text
            if let newName = name, newName.count > 0 {
                if DataManager.shared.checkNameExist(name: newName) {
                    self?.changeNameRecord(index: index, mess: "This name was existed.Please try with other name!")
                } else if DataManager.shared.checkNameExistVideo(name: newName) {
                    self?.changeNameRecord(index: index, mess: "This name was existed.Please try with other name!")
                } else {
                    if self!.typeCall == .phone {
                        DataManager.shared.changeNameRecordFromDocument(record: self!.recordPhone[index], name: newName)
                        DataManager.shared.changeNameRecord(record: self!.recordPhone[index], name: newName)
                        self!.lbTitle.text = self!.recordPhone[index].titleName
                    } else {
                        DataManager.shared.changeNameVideoRecordFromDocument(record: self!.recordVideo[index], name: newName)
                        DataManager.shared.changeNameVideoRecord(record: self!.recordVideo[index], name: newName)
                        self!.lbTitle.text = self!.recordVideo[index].titleName
                    }
                    self!.getRecorderFromDocument()
                }
                
            } else {
                self?.changeNameRecord(index: index, mess: "Please enter new name!")
            }
        }
        
        let actionCancel = UIAlertAction(title: "CANCEL", style: .default, handler: nil)
        
        alert.addAction(actionCancel)
        alert.addAction(actionSave)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: -- IBActions
    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func play(_ sender: Any) {
        switch typeCall {
        case .phone:
            playVideo(name: recordPhone[index].name ?? "Null")
        default:
            playVideo(name: recordVideo[index].name ?? "Null")
        }
    }
    
    @IBAction func share(_ sender: Any) {
        switch typeCall {
        case .phone:
            let url = URL(fileURLWithPath: DataManager.shared.getDocumentPath() + "/" + recordPhone[index].name!)
            let activityViewController = UIActivityViewController(activityItems: [url] , applicationActivities: nil)
            self.present(activityViewController, animated: true, completion: nil)
        default:
            let url = URL(fileURLWithPath: DataManager.shared.getDocumentPath() + "/" + recordVideo[index].name!)
            let activityViewController = UIActivityViewController(activityItems: [url] , applicationActivities: nil)
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func edit(_ sender: Any) {
        changeNameRecord(index: index, mess: "Enter new name of this record!")
        delegate?.changedName(index: index)
    }
    
}

extension GetCallHistoryViewController: TrimAudioViewDelegate {
    func audioPlayerDidStop() {
        print("audioPlayerDidStop")
        isPlay = false
        btPlayPause.setImage(UIImage(named: "ic_play"), for: .normal)
    }
    
    func audioPlayerDidUpdate(currentValue: Int) {
        print("audioPlayerDidUpdate")
        lbCurrentTime.text = "\(currentValue.asStringFormattime())"
    }
    func didEndChangeCropview() {
        cropTime = trimView.rightCropView.cropTime - trimView.leftCropView.cropTime
        lbRangerTime.text = (Int(cropTime)).asStringFormattime()
    }
    func beginChangeCropView() {
        cropTime = trimView.rightCropView.cropTime - trimView.leftCropView.cropTime
        lbRangerTime.text = (Int(cropTime)).asStringFormattime()
    }
}
