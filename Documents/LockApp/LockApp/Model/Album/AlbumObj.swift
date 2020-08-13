//
//  AlbumObj.swift
//  PCM
//
//  Created by Anh Dũng on 11/15/19.
//  Copyright © 2019 Anh Dũng. All rights reserved.
//

import UIKit
import CoreData

class AlbumObj: NSObject {
    var id: String = ""
    var name: String = ""
    
    override init() {
        super.init()
        id = UUID().uuidString
    }
    
    init(_ name: String = "") {
        self.name = name
    }
    
    init(_ obj: Album) {
        self.id = obj.id ?? ""
        self.name = obj.name ?? ""
    }
}

extension AlbumObj {
    func saveAlbumList(_ isMerge: Bool = false) {
        print("save Album list, \(self.name), \(isMerge)")
        
        let minionManagedObjectContextWorker: NSManagedObjectContext =
            NSManagedObjectContext.init(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
        minionManagedObjectContextWorker.parent = mainContextInstance
        
        let album = NSEntityDescription.insertNewObject(forEntityName: "Album",
                                                          into: minionManagedObjectContextWorker) as! Album
        album.id = self.id
        album.name = self.name
        
        persistenceManager.saveWorkerContext(minionManagedObjectContextWorker)
        if isMerge {
            persistenceManager.mergeWithMainContext()
        }
    }
    
    func updateAlbum() {
        if let album = findAlbum() {
            album.name = self.name
            persistenceManager.mergeWithMainContext()
        }else{
            print("Don't find item")
        }
    }
    
    func deleteAlbum() {
        if let album = findAlbum() {
            mainContextInstance.delete(album)
            persistenceManager.mergeWithMainContext()
        }else{
            print("Don't find item")
        }
    }
    
    func findAlbum() -> Album? {
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Album")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format:"%K == %@", "id", self.id as CVarArg)
        
        var fetchedResults: Array<Album> = Array<Album>()
        
        do {
            fetchedResults = try  mainContextInstance.fetch(fetchRequest) as! [Album]
        } catch let fetchError as NSError {
            print("retrieveById error: \(fetchError.localizedDescription)")
            fetchedResults = Array<Album>()
        }
        if fetchedResults.count == 1 {
            return fetchedResults[0]
        }
        return nil
    }
}

