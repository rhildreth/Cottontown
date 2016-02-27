//
//  StopPageViewController.swift
//  Cottontown
//
//  Created by Ron Hildreth on 12/20/15.
//  Copyright © 2015 Tappdev.com. All rights reserved.
//

import UIKit

class StopPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var stop: Stop?
    
    var pageIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        let firstVC = viewControllerAtIndex(0)
        setViewControllers([firstVC!], direction: .Forward, animated: true, completion: nil)
        requestNotificationAuthorization()
        
       // Notification set in AppDelegate method application(_:didRegisterUserNotificationSettings)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "requestStopPushAuthorization", name: "userNotificationSettingsRegistered", object: nil)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
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
        guard !(NSUserDefaults.standardUserDefaults().boolForKey("hasPromptedForUserNotifications") && UIApplication.sharedApplication().currentUserNotificationSettings()?.types == .None) else {
            print("User prompted for notifications, but declined")
            return}
            
        if let pushTag = stop?.pushTag {
            print("Push tag:",pushTag)
            UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil ))
            
        }
        
        
    }
    
    func requestStopPushAuthorization (){
        print("push stop authorization")
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
