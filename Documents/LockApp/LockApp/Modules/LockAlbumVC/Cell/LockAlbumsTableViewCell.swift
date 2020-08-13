//
//  LockAlbumsTableViewCell.swift
//  LockApp
//
//  Created by Feitan on 8/10/20.
//  Copyright © 2020 SingleViewApp. All rights reserved.
//

import UIKit
import Photos
import SDWebImage

class LockAlbumsTableViewCell: UITableViewCell {

    @IBOutlet weak var viewLayout: UIView!
    @IBOutlet weak var images: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        viewLayout.clipsToBounds = true
        viewLayout.layer.cornerRadius = 20
        viewLayout.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
    }
    
    func config(_ obj: AlbumObj) {
        labelName.text = obj.name.count == 0 ? "No title" : obj.name
        if labelName.text == "All" {
            galleryManager.getOneItemByAllAlbum(obj.id) { (gallery, count) in
                self.labelCount.text = "\(count)"
                if gallery.isVideo {
                    let urlVideo = URL(fileURLWithPath: FilePaths.filePaths.path+gallery.fileName)
                    self.images.image = self.getThumbnailFrom(path: urlVideo)
                }else{
                    let urlImage = URL(fileURLWithPath: FilePaths.filePaths.path+gallery.fileName)
                    self.images.sd_setImage(with: urlImage)
                }
            }
        }else{
            galleryManager.getOneItemByIdAlbum(obj.id) { (gallery, count) in
                self.labelCount.text = "\(count)"
                if gallery.isVideo {
                    if gallery.fileName == "" {
                        self.images.image = UIImage.init(named: "ic_bg_album")
                    }else{
                        let urlVideo = URL(fileURLWithPath: FilePaths.filePaths.path+gallery.fileName)
                        self.images.image = self.getThumbnailFrom(path: urlVideo)
                    }
                }else{
                    if gallery.fileName == "" {
                        self.images.image = UIImage.init(named: "ic_bg_album")
                    }else{
                        let urlImage = URL(fileURLWithPath: FilePaths.filePaths.path+gallery.fileName)
                        self.images.sd_setImage(with: urlImage)
                    }
                }
            }
        }
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
}
