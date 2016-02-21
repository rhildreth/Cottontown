//
//  StopsModel.swift
//  Cottontown
//
//  Created by Ron Hildreth on 12/28/15.
//  Copyright © 2015 Tappdev.com. All rights reserved.
//

import Foundation

class StopsModel {
    
    static let sharedInstance = StopsModel()
    
    var plistStops:[[String:AnyObject]]
    var allStops = [Stop]()
    var path:String
    
    private init () {
        path = NSBundle.mainBundle().pathForResource("Stops", ofType: "plist")!
        plistStops = NSArray(contentsOfFile: path)! as! [[String : AnyObject]]
        
        for plistStop in plistStops {
            allStops.append(Stop(stop: plistStop))
        }
    }
}
