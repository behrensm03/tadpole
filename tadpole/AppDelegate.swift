//
//  AppDelegate.swift
//  tadpole
//
//  Created by Michael Behrens on 7/10/19.
//  Copyright © 2019 Michael Behrens. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        
        FirebaseApp.configure()
        
        let vc = ViewControllerv2()
        let nc = MapNavigationController(rootViewController: vc)
        window?.rootViewController = nc
        
        window?.makeKeyAndVisible()
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        //GIDSignIn.sharedInstance().clientID = "287699874657-3av6nauopcat31go3qt3v8u52sft63mi.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        
        
        return true
    }

    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    func getUsername(email: String) -> String {
        let components = email.components(separatedBy: "@")
        return components[0]
    }
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        let username = getUsername(email: user.profile.email)
        let name = user.profile.givenName
        System.currentUser = username
        System.name = name
        UserDefaults.standard.set(username, forKey: "username")
        UserDefaults.standard.set(name, forKey: "name")
        
        let signedInUser = User(username: username, name: name!)
        var cleanUsername: String = ""
        for ch in username {
            if ch != "." {
                cleanUsername += String(ch)
            }
        }
        let signedInRef = DatabaseManager.usersRef.child(cleanUsername)
        DatabaseManager.currentUserRef = signedInRef
        
        signedInRef.observe(.value) { snapshot in
//            print(snapshot)
            let alreadyExists = snapshot.hasChild("username")
            if (alreadyExists) {
                signedInRef.updateChildValues(["username":username, "name":name as Any])
            } else {
                signedInRef.setValue(signedInUser.toDict())
                signedInRef.child("checkins").setValue(["none": true])
            }
        }
        
        DatabaseManager.getCheckinsForUser()
        
    }
    
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
    }
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url as URL?,
                                                 sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
    }
    
    


}

