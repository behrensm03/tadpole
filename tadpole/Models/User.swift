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
    
    init(username: String, name: String) {
        self.username = username
        self.name = name
    }
    
    func toDict() -> [String:Any] {
        let dict: [String:Any] = [
            "username" : username,
            "name" : name
        ]
        return dict
    }
    
    
}
