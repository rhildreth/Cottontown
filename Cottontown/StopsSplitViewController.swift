//
//  StopsSplitViewController.swift
//  Cottontown
//
//  Created by Ron Hildreth on 1/15/16.
//  Copyright © 2016 Tappdev.com. All rights reserved.
//

import UIKit

class StopsSplitViewController: UISplitViewController, UISplitViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
        self.preferredDisplayMode = .AllVisible
        
        // Set the left bar button in the detail view controller
        let navigationController = self.viewControllers[self.viewControllers.count-1] as! UINavigationController
        navigationController.topViewController!.navigationItem.leftBarButtonItem = self.displayModeButtonItem()
    }
    
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController:UIViewController, ontoPrimaryViewController primaryViewController:UIViewController) -> Bool {
        guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
        guard let topAsDetailController = secondaryAsNavController.topViewController as? StopPageViewController else { return false }
        if topAsDetailController.stop == nil {
            // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
            return true
        }
        return true      // Apple default is false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
