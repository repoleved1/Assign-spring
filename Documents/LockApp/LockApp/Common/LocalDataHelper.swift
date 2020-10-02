//
//  LocalDataHelper.swift
//  ComicsSynthesis
//
//  Created by Anh Dũng on 11/24/19.
//  Copyright © 2019 Anh Dũng. All rights reserved.
//

import UIKit
import CoreLocation
import Contacts
import RealmSwift

class LocalDataHelper: NSObject {
    static let shared = LocalDataHelper()
    var viewController = [UIViewController]()
    
    override init() {
        super.init()
        let a = LAContactViewController.init(nibName: "LAContactViewController", bundle: nil)
        let b = LAGroupsViewController.init(nibName: "LAGroupsViewController", bundle: nil)
//        let c = FavoritesViewController.init(nibName: "FavoritesViewController", bundle: nil)
//        viewController = [a, b, c]
        viewController = [a, b]

    }
}

let localDataShared = LocalDataHelper.shared

class ShareData:NSObject {
    static let sharedInstance = ShareData()
    
    var arrContact = [ItemFavorites]()
    var saveFavorite = [ItemFavorites]()
    var arrShowStared = [ArrayFavorite]()
    var detailContact = [CNContact]()
    var nameImageTick = "ic_select"
    var contentFileUpload = ""
    var indexTable = 0
    var duplicateContact = [String: [CNContact]]()
    var duplicateMail = [String: [CNContact]]()
    var duplicatePhone = [String: [CNContact]]()
    var checkViewDuplicate = 0
}

class GetContact {
    
    func showContact(success:@escaping () -> Void) {
        let contactStore = CNContactStore()
        if CNContactStore.authorizationStatus(for: .contacts) == .notDetermined {
            
            contactStore.requestAccess(for: .contacts){succeeded, err in
                guard err == nil && succeeded else{
                    return
                }
                self.contactList(contactStore: contactStore, success: {
                    success()
                })
            }
        } else if CNContactStore.authorizationStatus(for: .contacts) == .authorized {
            self.contactList(contactStore: contactStore, success: {
                success()
            })
            NSLog(" move to contact list ")
            
        }
        
    }
    
    func contactList(contactStore:CNContactStore,success:@escaping () -> Void) -> Void {
        var contacts = [ItemFavorites]()
        var detailContacts = [CNContact]()
        let keys = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactPhoneNumbersKey,
            CNContactEmailAddressesKey,
            CNContactBirthdayKey,
            CNContactJobTitleKey,
            CNContactDepartmentNameKey
            ] as [Any]
        let request = CNContactFetchRequest(keysToFetch: keys as! [CNKeyDescriptor])
        do {
            try contactStore.enumerateContacts(with: request){
                (contact, stop) in
                
                //
                detailContacts.append(contact)
                detailContacts.sort(by: { (a, b) -> Bool in
                    return a.givenName.lowercased() < b.givenName.lowercased()
                })
                ShareData.sharedInstance.detailContact = detailContacts
                
                ///
                let contactCustomize = ItemFavorites()
                contactCustomize.giveName = contact.givenName
                contactCustomize.familyName = contact.familyName
                if let phone = contact.phoneNumbers.first?.value.stringValue {
                    contactCustomize.phone =  phone
                    
                } else {
                    contactCustomize.phone = " "
                }
                print(contactCustomize.phone)
                contacts.append(contactCustomize)
                contacts.sort(by: { (a, b) -> Bool in
                    return a.giveName.lowercased() < b.giveName.lowercased()
                })
            }
            ShareData.sharedInstance.arrContact = contacts
            success()
        } catch {
            print("unable to fetch contacts")
        }
    }
    
    func deleteContact(_ contactIphone: ItemFavorites) {
        let store = CNContactStore()
        let predicate = CNContact.predicateForContacts(matchingName: contactIphone.familyName)
        let toFetch = [CNKeyDescriptor]()
        do{
            let contacts = try store.unifiedContacts(matching: predicate, keysToFetch: toFetch)
            guard contacts.count > 0 else{
                print("No contacts found")
                return
            }
            
            guard let contact = contacts.first else{
                return
            }
            
            let req = CNSaveRequest()
            let mutableContact = contact.mutableCopy() as! CNMutableContact
            req.delete(mutableContact)
            do{
                try store.execute(req)
                print("Success, You deleted the user")
            } catch let e{
                print("Error = \(e)")
            }
        } catch let err{
            print(err)
        }
    }
    
    func deleteAllContact() {
        let contactStore = CNContactStore()
        let keys = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactPhoneNumbersKey,
            CNContactEmailAddressesKey
            ] as [Any]
        let request = CNContactFetchRequest(keysToFetch: keys as! [CNKeyDescriptor])
        do {
            try contactStore.enumerateContacts(with: request){
                (contact, stop) in
                // Array containing all unified contacts from everywhere
                let req = CNSaveRequest()
                
                let mutableContact = contact.mutableCopy() as! CNMutableContact
                print(mutableContact)
                req.delete(mutableContact)
                
                do{
                    try contactStore.execute(req)
                    print("Success, You deleted all the user")
                } catch let e{
                    print("Error = \(e)")
                }
            }
            
        } catch let err{
            print(err)
        }
        

    }
}

class DatabaseService {
    
    static let sharedInstance = DatabaseService()
    fileprivate let realm = try! Realm()
    
    func getAll() -> Results<ItemFavorites> {
        return realm.objects(ItemFavorites.self)
    }
    
    func getGroup() -> Results<Group> {
        return realm.objects(Group.self)
    }
    
    func getAllArrFavorites() -> Results<ArrayFavorite> {
        return realm.objects(ArrayFavorite.self)
    }
    
    func getAllBackup() -> Results<BackupItem> {
        return realm.objects(BackupItem.self)
    }
    
    func add(_ obj: Object ) {
        write {
            self.realm.add(obj)
        }
    }
    
    func delete(_ obj: Object) {
        if obj.isInvalidated {
            return
        }
        write {
            self.realm.delete(obj)
        }
    }
    
    func deleteAll() {
        write {
            self.realm.deleteAll()
        }
    }
    
    func write(_ closure: @escaping ()->()) {
        do {
            try realm.write { closure() }
        } catch {
            print(error)
        }
    }
    
    //        func subscribeNotification(_ block: @escaping ()->()) -> NotificationToken {
    //            return realm.addNotificationBlock { (notification, realm) in
    //                block()
    //            }
    //        }
    
}

class Storage {
    static func getFreeSpace() -> Int64 {
        do {
            let attributes = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory() as String)
            
            return ((attributes[FileAttributeKey.systemFreeSize] as? NSNumber)?.int64Value)!
        } catch {
            return 0
        }
    }
    
    static func getTotalSpace() -> Int64 {
        do {
            let attributes = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory() as String)
            return ((attributes[FileAttributeKey.systemSize] as? NSNumber)?.int64Value)!
        } catch {
            return 0
        }
    }
    
    static func getUsedSpace() -> Int64 {
        return getTotalSpace() - getFreeSpace()
    }
}

