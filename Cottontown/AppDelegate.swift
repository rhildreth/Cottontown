//
//  AppDelegate.swift
//  Cottontown
//
//  Created by Ron Hildreth on 12/12/15.
//  Copyright © 2015 Tappdev.com. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate, CLLocationManagerDelegate {

    var window: UIWindow?
    var tabBarController: CottontownTabBarController!
    var stopsTVC: StopsTableViewController!
    
    let locationManager = CLLocationManager()
    let cottontownRegion = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!, identifier: "cottontownBeaconRegion")
    
    var iBeaconStop: Int?
    var iBeaconSeenCount = 0
    var iBeaconMaxSeenCount = 3
    var iBeaconStopValid = false
    var userNotified = false
    var userNotifiedTime: NSDate?
    
    var iBeaconAlertGenerated = false
    var goToStopForiBeaconRegion = false
    
    struct actionIdentier {
        static let goToLocation = "GoToLocation"
        static let ignoreiBeacons = "IgnoreiBeacons"
    }
    
    let defaults = NSUserDefaults.standardUserDefaults()
    let initialDefaults = ["goToStopForiBeaconRegion":false, "enableiBeacons":true]
    

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        tabBarController = self.window!.rootViewController as! CottontownTabBarController
        let stopsSplitVC = tabBarController.viewControllers?.first as! StopsSplitViewController
        let stopsNavVC = stopsSplitVC.viewControllers.first as! UINavigationController
        stopsTVC = stopsNavVC.topViewController as! StopsTableViewController
        
        UINavigationBar.appearance().barTintColor = UIColor(red: 244.0/255.0, green:
            190.0/255.0, blue: 64.0/255.0, alpha: 1.0)
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        
        if let barFont = UIFont(name: "Avenir-Light", size: 24.0) {
            UINavigationBar.appearance().titleTextAttributes =
            [NSForegroundColorAttributeName:UIColor.whiteColor(),
            NSFontAttributeName:barFont]
        }
        
        let pageControl = UIPageControl.appearance()
        pageControl.pageIndicatorTintColor = UIColor.lightGrayColor()
        pageControl.currentPageIndicatorTintColor = UIColor.blackColor()
        pageControl.backgroundColor = UIColor.whiteColor()
        
        
        /*
        notifyEntryStateOnDisplay - App will be launched and the delegate will be notified via
                  locationManager:didDetermineState:forRegion:
        each time the device's screen is turned on (by either the home or shoulder button)and the user is in the region.
        */
        cottontownRegion.notifyEntryStateOnDisplay = true
        
        locationManager.delegate = self
        
        /*
        This requests user's permission to send notifications when app
        is in background or closed.  Triggers method -
               locationManager:didChangeAuthorizationStatus
        */
        locationManager.requestAlwaysAuthorization()
        
        //Setup custom actions for notifications which show when you swipe left
        //   on a notificaion
        
        //Go to Stop indicated by the nearest iBeacon
        let actionGoToLocation = UIMutableUserNotificationAction()
        actionGoToLocation.identifier = actionIdentier.goToLocation
        actionGoToLocation.title = "Go To iBeacon Location"
        actionGoToLocation.activationMode = UIUserNotificationActivationMode.Foreground
        actionGoToLocation.destructive = false
        actionGoToLocation.authenticationRequired = false
        
        //Ignore the iBeacon notification
        let actionIgnoreBeacon = UIMutableUserNotificationAction()
        actionIgnoreBeacon.identifier = actionIdentier.ignoreiBeacons
        actionIgnoreBeacon.title = "Ignore iBeacons"
        actionIgnoreBeacon.activationMode = UIUserNotificationActivationMode.Background
        actionIgnoreBeacon.destructive = false
        actionIgnoreBeacon.authenticationRequired = false
        
        let iBeaconCategory = UIMutableUserNotificationCategory()
        iBeaconCategory.identifier = "iBeaconCategory"
        iBeaconCategory.setActions([actionGoToLocation, actionIgnoreBeacon], forContext: UIUserNotificationActionContext.Default)
        iBeaconCategory.setActions([actionGoToLocation, actionIgnoreBeacon], forContext: UIUserNotificationActionContext.Minimal)
        

        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: [iBeaconCategory]))
        
        /*
        The Settings app is used to persist goToStopForiBeaconRegion and enableiBeacons.  It is 
        important to note that the defaults specified in Root.plist are only for the toggle buttons
        displayed to the user by the Settings app.
        */
        defaults.registerDefaults(initialDefaults)
        let testSettings = defaults.boolForKey("enableiBeacons")
        print(testSettings)
        
        return true
    }
    
   
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        
    }
    
    /*
    Point for handling a local notification when the app is in the foreground
       Notifications are not displayed when the app is in the foreground
       Generate an alert to simulate the notification
    */
//FIXME: This method should not be called - but it is??
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        print("didReceiveLocalNotification:  app is open and notification occurred")
        print("** notification: ", notification.alertBody)
        
    }
    
    /*
    The following method runs when the user chooses a custom action
       on the local notifiction. The app is initially in the background
       when this happens.  If the notification specifies .Background, the
       app is given 10 sec. to execute, and this method is called.  If the
       notification specifies .Foreground, the app is opened and this method is called.
    */
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, withResponseInfo responseInfo: [NSObject : AnyObject], completionHandler: () -> Void) {
        print(identifier)
        if let identifier = identifier {
            switch identifier {
            case actionIdentier.goToLocation :
                defaults.setBool(true, forKey: "goToStopForiBeaconRegion")
            case actionIdentier.ignoreiBeacons:
                locationManager.stopMonitoringForRegion(cottontownRegion)
                locationManager.stopRangingBeaconsInRegion(cottontownRegion)
                defaults.setBool(false, forKey: "enableiBeacons")
            default:
                print("Invalid identifier")
                break
            }
        }

        completionHandler()
    }
    
    
    /*
    The following fixes an autolayout conflict error.  See http://stackoverflow.com/questions/33112762/in-call-status-bar-unable-to-satisfy-constraints
    */
    func application(application: UIApplication, willChangeStatusBarFrame newStatusBarFrame: CGRect) {
        for window in UIApplication.sharedApplication().windows {
            if window.dynamicType.self.description().containsString("UITextEffectsWindow") {
                window.removeConstraints(window.constraints)
            }
        }
    }
    
     //MARK: - CLLocationManagerDelegate protocols

    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .AuthorizedAlways:
            locationManager.startMonitoringForRegion(cottontownRegion)
            locationManager.startRangingBeaconsInRegion(cottontownRegion)
            locationManager.requestStateForRegion(cottontownRegion) // triggers locationManager:didDetermineState:forRegion:
        case .Denied:
            locationManager.stopMonitoringForRegion(cottontownRegion)
            locationManager.stopRangingBeaconsInRegion(cottontownRegion)
            print("beacon auth denied")
        default:
            print("CLAuthorizationStatus not AuthorizedAlways or Denied")
        }
        
    }
    
    /*
    Called by iOS even when app is not running or in background
       Also triggered asynchronously by locationManager:didDetermineState:forRegion:
    */
    func locationManager(manager: CLLocationManager, didDetermineState state: CLRegionState, forRegion region: CLRegion) {
        
        switch state {
            
        case .Unknown:
            print("unknown region")
            
        case .Inside:
            
            Notifications.display("Cottontown iBeacons detetected")
            print("inside:", region.identifier)
            
        case .Outside:  // No need to notify the user when this happens
            
//            Notifications.display("User outside region")
            print("outside region")
            
        }
    }
/*
    Called each scan for beacons in region (approx. 1/sec)
       only when app is in foreground and for about 10 sec when
       activation mode for notification is .Background
       One issue noted is that the CLBeacons returned from this method have values
       that vary widely, even when the iBeacon is not moving.  For example, I've noted
       the proximity value will seem to randomly change to .Unknown.  Consequently, I've 
       filtered the results to make them more consistent.  (Changing beacon type from Estimote
       to Apple iBeacon type significantly improved this problem. Apple advertising interval
       is fixed at 100ms.  Estimote type is adjustable with default of 950ms.)
*/
    func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
//        print(beacons)
        
        // We only want to notify for proximity values .Near and .Immediate
        let closeBeacons = beacons.filter{ $0.proximity != .Unknown && $0.proximity != .Far }
        if closeBeacons.count > 0 {
            let nearestBeacon = closeBeacons.first  // gets the closest iBeacon
         
            switch (nearestBeacon!.major, nearestBeacon!.minor) {
            case (572,1):     // Stop 5

                if filteriBeaconForStop(5){
                    if goToStopForiBeaconRegion {
                    tabBarController.selectedIndex = 0  // Make sure Stops tab is selected
                    stopsTVC.showDetailViewForStopNumber(5)
                    print("Vino Beacon active")

                    }
                                        
                    iBeaconAlertForStop(5)
                }
                
            case (572,2):     // Stop 7
                
                if filteriBeaconForStop(7) {
                    tabBarController.selectedIndex = 0  // Make sure Stops tab is selected
                    stopsTVC.showDetailViewForStopNumber(7)
                    print("Warmouth Beacon active")
                    
                    iBeaconAlertForStop(7)
                }
                
            default:
//                print("Unknown Beacon")
                
               filteriBeaconForStop(nil)
                
            }
            
//            print("Nearest iBeacon", nearestBeacon)
        } else {
//            print("No close iBeacon")
            filteriBeaconForStop(nil)
        }
        
        
    }

    //MARK: - 
    
    func filteriBeaconForStop(stop: Int?) -> Bool {
        
        guard UIApplication.sharedApplication().applicationState == .Active else {return false}
        
        if let stop = stop {
            if iBeaconSeenCount == 0 {
                iBeaconStop = stop
                
            }
            
            if iBeaconStop == stop {
                
                if iBeaconSeenCount < iBeaconMaxSeenCount  {
                    iBeaconSeenCount += 1
                    if iBeaconSeenCount == iBeaconMaxSeenCount && !iBeaconStopValid {
                        iBeaconStopValid = true
                        print("+++Stop", stop, "now valid")
                        return true
                    }
                }
                return false
            }
            
        }
        
        if iBeaconStopValid {
            iBeaconSeenCount -= 1
            if iBeaconSeenCount == 0  {
                iBeaconStopValid = false
                print("a++Stop", iBeaconStop, "no longer valid")
            }
        }
        return false
    }
    
    func iBeaconAlertForStop(stop: Int) {
        guard !iBeaconAlertGenerated else { return }  // Only generate this alert once
        iBeaconAlertGenerated = true
        
        let alertController = UIAlertController(title: "iBeacon Detected", message: "How do you want to handle iBeacon notifications?", preferredStyle: .Alert)
        let goToStopAction = UIAlertAction(title: "Always go to the iBeacon stop location", style: .Default, handler: { alert in
            
            self.goToStopForiBeaconRegion = true
            self.tabBarController.selectedIndex = 0  // Make sure Stops tab is selected
            self.stopsTVC.showDetailViewForStopNumber(stop)
            print(stop, "Beacon active")
            
        })
        let canceliBeacons = UIAlertAction(title: "Stop using iBeacons", style: .Default , handler: {(alert) in
            print(alert)
            self.locationManager.stopMonitoringForRegion(self.cottontownRegion)
            self.locationManager.stopRangingBeaconsInRegion(self.cottontownRegion)
            
        })
        
        alertController.addAction(goToStopAction)
        alertController.addAction(canceliBeacons)
        
        dispatch_async(dispatch_get_main_queue(), {
            
            self.window?.rootViewController?.presentViewController(alertController, animated: true, completion: nil)
        })
    }
    
}
