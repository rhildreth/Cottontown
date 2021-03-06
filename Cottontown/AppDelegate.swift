//
//  AppDelegate.swift
//  Cottontown
//
//  Created by Ron Hildreth on 12/12/15.
//  Copyright © 2015 Tappdev.com. All rights reserved.
//


import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?
    var tabBarController: CottontownTabBarController!
    var stopsTVC: StopsTableViewController!
    

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
                        
        UISetup()
        
        return true
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
 
    
    func UISetup () {
        tabBarController = self.window!.rootViewController as! CottontownTabBarController
        let stopsSplitVC = tabBarController.viewControllers?.first as! StopsSplitViewController
        let stopsNavVC = stopsSplitVC.viewControllers.first as! UINavigationController
        stopsTVC = stopsNavVC.topViewController as! StopsTableViewController
        
        UINavigationBar.appearance().barTintColor = UIColor(red: 242.0/255.0, green:
            169.0/255.0, blue: 40.0/255.0, alpha: 1.0)
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
        pageControl.hidesForSinglePage = true
        
    }
    
}

