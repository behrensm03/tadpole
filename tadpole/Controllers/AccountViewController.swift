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
    var splashPowerLabel: UILabel!
    var userImg: UIImageView!
    var splashPowerProgressBarBackgroundView: UIView!
//    var splashPowerProgressBarView: UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // Do any additional setup after loading the view.
        
        self.navigationItem.title = "account"
        view.backgroundColor = .white
        
        self.navigationController!.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: Colors.main,
             NSAttributedString.Key.font: UIFont(name: "Comfortaa-Bold", size: 30) ?? UIFont.systemFont(ofSize: 30, weight: .bold)]
        
        
        signOutButton = UIButton()
        signOutButton.translatesAutoresizingMaskIntoConstraints = false
        signOutButton.setTitle("Sign out", for: .normal)
        signOutButton.setTitleColor(.white, for: .normal)
        signOutButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        signOutButton.backgroundColor = Colors.main
        signOutButton.layer.cornerRadius = 25
        signOutButton.layer.shadowColor = UIColor.gray.cgColor
        signOutButton.layer.shadowOffset = CGSize(width: 5, height: 7)
        signOutButton.layer.shadowOpacity = 0.8
        signOutButton.layer.masksToBounds = false
        signOutButton.addTarget(self, action: #selector(signOut), for: .touchUpInside)
        view.addSubview(signOutButton)
        
        
        
        accountEmailLabel = UILabel()
        accountEmailLabel.translatesAutoresizingMaskIntoConstraints = false
        accountEmailLabel.font = UIFont(name: "Comfortaa-Bold", size: 25)
        accountEmailLabel.textColor = Colors.main
        accountEmailLabel.textAlignment = .center
        view.addSubview(accountEmailLabel)
        
        
        
        
        splashPowerLabel = UILabel()
        splashPowerLabel.translatesAutoresizingMaskIntoConstraints = false
        splashPowerLabel.font = UIFont(name: "Comfortaa-Regular", size: 20)
        splashPowerLabel.textColor = Colors.main
        splashPowerLabel.textAlignment = .center
        view.addSubview(splashPowerLabel)
        
        
        userImg = UIImageView()
        userImg.translatesAutoresizingMaskIntoConstraints = false
        userImg.image = UIImage(named: "tadpoletemp")
        userImg.layer.cornerRadius = Constants.imgViewDimension / 2
        userImg.clipsToBounds = true
        view.addSubview(userImg)
        
        
        
        splashPowerProgressBarBackgroundView = UIView()
        splashPowerProgressBarBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        splashPowerProgressBarBackgroundView.backgroundColor = Colors.progressBarBackground
        splashPowerProgressBarBackgroundView.layer.cornerRadius = Constants.splashPowerProgressBarHeight / 2
        splashPowerProgressBarBackgroundView.clipsToBounds = true
        splashPowerProgressBarBackgroundView.layer.borderColor = UIColor.gray.cgColor
        splashPowerProgressBarBackgroundView.layer.borderWidth = 1
        view.addSubview(splashPowerProgressBarBackgroundView)
        
        
        
        
        
        
        setupConstraints()
//        getSplashPowerProgressBarWidth()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        showCurrentUser()
        removeSubviews(view: splashPowerProgressBarBackgroundView)
        addSplashPowerProgressBar()
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
            signOutButton.heightAnchor.constraint(equalToConstant: 50),
            signOutButton.widthAnchor.constraint(equalToConstant: 250)
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
            splashPowerProgressBarBackgroundView.topAnchor.constraint(equalTo: accountEmailLabel.bottomAnchor, constant: Constants.verticalPadding),
            splashPowerProgressBarBackgroundView.heightAnchor.constraint(equalToConstant: Constants.splashPowerProgressBarHeight),
            splashPowerProgressBarBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalPadding),
            splashPowerProgressBarBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -1 * Constants.horizontalPadding)
            ])
        
        NSLayoutConstraint.activate([
            splashPowerLabel.topAnchor.constraint(equalTo: splashPowerProgressBarBackgroundView.bottomAnchor, constant: Constants.verticalPadding),
            splashPowerLabel.heightAnchor.constraint(equalToConstant: 50),
            splashPowerLabel.leadingAnchor.constraint(equalTo: accountEmailLabel.leadingAnchor),
            splashPowerLabel.trailingAnchor.constraint(equalTo: splashPowerProgressBarBackgroundView.trailingAnchor)
            ])
        
        
    }
    
    
    
    func addSplashPowerProgressBar() {
        
        let splashPowerProgressBarView = UIView()
        splashPowerProgressBarView.translatesAutoresizingMaskIntoConstraints = false
        splashPowerProgressBarView.backgroundColor = Colors.main
        splashPowerProgressBarView.layer.cornerRadius = Constants.splashPowerProgressBarHeight / 2
        splashPowerProgressBarView.clipsToBounds = true
        splashPowerProgressBarBackgroundView.addSubview(splashPowerProgressBarView)
        splashPowerProgressBarBackgroundView.bringSubviewToFront(splashPowerProgressBarView)
        
        NSLayoutConstraint.activate([
            splashPowerProgressBarView.topAnchor.constraint(equalTo: splashPowerProgressBarBackgroundView.topAnchor),
            splashPowerProgressBarView.heightAnchor.constraint(equalTo: splashPowerProgressBarBackgroundView.heightAnchor),
            splashPowerProgressBarView.leadingAnchor.constraint(equalTo: splashPowerProgressBarBackgroundView.leadingAnchor),
            splashPowerProgressBarView.widthAnchor.constraint(equalToConstant: getSplashPowerProgressBarWidth())
        ])
        
    }
    
    
    func getSplashPowerProgressBarWidth() -> CGFloat {
        let bgwidth = splashPowerProgressBarBackgroundView.frame.width
        var w: CGFloat = 0
        if let splashPower = System.splashPower {
            w = (CGFloat(splashPower) / 100) * bgwidth
        }
        return w
    }
    
    
    @objc func signOut() {
        accountEmailLabel.text = ""
        splashPowerLabel.text = ""
        tabBarController?.selectedIndex = 1
        GIDSignIn.sharedInstance().signOut()
        let signInController = SignInSignUpViewController()
        present(signInController, animated: true, completion: nil)
    }
    
    func showCurrentUser() {
        
        // Show the user's name
        accountEmailLabel.text = "Hello "
        if let name = System.name {
            accountEmailLabel.text = accountEmailLabel.text! + name + "!"
        } else {
            accountEmailLabel.text = "Hello nobody!"
        }
        
        // Show the user their splash power
        splashPowerLabel.text = "Your splash power is "
        if let sp = System.splashPower {
            splashPowerLabel.text = splashPowerLabel.text! + "\(sp)"
        } else {
            splashPowerLabel.text = splashPowerLabel.text! + "a fat zero."
        }
    }

    
    
    
}
