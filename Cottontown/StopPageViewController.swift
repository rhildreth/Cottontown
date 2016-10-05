//
//  StopPageViewController.swift
//  Cottontown
//
//  Created by Ron Hildreth on 12/20/15.
//  Copyright © 2015 Tappdev.com. All rights reserved.
//

import UIKit

class StopPageViewController: UIPageViewController, UIPageViewControllerDataSource, PictureContentViewControllerDelegate {
    
    var stop: Stop?
 
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
        setViewControllers([firstVC!], direction: .forward, animated: false, completion: nil)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func viewControllerAtIndex(_ index: Int) -> UIViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard allStopContent.count > 0 else {
            
            let stopContentVC = storyboard.instantiateViewController(withIdentifier: "stopContentVC") as! PictureContentViewController
                stopContentVC.picText = "No Stop Selected"
                
            return stopContentVC
        }
        
        if let _ = (allStopContent[index])["picImage"]  {
        let stopContentVC = storyboard.instantiateViewController(withIdentifier: "stopContentVC") as! PictureContentViewController
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
            let youTubeContentVC = storyboard.instantiateViewController(withIdentifier: "YouTubeVC") as! YouTubeContentViewController
            
            youTubeContentVC.delegate = self
            youTubeContentVC.maxPages = allStopContent.count
            youTubeContentVC.pageIndex = index
            
            youTubeContentVC.youTubeID = (allStopContent[index])["YouTubeID"]!
            youTubeContentVC.youTubeText = (allStopContent[index])["YouTubeText"]!
            return youTubeContentVC
        }
        
    }
    
// MARK: - UIPageControllerDataSource Methods
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        var pageIndex = getPageIndexForVC(viewController)
        
        pageIndex -= 1
        
        if pageIndex < 0 {
            pageIndex = 0
            return nil
        } else {
            return viewControllerAtIndex(pageIndex)
        }
        
        
    }
    
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
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
    
    func getPageIndexForVC(_ viewController: UIViewController) -> Int {
        if let vc = viewController as? PictureContentViewController {
            return vc.pageIndex
        } else {
            let vc = viewController as! YouTubeContentViewController
            return vc.pageIndex
        }
    }
    
    //MARK: - PictureContentViewControllerDelegate method
    
    func pageControlChanged(_ sender: UIViewController, newPageIndex: Int) {
        
        // direction doesn't matter for scroll page views
        let nextVC = viewControllerAtIndex(newPageIndex)
        setViewControllers([nextVC!], direction: .forward, animated: false, completion: nil)
    }
    
    
}
