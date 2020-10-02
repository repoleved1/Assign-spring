//
//  ImageVideoModelView.swift
//  CalculaterPrivate
//
//  Created by Anh Dũng on 11/4/18.
//  Copyright © 2018 Anh Dũng. All rights reserved.
//

import UIKit

class ImageVideoModelView: NSObject {
    var arrData: [GalleryObj]
    var handleSelectRow: ((Int) -> Void)?
    var handleDeSelectRow: ((Int) -> Void)?
    
    var handleMultilSelectRow: ((Int) -> Void)?
    var handleMultilDeSelectRow: ((Int) -> Void)?
    
    var isNote = false
    var isVideo: Bool = false
    var isPreview: Bool = false
    var isMultiSelect = false
    
    override init() {
        arrData = []
    }
    
    init(_ arrData : [GalleryObj]) {
        self.arrData = arrData
    }
    
    
}

extension ImageVideoModelView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if isPreview {
            return CGSize(width: collectionView.frame.width,height: collectionView.frame.height)
        }else if isNote {
            return CGSize(width: collectionView.frame.height,height: collectionView.frame.height)
        }else{
            return CGSize(width: collectionView.frame.width/4 - 2 ,height: collectionView.frame.width/4 - 2)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrData.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as GalleryCollectionViewCell
        cell.config(arrData[indexPath.item], isMultiSelect: isMultiSelect)
        cell.isVideo = isVideo
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isMultiSelect {
            let cell = collectionView.cellForItem(at: indexPath) as? GalleryCollectionViewCell
            cell?.imageSelect.image = UIImage(named: "ic_selected")
            handleMultilSelectRow?(indexPath.row)
        }else{
            handleSelectRow?(indexPath.row)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if isMultiSelect {
            let cell = collectionView.cellForItem(at: indexPath) as? GalleryCollectionViewCell
            cell?.imageSelect.image = UIImage(named: "ic_select")
            handleMultilDeSelectRow?(indexPath.row)
        }else{
            handleDeSelectRow?(indexPath.row)
        }
    }
}
