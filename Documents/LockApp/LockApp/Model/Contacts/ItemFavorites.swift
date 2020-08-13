//
//  ItemFavorites.swift
//  MCBackup
//
//  Created by Apple on 3/21/18.
//  Copyright © 2018 Tien. All rights reserved.
//

import RealmSwift

class ItemFavorites: Object {
    @objc dynamic var giveName = ""
    @objc dynamic var familyName = ""
    @objc dynamic var check = -1
    @objc dynamic var phone: String!
}
