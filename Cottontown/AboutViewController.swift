//
//  AboutViewController.swift
//  Cottontown
//
//  Created by Ron Hildreth on 4/6/16.
//  Copyright © 2016 Tappdev.com. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet weak var aboutText: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.sharedApplication().statusBarHidden = true
        
        
        // Register for notification of font size changes
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HistoryViewController.updateFont), name: UIContentSizeCategoryDidChangeNotification, object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        // scroll text to top
        aboutText.setContentOffset(CGPointZero, animated: false)
    }
    
    override func viewWillDisappear(animated: Bool) {
        UIApplication.sharedApplication().statusBarHidden = false

    }

    func updateFont () {
        
        let style = aboutText.font?.fontDescriptor().objectForKey(UIFontDescriptorTextStyleAttribute) as! String
        aboutText.font = UIFont.preferredFontForTextStyle(style)
        
    }

}
