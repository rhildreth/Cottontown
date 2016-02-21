import Foundation

import Cocoa



        let path = NSBundle.mainBundle().pathForResource("Stops", ofType: "plist")!
public  let allStops = NSArray(contentsOfFile: path)! as! [[String : AnyObject]]
        

