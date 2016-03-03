//
//  StopPageViewController.swift
//  Cottontown
//
//  Created by Ron Hildreth on 12/20/15.
//  Copyright © 2015 Tappdev.com. All rights reserved.
//

import UIKit

class StopPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, didRegisterUserNotificationSettingsDelegate {
    
    var stop: Stop?
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var pageIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        let firstVC = viewControllerAtIndex(0)
        setViewControllers([firstVC!], direction: .Forward, animated: true, completion: nil)
        requestNotificationAuthorization()
        
        // ** test notifications
       // Notification set in AppDelegate method application(_:didRegisterUserNotificationSettings)
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "requestStopPushAuthorization", name: "userNotificationSettingsRegistered", object: nil)
        
        
        appDelegate.registeredDelegate = self
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//** test notifications
//    deinit {
//        NSNotificationCenter.defaultCenter().removeObserver(self)
//    }
    
    func viewControllerAtIndex(index: Int) -> StopContentViewController? {
        let stopContentVC = storyboard?.instantiateViewControllerWithIdentifier("stopContentVC") as! StopContentViewController
        if let stop = stop {
            
            
            stopContentVC.picImageFileName = (stop.stopPictures[index])["picImage"]!
            stopContentVC.picText = (stop.stopPictures[index])["picText"]!
            stopContentVC.maxPages = stop.stopPictures.count
            
            
        } else {
            stopContentVC.picText = "No Stop Selected"
        }
        stopContentVC.pageIndex = self.pageIndex
        return stopContentVC
        
    }
    
    func requestNotificationAuthorization() {
        
        guard let pushTag = stop?.pushTag else {return}  // return if no push tag for this stop
        guard !(NSUserDefaults.standardUserDefaults().boolForKey("hasPromptedForUserNotifications") && UIApplication.sharedApplication().currentUserNotificationSettings()?.types == .None) else {
            print("User prompted for notifications, but declined")
            return}
            
        if !NSUserDefaults.standardUserDefaults().boolForKey("hasPromptedForUserNotifications") {
            print("Request Notification Auth for Push ")
            UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil ))
            
        } else if !NSUserDefaults.standardUserDefaults().boolForKey(pushTag + "PushRequested") {
            handleDidRegisterUserNotificationSettings()
        } 
      
    }

    func handleDidRegisterUserNotificationSettings() {
        print("handle push stop authorization")
        
        // Make sure user didn't decline notifications
        guard !(NSUserDefaults.standardUserDefaults().boolForKey("hasPromptedForUserNotifications") && UIApplication.sharedApplication().currentUserNotificationSettings()!.types == .None) else {
            print("User prompted for notifications, but declined")
            return}
        
        // Make sure the stop supports push notifications
        guard let pushTag = stop?.pushTag else {
            print("stop doesn't support push notifications")
            return
        }
        
        // Make sure the user is asked only once if push notifications for this location are desired
        guard !NSUserDefaults.standardUserDefaults().boolForKey(pushTag + "PushRequested") else {
            print("already asked for push permission for this stop")
            return
        }
        
        // Set flag that the user has been asked to allow push messages
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: pushTag + "PushRequested")
        print("user default true set for key",pushTag + "PushRequested")
        
        let message = "Would you like to get Push messages from the " + stop!.stopTitle
        let alert = UIAlertController(title: "Push Notifications", message: message, preferredStyle: .Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .Default , handler: { _ in
            self.appDelegate.setTag(pushTag + "PushEnabled", value: "true")
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: pushTag + "PushEnabled")
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .Cancel, handler: { _ in
            self.appDelegate.setTag(pushTag + "PushEnabled", value: "false")
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: pushTag + "PushEnabled")
        }))
        
        presentViewController(alert, animated: true, completion: nil)
        
    }
    
    
    // MARK: - UIPageControllerDataSource Methods
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        
        let stopContentVC = viewController as! StopContentViewController
        pageIndex = stopContentVC.pageIndex - 1
        
        if pageIndex < 0 {
            pageIndex = 0
            return nil
        } else {
            return viewControllerAtIndex(pageIndex)
        }
        
        
    }
    
    
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        guard let stop = stop else {return nil}
        
        let stopContentVC = viewController as! StopContentViewController
        pageIndex = stopContentVC.pageIndex + 1
        
        if pageIndex > (stop.stopPictures.count) - 1 {
            pageIndex = (stop.stopPictures.count) - 1
            return nil
        } else {
            return viewControllerAtIndex(pageIndex)

        }        
    }
    
    
}
