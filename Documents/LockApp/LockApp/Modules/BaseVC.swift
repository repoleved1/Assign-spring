//
//  BaseVC.swift
//  LockApp
//
//  Created by Anh Dũng on 11/18/19.
//  Copyright © 2019 Anh Dũng. All rights reserved.
//

import UIKit
import Photos

class BaseVC: UIViewController {
    var addButton = VCFloatingActionButton()
    var handleFloatAciton: ((String) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        TAppDelegate.menuContainerViewController?.panMode = MFSideMenuPanModeNone
        TAppDelegate.menuContainerViewController?.setMenuState(MFSideMenuStateClosed, completion: nil)
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
    }

    func menuContainerViewController() -> MFSideMenuContainerViewController {
        return self.navigationController?.parent as! MFSideMenuContainerViewController
    }

    func clickMenu() {
        TAppDelegate.menuContainerViewController?.toggleLeftSideMenuCompletion(nil)
    }

    func clickBack() {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }

    func saveImageInDocsDir(_ idAlbum: String,_ asset: PHAsset, _ isNotes: Bool = false) {
        let image: UIImage? = getUIImage(asset: asset)//Here set your image
        if !(image == nil) {
            let dataPath = FilePaths.filePaths.path
            if !FileManager.default.fileExists(atPath: dataPath) {
                try? FileManager.default.createDirectory(atPath: dataPath, withIntermediateDirectories: true, attributes: nil) //Create folder if not
            }
            let uuid = UUID().uuidString
            let fileName = uuid+".jpg"
            let fileURL = URL(fileURLWithPath:dataPath).appendingPathComponent(fileName)//Your image name
            print(fileURL)
            // get your UIImage jpeg data representation
            let data = image?.jpegData(compressionQuality: 1)//Set image quality here
            do {
                // writes the image data to disk
                try data?.write(to: fileURL, options: .atomic)
                let obj = GalleryObj()
                obj.id = uuid
                obj.fileName = fileName
                obj.idAlbum = idAlbum
                obj.isNotes = isNotes
                obj.saveGalleryList(true)
            } catch {
                print("error:", error)
            }
        }
    }

    func saveImageInDocsDir(_ idAlbum: String,_ image: UIImage?, _ isNotes: Bool = false) {
//        let image: UIImage? = getUIImage(asset: asset)//Here set your image
        if !(image == nil) {
            let dataPath = FilePaths.filePaths.path
            if !FileManager.default.fileExists(atPath: dataPath) {
                try? FileManager.default.createDirectory(atPath: dataPath, withIntermediateDirectories: true, attributes: nil) //Create folder if not
            }
            let uuid = UUID().uuidString
            let fileName = uuid+".jpg"
            let fileURL = URL(fileURLWithPath:dataPath).appendingPathComponent(fileName)//Your image name
            print(fileURL)
            // get your UIImage jpeg data representation
            let data = image?.jpegData(compressionQuality: 1)//Set image quality here
            do {
                // writes the image data to disk
                try data?.write(to: fileURL, options: .atomic)
                let obj = GalleryObj()
                obj.id = uuid
                obj.fileName = fileName
                obj.idAlbum = idAlbum
                obj.isNotes = isNotes
                obj.saveGalleryList(true)
            } catch {
                print("error:", error)
            }
        }
    }

    func getUIImage(asset: PHAsset) -> UIImage? {
        var img: UIImage?
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.version = .original
        options.isSynchronous = true
        manager.requestImageData(for: asset, options: options) { data, _, _, _ in

            if let data = data {
                img = UIImage(data: data)
            }
        }
        return img
    }

    func getThumbnailFrom(path: URL) -> UIImage? {
        do {
            let asset = AVURLAsset(url: path , options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            return thumbnail
        } catch let error {
            print("*** Error generating thumbnail: \(error.localizedDescription)")
            return nil
        }
    }

    func deleteFile(url: URL) {
        let fileManager = FileManager.default
        do {
            try fileManager.removeItem(at: url)
            print("Delete")
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
        }
    }
}

extension BaseVC {
    func initFloatingActionMenu(_ arrimg: [String] = ["actionmenu_more","actionmenu_more"], _ arrTitle: [String] = ["Add","Create Group"]) {
        let floatFrame = CGRect(x: UIScreen.main.bounds.size.width - (ScreenSize.SCREEN_HEIGHT*0.111), y: UIScreen.main.bounds.size.height - 100 - (isIPad ? 80*1.2 : 80*heightRatio), width: ScreenSize.SCREEN_HEIGHT*0.111, height: ScreenSize.SCREEN_HEIGHT*0.111)

        addButton = VCFloatingActionButton(frame: floatFrame, normalImage: UIImage(named: "add_plust"), andPressedImage: UIImage(named: "add_plust_2"), withScrollview: nil)

        addButton.imageArray = arrimg
        addButton.labelArray = arrTitle

        addButton.hideWhileScrolling = true
        addButton.delegate = self
        addButton.layer.shadowColor = UIColor.black.cgColor
        addButton.layer.shadowOffset = CGSize.zero
        addButton.layer.shadowOpacity = 0.3
        addButton.layer.shadowRadius = 4.0
        addButton.layer.masksToBounds = false
        view.addSubview(addButton)
    }
}

extension BaseVC: floatMenuDelegate {
    func didSelectMenuOption(at row: Int) {
        let str = addButton.labelArray[row] as? String ?? ""
        handleFloatAciton?(str)
    }
}
