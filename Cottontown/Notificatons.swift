//
//  Notificatons.swift
//  Cottontown
//
//  Created by Ron Hildreth on 1/16/16.
//  Copyright © 2016 Tappdev.com. All rights reserved.
//

import Foundation
import UIKit

class Notifications {
    
    class func display(text: String) {
        
        let notification: UILocalNotification = UILocalNotification()
        
        notification.timeZone = NSTimeZone.defaultTimeZone()
        
//        let dateTime = NSDate()
//        notification.fireDate = dateTime
        notification.alertBody = text
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.userInfo = ["text": text]
        notification.category = "iBeaconCategory"
        
        
        UIApplication.sharedApplication().presentLocalNotificationNow(notification)
    
    }
}
