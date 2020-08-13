//
//  BackupSave.swift
//  MCBackup
//
//  Created by Apple on 3/23/18.
//  Copyright © 2018 Tien. All rights reserved.
//

import RealmSwift

class BackupDatabase: Object {

    @objc dynamic var giveName1 = ""
    @objc dynamic var familyName1 = ""
    @objc dynamic var phone1: String!
}
