//
//  DatabaseManager.swift
//  tadpole
//
//  Created by Michael Behrens on 7/25/19.
//  Copyright © 2019 Michael Behrens. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase

class DatabaseManager {
    
    static var url: String {
        guard let path = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist"), let dict = NSDictionary(contentsOfFile: path) else { return "" }
        return dict.value(forKey: "DATABASE_URL") as! String
    }
    
    
    static var lilyPadsRef: DatabaseReference {
//        return Database.database().reference(fromURL: url)
        return Database.database().reference(withPath: "lilypads")
    }
    
    static var usersRef: DatabaseReference {
        return Database.database().reference(withPath: "users")
    }
    
    
    
    static func getLilypadInfo(completion: @escaping ([String]?) -> Void) {
        lilyPadsRef.observe(.value, with: { snapshot in
            if let infoDict = snapshot.value as? [String: Any] {
                let info = infoDict.map { (key, value) in (key)}
                completion(info)
            }
            else {
                completion(nil)
            }
        }) { error in
            print(error.localizedDescription)
            completion(nil)
        }
    }
    
    
    static func getLilypads(info: [String], completion: @escaping (Bool) -> Void) {
        var success = true
        let dispatchGroup = DispatchGroup()
        var lilypads = [Lilypad]()
        info.forEach { (lilyid) in
            dispatchGroup.enter()
            lilyPadsRef.child(lilyid).observeSingleEvent(of: .value, with: { snapshot in
                print(snapshot)
                if let lilyDict = snapshot.value as? [String : Any] {
                    let lily = Lilypad(dict: lilyDict)
                    lilypads.append(lily)
                }
                else {
                    lilypads.append(Lilypad(title: "bad", subtitle: "bad", poster: "bad"))
                }
                dispatchGroup.leave()
            }, withCancel: { error in
                print(error.localizedDescription)
                success = false
                dispatchGroup.leave()
            })
        }
        dispatchGroup.notify(queue: .main, execute: {
            System.lilypads = lilypads
            completion(success)
        })
    }
    
    
    
    
    
}
