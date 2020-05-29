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
             NSAttributedString.Key.font: UIFont(name: "Comfortaa-Bold", size: 24) ?? UIFont.systemFont(ofSize: 24, weight: .bold)]
        
        
        
        mapView = MKMapView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        mapView.delegate = self
        view.addSubview(mapView)
        
        checkLocationServices()
//        addAnnotations()
        
//        addMarker(mapView: mapView)
    }
    
    
    func addMarker(mapView: MKMapView) {
//        let identifier = "annotationid"
//        let annotation = MKPointAnnotation()
//        annotation.title = "a lilypad!"
//        annotation.subtitle = "lilypad description description description"
//        annotation.coordinate = mapView.centerCoordinate
//        let pinImage = UIImage(named: "test")
    }
    
    func addAnnotations() {
        let a1 = MKPointAnnotation()
        a1.title = "Lily num 1"
        a1.coordinate = CLLocationCoordinate2D(latitude: 40.869593, longitude: -74.077342)
        
        let a2 = MKPointAnnotation()
        a2.title = "second lilypad"
        a2.subtitle = "This is a subtitle"
        a2.coordinate = CLLocationCoordinate2D(latitude: 40.867211, longitude: -74.062025)
        
        mapView.addAnnotation(a1)
        mapView.addAnnotation(a2)
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
            print("Should have zoomed")
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

    
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        let identifier = "annotationid"
//        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
//        if annotationView == nil {
//            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
////            annotationView?.image = UIImage(named: "test")
//            let img = UIImage(named: "test")
//            let size = CGSize(width: 50, height: 50)
//            UIGraphicsBeginImageContext(size)
//            img?.draw(in: CGRect(x: 0, y: 0, width: 50, height: 50))
//            let resized = UIGraphicsGetImageFromCurrentImageContext()
//            annotationView?.image = resized
//            annotationView?.canShowCallout = true
//        } else {
//            annotationView?.annotation = annotation
//        }
//        print("done")
//        return annotationView
//    }

}
