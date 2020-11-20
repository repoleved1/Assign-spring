//
//  RecorderCell.swift
//  CallSanta
//
//  Created by Feitan on 11/07/2020.
//  Copyright © 2019 Suntech. All rights reserved.
//

import UIKit
import SwipeCellKit
import FTPopOverMenu_Swift

protocol RecorderCellDelegate {
    func didControlRecorder(index: Int)
    func didTouchShare(index: Int)
    func didTouchChangeName(index: Int)
    func didTouchDelete(index: Int)
}

class RecorderCell: SwipeCollectionViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var lbCalendar: UILabel!
    @IBOutlet weak var lbTime: UILabel!
    
    @IBOutlet weak var heightPlayPauseButton: NSLayoutConstraint!    
    
    var controlPlayRecorder: (() -> Void)?
    var index: Int = 0
    var recoderDelegate: RecorderCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
                
    }
    
    func setupCell(record: RecordPhone, isPlay: Bool = false, index: Int) {
        self.index = index
        nameLabel.text = record.name?.replacingOccurrences(of: ".mp4", with: "")
        lbTime.text = record.timeCount
        lbCalendar.text = record.date?.convertDatetoString()
        if IS_IPAD {
            nameLabel.font = .applicationFontRegular(15)
        } else {
            nameLabel.font = .applicationFontRegular(15)
        }
        
        if isPlay {
            playPauseButton.setImage(UIImage(named: "ic_pause"), for: .normal)
        } else {
            playPauseButton.setImage(UIImage(named: "ic_play"), for: .normal)
        }
    }
    
    func setupCellVideo(record: RecordVideo, isPlay: Bool = false, index: Int) {
        self.index = index
        nameLabel.text = record.name?.replacingOccurrences(of: ".mp4", with: "")
        lbTime.text = record.timeCount
        lbCalendar.text = record.date?.convertDatetoString()
        if IS_IPAD {
            nameLabel.font = .applicationFontRegular(22)
        } else {
            nameLabel.font = .applicationFontRegular(15)
        }
        
        if isPlay {
            playPauseButton.setImage(UIImage(named: "ic_pause"), for: .normal)
        } else {
            playPauseButton.setImage(UIImage(named: "ic_play"), for: .normal)
        }
    }

    @IBAction func playPauseAction(_ sender: UIButton) {
        recoderDelegate?.didControlRecorder(index: index)
    }
    
    @IBAction func shareAction(_ sender: Any) {
        recoderDelegate?.didTouchShare(index: index)
    }
    
    @IBAction func editAction(_ sender: Any) {
        recoderDelegate?.didTouchChangeName(index: index)
    }
    
//    @IBAction func moreAction(_ sender: UIButton) {
//        FTPopOverMenu.showForSender(sender: sender,
//                                    with: ["Share", "Change name", "Delete"],
//                                    menuImageArray: ["ic_share", "ic_edit", "ic_trash"],
//                                    done: { (selectedIndex) -> () in
//                                        print(selectedIndex)
//                                        switch selectedIndex {
//                                        case 0:
//                                            self.delegate?.didTouchShare(index: self.index)
//                                        case 1:
//                                            self.delegate?.didTouchChangeName(index: self.index)
//                                        default:
//                                            self.delegate?.didTouchDelete(index: self.index)
//                                        }
//        }) {
//            
//        }
//    }
}
