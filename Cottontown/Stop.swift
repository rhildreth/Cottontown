//
//  Stop.swift
//  Cottontown
//
//  Created by Ron Hildreth on 12/22/15.
//  Copyright © 2015 Tappdev.com. All rights reserved.
//
// Version 1.0 of Cottontown app used Stops.plist which is an array of dictionaries whose values are strings and in one case an array.  This works fine in Obj-C, but Swift's strong typing forced this to be converting into an array with strings as keys and AnyObject as the type [[String: AnyObject]].  The init method here converts these to values used in the app.

import Foundation

class Stop {
    let stopNumber: String
    let stopTitle: String
    let stopAddress: String
    let latitude: String
    let longitude: String
    let youTubeURL: String
    let youTubeText: String
    let stopPictures: [[String: String]]
    
    init (stop:[String: AnyObject]) {
        stopNumber = stop["stopNumber"] as! String
        stopTitle = stop["stopTitle"] as! String
        stopAddress = stop["address"] as! String
        latitude = stop["latitude"] as! String
        longitude = stop["longitude"] as! String
        youTubeURL = stop["YouTube"] as! String
        youTubeText = stop["YouTubeText"] as! String
        stopPictures = stop["pictures"] as! [[String: String]]
        
    }
    
    
}