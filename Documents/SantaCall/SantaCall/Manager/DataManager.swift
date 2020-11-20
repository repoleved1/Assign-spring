//
//  DataManager.swift
//  SantaCall
//
//  Created by Feitan on 11/03/2020.
//

import Foundation
import RealmSwift

enum EditTypeSanta: Int {
    case background = 0
}

class DataManager: NSObject {
    
    static let shared = DataManager()
    let realm: Realm!
    
     //MARK: -- realm
    override init() {
        var config = Realm.Configuration.defaultConfiguration
        config.schemaVersion = 10
        config.migrationBlock = { migration, oldSchemaVersion in }
        realm = try! Realm(configuration: config)
        
         print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
    
    @discardableResult
    func addObject(object: Object) -> Object{
        try! realm.write {
            realm.add(object, update: .all)
        }
        return object
    }
    
    func changeNameRecord(record: RecordPhone, name: String) {
        try! realm.write {
            record.name = name + ".mp4"
            record.titleName = name
//            realm.add(record, update: .all)
        }
    }
    
    func changeNameVideoRecord(record: RecordVideo, name: String) {
        try! realm.write {
            record.name = name + ".mp4"
            record.titleName = name
        }
    }
    
    func deleteObject(object: Object) {
        try! realm.write {
            realm.delete(object)
        }
    }
    
    func checkNameExist(name: String) -> Bool {
        let records = getAllRecord()
        
        for record in records {
            if record.name == name + ".mp4" {
                return true
            }
        }
        return false
    }
    
    func checkNameExistVideo(name: String) -> Bool {
        let records = getAllRecordVideo()
        
        for record in records {
            if record.name == name + ".mp4" {
                return true
            }
        }
        return false
    }
    
    func getAllRecord() -> [RecordPhone] {
        let records =  Array(realm.objects(RecordPhone.self))
        return records
    }
    
    func getAllRecordVideo() -> [RecordVideo] {
        let records =  Array(realm.objects(RecordVideo.self))
        return records
    }
    
    //MARK: -- document
    
    func createNewDirectory(name: String) {
        let pathLib = (NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(name)
        if !FileManager.default.fileExists(atPath: pathLib) {
            do {
                try FileManager.default.createDirectory(atPath: pathLib, withIntermediateDirectories: true, attributes: nil)
            } catch {
            }
        }
    }
    
    func getDocumentPath() -> String {
        let pathLib = (NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(PHONE_RECORD)
        if !FileManager.default.fileExists(atPath: pathLib) {
            do {
                try FileManager.default.createDirectory(atPath: pathLib, withIntermediateDirectories: true, attributes: nil)
                
            } catch {
                
            }
        }
        
        return pathLib
    }
    
    func getDocumentVideoPath() -> String {
        let pathLib = (NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(VIDEO_RECORD)
        if !FileManager.default.fileExists(atPath: pathLib) {
            do {
                try FileManager.default.createDirectory(atPath: pathLib, withIntermediateDirectories: true, attributes: nil)
                
            } catch {
                
            }
        }
        
        return pathLib
    }
    
    func getAllRecordFromDirectory() -> [String] {
        var result = [String]()
        let fileManager = FileManager.default
        let path = (NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(PHONE_RECORD)
        
        if fileManager.fileExists(atPath: path) {
            let fileContents = try? fileManager.contentsOfDirectory(atPath: path)
            
            if let listPath = fileContents {
                result = listPath
            }
        }
        return result
    }
    
    func changeNameRecordFromDocument(record: RecordPhone, name: String) {
        let path =  getDocumentPath()
        let oldPath = path + "/" + (record.name!)
        
        if FileManager.default.fileExists(atPath: oldPath) {
            print("path; \(path)")
            let url = URL(fileURLWithPath: oldPath)
            let newPath = oldPath.replacingOccurrences(of: url.lastPathComponent, with: "\(name).mp4")
            
            print("renamefile: \(url.lastPathComponent)")
            do {
                try FileManager.default.moveItem(at: url, to: URL(fileURLWithPath: newPath))
                print("======rename success=======")
            } catch {
                print("======rename fail=======")
            }
            
        } else {
            print("old path not exist")
        }
    }
    
    func changeNameVideoRecordFromDocument(record: RecordVideo, name: String) {
        let path =  getDocumentPath()
        let oldPath = path + "/" + (record.name!)
        
        if FileManager.default.fileExists(atPath: oldPath) {
            print("path; \(path)")
            let url = URL(fileURLWithPath: oldPath)
            let newPath = oldPath.replacingOccurrences(of: url.lastPathComponent, with: "\(name).mp4")
            
            print("renamefile: \(url.lastPathComponent)")
            do {
                try FileManager.default.moveItem(at: url, to: URL(fileURLWithPath: newPath))
                print("======rename success=======")
            } catch {
                print("======rename fail=======")
            }
            
        } else {
            print("old path not exist")
        }
    }
    
    func deleteRecordFromDocument(name: String) {
        let fileManager = FileManager.default
        let path = (NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(PHONE_RECORD)
        var pathFile = path + "/" + name
        if path == nil {
            pathFile = ""
        }
        print("----path delete: \(pathFile)")
        if fileManager.fileExists(atPath: pathFile) {
            try! fileManager.removeItem(atPath: pathFile)
        }
    }
}
