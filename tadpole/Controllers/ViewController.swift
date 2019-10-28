//
//  ViewController.swift
//  tadpole
//
//  Created by Michael Behrens on 7/10/19.
//  Copyright © 2019 Michael Behrens. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import GoogleSignIn

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    // Views and variables
    
    var mapView: MKMapView!
    let locationManager = CLLocationManager()
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        checkSignIn()
        
        view.backgroundColor = .white
        self.navigationItem.title = "tadpole"
        self.navigationController!.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: Colors.main,
             NSAttributedString.Key.font: UIFont(name: "Comfortaa-Bold", size: 30) ?? UIFont.systemFont(ofSize: 30, weight: .bold)]
        
        
        
        mapView = MKMapView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        mapView.delegate = self
        view.addSubview(mapView)
        
        checkLocationServices()
        
        addMarker()
    }
    
    
    func addMarker() {
        let annotation = MKPointAnnotation()
        annotation.title = "a lilypad!"
        annotation.subtitle = "lilypad description description description"
        annotation.coordinate = mapView.centerCoordinate
        let pinImage = UIImage(named: "test")
        
        mapView.addAnnotation(annotation)
        print("done")
    }
    
    
    
    func checkSignIn() {
        if GIDSignIn.sharedInstance().hasAuthInKeychain() {
            DispatchQueue.main.async {
                GIDSignIn.sharedInstance()?.signInSilently()
                System.currentUser = UserDefaults.standard.string(forKey: "username")
                System.name = UserDefaults.standard.string(forKey: "name")
                System.splashPower = UserDefaults.standard.integer(forKey: "splashPower")
//                System.splashPower = Int(UserDefaults.standard.string(forKey: "splashPower")!)
            }
        }
        else {
            let signInController = SignInSignUpViewController()
            present(signInController, animated: true, completion: nil)
        }
    }
    
    
    func createGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [Colors.dark.cgColor,
                                Colors.light.cgColor]
        self.view.layer.addSublayer(gradientLayer)
    }
    
    
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationPermission()
        } else {
            // show the user that location services are disabled
            let alert = UIAlertController(title: "uh oh", message: "Please enable location services", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    
    func checkLocationPermission() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            zoomInOnUser()
            locationManager.startUpdatingLocation()
            break
        case .authorizedAlways:
            break
        case .denied:
            // alert
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            // alert
            break
        @unknown default:
            break
        }
    }
    
    
    func zoomInOnUser() {
        if let location = locationManager.location?.coordinate {
            let region  = MKCoordinateRegion.init(center: location, latitudinalMeters: Constants.mapdist, longitudinalMeters: Constants.mapdist)
            mapView.setRegion(region, animated: true)
        }
    }
    
    
    
    
    
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: Constants.mapdist, longitudinalMeters: Constants.mapdist)
        mapView.setRegion(region, animated: true)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationPermission()
    }


}
