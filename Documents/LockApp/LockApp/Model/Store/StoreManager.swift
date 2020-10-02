//
//  StoreManager.swift
//  LockApp
//
//  Created by Anh Dũng on 11/29/19.
//  Copyright © 2019 Anh Dũng. All rights reserved.
//

import UIKit
import CoreData

class StoreManager {
    static let shared = StoreManager()
    var arrSearch: [StoreObj] = []
    
    init() {
    }
    
    func getAllStores() -> [StoreObj] {
        var fetchedResults: Array<Store> = Array<Store>()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Store")
        do {
            fetchedResults = try  mainContextInstance.fetch(fetchRequest) as! [Store]
        } catch let fetchError as NSError {
            print("retrieveById error: \(fetchError.localizedDescription)")
            fetchedResults = Array<Store>()
        }
        var result: [StoreObj] = []
        for fetch in fetchedResults {
            let obj: StoreObj = StoreObj(fetch)
            result.append(obj)
        }
        return result.sorted(by: { (obj1, obj2) -> Bool in
            obj1.appID > obj2.appID
        })
    }
    
    func loadLocalData() {
        arrSearch.removeAll()
        arrSearch = self.getAllStores()
    }
}
