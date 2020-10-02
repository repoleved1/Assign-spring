
//
//  Group.swift
//  MCBackup
//
//  Created by Feitan on 9/18/20.
//  Copyright © 2018 Tien. All rights reserved.
//

import UIKit
import RealmSwift
import Contacts
class Group: Object {
    var listContact:List<GroupItem> = List()
    @objc dynamic var groupname = ""

}
