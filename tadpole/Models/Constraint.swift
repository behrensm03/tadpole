//
//  Constraint.swift
//  tadpole
//
//  Created by Michael Behrens on 4/30/20.
//  Copyright © 2020 Michael Behrens. All rights reserved.
//

import Foundation

enum constraintType {
    case north, south, east, west
}

class Constraint {

    var isGreaterThan: Bool
    var b: Double
    var m: Double
    // Constraints are of the format:
    // Y >= mX + b
    // Y <= mX + b
    
    init(isGreaterThan: Bool, m: Double, b: Double) {
        self.isGreaterThan = isGreaterThan
        self.m = m
        self.b = b
    }
    
    init(isGreater: Bool, p1: (Double, Double), p2: (Double, Double)) {
        self.m = (p2.1 - p1.1) / (p2.0 - p1.0)
        self.b = p1.1 - self.m * p1.0
        self.isGreaterThan = isGreater
    }
    
    func isSatisfiedAtPoint(x: Double, y: Double) -> Bool {
        if self.isGreaterThan {
            if ( y >= (self.m * x) + self.b ) {
                return true
            }
            return false
        } else {
            if ( y <= (self.m * x) + self.b ) {
                return true
            }
            return false
        }
    }
    
    
    func isSatisfiedAtPoint(p: (Double, Double)) -> Bool {
        return isSatisfiedAtPoint(x: p.0, y: p.1)
    }
    
    func toString() -> String {
        if isGreaterThan {
            return "y >= \(m) x + \(b)"
        }
            return "y <= \(m) + x + \(b)"
    }
    
    
}
