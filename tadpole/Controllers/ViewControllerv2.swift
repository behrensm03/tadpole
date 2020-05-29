//
//  ViewController.swift
//  tadpole
//
//  Created by Michael Behrens on 7/10/19.
//  Copyright © 2019 Michael Behrens. All rights reserved.
//

import UIKit
//import MapKit
import CoreLocation
import GoogleSignIn
import Mapbox
import NVActivityIndicatorView


class ViewControllerv2: UIViewController, CLLocationManagerDelegate, MGLMapViewDelegate {
    
    // Map and Location
    var mapView: MGLMapView!
    let locationManager = CLLocationManager()
    
    
    // Loading
    let loadingIndiator = NVActivityIndicatorView(frame: .zero, type: .circleStrokeSpin, color: Colors.main)
    
    
    // Top of screen Buttons
    var newLilypadButton: UIBarButtonItem!
    var accountButton: UIBarButtonItem!
    
    
    // Popup when not in a pond and trying to post
    var popupView: UIView!
    var titleLabel: UILabel!
    var body: UILabel!
    var dismissButtonNoZone: UIButton!
    
    
    // Detail view for lilypad
    var tpDetailView: TadpoleDetailView!
    var detailView: UIView!
    var dismissButtonDetailView: UIButton!
    var detailViewPosterLabel: UILabel!
    var checkinButton: UIButton!
    var buttonWidth = Constants.smallButtonWidth
    var buttonWidthConstraint: NSLayoutConstraint!
    var tpCollectionView: UICollectionView!
    var reuse = "reusetable"
    
    
    
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
        
        let accountImage = UIImage(named: "profile")
        accountButton = UIBarButtonItem(title: "Acct", style: .done, target: self, action: #selector(accountButtonTapped))
        accountButton.tintColor = Colors.main
        accountButton.image = accountImage
        self.navigationItem.leftBarButtonItem = accountButton
        
        mapView = MGLMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(mapView)
        mapView.styleURL = MGLStyle.darkStyleURL
        mapView.delegate = self
        mapView.showsUserLocation = true
        checkLocationServices()
        
        initializeZones()
        initializeZoneCenters()
    
        loadingIndiator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingIndiator)
        
        setupPopupView()
        setupDetailView()
        
        setupConstraints()
        view.bringSubviewToFront(loadingIndiator)
        loadingIndiator.startAnimating()

        let retrieval = DispatchGroup()
        retrieval.enter()
        getUserZone()
        retrieval.leave()
        retrieval.notify(queue: .main) {
            self.fetchLilypadsForZone()
        }
        
        
    }
    
    @objc func accountButtonTapped() {
        let avc = AccountViewController()
        self.navigationController?.pushViewController(avc, animated: true)
    }
    
    
    func setupDetailView() {
        tpDetailView = TadpoleDetailView()
        detailView = tpDetailView.getView()
        dismissButtonDetailView = tpDetailView.dismissButton
        detailViewPosterLabel = tpDetailView.posterLabel
        detailView.isHidden = true
        view.addSubview(detailView)
        tpCollectionView = tpDetailView.commentsCollectionView
        
        
        
        let ti = self.tpDetailView.titleLabel
        let sub = self.tpDetailView.subtitleLabel
        let ch = self.tpDetailView.checkinsLabel
        let icon = self.tpDetailView.checkinsIcon
        self.checkinButton = self.tpDetailView.checkinButton
        detailView.addSubview(ti)
        detailView.addSubview(sub)
        detailView.addSubview(dismissButtonDetailView)
        detailView.addSubview(detailViewPosterLabel)
        detailView.addSubview(icon)
        detailView.addSubview(ch)
        detailView.addSubview(checkinButton)
        checkinButton.addTarget(self, action: #selector(tappedCheckinButton), for: .touchUpInside)
        dismissButtonDetailView.addTarget(self, action: #selector(animateDetailViewOut), for: .touchUpInside)
        tpCollectionView.dataSource = self
        tpCollectionView.delegate = self
        detailView.addSubview(tpCollectionView)
        
        
        NSLayoutConstraint.activate([
            detailView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            detailView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            detailView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalPadding),
            detailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 4*Constants.verticalPadding)
        ])
        
        NSLayoutConstraint.activate([
            ti.topAnchor.constraint(equalTo: detailView.topAnchor, constant: Constants.verticalPadding),
            ti.leadingAnchor.constraint(equalTo: detailView.leadingAnchor, constant: Constants.horizontalPadding),
            ti.trailingAnchor.constraint(equalTo: detailView.trailingAnchor, constant: -1 * Constants.horizontalPadding),
            ti.heightAnchor.constraint(equalToConstant: Constants.slimLabelHeight)
        ])
        
        NSLayoutConstraint.activate([
            dismissButtonDetailView.bottomAnchor.constraint(equalTo: detailView.bottomAnchor, constant: -1 * Constants.verticalPadding),
            dismissButtonDetailView.centerXAnchor.constraint(equalTo: detailView.centerXAnchor),
            dismissButtonDetailView.widthAnchor.constraint(equalToConstant: Constants.defaultButtonWidth),
            dismissButtonDetailView.heightAnchor.constraint(equalToConstant: Constants.defaultButtonHeight)
        ])
        
        NSLayoutConstraint.activate([
            detailViewPosterLabel.topAnchor.constraint(equalTo: ti.bottomAnchor, constant: Constants.verticalPadding),
            detailViewPosterLabel.leadingAnchor.constraint(equalTo: ti.leadingAnchor),
            detailViewPosterLabel.trailingAnchor.constraint(equalTo: ti.trailingAnchor),
            detailViewPosterLabel.heightAnchor.constraint(equalToConstant: Constants.slimLabelHeight)
        ])
        
        NSLayoutConstraint.activate([
            sub.topAnchor.constraint(equalTo: detailViewPosterLabel.bottomAnchor, constant: Constants.verticalPadding),
            sub.leadingAnchor.constraint(equalTo: ti.leadingAnchor),
            sub.trailingAnchor.constraint(equalTo: ti.trailingAnchor),
            sub.heightAnchor.constraint(equalToConstant: Constants.defaultLabelHeight)
        ])
        
        NSLayoutConstraint.activate([
            icon.topAnchor.constraint(equalTo: sub.bottomAnchor, constant: Constants.verticalPadding),
            icon.leadingAnchor.constraint(equalTo: sub.leadingAnchor),
            icon.widthAnchor.constraint(equalToConstant: Constants.smallIconDimension),
            icon.heightAnchor.constraint(equalToConstant: Constants.smallIconDimension)
        ])
        
        NSLayoutConstraint.activate([
            ch.topAnchor.constraint(equalTo: icon.topAnchor),
            ch.leadingAnchor.constraint(equalTo: icon.trailingAnchor),
            ch.trailingAnchor.constraint(equalTo: sub.trailingAnchor),
            ch.bottomAnchor.constraint(equalTo: icon.bottomAnchor)
        ])
        
        buttonWidthConstraint = NSLayoutConstraint(item: checkinButton as Any, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: buttonWidth)
        NSLayoutConstraint.activate([
            checkinButton.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: Constants.verticalPadding),
            checkinButton.leadingAnchor.constraint(equalTo: icon.leadingAnchor),
            checkinButton.heightAnchor.constraint(equalToConstant: Constants.smallButtonHeight),
            buttonWidthConstraint
        ])
        
        NSLayoutConstraint.activate([
            tpCollectionView.topAnchor.constraint(equalTo: checkinButton.bottomAnchor, constant: Constants.verticalPadding),
            tpCollectionView.leadingAnchor.constraint(equalTo: detailView.leadingAnchor),
            tpCollectionView.trailingAnchor.constraint(equalTo: detailView.trailingAnchor),
            tpCollectionView.bottomAnchor.constraint(equalTo: dismissButtonDetailView.topAnchor, constant: -1 * Constants.verticalPadding)
        ])
    }
    
    @objc func tappedCheckinButton() {
//        print("add checkin here")
        if self.checkinButton.titleLabel?.text == "check in" {
            self.checkinButton.setTitle("✓", for: .normal)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
                self.buttonWidthConstraint.constant = 50
                self.checkinButton.layoutIfNeeded()
            }) { (complete) in
                print("adding checkin")
                DatabaseManager.updateCheckinsForLilypad(increase: true)
                self.changeNumCheckinsLabelByOne(isIncrementing: true)
                // MARK: update the number of checkins - do we reload the comment or just increment and wait till it appears again to reload everything
            }
        } else {
            self.checkinButton.setTitle("check in", for: .normal)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
                self.buttonWidthConstraint.constant = 100
                self.checkinButton.layoutIfNeeded()
            }) { (complete) in
                print("removing checkin")
                // MARK: check if this works - havent tested
                DatabaseManager.updateCheckinsForLilypad(increase: false)
                self.changeNumCheckinsLabelByOne(isIncrementing: false)
            }
        }
    }
    
    func changeNumCheckinsLabelByOne(isIncrementing: Bool) {
        let i = Int(self.tpDetailView.checkinsLabel.text!)
        if isIncrementing {
            self.tpDetailView.checkinsLabel.text = String(i!+1)
        } else {
            self.tpDetailView.checkinsLabel.text = String(i! - 1)
        }
    }
    
    @objc func animateDetailViewOut() {
        animateViewOut(v: detailView)
    }
    
    func setupPopupView() {
        popupView = UIView()
        popupView.translatesAutoresizingMaskIntoConstraints = false
        popupView.backgroundColor = .white
        popupView.layer.cornerRadius = 10
        popupView.layer.masksToBounds = false
        popupView.isHidden = true
        view.addSubview(popupView)
        
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Whoops!"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: "Comfortaa-Regular", size: 20)
        popupView.addSubview(titleLabel)
        
        body = UILabel()
        body.numberOfLines = 3
        body.translatesAutoresizingMaskIntoConstraints = false
        body.font = UIFont(name: "Comfortaa-Light", size: 15)
        body.textAlignment = .center
        body.text = "Looks like you're not in a pond. You can only create lilypads inside ponds!"
        popupView.addSubview(body)
        
        dismissButtonNoZone = Constants.buttonNoShadow(title: "dismiss", isLargeSize: true)
        dismissButtonNoZone.addTarget(self, action: #selector(animatePopupOut), for: .touchUpInside)
        popupView.addSubview(dismissButtonNoZone)
        
        NSLayoutConstraint.activate([
            popupView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            popupView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            popupView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalPadding),
            popupView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: popupView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: popupView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: popupView.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: Constants.defaultLabelHeight)
        ])
        
        NSLayoutConstraint.activate([
            body.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            body.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            body.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            body.heightAnchor.constraint(equalToConstant: Constants.defaultLabelHeight)
        ])
        
        NSLayoutConstraint.activate([
            dismissButtonNoZone.widthAnchor.constraint(equalToConstant: Constants.defaultButtonWidth),
            dismissButtonNoZone.heightAnchor.constraint(equalToConstant: Constants.defaultButtonHeight),
            dismissButtonNoZone.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dismissButtonNoZone.bottomAnchor.constraint(equalTo: popupView.bottomAnchor, constant: -2 * Constants.verticalPadding)
        ])
    }
    
    @objc func animatePopupOut() {
        animateViewOut(v: self.popupView)
    }
    
    func animateViewIn(v: UIView) {
        print("time to animate")
        v.isHidden = false
        v.transform = CGAffineTransform(translationX: 0, y: -v.frame.height)
        v.alpha = 0
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            v.transform = .identity
            v.alpha = 1
        }) { (complete) in
            if complete {
                print("done animating")
                if v == self.detailView {
                    print("animating the detail view so reloading collectionview")
                    self.tpCollectionView.reloadData()
                }
            }
        }
    }
    
    func animateViewOut(v: UIView) {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            v.transform = CGAffineTransform(translationX: 0, y: -self.view.frame.height)
        }) { (done) in
            if done {
                v.isHidden = true
            }
        }
    }
    
    
    
    // DEPRECATED??
//    func fetchZoneLilys() {
//        DatabaseManager.getZonesInfo { (info) in
//            if let info = info {
//                print("something good")
//                DatabaseManager.getLilypadsForZone(info: info) { (gotem) in
//                    if gotem {
//                        print("even better")
//                        self.loadingIndiator.stopAnimating()
//                        DispatchQueue.main.async {
//                            print("starting loop")
//                            for lily in System.lilypadsForZone {
//                                print("adding annotation")
//                                self.addAnnotationForLilypad(lily: lily)
//                            }
//                        }
//                    } else {
//                        fatalError()
//                    }
//                }
////                DatabaseManager.getZones(info: info) { (gotEm) in
////                    if gotEm {
////                        DispatchQueue.main.async {
////                            for zone in System.zonesDB {
////                                print("Got one from db ")
////                            }
////                        }
////                    } else {
////                        fatalError()
////                    }
////                }
//            } else {
//                fatalError()
//            }
//        }
//    }
    
    func debugUserZone() {
        for z in System.zones {
            print(z.name + " " + String(z.insideThisZone(p: System.transformedCoordinates!)))
            if z.name == "Soho" || z.name == "Lower East Side" {
                print("debugging for " + z.name)
                for c in z.constraints {
                    print(c.toString())
                    if let t = System.transformedCoordinates {
                        if c.isSatisfiedAtPoint(p: t) {
                            print("Above is satisfied")
                        } else {
                            print("The above is violated by " + String(t.0) + ", " + String(t.1))
                        }
                    }
                    else {
                        print("Did not have transformed coordinates at the moment")
                    }
                }
            }
        }
    }
    
    func getUserZone() {
        if let loc = System.currentLocation {
            System.lastTransformedCoordinates = System.transformedCoordinates
            System.transformedCoordinates = System.transformToCustomCoordinates(p: (loc.latitude, loc.longitude))
            let zonesByDist = zoneCentersByClosest()
            for zoneName in zonesByDist {
                if let z = System.getZoneByName(name: zoneName) {
                    if z.insideThisZone(p: System.transformedCoordinates!) {
                        if let curr = System.currentZone {
                            System.lastZone = curr
                        }
                        System.currentZone = z
                        DatabaseManager.currentZoneRef = DatabaseManager.zonesRef.child(z.name)
                        break
                    }
                }
            }
        }
//        if let curr = System.currentZone {
//            print("Located in " + curr.name)
//        } else {
//            print("Not in a zone")
//        }
    }
    
    func zoneCentersByClosest() -> [String] {
        if let loc = System.transformedCoordinates {
            var res = [String]() // zone names
            var distances = [Double]()
            System.zoneCenters.forEach { (name, coord) in
                let d = dist(p1: loc, p2: coord)
                if res.count == 0 {
                    res.append(name)
                    distances.append(d)
                } else {
                    for i in 0...(distances.count - 1) {
                        if distances[i] > d {
                            distances.insert(d, at: i)
                            res.insert(name, at: i)
                            break
                        }
                    }
                }
            }
            return res
        }
        else {
            return []
        }
    }
    
    func dist(p1: (Double, Double), p2: (Double, Double)) -> Double {
        return sqrt(pow(p2.0 - p1.0, 2) + pow(p2.1 - p1.1, 2))
    }
    
    func initializeZones() {
        //        let zeroCoordinates = (40.699896, -74.020616)
//        let zeroCoordinates = (40.712715, -74.037769)
//        let rotateCCW = -36.08 * Double.pi / 180 // radians
        let pointsOfIntersection : [String:(Double, Double)] = [
            "a":(40.805530, -73.970131),
            "b":(40.800616, -73.958156),
            "c":(40.796890, -73.949233),
            "d":(40.787906, -73.955778),
            "e":(40.782135, -73.942033),
            "f":(40.772989, -73.993727),
            "g":(40.768026, -73.981897),
            "h":(40.764321, -73.972993),
            "i":(40.758272, -73.958757),
            "j":(40.757155, -74.005196),
            "k":(40.752202, -73.993454),
            "l":(40.749825, -73.987760),
            "m":(40.742923, -73.992784),
            "n":(40.741573, -73.989581),
            "o":(40.740196, -73.986357),
            "p":(40.736897, -73.978551),
            "q":(40.735132, -73.974657),
            "r":(40.742533, -74.009096),
            "s":(40.737391, -73.996827),
            "t":(40.734791, -73.990740),
            "u":(40.733314, -73.987168),
            "v":(40.731343, -73.982569),
            "w":(40.726599, -73.971406),
            "x":(40.729169, -74.011013),
            "y":(40.728408, -74.002808),
            "z":(40.725614, -73.996670),
            "alpha":(40.723904, -73.992675),
            "beta":(40.718683, -73.973998),
            "gamma":(40.726125, -74.011576),
            "delta":(40.719403, -74.001894),
            "epsilon":(40.710750, -73.978483),
            "theta":(40.717340, -74.013186),
            "lambda":(40.714183, -74.006309),
            "mu":(40.708113, -73.999384),
            "pi":(40.704380, -74.018152),
            "sigma":(40.700317, -74.013051),
            "chi":(40.748476, -73.984572),
            "phi":(40.775002, -73.941573),
            "tau":(40.790173, -73.933386),
            "h1":(40.834624, -73.950189),
            "h2":(40.827899, -73.934283)
        ]
        
        var adjustedPoints = [String:(Double, Double)]()
        pointsOfIntersection.forEach { (pointName, point) in
//            let y = point.0 - zeroCoordinates.0
//            let x = point.1 - zeroCoordinates.1
//            let xprime = (x * cos(rotateCCW)) + (y * sin(rotateCCW))
//            let yprime = (-1 * x * sin(rotateCCW)) + (y * cos(rotateCCW))
//            adjustedPoints[pointName] = (xprime, yprime)
            adjustedPoints[pointName] = System.transformToCustomCoordinates(p: point)
        }
        
        // Name : [ (point, point, should be above, should be to the right of )
        let regionBoundaries : [String:[(String, String, Bool?, Bool?)]] =
            ["Harlem1" : [("h1", "h2", false, nil), ("h2", "tau", false, nil), ("tau", "c", true, nil), ("c", "a", true, nil), ("a", "h1", nil, true)],
             "Harlem2" : [("c", "tau", false, nil), ("tau", "e", true, nil), ("e", "d", true, nil), ("d", "c", nil, true)],
             "Upper West Side": [("a", "b", false, nil), ("b", "g", nil, false), ("g", "f", true, nil), ("f", "a", nil, true)],
             "Central Park": [("b", "c", false, nil), ("c", "d", nil, false), ("d", "h", nil, false), ("h", "g", true, nil), ("g", "b", nil, true)],
             "Upper East Side": [("d", "e", false, nil), ("e", "phi", false, nil), ("phi", "i", true, nil), ("i", "h", true, nil), ("h", "d", nil, true)],
             "Hell's Kitchen": [("f", "g", false, nil), ("g", "k", nil, false), ("k", "j", true, nil), ("j", "f", nil, true)],
             "Midtown1": [("g", "h", false, nil), ("h", "chi", nil, false), ("chi", "l", true, nil), ("l", "k", true, nil), ("k", "g", nil, true)],
             "Midtown2": [("l", "chi", false, nil), ("chi", "n", nil, false), ("n", "m", true, nil), ("m", "l", nil, true)],
             "Midtown East": [("h", "i", false, nil), ("i", "q", nil, false), ("q", "p", true, nil), ("p", "o", true, nil), ("o", "n", true, nil), ("n", "chi", nil, true), ("chi", "h", nil, true)],
             "Chelsea": [("j", "k", false, nil), ("k", "l", false, nil), ("l", "m", nil, false), ("m", "s", nil, false), ("s", "r", true, nil), ("r", "j", true, nil)],
             "Flatiron District": [("m", "n", false, nil), ("n", "o", false, nil), ("o", "t", nil, false), ("t", "s", true, nil), ("s", "m", nil, true)],
             "Gramercy": [("o", "p", false, nil), ("p", "v", nil, false), ("v", "u", true, nil), ("u", "t", true, nil), ("t", "o", nil, true)],
             "Stuyvesant Town": [("p", "q", false, nil), ("q", "w", false, nil), ("w", "v", true, nil), ("v", "p", nil, true)],
             "GV1": [("r", "s", false, nil), ("s", "y", nil, false), ("y", "x", true, nil), ("x", "r", true, nil)],
             "GV2": [("s", "t", false, nil), ("t", "z", nil, false), ("z", "y", true, nil), ("y", "s", nil, true)],
             "Noho": [("t", "u", false, nil), ("u", "alpha", nil, false), ("alpha", "z", true, nil), ("z", "t", nil, true)],
             "East Village": [("u", "v", false, nil), ("v", "w", false, nil), ("w", "beta", nil, false), ("beta", "alpha", true, nil), ("alpha", "u", nil, true)],
             "Soho": [("x", "y", false, nil), ("y", "z", false, nil), ("z", "delta", nil, false), ("delta", "gamma", true, nil), ("gamma", "x", true, nil)],
             "LES1": [("z", "alpha", false, nil), ("alpha", "lambda", true, nil), ("lambda", "z", nil, true)],
             "LES2": [("alpha", "beta", false, nil), ("beta", "epsilon", nil, false), ("epsilon", "mu", true, nil), ("mu", "lambda", true, nil), ("lambda", "alpha", false, nil)],
             "Tribeca": [("gamma", "delta", false, nil), ("delta", "lambda", nil, false), ("lambda", "theta", true, nil), ("theta", "gamma", true, nil)],
             "Financial District": [("theta", "lambda", false, nil), ("lambda", "mu", false, nil), ("mu", "sigma", true, nil), ("sigma", "pi", true, nil), ("pi", "theta", true, nil)]
        ]
        
        let subZones = ["Midtown1", "Midtown2", "GV1", "GV2", "LES1", "LES2", "Harlem1", "Harlem2"]
        var mt = [Zone]()
        var gv = [Zone]()
        var les = [Zone]()
        var harl = [Zone]()
        regionBoundaries.forEach { (name, bounds) in
            var cons = [Constraint]()
            for tup in bounds {
                var con : Constraint!
                if let known = tup.2 {
                    con = Constraint(isGreater: known, p1: adjustedPoints[tup.0]!, p2: adjustedPoints[tup.1]!)
                } else {
                    let m = slope(p1: adjustedPoints[tup.0]!, p2: adjustedPoints[tup.1]!)
                    let gt : Bool!
                    if ((m > 0) && (tup.3! == false)) || ((m < 0) && (tup.3! == true))  {
                        gt = true
                    } else {
//                        if name == "Tribeca" {
//                            print(m)
//                            print(tup.3)
//                        }
                        gt = false
                    }
                    con = Constraint(isGreater: gt, p1: adjustedPoints[tup.0]!, p2: adjustedPoints[tup.1]!)
                }
                cons.append(con)
            }
            if !(subZones.contains(name)) {
                System.zones.append(Zone(name: name, subs: [], const: cons))
            } else {
                if name == "Midtown1" || name == "Midtown2" {
                    mt.append(Zone(name: name, subs: [], const: cons))
                }
                else if name == "GV1" || name == "GV2" {
                    gv.append(Zone(name: name, subs: [], const: cons))
                }
                else if name == "LES1" || name == "LES2" {
                    les.append(Zone(name: name, subs: [], const: cons))
                }
                else if name == "Harlem1" || name == "Harlem2" {
                    harl.append(Zone(name: name, subs: [], const: cons))
                }
            }
        }
    
        System.zones.append(Zone(name: "Midtown", subs: mt, const: []))
        System.zones.append(Zone(name: "Greenwich Village", subs: gv, const: []))
        System.zones.append(Zone(name: "Lower East Side", subs: les, const:[]))
        System.zones.append(Zone(name: "Harlem", subs: harl, const: []))
    
    }
    
    func initializeZoneCenters() {
        let centers : [String : (Double, Double)] = [
            "Harlem" : (40.81175, -73.9463),
            "Upper West Side" : (40.78688, -73.97542),
            "Central Park" : (40.78146, -73.96598),
            "Upper East Side" : (40.77359, -73.95611),
            "Hell's Kitchen" : (40.76339, -73.99157),
            "Midtown" : (40.75753, -73.98326),
            "Midtown East" : (40.75169, -73.97496),
            "Chelsea" : (40.74629, -73.99933),
            "Flatiron District" : (40.73868, -73.9913),
            "Gramercy" : (40.73614, -73.98427),
            "Stuyvesant Town" : (40.73187, -73.97755),
            "Greenwich Village" : (40.73359, -74.00263),
            "Noho" : (40.72941, -73.99156),
            "East Village" : (40.72533, -73.98268),
            "Soho" : (40.7253, -74.00308),
            "Lower East Side" : (40.71655, -73.98922),
            "Tribeca" : (40.71857, -74.00695),
            "Financial District" : (40.70823, -74.00856)
        ]
        
        centers.forEach { (name, coord) in
            System.zoneCenters[name] = System.transformToCustomCoordinates(p: coord)
        }
    }
    
    func slope(p1: (Double, Double), p2: (Double, Double)) -> Double {
        return (p1.1 - p2.1) / (p1.0 - p2.0)
    }
    
    
    @objc func addLilypadButtonTapped() {
        if (System.currentZone?.name) != nil {
            let addLilypadController = AddLilypadViewController()
            self.navigationController?.pushViewController(addLilypadController, animated: true)
        }
        else {
            animateViewIn(v: self.popupView)
        }
    }

    
    func addAnnotationForLilypad(lily: Lilypad) {
//        let a = MGLPointAnnotation()
//        a.coordinate = CLLocationCoordinate2D(latitude: lily.latitude, longitude: lily.longitude)
//        a.title = lily.title
//        mapView.addAnnotation(a)
        
        let a = LilypadAnnotation()
        a.willUseImage = true
        a.coordinate = CLLocationCoordinate2D(latitude: lily.latitude, longitude: lily.longitude)
        a.title = lily.title
        mapView.addAnnotation(a)
        print("adding annotation for " + lily.title)
    }
    
    
    // DEPRECATED??
//    func fetchLilypads() {
//        DatabaseManager.getLilypadInfo { (info) in
//            if let info = info {
//                DatabaseManager.getLilypads(info: info) { (gotLilys) in
//                    if gotLilys {
//                        self.loadingIndiator.stopAnimating()
//                        DispatchQueue.main.async {
//                            for lily in System.lilypads {
//                                self.addAnnotationForLilypad(lily: lily)
//                            }
//                        }
//                    } else {
//                        fatalError()
//                    }
//                }
//            } else {
//                fatalError()
//            }
//        }
//    }
    
    func fetchLilypadsForZone() {
        DatabaseManager.getLilypadInfoForZone { (info) in
            if let info = info {
                DatabaseManager.getLilypadsForZone(info: info) { (gotLilys) in
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
    
    func fetchCommentsForLilypad() {
        DatabaseManager.getCommentsInfoForLilypad { (info) in
            if let info = info {
                DatabaseManager.getCommentsForLilypad(info: info) { (gotComments) in
                    if gotComments {
                        DispatchQueue.main.async {
                            // what here
                            for comment in System.activeLilypadComments {
                                print(comment.toString())
                            }
                        }
                        print("reloading data now")
//                        self.tpTableView.reloadData()
                        self.tpCollectionView.reloadData()
                    }
                }
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
            mapView.setCenter(CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude), zoomLevel: 13, animated: false)
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
        getUserZone()
        if let z = System.currentZone, let l = System.lastZone {
            if z.name != l.name {
                print("New zone so should update lilypads")
                fetchLilypadsForZone()
            } else {
                print("Same zone, no need to update")
            }
        }
        zoomInOnUser()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationPermission()
    }
    
    
    func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
        if let a = annotation as? LilypadAnnotation {
            if (!a.willUseImage) {
                return nil
            }
        }
        
        var img = mapView.dequeueReusableAnnotationImage(withIdentifier: "profile")
        if img == nil {
            img = MGLAnnotationImage(image: UIImage(named: "profile")!, reuseIdentifier: "profile")
        }
        return img
    }
    
    
    func mapView(_ mapView: MGLMapView, calloutViewFor annotation: MGLAnnotation) -> MGLCalloutView? {
        return LilypadCalloutView(representedObject: annotation)
    }
    
    
    func annotationsEqual(a1: MGLAnnotation, a2: MGLAnnotation) -> Bool {
        return a1.title == a2.title && a1.coordinate.latitude == a2.coordinate.latitude && a1.coordinate.longitude == a2.coordinate.longitude
    }
    
    func findAnnotationIndex(annotation: MGLAnnotation) -> Int? {
        if let annotations = mapView.annotations {
            for i in 0...(annotations.count-1) {
                print("examining annotation at index " + String(i))
                if annotationsEqual(a1: annotations[i], a2: annotation) {
                    print("equal")
                    return i
                }
            }
        }
        return nil
    }
    
    func findLilypadCorrespondingToAnnotation(annotation: MGLAnnotation) -> Lilypad? {
        if let t = annotation.title {
            for l in System.lilypads {
                if l.title == t && annotation.coordinate.latitude == l.latitude && annotation.coordinate.longitude == l.longitude {
                    return l
                }
            }
        }
        return nil
    }
    
    func findIdForLilypad(lilypad: Lilypad) -> String? {
        for i in 0...System.lilyIds.count {
            if lilypad.equals(lily2: System.lilypads[i]) {
                return System.lilyIds[i]
            }
        }
        return nil
    }
    
    func mapView(_ mapView: MGLMapView, tapOnCalloutFor annotation: MGLAnnotation) {
        if let lily = findLilypadCorrespondingToAnnotation(annotation: annotation) {
            self.tpDetailView.setLabelsForLilypad(lily: lily)
            animateViewIn(v: detailView)
            System.activeLilypad = lily
            if let id = findIdForLilypad(lilypad: lily) {
                print("this is the id")
                print(id)
                // get comments for this id
                System.activeLilypadId = id
                fetchCommentsForLilypad()
            } else {
                print("could not find the id for this lilypad")
                print(lily.toString())
            }
        } else {
            print("not found")
            return
        }
    }
    
    


}


extension ViewControllerv2: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return System.activeLilypadComments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: tpDetailView.reuse, for: indexPath) as! CommentCollectionViewCell
        cell.configure(for: System.activeLilypadComments[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected item at \(System.activeLilypadComments[indexPath.item].toString())")
    }
}


extension ViewControllerv2: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 200)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        <#code#>
//    }
}
