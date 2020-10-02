//
//  LAGaleryViewController.swift
//  LockApp
//
//  Created by Feitan on 8/13/20.
//  Copyright © 2020 SingleViewApp. All rights reserved.
//

import UIKit
import Gallery
import Photos

class LAGaleryViewController: BaseVC {
    
    // MARK: - IBOutlet
    @IBOutlet weak var imageNo: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var labelNo: UILabel!
    @IBOutlet weak var viewLayout: UIView!
    @IBOutlet weak var navi: NavigationView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var buttonAdd: UIButton!
    @IBOutlet weak var btDelete: UIButton!
    @IBOutlet weak var btSelect: UIButton!
    @IBOutlet weak var btShare: UIButton!
    
    let viewModel: ImageVideoModelView = ImageVideoModelView()
    var isVideos = false
    var isShowViewAction = false
    var arrData = [GalleryObj]()
    var gallery: GalleryController!
    let editor: VideoEditing = VideoEditor()
    var idAlbum = ""
    var objGallery = AlbumObj()
    var arrSelected = [GalleryObj]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        initData()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if arrData.count != 0 {
            imageNo.isHidden = true
            labelNo.isHidden = true
        } else {
            imageNo.isHidden = false
            labelNo.isHidden = false
        }
    }
    
    @IBAction func share(_ sender: Any) {
    }
    
    @IBAction func addMedia(_ sender: Any) {
        self.gallery = GalleryController()
        Config.Camera.recordLocation = true
        self.gallery.delegate = self
        
        let alert = UIAlertController(title: "Select Media", message: "Please Select an Option", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Select Media in Library", style: .default , handler:{ (UIAlertAction)in
            print("User click Edit button")
            Config.tabsToShow = [.imageTab, .videoTab]
            self.present(self.gallery, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancle", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func selected(_ sender: Any) {
        self.selected()
    }
    
    func initData() {
        self.arrData.removeAll()
        self.arrData = idAlbum == "-1" ? galleryManager.getAllGallery() : galleryManager.getAllGalleryByIdAlbum(idAlbum)
        viewModel.isVideo = isVideos
        viewModel.arrData = self.arrData
        collectionView.reloadData()
        imageNo.isHidden = true
        labelNo.isHidden = true
    }
    
    func setupUI() {
        lbTitle.text = objGallery.name.count == 0 ? "No title" : objGallery.name
    
        btShare.isHidden = true
        btDelete.isHidden = true
        btShare.addTarget(self, action: #selector(shareSelector), for: .touchUpInside)
        btDelete.addTarget(self, action: #selector(deleteSelector), for: .touchUpInside)
        self.collectionView.register(GalleryCollectionViewCell.self)
        collectionView.delegate = viewModel
        collectionView.dataSource = viewModel
        
        let lpgr : UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        
        lpgr.minimumPressDuration = 0.3
        lpgr.delegate = self
        lpgr.delaysTouchesBegan = true
        self.collectionView?.addGestureRecognizer(lpgr)
        
        
        viewModel.handleSelectRow = { (index) in
            self.goToPreview(index)
        }
        
        viewModel.handleMultilSelectRow = { (index) in // return index select when apped arr select
            self.arrSelected.append(self.arrData[index])
        }
        viewModel.handleMultilDeSelectRow = { (index) in // return index deseclect
            if let index = self.arrSelected.firstIndex(of: self.arrData[index]) {
                self.arrSelected.remove(at: index)
            }
        }
        
        //View Layout
        viewLayout.clipsToBounds = true
        viewLayout.layer.cornerRadius = 50
        viewLayout.layer.maskedCorners = [.layerMinXMinYCorner]
    }
    
    @objc func deleteSelector() {
        if arrSelected.count == 0 {
            Common.showAlert("No item in selected")
        }else{
            _ = UIAlertController.present(style: .alert, title: "app_name".localized, message: "txt_delete_selector".localized, attributedActionTitles: [("txt_ok".localized, .default), ("txt_cancel".localized, .cancel)], handler: { (action) in
                if action.title == "txt_ok".localized {
                    for obj in self.arrSelected {
                        let url = FilePaths.filePaths.path+obj.fileName
                        self.deleteFile(url: URL(fileURLWithPath: url))
                        obj.deleteGallery()
                    }
                    self.arrSelected.removeAll()
                    self.initData()
                }
            })
        }
        
    }
    
    @objc func shareSelector() {
        if self.arrSelected.count > 0 {
            
            var shareAll = [] as [Any]
            
            for obj in self.arrSelected {
                let filePath = FilePaths.filePaths.path+obj.fileName
                let file = NSURL(fileURLWithPath: filePath)
                shareAll.append(file)
            }
            let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)
        }else{
            Common.showAlert("No item in selected")
        }
    }
    
    func goToPreview(_ index: Int) {
        if self.arrData[index].isVideo {
            let lightBox = arrData.filter({ (obj) -> Bool in
                obj.isVideo == true
            }).map {LightboxImage(image: self.getThumbnailFrom(path: URL(fileURLWithPath: FilePaths.filePaths.path + $0.fileName))!, text: "Privew Video", videoURL: URL(fileURLWithPath: FilePaths.filePaths.path + $0.fileName))}
            let controller = LightboxController(images: lightBox)
            controller.dynamicBackground = true
            controller.goTo(index)
            controller.modalPresentationStyle = .fullScreen
            present(controller, animated: true, completion: nil)
        }else{
            let lightBox = arrData.filter({ (obj) -> Bool in
                obj.isVideo == false
            }).map {LightboxImage(image: UIImage(contentsOfFile: FilePaths.filePaths.path + $0.fileName)!)}
            let controller = LightboxController(images: lightBox)
            controller.dynamicBackground = true
            controller.goTo(index)
            controller.modalPresentationStyle = .fullScreen
            present(controller, animated: true, completion: nil)
        }
        
    }
    
    @objc func handleLongPress(gestureRecognizer : UILongPressGestureRecognizer){
        if (gestureRecognizer.state != .ended){
            return
        }
        
        let p = gestureRecognizer.location(in: self.collectionView)
        
        if let _ : IndexPath = self.collectionView.indexPathForItem(at: p) {
            self.selected()
        }
    }
    
    func selected() {
        self.viewModel.isMultiSelect = !self.viewModel.isMultiSelect
        if self.isShowViewAction {
            self.btSelect.setTitle("Select", for: .normal)
            self.buttonAdd.isHidden = false
        }else{
            self.btSelect.setTitle("Done", for: .normal)
            self.buttonAdd.isHidden = true
        }
        self.btShare.isHidden = self.isShowViewAction
        self.btDelete.isHidden = self.isShowViewAction
        self.collectionView.allowsMultipleSelection = !self.isShowViewAction
        self.buttonAdd.isHidden = !self.isShowViewAction
        self.isShowViewAction = !self.isShowViewAction
        self.collectionView.reloadData()
    }
    
}

extension LAGaleryViewController: GalleryControllerDelegate {
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        controller.dismiss(animated: true) {
            Image.resolve(images: images, completion: { (images) in
                for img in images {
                    if let imgs = img {
                        self.saveImageInDocsDir(self.idAlbum, imgs)
                    }
                }
                self.initData()
                self.gallery = nil
            })
        }
    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        controller.dismiss(animated: true) {
            self.gallery = nil
            self.editor.edit(video: video) { (editedVideo: Video?, tempPath: URL?) in
                DispatchQueue.main.async {
                    if let tempPath = tempPath {
                        tempPath.saveVideo(idAlbum: self.idAlbum, success: { (status, url) in
                            if status {
                                self.initData()
                            }
                            self.gallery = nil
                        })
                    }
                }
            }
        }
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        controller.dismiss(animated: true) {
        }
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        controller.dismiss(animated: true) {
            
        }
    }
}

extension LAGaleryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let videoUrl = info[.mediaURL] as! URL
        print(videoUrl)
        videoUrl.saveVideo(idAlbum: self.idAlbum, success: { (status, url) in
            if status {
                self.initData()
            }
        })
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension LAGaleryViewController: UIGestureRecognizerDelegate {
    
}

