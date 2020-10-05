//
//  RegisterModel.swift
//  FirebaseStarterApp
//
//  Created by Feitan on 10/3/20.
//  Copyright © 2020 Instamobile. All rights reserved.
//

import Foundation

struct RegisterModel: Encodable {
    let email: String
    let password: String
}

struct ResponseModel: Codable {
    let lastLogin: Int
    let userStatus, socialAccount: String
    let created: Int
    let email, blUserLocale: String
    let objectId, ownerId, welcomeClass, userToken: String
    
    enum CodingKeys: String, CodingKey {
        case lastLogin, userStatus, socialAccount, created, email, blUserLocale
        case objectId = "objectId"
        case ownerId = "ownerId"
        case welcomeClass = "___class"
        case userToken = "user-token"
    }
}
