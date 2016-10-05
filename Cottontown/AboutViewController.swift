//
//  AboutViewController.swift
//  Cottontown
//
//  Created by Ron Hildreth on 4/6/16.
//  Copyright © 2016 Tappdev.com. All rights reserved.
//
// Start conversion to Swift 3

import UIKit
import SafariServices

class AboutViewController: UIViewController, UITextViewDelegate, SFSafariViewControllerDelegate {

    @IBOutlet weak var aboutText: UITextView!
    
    var scrolledToTop = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        aboutText.isSelectable = false  // fixes apparent bug in IB preventing changing fonts unless selectable box is checked.
        
        aboutText.delegate = self
        aboutText.isSelectable = true
        aboutText.isEditable = false
        aboutText.dataDetectorTypes = UIDataDetectorTypes.link
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.shared.isStatusBarHidden = true
        scrolledToTop = false
        
        // Register for notification of font size changes
        NotificationCenter.default.addObserver(self, selector: #selector(HistoryViewController.updateFont), name: NSNotification.Name.UIContentSizeCategoryDidChange, object: nil)
        
        
        // Move the VoiceOver focus to the text when the About tab is selected
        delay(0.5) {
            UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, self.aboutText)
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        // scroll text to top only once.  For some reason touching a web link calls 
        // viewDidLayoutSubviews
        
        if !scrolledToTop {
            aboutText.setContentOffset(CGPoint.zero, animated: false)
            scrolledToTop = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.isStatusBarHidden = false
        NotificationCenter.default.removeObserver(self)
    }

    func updateFont () {
        
        let style = aboutText.font?.fontDescriptor.object(forKey: UIFontDescriptorTextStyleAttribute) as! String
        aboutText.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle(rawValue: style))
        
    }
    
    
    
    // MARK: - UITextViewDelegate Method
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        
        let safariVC = SFSafariViewController(url: URL)
        safariVC.delegate = self
        present(safariVC, animated: true, completion: nil)
        
        return false
    }

}
