//
//  SignInSignUpViewController.swift
//  tadpole
//
//  Created by Michael Behrens on 7/24/19.
//  Copyright © 2019 Michael Behrens. All rights reserved.
//

import UIKit
//import Firebase
import GoogleSignIn

class SignInSignUpViewController: UIViewController, GIDSignInUIDelegate, UIGestureRecognizerDelegate {
    
    
    var tadpoleLabel: UILabel!
    var signInButton: GIDSignInButton!
    var tadpoleLogoImageView: UIImageView!
    
    
    
  

    override func viewDidLoad() {
        super.viewDidLoad()
        
   
        let touchRecognizer = UITapGestureRecognizer(target: self, action: #selector(onBaseTapOnly))
        touchRecognizer.numberOfTapsRequired = 1
        touchRecognizer.delegate = self
        self.view.addGestureRecognizer(touchRecognizer)
        
        createGradient()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        

        // Do any additional setup after loading the view.
        
        
        tadpoleLogoImageView = UIImageView()
        tadpoleLogoImageView.translatesAutoresizingMaskIntoConstraints = false
        tadpoleLogoImageView.image = UIImage(named: "tadpoletemp")
        tadpoleLogoImageView.alpha = 1
        tadpoleLogoImageView.layer.cornerRadius = Constants.loadingScreenLogoDimension / 2
        tadpoleLogoImageView.clipsToBounds = true
        view.addSubview(tadpoleLogoImageView)
        
        
        tadpoleLabel = UILabel()
        tadpoleLabel.translatesAutoresizingMaskIntoConstraints = false
        tadpoleLabel.text = "tadpole"
        tadpoleLabel.textAlignment = .center
        tadpoleLabel.textColor = .white
        tadpoleLabel.font = UIFont(name: "Comfortaa-Bold", size: 40) ?? UIFont.systemFont(ofSize: 40, weight: .bold)
        tadpoleLabel.alpha = 0
        view.addSubview(tadpoleLabel)
        
        
        signInButton = GIDSignInButton()
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        signInButton.style = .wide
        signInButton.colorScheme = .light
        signInButton.alpha = 0
        view.addSubview(signInButton)
        
        
        
        setupConstraints()
        
        
        
      
    }
    

    
    
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == gestureRecognizer.view
    }
    
    @objc func onBaseTapOnly(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            self.view.endEditing(true)
        }
    }
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if GIDSignIn.sharedInstance().hasAuthInKeychain() {
            DispatchQueue.main.async {
                GIDSignIn.sharedInstance()?.signInSilently()
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        UIView.animate(withDuration: 1) {
            self.tadpoleLogoImageView.alpha = 0
        }
        
        UIView.animate(withDuration: 1) {
            self.tadpoleLabel.alpha = 1
            self.signInButton.alpha = 1
        }
    }

    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            tadpoleLogoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tadpoleLogoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            tadpoleLogoImageView.widthAnchor.constraint(equalToConstant: Constants.loadingScreenLogoDimension),
            tadpoleLogoImageView.heightAnchor.constraint(equalToConstant: Constants.loadingScreenLogoDimension)
            ])
        
        NSLayoutConstraint.activate([
            tadpoleLabel.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -1 * Constants.verticalPadding),
            tadpoleLabel.heightAnchor.constraint(equalToConstant: 100),
            tadpoleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalPadding),
            tadpoleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -1 * Constants.horizontalPadding)
            ])
        
        NSLayoutConstraint.activate([
            signInButton.topAnchor.constraint(equalTo: tadpoleLabel.bottomAnchor, constant: Constants.verticalPadding),
            signInButton.heightAnchor.constraint(equalToConstant: 100),
            signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signInButton.widthAnchor.constraint(equalToConstant: 200)
            ])
    }
    

    
    func createGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [
            Colors.dark.cgColor,
            Colors.light.cgColor
        ]
        self.view.layer.addSublayer(gradientLayer)
    }

}


