//
//  MapPageViewController.swift
//  Cottontown
//
//  Created by Ron Hildreth on 12/28/15.
//  Copyright © 2015 Tappdev.com. All rights reserved.
//

import UIKit

class MapPageViewController: UIPageViewController, UIPageViewControllerDataSource, PictureContentViewControllerDelegate {

    var stop: Stop?
        
    var pageIndex = 0
    
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
        setViewControllers([firstVC!], direction: .Forward, animated: true, completion: nil)
        

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
       
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewControllerAtIndex(index: Int) -> UIViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // In a split view with both the master and detail view showing (Regular width class)
        // it is possible that a detail view has not been selected - a map pin in this case
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
    
    //MARK: - UIPageViewControllerDataSource
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        let stopContentVC = viewController as! PictureContentViewController
        pageIndex = stopContentVC.pageIndex - 1
        
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
