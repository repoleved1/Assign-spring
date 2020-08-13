//
//  GalleryCollectionViewCell.swift
//  LockApp
//
//  Created by Feitan on 8/13/20.
//  Copyright © 2020 SingleViewApp. All rights reserved.
//

import UIKit
import SDWebImage
import AVKit

class GalleryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var imageSelect: UIImageView!
    @IBOutlet weak var viewIsVideo: UIView!
    
    var isVideo = false
    var isPreview = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override var isSelected: Bool{
            didSet{
                if !isPreview && self.isSelected {
                    if imageSelect.isHidden {
                        self.layer.borderColor = UIColor.white.cgColor
                        self.layer.borderWidth = 1
                    }else{
                        self.layer.borderColor = UIColor("076AFF", alpha: 1.0).cgColor
                        self.layer.borderWidth = 1
                    }
                }else{
                    self.layer.borderColor = UIColor.clear.cgColor
                    self.layer.borderWidth = 0
                }
            }
        }

        func config(_ obj: GalleryObj, isMultiSelect: Bool) {
            imageSelect.isHidden = !isMultiSelect
            viewIsVideo.isHidden = !obj.isVideo
            if obj.isVideo {
                let urlVideo = URL(fileURLWithPath: FilePaths.filePaths.path+obj.fileName)
                self.image.image = getThumbnailFrom(path: urlVideo)
            }else{
                let urlImage = URL(fileURLWithPath: FilePaths.filePaths.path+obj.fileName)
                self.image.sd_setImage(with: urlImage)
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

