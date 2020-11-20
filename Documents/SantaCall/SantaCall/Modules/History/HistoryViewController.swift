//
//  HistoryViewController.swift
//  SantaCall
//
//  Created by Feitan on 11/6/20.
//

import UIKit
import Foundation
import MASegmentedControl
import AVKit
import DZNEmptyDataSet
import SwipeCellKit

class ContentDataSource {
    static func colorItems() -> [UIColor] {
        return [#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1), #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)]
    }
    
    static func textItems() -> [String] {
        return ["Get Call", "Video Call"]
    }
}

class HistoryViewController: BaseViewController, SwipeCollectionViewCellDelegate, RecorderCellDelegate, GetCallHistoryViewControllerDelegate{
        
    //MARK: -- Outlet
    @IBOutlet weak var segmentedControl: MASegmentedControl! {
        didSet {
            //Set this booleans to adapt control
            segmentedControl.itemsWithText = true
            segmentedControl.fillEqually = true
            segmentedControl.roundedControl = true
            
            let strings = ContentDataSource.textItems()
            segmentedControl.setSegmentedWith(items: strings)
            segmentedControl.padding = 2
            segmentedControl.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            segmentedControl.selectedTextColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            segmentedControl.thumbViewColor = #colorLiteral(red: 1, green: 0.4470588235, blue: 0.4588235294, alpha: 1)
            segmentedControl.titlesFont = .appplicationFontSemibold(14)
            
            let colors = ContentDataSource.colorItems()
            segmentedControl.animationDuration = 0.2
            colorsViewModel = GenericViewModel<UIColor>(items: colors)
        }
    }
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var takeRecordLabel: UILabel!
    
    //MARK: -- Varibles
    private var colorsViewModel: GenericViewModel<UIColor>?
    var recordPhone = [RecordPhone]()
    var recordVideo = [RecordVideo]()
    
    var segment = 0
    var currentIndex = -1
    var isPlay = false
    var isReStart = false
    var typeCall: TypeCall = .phone

    var player = AVPlayer()
    
    let text = "You can take a video call or voice call"
    
    //MARK: -- View life cycle
    override func viewDidLoad() {
        let backGroundColor = colorsViewModel?.getItem(at: 0)
        UIView.animate(withDuration: 0.3) {
            self.view.backgroundColor = backGroundColor
        }
        super.viewDidLoad()
        configCollectionView()
        getRecorderFromDocument()
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(takeRecord(gesture:)))
        takeRecordLabel.addGestureRecognizer(tapGesture)
        
        //        takeRecordLabel.text = "text"
        takeRecordLabel.isUserInteractionEnabled = true
        let attr = "You can take a ".normalAttribute()
        attr.append("video call".boldItalicAttribute())
        attr.append(" or ".normalAttribute())
        attr.append("voice call".boldItalicAttribute())
        takeRecordLabel.attributedText = attr
    }
    
    func configCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: RecorderCell.className.nibWithNameiPad(), bundle: nil), forCellWithReuseIdentifier: RecorderCell.className.nibWithNameiPad())
    }
    
    func getRecorderFromDocument() {
        recordPhone.removeAll()
        recordPhone = DataManager.shared.getAllRecord()
        
        recordVideo.removeAll()
        recordVideo = DataManager.shared.getAllRecordVideo()
        
        collectionView.reloadData()
        updateUI()
        
    }
    
    func updateUI() {
        if recordPhone.count == 0 || recordVideo.count == 0 {
            emptyView.isHidden = false
        } else {
            emptyView.isHidden = true
        }
    }
    
    
    func playPauseRecorder(index: Int) {
        if index == currentIndex {
            
            isPlay.toggle()
            if isPlay {
                if isReStart {
                    if segmentedControl.selectedSegmentIndex == 0 {
                        playVideo(name: recordPhone[index].name ?? "Null")
                    } else {
                        playVideo(name: recordVideo[index].name ?? "Null")
                    }
                    isReStart = false
                } else {
                    player.play()
                }
                
            } else {
                player.pause()
            }
        } else {
            currentIndex = index
            isPlay = true
            if segmentedControl.selectedSegmentIndex == 0 {
                playVideo(name: recordPhone[index].name ?? "Null")
            } else {
                playVideo(name: recordVideo[index].name ?? "Null")
            }        }
    }
    
    private func playVideo(name: String) {
        print("play video")
        let path = DataManager.shared.getDocumentPath() + "/" + name
        print("----path: \(path)")
        let url = URL(fileURLWithPath: path)
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        //        player = AVPlayer(url: url)
        player.volume = 50
        player.play()
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
                    if self!.segmentedControl.selectedSegmentIndex == 0 {
                        DataManager.shared.changeNameRecordFromDocument(record: self!.recordPhone[index], name: newName)
                        DataManager.shared.changeNameRecord(record: self!.recordPhone[index], name: newName)
                    } else {
                        DataManager.shared.changeNameVideoRecordFromDocument(record: self!.recordVideo[index], name: newName)
                        DataManager.shared.changeNameVideoRecord(record: self!.recordVideo[index], name: newName)
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
    
    func shareRecord(index: Int) {
//        guard let cell = collectionView.cellForItem(at: IndexPath(row: index, section: 0)) as? RecorderCell else { return }
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            let url = URL(fileURLWithPath: DataManager.shared.getDocumentPath() + "/" + recordPhone[index].name!)
            let activityViewController = UIActivityViewController(activityItems: [url] , applicationActivities: nil)
            self.present(activityViewController, animated: true, completion: nil)
        case 1:
            let videoUrl = URL(fileURLWithPath: DataManager.shared.getDocumentPath() + "/" + recordVideo[index].name!)
            let activityVideoViewController = UIActivityViewController(activityItems: [videoUrl] , applicationActivities: nil)
            self.present(activityVideoViewController, animated: true, completion: nil)
        default:
            break
        }
    }
    
    // MARK: GetCallHistoryViewControllerDelegate
    func changedName(index: Int) {
        let getCallDetailVC = GetCallHistoryViewController()
        recordPhone[index].name = getCallDetailVC.recordPhone[index].name
    }
    
    //MARK: -- Actions
    @IBAction func viewChanged(_ sender: MASegmentedControl) {
        let backGroundColor = colorsViewModel?.getItem(at: sender.selectedSegmentIndex)
        UIView.animate(withDuration: 0.3) {
            self.view.backgroundColor = backGroundColor
        }
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            segment = 0
            UserDefaults.standard.setValue(segment, forKey:"segment")
            UserDefaults.standard.synchronize()
        case 1:
            segment = 1
            UserDefaults.standard.setValue(segment, forKey:"segment")
            UserDefaults.standard.synchronize()
        default:
            break
        }
        self.collectionView.reloadData()
    }
    
    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func playerDidFinishPlaying(note: NSNotification) {
        print("finish playing")
        isPlay = false
        isReStart = true
        collectionView.reloadData()
    }
    
    @objc func takeRecord(gesture: UITapGestureRecognizer) {
        
        let phoneRange = (text as NSString).range(of: "voice call")
        // comment for now
        let videoRange = (text as NSString).range(of: "video call")
        
        if gesture.didTapAttributedTextInLabel(label: takeRecordLabel, inRange: phoneRange) {
            print("voice none")
            let callerVC = DetailGetCallViewController.init(nibName: String(describing: DetailGetCallViewController.self).nibWithNameiPad(), bundle: nil)
            callerVC.typeCall = .phone
            self.navigationController?.pushViewController(callerVC, animated: true)
        } else if gesture.didTapAttributedTextInLabel(label: takeRecordLabel, inRange: videoRange) {
            print("video none")
            let callerVC = DetailGetCallViewController.init(nibName: String(describing: DetailGetCallViewController.self).nibWithNameiPad(), bundle: nil)
            callerVC.typeCall = .video
            self.navigationController?.pushViewController(callerVC, animated: true)
        } else {
            print("Tapped none")
        }
    }
    
}

//MARK: -- UICollectionViewDelegate, UICollectionViewDataSource
extension HistoryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if segmentedControl.selectedSegmentIndex == 0 {
            return recordPhone.count
        }
        return recordVideo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let segment = segmentedControl.selectedSegmentIndex
        
        switch segment {
        case 0:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecorderCell.className.nibWithNameiPad(), for: indexPath) as? RecorderCell {
                if currentIndex == indexPath.row, isPlay {
                    cell.setupCell(record: recordPhone[indexPath.row], isPlay: true, index: indexPath.row)
                } else {
                    cell.setupCell(record: recordPhone[indexPath.row], index: indexPath.row)
                }
                cell.recoderDelegate = self
                cell.delegate = self
                return cell
            }
        case 1:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecorderCell.className.nibWithNameiPad(), for: indexPath) as? RecorderCell {
                if currentIndex == indexPath.row, isPlay {
                    cell.setupCellVideo(record: recordVideo[indexPath.row], isPlay: true, index: indexPath.row)
                } else {
                    cell.setupCellVideo(record: recordVideo[indexPath.row], index: indexPath.row)
                }
                cell.recoderDelegate = self
                cell.delegate = self
                return cell
            }
        default:
            break
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //TODO play record
        if segmentedControl.selectedSegmentIndex == 0 {
            let detailGetCall = GetCallHistoryViewController()
            typeCall = .phone
            detailGetCall.typeCall = typeCall
            detailGetCall.index = indexPath.row
            navigationController?.pushViewController(detailGetCall, animated: true)
        } else {
            let detailGetCall = GetCallHistoryViewController()
            typeCall = .video
            detailGetCall.typeCall = typeCall
            detailGetCall.index = indexPath.row
            navigationController?.pushViewController(detailGetCall, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, editActionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            self.didTouchDelete(index: indexPath.row)
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "ic_trash")
        deleteAction.fulfill(with: .delete)
        
        return [deleteAction]
    }
    
    func collectionView(_ collectionView: UICollectionView, editActionsOptionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .drag
        return options
    }
    
    //MARK: -- RecorderCellDelegate
    func didControlRecorder(index: Int) {
        playPauseRecorder(index: index)
        collectionView.reloadData()
    }
    
    func didTouchShare(index: Int) {
        print("đi touch share at cell: \(index)")
        shareRecord(index: index)
    }
    
    func didTouchChangeName(index: Int) {
        print("đi touch change name at cell: \(index)")
        changeNameRecord(index: index, mess: "Enter new name of this record!")
    }
    
    func didTouchDelete(index: Int) {
        print("đi touch delete at cell: \(index)")
        let alertVC = UIAlertController(title: "", message: "Do you really want to delete this record?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            if self.segmentedControl.selectedSegmentIndex == 0 {
                DataManager.shared.deleteRecordFromDocument(name: self.recordPhone[index].name!)
                DataManager.shared.deleteObject(object: self.recordPhone[index])
            } else {
                DataManager.shared.deleteRecordFromDocument(name: self.recordVideo[index].name!)
                DataManager.shared.deleteObject(object: self.recordVideo[index])
            }
            self.getRecorderFromDocument()
        }
        
        let cancelAction = UIAlertAction(title: "CANCEL", style: .default) { (action) in
            alertVC.dismiss(animated: true, completion: nil)
        }
        alertVC.addAction(cancelAction)
        alertVC.addAction(okAction)
        self.present(alertVC, animated: true, completion: nil)
        
    }
}

//MARK: -- UICollectionViewDelegateFlowLayout
extension HistoryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return IS_IPAD ? CGSize(width: DEVICE_WIDTH, height: 120) : CGSize(width: DEVICE_WIDTH, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
}
