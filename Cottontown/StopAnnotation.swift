//
//  File.swift
//  Cottontown
//
//  Created by Ron Hildreth on 1/2/16.
//  Copyright © 2016 Tappdev.com. All rights reserved.
//

import MapKit
import UIKit

class StopAnnotation: NSObject, MKAnnotation {
    
    let coordinate: CLLocationCoordinate2D
    
    let title: String?
    let subtitle: String?
    
    let stopNumber: Int
    
    init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String, stopNumber: Int){
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.stopNumber = stopNumber
    }

}
