//
//  MapPageViewController.swift
//  Cottontown
//
//  Created by Ron Hildreth on 12/28/15.
//  Copyright © 2015 Tappdev.com. All rights reserved.
//

import UIKit

class MapPageViewController: UIPageViewController, UIPageViewControllerDataSource {

    var stop: Stop?
    
    
    var pageIndex = 0
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.extendedLayoutIncludesOpaqueBars = false
        self.edgesForExtendedLayout = .None
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        let firstVC = viewControllerAtIndex(0)
        setViewControllers([firstVC!], direction: .Forward, animated: true, completion: nil)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewControllerAtIndex(index: Int) -> StopContentViewController? {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let stopContentVC = storyboard.instantiateViewControllerWithIdentifier("stopContentVC") as! StopContentViewController
        
        if let stop = stop {
            
            
            stopContentVC.picImageFileName = (stop.stopPictures[index])["picImage"]!
            stopContentVC.picText = (stop.stopPictures[index])["picText"]!
            stopContentVC.maxPages = stop.stopPictures.count
            
            
        } else {
            stopContentVC.picText = "No Stop Selected  abc"
        }
        stopContentVC.pageIndex = self.pageIndex
        return stopContentVC
        
    }
    
    //MARK: - UIPageViewControllerDataSource
    
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
