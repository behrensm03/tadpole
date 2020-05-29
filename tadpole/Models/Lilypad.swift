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
    var numCheckins: Int

    

    init(title: String, subtitle: String, poster: String, latitude: Double, longitude: Double, numCheckins: Int) {
        self.title = title
        self.subtitle = subtitle
        self.poster = poster
        self.latitude = latitude
        self.longitude = longitude
        self.numCheckins = numCheckins
    }
    
    init(dict: [String:String]) {
        self.title = dict["title"]!
        self.subtitle = dict["subtitle"]!
        self.poster = dict["poster"]!
        self.latitude = Double(dict["latitude"]!)!
        self.longitude = Double(dict["longitude"]!)!
        self.numCheckins = Int(dict["numCheckins"]!)!
    }
    
    init(dict: [String:Any]) {
        self.title = dict["title"] as! String
        self.subtitle = dict["subtitle"] as! String
        self.poster = dict["poster"] as! String
        self.latitude = dict["latitude"] as! Double
        self.longitude = dict["longitude"] as! Double
        self.numCheckins = dict["numCheckins"] as! Int
    }
    
    func toDict() -> [String: Any] {
        let dict: [String: Any] = [
            "title" : title,
            "subtitle" : subtitle,
            "poster" : poster,
            "latitude" : latitude,
            "longitude" : longitude,
            "numCheckins" : numCheckins
        ]
        return dict
    }
    
    func toString() -> String {
        let s = "Title: \(title), Subtitle: \(subtitle), poster: \(poster), latitude: \(latitude), longitude: \(longitude), numCheckins: \(numCheckins)"
        return s
    }
    
    func equals(lily2: Lilypad) -> Bool {
        return (self.title == lily2.title) && (self.latitude == lily2.latitude) && (self.longitude == lily2.longitude)
    }
    
}

