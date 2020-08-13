//
//  AlbumManager.swift
//  PCM
//
//  Created by Anh Dũng on 11/15/19.
//  Copyright © 2019 Anh Dũng. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import UserNotifications

class AlbumManager {
    static let sharedInstance = AlbumManager()
    var arrSearch: [AlbumObj] = []
    
    init() {
    }
    
    func getAllAlbum() -> [AlbumObj] {
        var fetchedResults: Array<Album> = Array<Album>()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Album")
        do {
            fetchedResults = try  mainContextInstance.fetch(fetchRequest) as! [Album]
        } catch let fetchError as NSError {
            print("retrieveById error: \(fetchError.localizedDescription)")
            fetchedResults = Array<Album>()
        }
        var result: [AlbumObj] = []
        for fetch in fetchedResults {
            let obj: AlbumObj = AlbumObj(fetch)
            result.append(obj)
        }
        return result
//        return result.sorted(by: { (obj1, obj2) -> Bool in
//            obj1.name.localizedCaseInsensitiveCompare(obj2.name) == .orderedAscending
//        })
    }
    
    func loadLocalData() {
        arrSearch = self.getAllAlbum()
    }
}

let albumManager = AlbumManager.sharedInstance
