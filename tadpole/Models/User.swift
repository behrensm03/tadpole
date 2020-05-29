//
//  User.swift
//  tadpole
//
//  Created by Michael Behrens on 7/31/19.
//  Copyright © 2019 Michael Behrens. All rights reserved.
//

import Foundation


class User {
    
    var username: String
    var name: String
//    var splashPower: Int
    
//    init(username: String, name: String, splashPower: Int) {
//        self.username = username
//        self.name = name
//        self.splashPower = splashPower
//    }
    
    init(username: String, name: String) {
        self.username = username
        self.name = name
//        self.splashPower = 0
    }
    
    func toDict() -> [String:Any] {
        let dict: [String:Any] = [
            "username" : username,
            "name" : name
//            "splashPower" : splashPower
        ]
        return dict
    }
    
    
}
