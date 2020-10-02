//
//  StoreObj.swift
//  LockApp
//
//  Created by Anh Dũng on 11/27/19.
//  Copyright © 2019 Anh Dũng. All rights reserved.
//

import UIKit
import CoreData

class StoreObj: NSObject {
    var aID: Int32 = 0
    var developer = ""
    var name = ""
    var username = ""
    var password = ""
    var buildID = ""
    var appID: Int32 = 0
    var imageUrl = ""
    var note = ""
    var website = ""
    var trackViewUrl = ""
    var touchID = ""
    
    override init() {
        super.init()
    }
    
    init(_ obj : Store) {
        self.aID = obj.aID
        self.name = obj.name ?? ""
        self.developer = obj.developer ?? ""
        self.username = obj.username ?? ""
        self.password = obj.password ?? ""
        self.buildID = obj.buildID ?? ""
        self.appID = obj.appID
        self.imageUrl = obj.imageUrl ?? ""
        self.note = obj.note ?? ""
        self.website = obj.website ?? ""
        self.trackViewUrl = obj.trackViewUrl ?? ""
        self.touchID = obj.touchID ?? "F"
    }
    
}

extension StoreObj {
    func saveStoreList(_ isMerge: Bool = false) {
        print("save Store list, \(self.appID), \(isMerge)")
        
        let minionManagedObjectContextWorker: NSManagedObjectContext =
            NSManagedObjectContext.init(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
        minionManagedObjectContextWorker.parent = mainContextInstance
        
        let store = NSEntityDescription.insertNewObject(forEntityName: "Store",
                                                       into: minionManagedObjectContextWorker) as! Store
        store.aID = self.aID
        store.name = self.name
        store.developer = self.developer
        store.username = self.username
        store.password = self.password
        store.appID = self.appID
        store.buildID = self.buildID
        store.imageUrl = self.imageUrl
        store.note = self.note
        store.website = self.website
        store.trackViewUrl = self.trackViewUrl
        store.touchID = self.touchID
        
        persistenceManager.saveWorkerContext(minionManagedObjectContextWorker)
        if isMerge {
            persistenceManager.mergeWithMainContext()
        }
    }
    
    func updateStore(_ isMerge: Bool = false) {
        if let store = findStore() {
            store.aID = self.aID
            store.appID = self.appID
            store.name = self.name
            store.developer = self.developer
            store.username = self.username
            store.password = self.password
            store.buildID = self.buildID
            store.imageUrl = self.imageUrl
            store.note = self.note
            store.website = self.website
            store.trackViewUrl = self.trackViewUrl
            store.touchID = self.touchID
            
            persistenceManager.mergeWithMainContext()
            print("Update")
        }else{
            print("Don't find item")
            saveStoreList(isMerge)
        }
    }
    
    func deleteStore() {
        if let store = findStore() {
            mainContextInstance.delete(store)
            persistenceManager.mergeWithMainContext()
        }else{
            print("Don't find item")
        }
    }
    
    func findStore() -> Store? {
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Store")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format:"%K == %i", "appID", self.appID)
        
        var fetchedResults: Array<Store> = Array<Store>()
        
        do {
            fetchedResults = try  mainContextInstance.fetch(fetchRequest) as! [Store]
        } catch let fetchError as NSError {
            print("retrieveById error: \(fetchError.localizedDescription)")
            fetchedResults = Array<Store>()
        }
        if fetchedResults.count == 1 {
            return fetchedResults[0]
        }
        return nil
    }
}

