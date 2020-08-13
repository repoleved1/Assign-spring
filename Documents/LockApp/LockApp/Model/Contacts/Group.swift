
//
//  Group.swift
//  MCBackup
//
//  Created by DAO VAN UOC on 6/18/18.
//  Copyright © 2018 Tien. All rights reserved.
//

import UIKit
import RealmSwift
import Contacts
class Group: Object {
    var listContact:List<GroupItem> = List()
    @objc dynamic var groupname = ""

}
