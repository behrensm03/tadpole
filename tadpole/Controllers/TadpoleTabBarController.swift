//
//  TadpoleTabBarController.swift
//  tadpole
//
//  Created by Michael Behrens on 7/11/19.
//  Copyright © 2019 Michael Behrens. All rights reserved.
//

import UIKit
//import Firebase

class TadpoleTabBarController: UITabBarController {

//    var firstLaunch = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        let viewController = ViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem.image = UIImage(named: "map")
//        navigationController.title = "tadpole"
        
        let accountViewController = AccountViewController()
        let accountNavigationController = UINavigationController(rootViewController: accountViewController)
        accountNavigationController.tabBarItem.image = UIImage(named: "profile")
//        accountNavigationController.title = "account"
        
        let browseViewController = BrowseViewController()
        let browseNavigationController = UINavigationController(rootViewController: browseViewController)
        browseNavigationController.tabBarItem.image = UIImage(named: "search")
//        browseNavigationController.title = "browse"
        
        viewControllers = [browseNavigationController, navigationController, accountNavigationController]
        
        self.selectedIndex = 1
//        self.removeTabBarTitles()
    }
    
    
    func removeTabBarTitles() {
        if let tabs = tabBarController?.tabBar.items {
            for tab in tabs {
                tab.title = ""
                tab.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
            }
        }
    }
    

}
