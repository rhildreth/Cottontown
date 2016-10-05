//
//  HistoryViewController.swift
//  Cottontown
//
//  Created by Ron Hildreth on 4/2/16.
//  Copyright © 2016 Tappdev.com. All rights reserved.
//

import UIKit

func delay(_ delay:Double, closure:@escaping ()->()) {
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}

class HistoryViewController: UIViewController {
    
    let historyTitle = UILabel.init(frame: CGRect(x: 0.0, y: 0.0,width: 98.0 , height: 24.0))

    @IBOutlet weak var historyImage: UIImageView!
    
    @IBOutlet weak var historyText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        historyTitle.backgroundColor = UIColor.clear
        historyTitle.font = UIFont.systemFont(ofSize: 20.0)
        
        historyTitle.textAlignment = .center
        
        historyTitle.textColor = UIColor.white
        historyTitle.text = "History of Cottontown"
        historyTitle.sizeToFit()
        navigationItem.titleView = historyTitle
        historyTitle.isAccessibilityElement = true
        
        historyText.isSelectable = false  // fixes apparent bug in IB preventing changing fonts unless selectable box is checked.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Register for notification of font size changes
        NotificationCenter.default.addObserver(self, selector: #selector(HistoryViewController.updateFont), name: NSNotification.Name.UIContentSizeCategoryDidChange, object: nil)
        
        delay(0.5) {
            UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, self.historyTitle)
        }
        
        
    }
    
    override func viewWillLayoutSubviews() {
        
    }
    
    override func viewDidLayoutSubviews() {
        
        
        
        // scroll text to top
        historyText.setContentOffset(CGPoint.zero, animated: false)
        
        let maxWidth = historyImage.frame.width
        StopsModel.resizeImage(fileName: "historya", type: "jpg", maxPointSize: maxWidth) { (image) in
            self.historyImage.image = image
        }
    }
    
    func updateFont () {
        
        let style = historyText.font?.fontDescriptor.object(forKey: UIFontDescriptorTextStyleAttribute) as! String
        historyText.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle(rawValue: style))
        
    }

    @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
        
        let historyImageVC = storyboard?.instantiateViewController(withIdentifier: "contentImageID") as! ContentImage
            historyImageVC.contentImageName = "historya"
        navigationController?.pushViewController(historyImageVC, animated: false)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        NotificationCenter.default.removeObserver(self)
    }



}
