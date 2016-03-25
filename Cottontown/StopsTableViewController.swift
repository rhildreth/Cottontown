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
    let scale = UIScreen.mainScreen().scale
 
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        self.navigationItem.leftBarButtonItem = self.editButtonItem()

//        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
//        self.navigationItem.rightBarButtonItem = addButton
//        if let split = self.splitViewController {
//            let controllers = split.viewControllers
//            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
//        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        
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
        
//        let maxPixelWidth = cell.stopCellImage.bounds.width * scale
        
        let stop: Stop = allStops[indexPath.row]
        let stopFileName = (stop.stopPictures[0])["picImage"]!
        StopsModel.resizeImage(fileName: stopFileName + "_tn@2x", maxSize: 264.0) { (image) -> Void in
            guard let _ = tableView.cellForRowAtIndexPath(indexPath) else {
                print("found nil myCell:")
                return
            }
            cell.stopCellImage.image = image
            
        }
        
//        let startTime = CACurrentMediaTime()
//        let url = NSBundle.mainBundle().URLForResource(stopFileName + "_tn", withExtension: "png")!
//        cell.stopCellImage.hnk_setImageFromURL(url)
        
        
//        let startTime = CACurrentMediaTime()
//        
//        let bundlePath = NSBundle.mainBundle().pathForResource(stopFileName + "_tn", ofType: "png")
//        
//        cell.stopCellImage.image = UIImage(contentsOfFile: bundlePath!)
        
//        let elapsedTime = (CACurrentMediaTime() - startTime) * 1000
//        print("image time for row",indexPath.row,"=", elapsedTime ,"ms")
        
        cell.stopTitle.text = stop.stopTitle
        cell.stopAddress.text = stop.stopAddress
        cell.stopTitle.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        cell.stopTitle.numberOfLines = 0
        cell.stopAddress.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        cell.stopAddress.numberOfLines = 0
        
        return cell
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    
    override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
        
    }
    override func transitionFromViewController(fromViewController: UIViewController, toViewController: UIViewController, duration: NSTimeInterval, options: UIViewAnimationOptions, animations: (() -> Void)?, completion: ((Bool) -> Void)?) {
         
    }
}

