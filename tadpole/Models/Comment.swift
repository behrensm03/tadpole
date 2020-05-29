//
//  Comment.swift
//  tadpole
//
//  Created by Michael Behrens on 10/28/19.
//  Copyright © 2019 Michael Behrens. All rights reserved.
//

import Foundation


class Comment {
    var body: String
    var poster: String
    
    init(poster: String, body: String) {
        self.body = body
        self.poster = poster
    }
    
    init(dict: [String: Any]) {
        self.body = dict["body"] as! String
        self.poster = dict["poster"] as! String
    }
    
    func toString() -> String {
        return "poster: \(self.poster), body: \(self.body)"
    }
    
}
