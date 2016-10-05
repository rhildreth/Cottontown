//
//  StopsModel.swift
//  Cottontown
//
//  Created by Ron Hildreth on 12/28/15.
//  Copyright © 2015 Tappdev.com. All rights reserved.
//

import Foundation
import ImageIO
import UIKit

class StopsModel {
    
    static let sharedInstance = StopsModel()
    
    var plistStops:[[String:AnyObject]]
    var allStops = [Stop]()
    var path:String
    let scale = UIScreen.main.scale
    
    fileprivate init () {
        path = Bundle.main.path(forResource: "Stops", ofType: "plist")!
        plistStops = NSArray(contentsOfFile: path)! as! [[String : AnyObject]]
        
        for plistStop in plistStops {
            allStops.append(Stop(stop: plistStop))
        }
    }
    
    class func resizeImage(fileName file: String, type: String, maxPointSize: CGFloat, completionHandler handler: @escaping (_ image: UIImage) -> Void) {
        
        let url = Bundle.main.url(forResource: file, withExtension: type)!

        let src = CGImageSourceCreateWithURL(url as CFURL, nil)!
        
        let scale = UIScreen.main.scale
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive).async {
            
            let dict : [AnyHashable: Any] = [
                kCGImageSourceShouldAllowFloat as AnyHashable : true,
                kCGImageSourceCreateThumbnailWithTransform as AnyHashable : true,
                kCGImageSourceCreateThumbnailFromImageAlways as AnyHashable : true,
                kCGImageSourceThumbnailMaxPixelSize as AnyHashable : maxPointSize * scale
            ]
            
            let imref = CGImageSourceCreateThumbnailAtIndex(src, 0, dict as CFDictionary?)!
            let im = UIImage(cgImage: imref, scale: scale, orientation: .up)
            
            DispatchQueue.main.async {
//                let startTime = CACurrentMediaTime()
                handler(im)
//                let elapsedTime = (CACurrentMediaTime() - startTime) * 1000
//                print("image time for row",file,"=", elapsedTime ,"ms")
                
            }
        }

    }
}
