//
//  requestAPI.swift
//  GoogleMappractice
//
//  Created by Satoru Murakami on 2016/12/15.
//  Copyright © 2016年 Satoru Murakami. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

let env = ProcessInfo.processInfo.environment
let MY_PLACE_KEY:String = env["PLACE_KEY"]! as String

// places apiを叩く
func place_easy_info(latitude:Double, longitude:Double, genre:String) -> [[String:String]] {
    
    

    var type:String = ""
    var flg = 0
    
    if genre != "" {
        switch genre{
        case "食事":type = "food"
        case "カフェ":type = "cafe"
        case "娯楽施設":type = "amusement_park"
        case "公園":type = "park"
        default: break
        }
    }
    
    var parameters:Parameters = [
        "location":String(latitude)+","+String(longitude),
        "radius":"500",
        "types":type,
        "key":MY_PLACE_KEY
    ]
    
    if genre == "" {
        parameters.removeValue(forKey: "types")
        flg = 1
    }
    
    var place_datas:[[String:String]] = []
    var keep:Bool = true
    var place_rate:String!
    var price_rate:String!
    var photo:String!
    
    
    Alamofire.request("https://maps.googleapis.com/maps/api/place/nearbysearch/json", parameters:parameters, encoding:URLEncoding.default)
        .responseJSON { response in
            guard let object = response.result.value else {
                return
            }
            let data = JSON(object)
            let json = data["results"]
            
            json.forEach{ (_, json) in
                
                if flg == 1 {
                    flg = 0
                    return
                }
                
                if json["rating"].exists() {
                    place_rate = String(describing: json["rating"])
                } else {
                    place_rate = "---"
                }
                if json["price_level"].exists() {
                    price_rate = String(describing: 5-json["price_level"].int!)+".0"
                } else {
                    price_rate = "---"
                }
                if json["photos"][0]["photo_reference"].exists() {
                    photo = json["photos"][0]["photo_reference"].string!
                } else {
                    photo = "icon"
                }
                
                let info:[String:String] = [
                    "name":json["name"].string!,
                    "icon":json["icon"].string!,
                    "place_id":json["place_id"].string!,
                    "rate":place_rate,
                    "price":price_rate,
                    "genre":json["types"][0].string!,
                    "latitude":String(describing: json["geometry"]["location"]["lat"]),
                    "longitude":String(describing: json["geometry"]["location"]["lng"]),
                    "photo":photo
                ]
                place_datas.append(info)
            }
            keep = false
    }
    let runloop = RunLoop.current
    while keep && runloop.run(mode: RunLoopMode.defaultRunLoopMode, before: NSDate(timeIntervalSinceNow: 0.1) as Date) {
        //        0.1秒ごとに変数チェック
        //        response処理待ち
    }
    return place_datas
}

// なんでも検索
func free_word_search(key:String, genre:String) -> [[String:String]] {
    var type:String = ""
    
    if genre != "" {
        switch genre{
        case "食事":type = "food"
        case "カフェ":type = "cafe"
        case "娯楽施設":type = "amusement_park"
        case "公園":type = "park"
        default: break
        }
    }
    
    var parameters:Parameters = [
        "query":key+"+"+type,
        "radius":"500",
        "key":MY_PLACE_KEY
    ]
    
    if genre == "" {
        parameters.removeValue(forKey: "types")
    }
    
    var place_datas:[[String:String]] = []
    var keep:Bool = true
    var place_rate:String!
    var price_rate:String!
    var cnt = 0
    var photo:String!
    
    Alamofire.request("https://maps.googleapis.com/maps/api/place/textsearch/json", parameters:parameters, encoding:URLEncoding.default)
        .responseJSON { response in
            guard let object = response.result.value else {
                return
            }
            let data = JSON(object)
            let json = data["results"]
            json.forEach{ (_, json) in
                if cnt == 0 {
                    cnt = cnt + 1
                    return
                }
                if !(json["rating"].exists()) {
                    place_rate = "---"
                } else {
                    place_rate = String(describing: json["rating"])
                }
                if !(json["price_level"].exists()) {
                    price_rate = "---"
                } else {
                    price_rate = String(describing: 5-json["price_level"].int!)+".0"
                }
                if !(json["photos"][0]["photo_reference"].exists()) {
                    photo = "icon"
                } else {
                    photo = json["photos"][0]["photo_reference"].string!
                }
                let info:[String:String] = [
                    "name":json["name"].string!,
                    "icon":json["icon"].string!,
                    "place_id":json["place_id"].string!,
                    "rate":place_rate,
                    "price":price_rate,
                    "genre":json["types"][0].string!,
                    "latitude":String(describing: json["geometry"]["location"]["lat"]),
                    "longitude":String(describing: json["geometry"]["location"]["lng"]),
                    "photo":photo
                ]
                place_datas.append(info)
                cnt = cnt + 1
            }
            keep = false
    }
    let runloop = RunLoop.current
    while keep && runloop.run(mode: RunLoopMode.defaultRunLoopMode, before: NSDate(timeIntervalSinceNow: 0.1) as Date) {
        //        0.1秒ごとに変数チェック
        //        response処理待ち
    }
    return place_datas
}

// place_idを使用して場所の詳細情報を取得する
func detail_info(place_id:String) -> [String:String] {
    var info:[String:String] = [:]
    var keep:Bool = true
    var phone:String = "不明"
    let parameters:Parameters = [
        "placeid": place_id,
        "key":MY_PLACE_KEY
    ]
    Alamofire.request("https://maps.googleapis.com/maps/api/place/details/json", parameters:parameters, encoding:URLEncoding.default)
        .responseJSON { response in
            guard let object = response.result.value else {
                return
            }
            var data = JSON(object)
            let json = data["result"]
            if !(json["formatted_address"].exists()){
                phone = json["formatted_phone_number"].string!
            }
            info = [
                "address":json["formatted_address"].string!,
                "phone":phone
            ]
            keep = false
    }
    let runloop = RunLoop.current
    while keep && runloop.run(mode: RunLoopMode.defaultRunLoopMode, before: NSDate(timeIntervalSinceNow: 0.1) as Date) {
        //        0.1秒ごとに変数チェック
        //        response処理待ち
    }
    return info
}

// その場所のレビューを取得する(案外日本語がなかったので英語と日本語のものを取得)
func get_review(place_id:String) -> [[String:String]] {
    var info:[[String:String]] = []
    var keep:Bool = true
    let parameters:Parameters = [
        "placeid": place_id,
        "key":MY_PLACE_KEY
    ]
    Alamofire.request("https://maps.googleapis.com/maps/api/place/details/json", parameters:parameters, encoding:URLEncoding.default)
        .responseJSON { response in
            guard let object = response.result.value else {
                return
            }
            var data = JSON(object)
            let json = data["result"]["reviews"]
            json.forEach{ (_, json) in
                let review:[String:String] = [
                    "rate":String(describing: json["rating"]),
                    "text":json["text"].string!
                ]
                info.append(review)
            }
            keep = false
    }
    let runloop = RunLoop.current
    while keep && runloop.run(mode: RunLoopMode.defaultRunLoopMode, before: NSDate(timeIntervalSinceNow: 0.1) as Date) {
        //        0.1秒ごとに変数チェック
        //        response処理待ち
    }
    return info
}
