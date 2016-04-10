//
//  StopsTableViewController.swift
//  Cottontown
//
//  Created by Ron Hildreth on 12/12/15.
//  Copyright © 2015 Tappdev.com. All rights reserved.
//


// This is the initial Stops Table view shown to the user when the app loads.

import UIKit


class StopsTableViewController: UITableViewController, UIViewControllerPreviewingDelegate {
    
    let allStops = StopsModel.sharedInstance.allStops
 
    var suffix = ""
    let scale = UIScreen.mainScreen().scale
    var forceTouchSupported = false
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if traitCollection.forceTouchCapability == .Available {
            forceTouchSupported = true
            registerForPreviewingWithDelegate(self, sourceView: tableView)
        }
        
        tableView.estimatedRowHeight = 95
        tableView.rowHeight = UITableViewAutomaticDimension
        
        switch scale {
        case 1.0:
            suffix = "_tn"  // Only used on iPad 2
        case 2.0:
            suffix = "_tn@2x"
        default:
            suffix = "_tn@3x"
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        
    }
    
    override func viewDidLayoutSubviews() {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            guard let indexPath = self.tableView.indexPathForSelectedRow else {return}
            let pageController = (segue.destinationViewController as! UINavigationController).topViewController as! StopPageViewController
                
            pageController.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                pageController.navigationItem.leftItemsSupplementBackButton = true
                pageController.stop = allStops[indexPath.row]
            
        }
    }
    
    
    // called only to show stop for in range iBeacon.  Not implemented of release version 
    // of app.
    func showDetailViewForStopNumber(stopNumber: Int) {
        
        let indexPath = NSIndexPath(forRow: stopNumber - 1, inSection: 0)
        tableView.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: .Middle)
        performSegueWithIdentifier("showDetail", sender: self)
        
    }
    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allStops.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StopCell", forIndexPath: indexPath) as! StopCell
        
        cell.layoutIfNeeded()
        cell.stopCellImage.image = nil
        
        let stop: Stop = allStops[indexPath.row]
        let stopFileName = (stop.stopPictures[0])["picImage"]!
        
        let imageWidth = cell.stopCellImage.bounds.width
        
        // Called to decompress image in the background prior 
        // to assigning to cell to improve scroll performance
        StopsModel.resizeImage(fileName: stopFileName + suffix, type: "png", maxPointSize: imageWidth) { (image) -> Void in
            guard let _ = tableView.cellForRowAtIndexPath(indexPath) else {
                print("found nil myCell:")
                return
            }
            cell.stopCellImage.image = image
            
        }
        
        cell.stopTitle.text = stop.stopTitle
        cell.stopAddress.text = stop.stopAddress
        cell.stopTitle.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        cell.stopTitle.numberOfLines = 0
        cell.stopAddress.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        cell.stopAddress.numberOfLines = 0
        
        return cell
    }
    
    @IBAction func longPressDetected(sender: UILongPressGestureRecognizer) {
        
        guard sender.state == UIGestureRecognizerState.Began else {return}
        
        let touchPoint = sender.locationInView(tableView)
        let indexPath = tableView.indexPathForRowAtPoint(touchPoint)
        
        let stop = allStops[indexPath!.row]
        
        showMapForStop(stop)
        
    }
    
    func showMapForStop(stop: Stop) {
        let mapSplitVC = self.tabBarController!.viewControllers![1] as! MapSplitViewController
        let mapVCNavigationController = mapSplitVC.viewControllers[0] as! UINavigationController
        let mapVC = mapVCNavigationController.viewControllers[0] as! MapViewController
        
        mapVC.showStop = stop
        
        // If the map detail is being displayed, remove it so the user will see the map view
        if mapVCNavigationController.viewControllers.count > 1 {
            mapVCNavigationController.popViewControllerAnimated(false)
        }
        
        
        
        mapSplitVC.preferredDisplayMode = UISplitViewControllerDisplayMode.AllVisible
        tabBarController?.selectedIndex = 1
        
    }


    override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
        
    }
    override func transitionFromViewController(fromViewController: UIViewController, toViewController: UIViewController, duration: NSTimeInterval, options: UIViewAnimationOptions, animations: (() -> Void)?, completion: ((Bool) -> Void)?) {
         
    }

    //MARK: - UIViewcontrollerPreviewingDelegate methods
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
       
        guard let indexPath = tableView.indexPathForRowAtPoint(location) else {return nil}
        
        //This will show the cell clearly and blur the rest of the screen for our peek.
        previewingContext.sourceRect = tableView.rectForRowAtIndexPath(indexPath)
        
        let stop = allStops[indexPath.row]
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let mapVC = storyBoard.instantiateViewControllerWithIdentifier("MapVCID") as! MapViewController
        
        
        mapVC.showStop = stop
        
        return mapVC 
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        
        let stop = (viewControllerToCommit as! MapViewController).showStop!
        
        showMapForStop(stop)
    }
    
    
}

