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
import Mapbox
import NVActivityIndicatorView

class ViewControllerv2: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, MGLMapViewDelegate {
    
    // Views and variables
    
    
    var mapView: MGLMapView!
    let locationManager = CLLocationManager()
    let loadingIndiator = NVActivityIndicatorView(frame: .zero, type: .circleStrokeSpin, color: Colors.main)
    var newLilypadButton: UIBarButtonItem!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setNeedsStatusBarAppearanceUpdate()
        checkSignIn()
        
        view.backgroundColor = .white
        self.navigationItem.title = "tadpole"
        self.navigationController!.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: Colors.main,
             NSAttributedString.Key.font: UIFont(name: "Comfortaa-Bold", size: 24) ?? UIFont.systemFont(ofSize: 24, weight: .bold)]
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
    

        
        newLilypadButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addLilypadButtonTapped))
        newLilypadButton.tintColor = Colors.main
        self.navigationItem.rightBarButtonItem = newLilypadButton
        
        mapView = MGLMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(mapView)
        mapView.styleURL = MGLStyle.darkStyleURL
        mapView.delegate = self
        mapView.showsUserLocation = true
        checkLocationServices()
    
        loadingIndiator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingIndiator)
        
        setupConstraints()
        view.bringSubviewToFront(loadingIndiator)
        loadingIndiator.startAnimating()
        fetchLilypads()
        
    }
    
    @objc func addLilypadButtonTapped() {
        let addLilypadController = AddLilypadViewController()
        self.navigationController?.pushViewController(addLilypadController, animated: true)
    }

    
    func addAnnotations() {
        let a1 = MGLPointAnnotation()
        a1.coordinate = CLLocationCoordinate2D(latitude: 40.869593, longitude: -74.077342)
        a1.title = "lily1"
        mapView.addAnnotation(a1)
    }
    

    
    func addAnnotationForLilypad(lily: Lilypad) {
        let a = MGLPointAnnotation()
        a.coordinate = CLLocationCoordinate2D(latitude: lily.latitude, longitude: lily.longitude)
        a.title = lily.title
        mapView.addAnnotation(a)
    }
    
    func fetchLilypads() {
        DatabaseManager.getLilypadInfo { (info) in
            if let info = info {
                DatabaseManager.getLilypads(info: info) { (gotLilys) in
                    if gotLilys {
                        self.loadingIndiator.stopAnimating()
                        DispatchQueue.main.async {
                            for lily in System.lilypads {
                                self.addAnnotationForLilypad(lily: lily)
                            }
                        }
                    } else {
                        fatalError()
                    }
                }
            } else {
                fatalError()
            }
        }
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            loadingIndiator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndiator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loadingIndiator.widthAnchor.constraint(equalToConstant: 50),
            loadingIndiator.heightAnchor.constraint(equalToConstant: 50)
        ])
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
            mapView.setCenter(CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude), zoomLevel: 10, animated: false)
            System.currentLocation = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        } else {
            mapView.setCenter(CLLocationCoordinate2D(latitude: 40.781049, longitude: -73.966727), animated: false)
        }
    }
    
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        mapView.setCenter(center, animated: true)
        System.currentLocation = center
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationPermission()
    }

    

}
