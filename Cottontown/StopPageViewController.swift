//
//  StopPageViewController.swift
//  Cottontown
//
//  Created by Ron Hildreth on 12/20/15.
//  Copyright © 2015 Tappdev.com. All rights reserved.
//

import UIKit

class StopPageViewController: UIPageViewController, UIPageViewControllerDataSource, didRegisterUserNotificationSettingsDelegate, PictureContentViewControllerDelegate {
    
    var stop: Stop?
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
 
    var allStopContent = [[String: String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        
        if let stop = stop {
            allStopContent = stop.stopPictures + (stop.youTubes ?? [])  // ?? is nil coalescing
            // operator - If stop.youTubes is not nil it is unwrapped, otherwise the empty array is
            // returned
        }
        let firstVC = viewControllerAtIndex(0)
        setViewControllers([firstVC!], direction: .Forward, animated: false, completion: nil)
        
        
        requestNotificationAuthorization()
        
        // ** test notifications
       // Notification set in AppDelegate method application(_:didRegisterUserNotificationSettings)
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "requestStopPushAuthorization", name: "userNotificationSettingsRegistered", object: nil)
        
        
        appDelegate.registeredDelegate = self
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
    }
    
    override func viewDidLayoutSubviews() {
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//** test notifications
//    deinit {
//        NSNotificationCenter.defaultCenter().removeObserver(self)
//    }
    
    func viewControllerAtIndex(index: Int) -> UIViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard allStopContent.count > 0 else {
            
            let stopContentVC = storyboard.instantiateViewControllerWithIdentifier("stopContentVC") as! PictureContentViewController
                stopContentVC.picText = "No Stop Selected"
                
            return stopContentVC
        }
        
        if let _ = (allStopContent[index])["picImage"]  {
        let stopContentVC = storyboard.instantiateViewControllerWithIdentifier("stopContentVC") as! PictureContentViewController
        if let _ = stop {
            
            stopContentVC.delegate = self
            stopContentVC.picImageFileName = (allStopContent[index])["picImage"]!
            stopContentVC.picText = (allStopContent[index])["picText"]!
            stopContentVC.maxPages = allStopContent.count
            
            
        } else {
            stopContentVC.picText = "No Stop Selected"
        }
        stopContentVC.pageIndex = index
        return stopContentVC
        }else {
            let youTubeContentVC = storyboard.instantiateViewControllerWithIdentifier("YouTubeVC") as! YouTubeContentViewController
            
            youTubeContentVC.delegate = self
            youTubeContentVC.maxPages = allStopContent.count
            youTubeContentVC.pageIndex = index
            
            youTubeContentVC.youTubeID = (allStopContent[index])["YouTubeID"]!
            youTubeContentVC.youTubeText = (allStopContent[index])["YouTubeText"]!
            return youTubeContentVC
        }
        
    }
    
    func requestNotificationAuthorization() {
        
        guard let pushTag = stop?.pushTag else {return}  // return if no push tag for this stop
        guard !(NSUserDefaults.standardUserDefaults().boolForKey("hasPromptedForUserNotifications") && UIApplication.sharedApplication().currentUserNotificationSettings()?.types == .None) else {
            
            return}
            
        if !NSUserDefaults.standardUserDefaults().boolForKey("hasPromptedForUserNotifications") {
            
            UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil ))
            
        } else if !NSUserDefaults.standardUserDefaults().boolForKey(pushTag + "PushRequested") {
            handleDidRegisterUserNotificationSettings()
        } 
      
    }

    func handleDidRegisterUserNotificationSettings() {
        
        
        // Make sure user didn't decline notifications
        guard !(NSUserDefaults.standardUserDefaults().boolForKey("hasPromptedForUserNotifications") && UIApplication.sharedApplication().currentUserNotificationSettings()!.types == .None) else {
            
            return}
        
        // Make sure the stop supports push notifications
        guard let pushTag = stop?.pushTag else {
            
            return
        }
        
        // Make sure the user is asked only once if push notifications for this location are desired
        guard !NSUserDefaults.standardUserDefaults().boolForKey(pushTag + "PushRequested") else {
            
            return
        }
        
        // Set flag that the user has been asked to allow push messages
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: pushTag + "PushRequested")
        
        
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
        
        var pageIndex = getPageIndexForVC(viewController)
        
        pageIndex -= 1
        
        if pageIndex < 0 {
            pageIndex = 0
            return nil
        } else {
            return viewControllerAtIndex(pageIndex)
        }
        
        
    }
    
    
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        guard let _ = stop else {return nil}
        
        var pageIndex = getPageIndexForVC(viewController)
        
            pageIndex += 1
        
            if pageIndex > (allStopContent.count) - 1  {
                pageIndex = (allStopContent.count) - 1
                return nil
            } else {
                return viewControllerAtIndex(pageIndex)
            }
            
            }
    
    func getPageIndexForVC(viewController: UIViewController) -> Int {
        if let vc = viewController as? PictureContentViewController {
            return vc.pageIndex
        } else {
            let vc = viewController as! YouTubeContentViewController
            return vc.pageIndex
        }
    }
    
    //MARK: - PictureContentViewControllerDelegate method
    
    func pageControlChanged(sender: UIViewController, newPageIndex: Int) {
        
        // direction doesn't matter for scroll page views
        let nextVC = viewControllerAtIndex(newPageIndex)
        setViewControllers([nextVC!], direction: .Forward, animated: false, completion: nil)
    }
    
    
}
