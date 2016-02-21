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

        cell.configureCellForStop(allStops[indexPath.row])
        
        return cell
    }
    

    override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
        
    }
    override func transitionFromViewController(fromViewController: UIViewController, toViewController: UIViewController, duration: NSTimeInterval, options: UIViewAnimationOptions, animations: (() -> Void)?, completion: ((Bool) -> Void)?) {
         
    }
}

