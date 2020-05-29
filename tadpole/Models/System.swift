//
//  System.swift
//  tadpole
//
//  Created by Michael Behrens on 7/24/19.
//  Copyright © 2019 Michael Behrens. All rights reserved.
//

import Foundation
import MapKit

class System {
    
    // Account stuff
    static var currentUser: String?
    static var name: String?
    
    
    
    // Lilypads
    static var lilypads = [Lilypad]()
    static var lilyIds = [String]()
    static var activeLilypad: Lilypad?
    static var activeLilypadId: String?
    
    // Comments
    static var activeLilypadComments = [Comment]()
    
    
    // Coordinates
    static var currentLocation: CLLocationCoordinate2D?
    static var transformedCoordinates : (Double, Double)? // Store the user location in the custom coordinate system
    static var lastTransformedCoordinates : (Double, Double)? // most recent one but not current
    
    
    // Geometry Calculations - NYC specific
    // MARK: Convert to JSON input for future addition of cities
    static var zeroCoordinates = (40.712715, -74.037769)
    static var rotateCCW = -36.08 * Double.pi / 180 // radians
    
    
    
    
    // Zones
    static var zones = [Zone]()
    static var zoneCenters = [String: (Double, Double)]() // these are in the tranformed coordinate system
    static var currentZone : Zone?
    static var lastZone : Zone?  // zone we were most recently in
    
    
    
    
    
    
    
    
    // Take a point p with latitude and longitude and convert it to a coordinate in the
    // custom system defined by zeroCoordinates and rotateCCW
    // Also switch latitude to y and longitude to x
    static func transformToCustomCoordinates(p: (Double, Double)) -> (Double, Double) {
        // Note: p is lat, long
        let y = p.0 - zeroCoordinates.0
        let x = p.1 - zeroCoordinates.1
        let xprime = (x * cos(rotateCCW)) + (y * sin(rotateCCW))
        let yprime = (-1 * x * sin(rotateCCW)) + (y * cos(rotateCCW))
        return (xprime, yprime)
    }
    
    
    
    static func getZoneByName(name: String) -> Zone? {
        for z in zones {
            if z.name == name {
                return z
            }
        }
        return nil
    }
    
    static var zonesDB = [[String:Any]]()
}

