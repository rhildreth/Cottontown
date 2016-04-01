//
//  StopsTableViewController.swift
//  Cottontown
//
//  Created by Ron Hildreth on 12/12/15.
//  Copyright © 2015 Tappdev.com. All rights reserved.
//


// This is the initial Stops Table view shown to the user when the app loads.

import UIKit


class StopsTableViewController: UITableViewController {
    
    let allStops = StopsModel.sharedInstance.allStops
 
    var suffix = ""
    let scale = UIScreen.mainScreen().scale
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        tableView.estimatedRowHeight = 95
//        tableView.rowHeight = UITableViewAutomaticDimension
        
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
    

    override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
        
    }
    override func transitionFromViewController(fromViewController: UIViewController, toViewController: UIViewController, duration: NSTimeInterval, options: UIViewAnimationOptions, animations: (() -> Void)?, completion: ((Bool) -> Void)?) {
         
    }
}

