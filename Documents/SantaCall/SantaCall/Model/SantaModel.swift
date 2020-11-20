//
//  SantaModel.swift
//  SantaCall
//
//  Created by Feitan on 11/3/20.
//

import Foundation

enum TypeCall {
    case video
    case phone
    
    func changeType() -> TypeCall {
        switch self {
        case .video:
            return .phone
        default:
            return .video
        }
    }
}

class SantaClaus {
    var background: String
    var textIntro: String
    var videoLink : String
    var content : String

    init(background: String, textIntro: String, videoLink: String, content: String) {
        self.background = background
        self.textIntro = textIntro
        self.videoLink = videoLink
        self.content = content
    }
}

