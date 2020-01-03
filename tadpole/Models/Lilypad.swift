//
//  Lilypad.swift
//  tadpole
//
//  Created by Michael Behrens on 8/8/19.
//  Copyright © 2019 Michael Behrens. All rights reserved.
//

import Foundation


class Lilypad: Codable {
    
    var title: String
    var subtitle: String
    var poster: String
    var latitude: Double
    var longitude: Double
    

    init(title: String, subtitle: String, poster: String, latitude: Double, longitude: Double) {
        self.title = title
        self.subtitle = subtitle
        self.poster = poster
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init(dict: [String:String]) {
        self.title = dict["title"]!
        self.subtitle = dict["subtitle"]!
        self.poster = dict["poster"]!
        self.latitude = Double(dict["latitude"]!)!
        self.longitude = Double(dict["longitude"]!)!
    }
    
    init(dict: [String:Any]) {
        self.title = dict["title"] as! String
        self.subtitle = dict["subtitle"] as! String
        self.poster = dict["poster"] as! String
        self.latitude = dict["latitude"] as! Double
        self.longitude = dict["longitude"] as! Double
    }
    
    
//    func toDict() -> [String: String] {
//        let dict: [String: String] = [
//            "title" : title,
//            "subtitle" : subtitle,
//            "poster" : poster,
//            "latitude" : String(latitude),
//            "longitude" : String(longitude)
//        ]
//        return dict
//    }
    
    func toDict() -> [String: Any] {
        let dict: [String: Any] = [
            "title" : title,
            "subtitle" : subtitle,
            "poster" : poster,
            "latitude" : latitude,
            "longitude" : longitude
        ]
        return dict
    }
    
    func toString() -> String {
        let s = "Title: " + title + ", Subtitle: " + subtitle + ", poster: " + poster + ", latitude: " + String(latitude) + ", longitude: " + String(longitude)
        return s
    }
    
}

