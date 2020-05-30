//
//  AccountViewController.swift
//  tadpole
//
//  Created by Michael Behrens on 7/11/19.
//  Copyright © 2019 Michael Behrens. All rights reserved.
//

import UIKit
//import Firebase
import GoogleSignIn

class AccountViewController: UIViewController {
    
    var signOutButton: UIButton!
    var accountEmailLabel: UILabel!
    var userImg: UIImageView!
    var currentZoneLabel: UILabel!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationItem.title = "account"
        view.backgroundColor = Colors.darkGray
        
        self.navigationController!.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: Colors.main,
             NSAttributedString.Key.font: UIFont(name: "Comfortaa-Bold", size: 24) ?? UIFont.systemFont(ofSize: 24, weight: .bold)]
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        
        signOutButton = Constants.buttonNoShadow(title: "sign out", isLargeSize: true)
        signOutButton.addTarget(self, action: #selector(signOut), for: .touchUpInside)
        view.addSubview(signOutButton)
        
        
        
        accountEmailLabel = UILabel()
        accountEmailLabel.translatesAutoresizingMaskIntoConstraints = false
        accountEmailLabel.font = UIFont(name: "Comfortaa-Bold", size: 25)
        accountEmailLabel.textColor = Colors.main
        accountEmailLabel.textAlignment = .center
        view.addSubview(accountEmailLabel)
        
        
        
        userImg = UIImageView()
        userImg.translatesAutoresizingMaskIntoConstraints = false
        userImg.image = UIImage(named: "tadpoletemp")
        userImg.layer.cornerRadius = Constants.imgViewDimension / 2
        userImg.clipsToBounds = true
        view.addSubview(userImg)
        
        
        currentZoneLabel = UILabel()
        currentZoneLabel.translatesAutoresizingMaskIntoConstraints = false
        currentZoneLabel.numberOfLines = 3
        currentZoneLabel.font = UIFont(name: "Comfortaa-Regular", size: 20)
        if let z = System.currentZone {
            currentZoneLabel.text = "Current Pond: " + z.name
        } else {
            currentZoneLabel.text = "Current Pond: None!"
        }
        currentZoneLabel.textAlignment = .center
        currentZoneLabel.textColor = Colors.main
        view.addSubview(currentZoneLabel)
        
        
        
        setupConstraints()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        showCurrentUser()
    }
    
    func removeSubviews(view: UIView) {
        for subview in view.subviews {
            subview.removeFromSuperview()
        }
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            signOutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            signOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signOutButton.heightAnchor.constraint(equalToConstant: Constants.defaultButtonHeight),
            signOutButton.widthAnchor.constraint(equalToConstant: Constants.defaultButtonWidth)
            ])
        
        NSLayoutConstraint.activate([
            userImg.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.verticalPadding),
            userImg.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userImg.heightAnchor.constraint(equalToConstant: Constants.imgViewDimension),
            userImg.widthAnchor.constraint(equalToConstant: Constants.imgViewDimension)
            ])
        
        NSLayoutConstraint.activate([
            accountEmailLabel.topAnchor.constraint(equalTo: userImg.bottomAnchor, constant: Constants.verticalPadding),
            accountEmailLabel.heightAnchor.constraint(equalToConstant: 50),
            accountEmailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalPadding),
            accountEmailLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -1 * Constants.horizontalPadding)
            ])
        
        NSLayoutConstraint.activate([
            currentZoneLabel.topAnchor.constraint(equalTo: accountEmailLabel.bottomAnchor, constant: Constants.verticalPadding),
            currentZoneLabel.leadingAnchor.constraint(equalTo: accountEmailLabel.leadingAnchor),
            currentZoneLabel.trailingAnchor.constraint(equalTo: accountEmailLabel.trailingAnchor),
            currentZoneLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        
    }
    
    @objc func signOut() {
        accountEmailLabel.text = ""
        GIDSignIn.sharedInstance().signOut()
        let signInController = SignInSignUpViewController()
        present(signInController, animated: true, completion: nil)
    }
    
    func showCurrentUser() {
        accountEmailLabel.text = "Hello "
        if let name = System.name {
            accountEmailLabel.text = accountEmailLabel.text! + name + "!"
        } else {
            accountEmailLabel.text = "Hello nobody!"
        }
    }

    
    
    
}
