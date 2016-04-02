//
//  HistoryViewController.swift
//  Cottontown
//
//  Created by Ron Hildreth on 4/2/16.
//  Copyright © 2016 Tappdev.com. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {

    @IBOutlet weak var historyImage: UIImageView!
    
    @IBOutlet weak var historyText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        historyText.selectable = false  // fixes apparent bug in IB preventing changing fonts unless selectable box is checked.

    }
    
    override func viewWillAppear(animated: Bool) {
        
        // Register for notification of font size changes
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HistoryViewController.updateFont), name: UIContentSizeCategoryDidChangeNotification, object: nil)
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
        print("image tapped")
        
        let historyImageVC = storyboard?.instantiateViewControllerWithIdentifier("contentImageID") as! ContentImage
            historyImageVC.contentImageName = "historya"
        navigationController?.pushViewController(historyImageVC, animated: false)
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }



}
