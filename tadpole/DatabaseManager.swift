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
    
    static var zonesRef: DatabaseReference {
        return Database.database().reference(withPath: "zones")
    }
    
    static var commentsRef: DatabaseReference {
        return Database.database().reference(withPath: "comments")
    }
    
    static var currentZoneRef: DatabaseReference? = nil
    
    
    
    
    // DEPRECATED???
//    static func getLilypadInfo(completion: @escaping ([String]?) -> Void) {
//        lilyPadsRef.observe(.value, with: { snapshot in
//            if let infoDict = snapshot.value as? [String: Any] {
//                let info = infoDict.map { (key, value) in (key)}
//                completion(info)
//            }
//            else {
//                completion(nil)
//            }
//        }) { error in
//            print(error.localizedDescription)
//            completion(nil)
//        }
//    }
    
    // DEPRECATED??
//    static func getLilypads(info: [String], completion: @escaping (Bool) -> Void) {
//        var success = true
//        let dispatchGroup = DispatchGroup()
//        var lilypads = [Lilypad]()
//        info.forEach { (lilyid) in
//            dispatchGroup.enter()
//            lilyPadsRef.child(lilyid).observeSingleEvent(of: .value, with: { snapshot in
//                print(snapshot)
//                if let lilyDict = snapshot.value as? [String : Any] {
//                    let lily = Lilypad(dict: lilyDict)
//                    lilypads.append(lily)
//                }
//                else {
//                    lilypads.append(Lilypad(title: "bad", subtitle: "bad", poster: "bad", latitude: 1.0, longitude: 1.0))
//                }
//                dispatchGroup.leave()
//            }, withCancel: { error in
//                print(error.localizedDescription)
//                success = false
//                dispatchGroup.leave()
//            })
//        }
//        dispatchGroup.notify(queue: .main, execute: {
//            System.lilypads = lilypads
//            print(lilypads)
//            completion(success)
//        })
//    }
    
    
    static func getLilypadInfoForZone(completion: @escaping ([String]?) -> Void) {
        if let z = System.currentZone {
            let r = zonesRef.child(z.name)
//            lilyPadsRef.observe(.value, with: { snapshot in
            r.observe(.value, with: { snapshot in
                if let infoDict = snapshot.value as? [String: Any] {
//                    print(snapshot.key)
//                    print("thats a key")
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
    }
    
    
    static func getLilypadsForZone(info: [String], completion: @escaping (Bool) -> Void) {
        if let z = System.currentZone {
            var success = true
            let dispatchGroup = DispatchGroup()
            var lilypads = [Lilypad]()
            var lilyIds = [String]()
            let r = zonesRef.child(z.name)
            info.forEach { (lilyid) in
                dispatchGroup.enter()
//                lilyPadsRef.child(lilyid).observeSingleEvent(of: .value, with: { snapshot in
                r.child(lilyid).observeSingleEvent(of: .value, with: { snapshot in
                    print(snapshot)
                    print(snapshot.key)
                    print("thats a key but lower")
                    if let lilyDict = snapshot.value as? [String : Any] {
                        let lily = Lilypad(dict: lilyDict)
                        lilypads.append(lily)
                        lilyIds.append(snapshot.key)
                    }
                    else {
                        lilypads.append(Lilypad(title: "bad", subtitle: "bad", poster: "bad", latitude: 1.0, longitude: 1.0, numCheckins: -1))
                        lilyIds.append("No bueno")
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
                System.lilyIds = lilyIds
                print(lilypads)
                completion(success)
            })
        }
    }
    
    
    static func getCommentsInfoForLilypad(completion: @escaping ([String]?) -> Void) {
        if let id = System.activeLilypadId {
            let r = commentsRef.child(id)
            r.observe(.value, with: { (snapshot) in
                if let infoDict = snapshot.value as? [String: Any] {
                    let info = infoDict.map { (key, value) in (key) }
                    completion(info)
                } else {
                    completion(nil)
                }
            }) { (error) in
                print(error.localizedDescription)
                completion(nil)
            }
        }
    }
    
    
    static func getCommentsForLilypad(info: [String], completion: @escaping (Bool) -> Void) {
        if let id = System.activeLilypadId {
            var success = true
            let dispatchGroup = DispatchGroup()
            var comments = [Comment]()
            let r = commentsRef.child(id)
            info.forEach { (commentId) in
                dispatchGroup.enter()
                r.child(commentId).observeSingleEvent(of: .value, with: { (snapshot) in
                    print(snapshot)
                    print("heres a comment snapshot ^^")
                    if let commentDict = snapshot.value as? [String: Any] {
                        let comment = Comment(dict: commentDict)
                        comments.append(comment)
                    } else {
                        comments.append(Comment(poster: "BAD_COMMENT", body: "BAD_COMMENT_ERROR"))
                    }
                    dispatchGroup.leave()
                }, withCancel: { (error) in
                    print(error.localizedDescription)
                    success = false
                    dispatchGroup.leave()
                })
            }
            dispatchGroup.notify(queue: .main) {
                System.activeLilypadComments = comments
                print(comments)
                completion(success)
            }
        }
    }
    
    
    static func updateCheckinsForLilypad(increase: Bool) {
        if let id = System.activeLilypadId, let z = currentZoneRef {
            let r = z.child(id)
            r.runTransactionBlock({ (data) -> TransactionResult in
                if var d = data.value as? [String: Any] {
                    if var num = d["numCheckins"] as? Int {
                        if increase {
                            num += 1
                        } else {
                            num -= 1
                        }
                        d["numCheckins"] = num
                        data.value = d
                    }
                }
                return TransactionResult.success(withValue: data)
            }) { (error, commited, snapshot) in
                if let e = error {
                    print(e.localizedDescription)
                }
            }
        }
    }
    
    
    
    
    
    
    
    // DEPRECATED??
//    static func getLilypadsForZone(info: [String], completion: @escaping (Bool) -> Void) {
//        if let z = System.currentZone {
//            let name = z.name
////            let r = zonesRef.child(name)
//            let r = lilyPadsRef
//            var success = true
//            let dispatchGroup = DispatchGroup()
//            var lilys = [Lilypad]()
//            info.forEach { (lilyId) in
//                print(lilyId)
//                dispatchGroup.enter()
//                r.child(lilyId).observeSingleEvent(of: .value, with: { (snapshot) in
//                    print(snapshot)
//                    print("this is working")
//                    if let lilyDict = snapshot.value as? [String:Any] {
//                        let lily = Lilypad(dict: lilyDict)
//                        lilys.append(lily)
//                    } else {
//                        lilys.append(Lilypad(title: "bad", subtitle: "bad", poster: "bad", latitude: 1.0, longitude: 1.0))
//                        print("Failed conversion ----------")
//                    }
//                }, withCancel: { (error) in
//                    print(error.localizedDescription)
//                    success = false
//                    dispatchGroup.leave()
//                })
//            }
//            print("finished1")
//            dispatchGroup.notify(queue: .main, execute: {
//                print("finished")
//                System.lilypadsForZone = lilys
//                print(System.lilypadsForZone)
//                completion(success)
//            })
//        } else {
//            fatalError()
//        }
//    }
    
    static func getZonesInfo(completion: @escaping ([String]?) ->Void) {
        if System.currentZone != nil {
//            let name = z.name
//            zonesRef.child(name).observe(.value, with: { (snapshot) in
            lilyPadsRef.observe(.value, with: { (snapshot) in
                if let infoDict = snapshot.value as? [String: Any] {
                    let info = infoDict.map { (key, value) in (key) }
                    completion(info)
                }
                else {
                    completion(nil)
                }
            }) { (error) in
                print(error.localizedDescription)
                completion(nil)
            }
        } else {
            fatalError()
        }
    }
    
    
    
//    static func addLilypad(lily: Lilypad) {
//        let updates = lily.toDict()
//        lilyPadsRef.childByAutoId().updateChildValues(updates)
//    }
    
    static func addLilypadForZone(lily: Lilypad) {
        if let z = currentZoneRef {
            let updates = lily.toDict()
            z.childByAutoId().updateChildValues(updates)
//            let comments = []
            
        }
        else {
            print("wasnt supposed to happen but no current zone ref")
        }
    }
    
    static func addNewUser(user: User) {
        let updates = user.toDict()
        usersRef.childByAutoId().updateChildValues(updates)
    }
    
    
    // DEPRECATED??
//    static func getZones(info: [String], completion: @escaping (Bool) -> Void) {
//        var success = true
//        let dispatchGroup = DispatchGroup()
//        var zones = [[String: Any]]()
//        info.forEach { (zoneName) in
//            dispatchGroup.enter()
//            zonesRef.child(zoneName).observeSingleEvent(of: .value, with: { (snapshot) in
//                print(snapshot)
//                print("this is working")
//                if let zoneDict = snapshot.value as? [String:Any] {
//                    zones.append(zoneDict)
//                } else {
//                    print("Failed conversion ----------")
//                }
//            }, withCancel: { (error) in
//                print(error.localizedDescription)
//                success = false
//                dispatchGroup.leave()
//            })
//        }
//        dispatchGroup.notify(queue: .main, execute: {
//            print("finished")
//            System.zonesDB = zones
//            completion(success)
//        })
//    }
    
    // DEPRECATED??
    //    static func getZonesInfo(completion: @escaping ([String]?) ->Void) {
    //        zonesRef.observe(.value, with: { (snapshot) in
    //            if let infoDict = snapshot.value as? [String: Any] {
    //                let info = infoDict.map { (key, value) in (key) }
    //                completion(info)
    //            }
    //            else {
    //                print("completion nil time")
    //                completion(nil)
    //            }
    //        }) { (error) in
    //            print(error.localizedDescription)
    //            completion(nil)
    //        }
    //    }
    
    
}
