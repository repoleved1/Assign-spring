//
//  LoginModel.swift
//  FirebaseStarterApp
//
//  Created by Feitan on 10/4/20.
//  Copyright © 2020 Instamobile. All rights reserved.
//

import UIKit

struct LoginModel: Encodable {
    let login: String
    let password: String
}

struct LoginResponseModel {
    let email: String
}
