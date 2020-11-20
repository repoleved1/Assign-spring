//
//  Constant.swift
//  RingtoneMaker
//
//  Created by Feitan on 11/1/20.
//

import Foundation
import UIKit

//VALUE
let DEVICE_WIDTH = UIScreen.main.bounds.width
let DEVICE_HEIGHT = UIScreen.main.bounds.height
let SCREEN_WIDTH = UIScreen.main.bounds.width
let SCREEN_HEIGHT = UIScreen.main.bounds.height
let IS_IPAD = UIDevice.current.userInterfaceIdiom == .pad
let PHONE_RECORD = "phone_record"
let VIDEO_RECORD = "video_record"
let CURRENT_SANTA = "current_santa_claus"
let TIME_WAIT_MAX = 99
let TIME_WAIT_CURRENT = "time_wait_current"
let rootVC = UIApplication.shared.keyWindow?.rootViewController


//Object
let santaClauses = [
    SantaClaus(background: "background1_Detail", textIntro: "hello Santa", videoLink: "santa_1", content: "You are special, you are unique; may your Christmas be also as special and unique as you are! Merry Christmas!"),
    SantaClaus(background: "background2_Detail", textIntro: "naughty or nice", videoLink: "santa_2", content: "If you’re naughty child, you will not have gift. If you’re naughty child, you will not have gift."),
    SantaClaus(background: "background4_Detail", textIntro: "christmas preparation", videoLink: "santa_4", content: "Christmas is the proof that this world can become a better place if we have lots of people like you who fills it with happiness."),
    SantaClaus(background: "background3_Detail", textIntro: "what you want", videoLink: "santa_5", content: " There are so many gifts I want to give to you this Christmas. Peace, love, joy, happiness are all presents I am sending your way.")
    ]
