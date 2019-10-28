//
//  Lilypad.swift
//  tadpole
//
//  Created by Michael Behrens on 8/8/19.
//  Copyright © 2019 Michael Behrens. All rights reserved.
//

import Foundation


class Lilypad {
    
    var title: String
    var subtitle: String
    var poster: String
    
    

    init(title: String, subtitle: String, poster: String) {
        self.title = title
        self.subtitle = subtitle
        self.poster = poster
    }
    
    init(dict: [String:String]) {
        self.title = dict["title"]!
        self.subtitle = dict["subtitle"]!
        self.poster = dict["poster"]!
    }
    
    init(dict: [String:Any]) {
        self.title = dict["title"] as! String
        self.subtitle = dict["subtitle"] as! String
        self.poster = dict["poster"] as! String
    }
    
//    init(db: [String:AnyObject]) {
//        
//    }
    
    
    func toDict() -> [String: String] {
        let dict: [String: String] = [
            "title" : title,
            "subtitle" : subtitle,
            "poster" : poster
        ]
        return dict
    }
    
    func toString() -> String {
        let s = "Title: " + title + ", Subtitle: " + subtitle + ", poster: " + poster
        return s
    }
    
}

