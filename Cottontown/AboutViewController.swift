//
//  AboutViewController.swift
//  Cottontown
//
//  Created by Ron Hildreth on 4/6/16.
//  Copyright © 2016 Tappdev.com. All rights reserved.
//

import UIKit
import SafariServices

class AboutViewController: UIViewController, UITextViewDelegate, SFSafariViewControllerDelegate {

    @IBOutlet weak var aboutText: UITextView!
    
    var scrolledToTop = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        aboutText.selectable = false  // fixes apparent bug in IB preventing changing fonts unless selectable box is checked.
        
        aboutText.delegate = self
        aboutText.selectable = true
        aboutText.editable = false
        aboutText.dataDetectorTypes = UIDataDetectorTypes.Link
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.sharedApplication().statusBarHidden = true
        scrolledToTop = false
        
        // Register for notification of font size changes
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HistoryViewController.updateFont), name: UIContentSizeCategoryDidChangeNotification, object: nil)
        
        
        // Move the VoiceOver focus to the text when the About tab is selected
        delay(0.5) {
            UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, self.aboutText)
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        // scroll text to top only once.  For some reason touching a web link calls 
        // viewDidLayoutSubviews
        
        if !scrolledToTop {
            aboutText.setContentOffset(CGPointZero, animated: false)
            scrolledToTop = true
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        UIApplication.sharedApplication().statusBarHidden = false
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    func updateFont () {
        
        let style = aboutText.font?.fontDescriptor().objectForKey(UIFontDescriptorTextStyleAttribute) as! String
        aboutText.font = UIFont.preferredFontForTextStyle(style)
        
    }
    
    
    
    // MARK: - UITextViewDelegate Method
    
    func textView(textView: UITextView, shouldInteractWithURL URL: NSURL, inRange characterRange: NSRange) -> Bool {
        
        let safariVC = SFSafariViewController(URL: URL)
        safariVC.delegate = self
        presentViewController(safariVC, animated: true, completion: nil)
        
        return false
    }

}
