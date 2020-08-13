//
//  BackupItem.swift
//  MCBackup
//
//  Created by Apple on 3/23/18.
//  Copyright © 2018 Tien. All rights reserved.
//

import RealmSwift
import Contacts

class BackupItem: Object {
    var contactBackup: List<BackupDatabase> = List()
    @objc dynamic var dateSave = Date()
}


