//
//  TrimAudioView.swift
//  RingTones
//
//  Created by Duong on 12/26/19.
//  Copyright © 2019 Duong. All rights reserved.
//

import Foundation
import UIKit
 
enum TrimAudioGestureState: Int {
    case None
    case Left
    case Right
}

protocol TrimAudioViewDelegate: class {
    func audioPlayerDidUpdate(currentValue: Int)
    func audioPlayerDidStop()
    func beginChangeCropView()
    func didEndChangeCropview()
}

class TrimAudioView: UIView {
    weak var delegate: TrimAudioViewDelegate?
    
    var playProgressDisplayLink: CADisplayLink?
    var _oldSessionCategory: String?
    var _wasIdleTimerDisabled: Bool = false
    
    private var middleContainerView: UIView!
    private var originalAudioFileURL: URL? = nil
    private var currentAudioFileURL: URL? = nil
    private var gestureState: TrimAudioGestureState!
    private var cropPanGesture: UIPanGestureRecognizer!
    private var cropTapGesture: UITapGestureRecognizer!
    
    var waveformView: IQ_FDWaveformView!
    var beginCenter: CGPoint!
    var leftCropView: IQCropSelectionBeginView!
    var rightCropView: IQCropSelectionEndView!
    var audioPlayer: AVAudioPlayer!
    
    func setupView() {        
        middleContainerView = UIView(frame: self.bounds)
        middleContainerView?.backgroundColor = .clear
      
        waveformView = IQ_FDWaveformView(frame: CGRect(x: 22, y: 25, width: DEVICE_WIDTH - 44, height: 150))
        waveformView.isUserInteractionEnabled = false
        waveformView.wavesColor = .white
        waveformView.progressColor = .black
        waveformView.cropColor = UIColor(named: "Shadow")
        
        waveformView.doesAllowScroll = true
        waveformView.doesAllowScrubbing = true
        waveformView.doesAllowStretch = true
        
        self.addSubview(middleContainerView!)
        middleContainerView.addSubview(waveformView)
        
        // - CropView
        leftCropView = IQCropSelectionBeginView(frame: CGRect(x: 0, y: 0, width: 44, height: 210))
        leftCropView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
        self.addSubview(leftCropView)
        rightCropView = IQCropSelectionEndView(frame: CGRect(x: DEVICE_WIDTH - 44, y: 0, width: 44, height: 210))
        rightCropView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
        self.addSubview(rightCropView)
    }
    
    func setAudioFile(urlAudio: URL) {
        self.originalAudioFileURL = urlAudio
        self.currentAudioFileURL = urlAudio
        
        // - Audio
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: currentAudioFileURL!)
            audioPlayer = try? AVAudioPlayer(contentsOf: currentAudioFileURL!)
            audioPlayer.delegate = self
            audioPlayer.isMeteringEnabled = true
        } catch {
            print(error)
        }
        
        waveformView.audioURL = currentAudioFileURL
        
        // - Update
        leftCropView.cropTime = 0
        rightCropView.cropTime = audioPlayer.duration
        
        waveformView.cropStartSamples = Int(Double(waveformView.totalSamples) * (leftCropView.cropTime / audioPlayer.duration))
        waveformView.cropEndSamples = Int(Double(waveformView.totalSamples) * (rightCropView.cropTime / audioPlayer.duration))
        if waveformView.audioURL != nil {
            cropPanGesture = UIPanGestureRecognizer.init(target: self, action: #selector(cropPan(_:)))
            self.addGestureRecognizer(cropPanGesture)
        }
    }
    
    // MARK:  -
    func changeLeftValue(value: Double) {
        stopPlayingButtonAction()
        audioPlayer.currentTime = value
        leftCropView.cropTime = value
//        waveformView.progressSamples = Int(Double(waveformView.totalSamples) * (audioPlayer.currentTime / audioPlayer.duration))
//        waveformView.cropStartSamples = Int(Double(waveformView.totalSamples) * (value / audioPlayer.duration))
        
    }
    
    func changeRightValue(value: Double) {
        stopPlayingButtonAction()
        rightCropView.cropTime = value
        waveformView.cropEndSamples = Int(Double(waveformView.totalSamples) * (value / audioPlayer.duration))
    }
    
    @objc func cropTap(_ tapRecognizer: UITapGestureRecognizer) {
        if tapRecognizer.state == .ended {
            stopPlayingButtonAction()
            
            let tappedLocation: CGPoint = tapRecognizer.location(in: self.middleContainerView)
            let leftDistance: CGFloat = abs(leftCropView.center.x - tappedLocation.x)
            let rightDistance: CGFloat = abs(rightCropView.center.x - tappedLocation.x)
            
            let state: TrimAudioGestureState = leftDistance > rightDistance ? TrimAudioGestureState.Right : TrimAudioGestureState.Left
            switch state {
            case .Left:
                var pointX = max(waveformView.frame.minX, tappedLocation.x)
                pointX = min(rightCropView.frame.minX, pointX)
                
                let leftCropViewCenter: CGPoint = CGPoint(x: pointX, y: leftCropView.center.y)
                
                UIView.animate(withDuration: 0.2, delay: 0, options: [.beginFromCurrentState, .curveEaseInOut], animations: {
                    self.leftCropView.center = leftCropViewCenter
                }, completion: nil)
                
                let centerInWaveform: CGPoint = leftCropView.superview!.convert(leftCropViewCenter, to: waveformView)
                
                leftCropView.cropTime = TimeInterval(centerInWaveform.x / waveformView.frame.size.width) * audioPlayer.duration
                audioPlayer.currentTime = leftCropView.cropTime
                waveformView.progressSamples = Int(Double(waveformView.totalSamples) * (audioPlayer.currentTime / audioPlayer.duration))
                waveformView.cropStartSamples = Int(Double(waveformView.totalSamples) * (leftCropView.cropTime / audioPlayer.duration))
                break
                
            case .Right:
                var pointX = min(waveformView.frame.maxX, tappedLocation.x)
                pointX = max(leftCropView.frame.maxX, pointX)
                
                let rightCropViewCenter: CGPoint = CGPoint(x: pointX, y: rightCropView.center.y)
                
                UIView.animate(withDuration: 0.2, delay: 0, options: [.beginFromCurrentState, .curveEaseInOut], animations: {
                    self.rightCropView.center = rightCropViewCenter
                }, completion: nil)
                
                let centerInWaveform: CGPoint = rightCropView.superview!.convert(rightCropViewCenter, to: waveformView)
                
                rightCropView.cropTime = TimeInterval(centerInWaveform.x / waveformView.frame.size.width) * audioPlayer.duration
                waveformView.cropEndSamples = Int(Double(waveformView.totalSamples) * (rightCropView.cropTime / audioPlayer.duration))
                break
            default:
                break
            }
        }
    }
    
    @objc func cropPan(_ panRecognizer: UIPanGestureRecognizer) {
        
        let currentLocation = panRecognizer.location(in: middleContainerView)
        if panRecognizer.state == .began {
            stopPlayingButtonAction()
            
            let leftDistance: CGFloat = abs(leftCropView.center.x - currentLocation.x)
            let rightDistance: CGFloat = abs(rightCropView.center.x - currentLocation.x)
            
            gestureState = leftDistance > rightDistance ? TrimAudioGestureState.Right : TrimAudioGestureState.Left
            
            switch gestureState {
            case .Left:
                beginCenter = leftCropView.center
                break
            case .Right:
                beginCenter = rightCropView.center
                break
            default:
                break
            }
        }
        
        if panRecognizer.state == .began || panRecognizer.state == .changed {
            
            switch gestureState {
            case .Left:
                var pointX = max(waveformView.frame.minX, currentLocation.x)
                pointX = min(rightCropView.frame.minX, pointX)
                
                let leftCropViewCenter: CGPoint = CGPoint(x: pointX, y: beginCenter.y)
                
                UIView.animate(withDuration: panRecognizer.state == UIGestureRecognizer.State.began ? 0.2 : 0, delay: 0, options: [.beginFromCurrentState, .curveEaseInOut], animations: {
                    self.leftCropView.center = leftCropViewCenter
                }, completion: nil)
                
                let centerInWaveform: CGPoint = leftCropView.superview!.convert(leftCropViewCenter, to: waveformView)
                
                leftCropView.cropTime = TimeInterval(centerInWaveform.x / waveformView.frame.size.width) * audioPlayer.duration
                audioPlayer.currentTime = leftCropView.cropTime
                waveformView.progressSamples = Int(Double(waveformView.totalSamples) * (audioPlayer.currentTime / audioPlayer.duration))
                waveformView.cropStartSamples = Int(Double(waveformView.totalSamples) * (leftCropView.cropTime / audioPlayer.duration))
                delegate?.beginChangeCropView()
                break
                
            case .Right:
                var pointX = min(waveformView.frame.maxX, currentLocation.x)
                pointX = max(leftCropView.frame.maxX, pointX)
                
                let rightCropViewCenter: CGPoint = CGPoint(x: pointX, y: rightCropView.center.y)
                
                UIView.animate(withDuration: panRecognizer.state == UIGestureRecognizer.State.began ? 0.2 : 0, delay: 0, options: [.beginFromCurrentState, .curveEaseInOut], animations: {
                    self.rightCropView.center = rightCropViewCenter
                }, completion: nil)
                
                let centerInWaveform: CGPoint = rightCropView.superview!.convert(rightCropViewCenter, to: waveformView)
                
                rightCropView.cropTime = TimeInterval(centerInWaveform.x / waveformView.frame.size.width) * audioPlayer.duration
                waveformView.cropEndSamples = Int(Double(waveformView.totalSamples) * (rightCropView.cropTime / audioPlayer.duration))
                delegate?.beginChangeCropView()
                break
            default:
                break
            }
        } else if panRecognizer.state == .ended || panRecognizer.state == .failed {
            beginCenter = CGPoint.zero
            gestureState = .None
            delegate?.didEndChangeCropview()
        }
    }
    
    
    // MARK: - Audio Play
    @objc func updatePlayProgress() {
        let value = audioPlayer.currentTime - leftCropView.cropTime
        if delegate != nil {
            delegate?.audioPlayerDidUpdate(currentValue: Int(value))
        }
        
        waveformView!.progressSamples = Int(Double(waveformView.totalSamples) * (audioPlayer.currentTime / audioPlayer.duration))
        if audioPlayer.currentTime >= rightCropView.cropTime {
            // - Pause
            stopPlayingButtonAction()
        }
    }
    
    func playAction() {
        _oldSessionCategory = AVAudioSession.sharedInstance().category.rawValue
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            UIApplication.shared.isIdleTimerDisabled = true
        } catch {
            print(error)
        }
        
        audioPlayer.prepareToPlay()
        audioPlayer.play()
        
        playProgressDisplayLink?.invalidate()
        playProgressDisplayLink = CADisplayLink(target: self, selector: #selector(updatePlayProgress))
        playProgressDisplayLink?.add(to: .current, forMode: .common)
    }
    
    func pauseAction() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.init(rawValue: _oldSessionCategory ?? ""))
            UIApplication.shared.isIdleTimerDisabled = false
        } catch {
            print(error)
        }
        audioPlayer.pause()
        if delegate != nil {
            delegate?.audioPlayerDidStop()
        }
    }
    
    func stopPlayingButtonAction() {
        playProgressDisplayLink?.invalidate()
        playProgressDisplayLink = nil
        
        audioPlayer.stop()
        
        if delegate != nil {
            delegate?.audioPlayerDidStop()
        }
        
        audioPlayer.currentTime = leftCropView.cropTime
        waveformView.progressSamples = Int(Double(waveformView.totalSamples) * (audioPlayer.currentTime / audioPlayer.duration))
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.init(rawValue: _oldSessionCategory ?? ""))
            UIApplication.shared.isIdleTimerDisabled = false
        } catch {
            print(error)
        }
    }
    
    // MARK: - Crop
}

extension TrimAudioView: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        stopPlayingButtonAction()
    }
}
