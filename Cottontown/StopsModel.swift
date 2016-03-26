//
//  StopsModel.swift
//  Cottontown
//
//  Created by Ron Hildreth on 12/28/15.
//  Copyright © 2015 Tappdev.com. All rights reserved.
//

import Foundation
import ImageIO

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
    
    class func resizeImage(fileName file: String, maxPixelSize: CGFloat, completionHandler handler: (image: UIImage) -> Void) {
        
        let url = NSBundle.mainBundle().URLForResource(file, withExtension: "png")!
        print(url)
        let src = CGImageSourceCreateWithURL(url, nil)!
        
        let scale = UIScreen.mainScreen().scale
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0)) {
            
            let dict : [NSObject:AnyObject] = [
                kCGImageSourceShouldAllowFloat : true,
                kCGImageSourceCreateThumbnailWithTransform : true,
                kCGImageSourceCreateThumbnailFromImageAlways : true,
                kCGImageSourceThumbnailMaxPixelSize : maxPixelSize
            ]
            
            let imref = CGImageSourceCreateThumbnailAtIndex(src, 0, dict)!
            let im = UIImage(CGImage: imref, scale: scale, orientation: .Up)
            
            dispatch_async(dispatch_get_main_queue()) {
                let startTime = CACurrentMediaTime()
                handler(image: im)
                let elapsedTime = (CACurrentMediaTime() - startTime) * 1000
                print("image time for row",file,"=", elapsedTime ,"ms")
                
            }
        }

    }
}
