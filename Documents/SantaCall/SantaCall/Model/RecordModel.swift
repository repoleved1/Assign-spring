//
//  RecordModel.swift
//  SantaCall
//
//  Created by Feitan on 11/3/20.
//

import Foundation
import RealmSwift

class RecordPhone: Object {
    @objc dynamic var id: String?
    @objc dynamic var name: String?
    @objc dynamic var santaName: String?
    @objc dynamic var santaAvatar: String?
    @objc dynamic var date: Date?
    @objc dynamic var timeCount: String?
    @objc dynamic var titleName: String?

    override class func primaryKey() -> String? {
        return "id"
    }
}

class RecordVideo: Object {
    @objc dynamic var id: String?
    @objc dynamic var name: String?
    @objc dynamic var santaName: String?
    @objc dynamic var santaAvatar: String?
    @objc dynamic var date: Date?
    @objc dynamic var timeCount: String?
    @objc dynamic var titleName: String?
    @objc dynamic var videoName: String?

    override class func primaryKey() -> String? {
        return "id"
    }
}
