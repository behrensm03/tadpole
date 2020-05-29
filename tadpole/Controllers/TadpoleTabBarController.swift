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
        
        
        let accountViewController = AccountViewController()
        let accountNavigationController = MapNavigationController(rootViewController: accountViewController)
        accountNavigationController.tabBarItem.image = UIImage(named: "profile")
        
        let mapv2 = ViewControllerv2()
        let mapv2nc = MapNavigationController(rootViewController: mapv2)
        mapv2nc.tabBarItem.image = UIImage(named: "search")
        
        viewControllers = [mapv2nc, accountNavigationController]
        self.selectedIndex = 0
        self.tabBar.barTintColor = UIColor.black

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
