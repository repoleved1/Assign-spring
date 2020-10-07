//
//  APIManager.swift
//  FirebaseStarterApp
//
//  Created by Feitan on 10/3/20.
//  Copyright © 2020 Instamobile. All rights reserved.
//

import Foundation
import Alamofire

enum APIErorrs: Error {
    case custom(message: String)
}

typealias Handler = (Swift.Result<Any?, APIErorrs>) -> Void

class  APIManager {
    static let shareInstance = APIManager()
    
    func callingRegisterApi(register: RegisterModel, completionHandler:
        @escaping (Bool, String) -> ()) {
        let headers: HTTPHeaders = [
            .contentType("application/json")
        ]
        
        AF.request(register_url, method: .post, parameters: register, encoder: JSONParameterEncoder.default, headers: headers).response { response in
            debugPrint(response)
            switch response.result {
            case .success(let data):
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: [])
                    if response.response?.statusCode == 200 {
                        completionHandler(true, "User register successfully")
                    } else {
                        completionHandler(false, "Email đã tồn tại")
                    }
                } catch {
                    print(error.localizedDescription)
                    completionHandler(false, "Email đã tồn tại")
                }
            case .failure(let err):
                print(err.localizedDescription)
                completionHandler(false, "Email đã tồn tại")
                break
            }
        }
    }
    
    func callingLoginApi(login: LoginModel, completionHandler: @escaping Handler) {
        let headers: HTTPHeaders = [
            .contentType("application/json")
        ]
        
        AF.request(login_url, method: .post, parameters: login, encoder: JSONParameterEncoder.default, headers: headers).response { response in
            debugPrint(response)
            switch response.result {
            case .success(let data):
                do {
                    let json = try JSONDecoder().decode(ResponseModel.self, from: data!)
//                    let json = try JSONSerialization.jsonObject(with: data!, options: [])
                    if response.response?.statusCode == 200 {
                        completionHandler(.success(json))
                    } else {
                        completionHandler(.failure(.custom(message: "Please check your network connectivity")))
                    }
                } catch {
                    print(error.localizedDescription)
                    completionHandler(.failure(.custom(message: "Please try agian")))
                }
            case .failure(let err):
                print(err.localizedDescription)
                completionHandler(.failure(.custom(message: "Please try agian")))
                break
            }
        }
    }
}
