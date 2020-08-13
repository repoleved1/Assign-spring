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
    @IBOutlet weak var navi: NavigationView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var buttonAdd: UIButton!
    
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

    @IBAction func addMedia(_ sender: Any) {
        self.gallery = GalleryController()
        Config.Camera.recordLocation = true
        self.gallery.delegate = self
            
        let alert = UIAlertController(title: "Select Media", message: "Please Select an Option", preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Select Video in Library", style: .default , handler:{ (UIAlertAction)in
            print("User click Edit button")
            Config.tabsToShow = [.imageTab,  .cameraTab, .videoTab]
            self.present(self.gallery, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))

        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    func initData() {
        self.arrData.removeAll()
        self.arrData = idAlbum == "-1" ? galleryManager.getAllGallery() : galleryManager.getAllGalleryByIdAlbum(idAlbum)
        viewModel.isVideo = isVideos
        viewModel.arrData = self.arrData
        collectionView.reloadData()
    }
    
    func setupUI() {
        navi.title = ""
        navi.handleBack = {
            self.navigationController?.popViewController(animated: true)
        }
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
        self.navi.hasLeft = self.isShowViewAction
        if self.isShowViewAction {
            self.navi.imgActionRight3.isHidden = false
            self.navi.btRight3.setTitle("", for: .normal)
            self.navi.title = objGallery.name.count == 0 ? "No title" : objGallery.name
            self.buttonAdd.isHidden = false
        }else{
            self.navi.imgActionRight3.isHidden = true
            self.navi.btRight3.setTitle("Done", for: .normal)
            self.navi.title = "Select Gallery"
            self.buttonAdd.isHidden = true
        }
        
        self.collectionView.allowsMultipleSelection = !self.isShowViewAction
        self.isShowViewAction = !self.isShowViewAction
        self.collectionView.reloadData()
    }

}

extension LAGaleryViewController: GalleryControllerDelegate {
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        controller.dismiss(animated: true) {
//            if images.count > 0 {
//                for img in images {
//                    self.saveImageInDocsDir(self.idAlbum, img.asset)
//                }
//                self.initData()
//            }
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
