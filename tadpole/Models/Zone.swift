//
//  Zone.swift
//  tadpole
//
//  Created by Michael Behrens on 4/30/20.
//  Copyright © 2020 Michael Behrens. All rights reserved.
//

import Foundation

class Zone {
    var name: String
    var subZones: [Zone]
    var constraints: [Constraint]
    
    init(name: String) {
        self.name = name
        self.subZones = [Zone]()
        self.constraints = [Constraint]()
    }
    
    init(name: String, subs: [Zone], const: [Constraint]) {
        self.name = name
        self.subZones = subs
        self.constraints = const
    }
    
    func addConstraint(constraint: Constraint) {
        self.constraints.append(constraint)
    }
    
    func insideThisZone(p: (Double, Double)) -> Bool {
        if self.subZones.count > 0 {
            for sz in self.subZones {
                if (sz.insideThisZone(p: p)) {
                    return true
                }
            }
            return false
        } else {
            for c in self.constraints {
                if !(c.isSatisfiedAtPoint(p: p)) {
                    return false
                }
            }
            return true
        }
    }
    
    
    func toString() -> String {
        var res = "Zone: " + String(name) + ", Subzones: ["
        for sz in subZones {
            res = res + sz.name + ", "
        }
        res = res + " --]" + ", Constraints: ["
        for c in constraints {
            res = res + c.toString() + " , "
        }
        res = res + " --]"
        return res
    }
    

}
