//
//  GalleryManager.swift
//  PCM
//
//  Created by Anh Dũng on 11/13/19.
//  Copyright © 2019 Anh Dũng. All rights reserved.
//


import Foundation
import UIKit
import CoreData
import UserNotifications

class GalleryManager {
    static let sharedInstance = GalleryManager()
    var arrSearch: [GalleryObj] = []
    
    init() {
    }
    
    func getAllGallery() -> [GalleryObj] {
        var fetchedResults: Array<Gallery> = Array<Gallery>()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Gallery")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format:"%K == false", "isNotes")
        
        do {
            fetchedResults = try  mainContextInstance.fetch(fetchRequest) as! [Gallery]
        } catch let fetchError as NSError {
            print("retrieveById error: \(fetchError.localizedDescription)")
            fetchedResults = Array<Gallery>()
        }
        var result: [GalleryObj] = []
        for fetch in fetchedResults {
            let obj: GalleryObj = GalleryObj(fetch)
            result.append(obj)
        }
        return result.sorted(by: { (obj1, obj2) -> Bool in
            obj1.fileName.localizedCaseInsensitiveCompare(obj2.fileName) == .orderedAscending
        })
    }
    
    func getAllGalleryByIdAlbum(_ id: String) -> [GalleryObj] {
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Gallery")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format:"%K == %@", "idAlbum", id as CVarArg)
        
        var fetchedResults: Array<Gallery> = Array<Gallery>()
        
        do {
            fetchedResults = try  mainContextInstance.fetch(fetchRequest) as! [Gallery]
        } catch let fetchError as NSError {
            print("retrieveById error: \(fetchError.localizedDescription)")
            fetchedResults = Array<Gallery>()
        }
        
        var result: [GalleryObj] = []
        for fetch in fetchedResults {
            let obj: GalleryObj = GalleryObj(fetch)
            result.append(obj)
        }
        return result.sorted(by: { (obj1, obj2) -> Bool in
            obj1.fileName.localizedCaseInsensitiveCompare(obj2.fileName) == .orderedAscending
        })
    }
    
    func getOneItemByIdAlbum(_ id: String, success: @escaping (GalleryObj, Int) -> Void) {
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Gallery")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format:"%K == %@", "idAlbum", id as CVarArg)
        var fetchedResults: Array<Gallery> = Array<Gallery>()
        
        do {
            fetchedResults = try  mainContextInstance.fetch(fetchRequest) as! [Gallery]
        } catch let fetchError as NSError {
            print("retrieveById error: \(fetchError.localizedDescription)")
            fetchedResults = Array<Gallery>()
        }
        var result: [GalleryObj] = []
        for fetch in fetchedResults {
            let obj: GalleryObj = GalleryObj(fetch)
            result.append(obj)
        }
        success(result.count > 0 ? result[result.count - 1] : GalleryObj(), result.count)
    }
    
    func getOneItemByAllAlbum(_ id: String, success: @escaping (GalleryObj, Int) -> Void) {
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Gallery")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format:"%K == false", "isNotes")
        var fetchedResults: Array<Gallery> = Array<Gallery>()
        
        do {
            fetchedResults = try  mainContextInstance.fetch(fetchRequest) as! [Gallery]
        } catch let fetchError as NSError {
            print("retrieveById error: \(fetchError.localizedDescription)")
            fetchedResults = Array<Gallery>()
        }
        var result: [GalleryObj] = []
        for fetch in fetchedResults {
            let obj: GalleryObj = GalleryObj(fetch)
            result.append(obj)
        }
        success(result.count > 0 ? result[result.count - 1] : GalleryObj(), result.count)
    }
    
    func loadLocalData() {
        arrSearch = self.getAllGallery()
    }
}

let galleryManager = GalleryManager.sharedInstance

