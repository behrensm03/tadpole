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
    var checkins: [String]
    
    init(username: String, name: String) {
        self.username = username
        self.name = name
        self.checkins = []
    }
    
    func toDict() -> [String:Any] {
        let dict: [String:Any] = [
            "username" : username,
            "name" : name,
            "checkins" : checkins
        ]
        return dict
    }
    
    
}
