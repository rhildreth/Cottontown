//
//  HistoryViewController.swift
//  Cottontown
//
//  Created by Ron Hildreth on 4/2/16.
//  Copyright © 2016 Tappdev.com. All rights reserved.
//

import UIKit

func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}

class HistoryViewController: UIViewController {
    
    let historyTitle = UILabel.init(frame: CGRectMake(0.0, 0.0,98.0 , 24.0))

    @IBOutlet weak var historyImage: UIImageView!
    
    @IBOutlet weak var historyText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        historyTitle.backgroundColor = UIColor.clearColor()
        historyTitle.font = UIFont.systemFontOfSize(20.0)
        
        historyTitle.textAlignment = .Center
        
        historyTitle.textColor = UIColor.whiteColor()
        historyTitle.text = "History of Cottontown"
        historyTitle.sizeToFit()
        navigationItem.titleView = historyTitle
        historyTitle.isAccessibilityElement = true
        
        historyText.selectable = false  // fixes apparent bug in IB preventing changing fonts unless selectable box is checked.
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Register for notification of font size changes
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HistoryViewController.updateFont), name: UIContentSizeCategoryDidChangeNotification, object: nil)
        
        delay(0.5) {
            UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, self.historyTitle)
        }
        
        
    }
    
    override func viewWillLayoutSubviews() {
        
    }
    
    override func viewDidLayoutSubviews() {
        
        
        
        // scroll text to top
        historyText.setContentOffset(CGPointZero, animated: false)
        
        let maxWidth = historyImage.frame.width
        StopsModel.resizeImage(fileName: "historya", type: "jpg", maxPointSize: maxWidth) { (image) in
            self.historyImage.image = image
        }
    }
    
    func updateFont () {
        
        let style = historyText.font?.fontDescriptor().objectForKey(UIFontDescriptorTextStyleAttribute) as! String
        historyText.font = UIFont.preferredFontForTextStyle(style)
        
    }

    @IBAction func imageTapped(sender: UITapGestureRecognizer) {
        
        let historyImageVC = storyboard?.instantiateViewControllerWithIdentifier("contentImageID") as! ContentImage
            historyImageVC.contentImageName = "historya"
        navigationController?.pushViewController(historyImageVC, animated: false)
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }



}
