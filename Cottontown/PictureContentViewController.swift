//
//  PictureContentViewController.swift
//  Cottontown
//
//  Created by Ron Hildreth on 12/20/15.
//  Copyright © 2015 Tappdev.com. All rights reserved.
//

import UIKit
import SafariServices

/*
    This protocol method is used to allow the PictureContentViewController to notify the
    StopPageViewController when the user has requested a navigation the next or previous page.
*/
protocol PictureContentViewControllerDelegate: class {
    func pageControlChanged(sender: UIViewController, newPageIndex: Int)
}

class PictureContentViewController: UIViewController, UITextViewDelegate, SFSafariViewControllerDelegate {
    
    @IBOutlet weak var contentImage: UIImageView!
    @IBOutlet weak var contentText: UITextView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var leftArrow: UIButton!
    @IBOutlet weak var rightArrow: UIButton!
    
    weak var delegate: PictureContentViewControllerDelegate?
    
    var picImageFileName: String?
    var picText = ""
    var pageIndex = 0   // the first page displayed is pageIndex = 0
    var maxPages = 0
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    var scrolledToTop = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentText.text = picText
        
        contentText.selectable = false  // fixes apparent bug in IB preventing changing fonts unless selectable box is checked.  
        
        pageControl.currentPage = pageIndex
        pageControl.numberOfPages = maxPages
        pageControl.currentPageIndicatorTintColor = UIColor.init(colorLiteralRed: 242.0/255, green: 169.0/255.0, blue: 40.0/255.0, alpha: 1.0)
        
        // Disable page control for Voice Over.  Navigation is confusing using this
        // and there is directional arrows that are easier to use in this mode.
        pageControl.isAccessibilityElement = false
     
        showPageNavigationArrows ()
        
        contentText.delegate = self
        contentText.selectable = true
        contentText.editable = false
        contentText.dataDetectorTypes = UIDataDetectorTypes.Link
        
        contentImage.isAccessibilityElement = true
        contentImage.accessibilityLabel = "Image for stop detail page \(pageIndex + 1) of \(maxPages).  Swipe right for description"
        contentImage.accessibilityHint = "Double tap to enable zoom and scroll"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
// Make sure the font size matches the one currently selected by the user
//when the view initially displays.
        updateFont()
        
// Register for notification of font size changes
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PictureContentViewController.updateFont), name: UIContentSizeCategoryDidChangeNotification, object: nil)
        
        pageControl.accessibilityTraits = UIAccessibilityTraitNone
        
        delay(0.5) {
            UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, self.contentImage)
        }
        
        let maxWidth = contentImage.frame.width
        
        guard   let picImageFileName = picImageFileName  else {return}
        StopsModel.resizeImage(fileName: picImageFileName, type: "jpg", maxPointSize: maxWidth) { (image) in
            self.contentImage.image = image
        }

        
    }
    
    override func viewDidAppear(animated: Bool) {
        
            super.viewDidAppear(animated)
        
        
            
            // Alert the user only once if they have visited the detail view, but did not 
            // tap the image to zoom it
            
            if  !defaults.boolForKey("shownDetailMessage") && !defaults.boolForKey("imageTapped") && defaults.integerForKey("detailSelectedCount") > 2 {
                
                let alert = UIAlertController(title: "Hint!", message: "Tap the image to zoom and scroll.", preferredStyle: .Alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                navigationController!.presentViewController(alert, animated: true) {
                    self.defaults.setBool(true, forKey: "shownDetailMessage")
                }
                
            }
        
        defaults.setInteger((defaults.integerForKey("detailSelectedCount") + 1), forKey: "detailSelectedCount")
        
    }
    

    override func viewDidLayoutSubviews() {
        
        // scroll text to top only once
        if !scrolledToTop {
        contentText.setContentOffset(CGPointZero, animated: false)
            scrolledToTop = true
        }
        

        
    }
    
    func updateFont () {
        
        let style = contentText.font?.fontDescriptor().objectForKey(UIFontDescriptorTextStyleAttribute) as! String
        contentText.font = UIFont.preferredFontForTextStyle(style)
        
    }
    
    func showPageNavigationArrows () {
        
        if maxPages == 1 {
            leftArrow.hidden = true
            rightArrow.hidden = true
            return
        }
        
        if maxPages - (pageIndex + 1) > 0 {
            rightArrow.hidden = false
            rightArrow.accessibilityLabel = "Goes to page \(pageIndex + 2)"
        } else {
            rightArrow.hidden = true
        }
        
        if pageIndex + 1 > 1 {
            leftArrow.hidden = false
            leftArrow.accessibilityLabel = "Goes to page \(pageIndex)"
        } else {
            leftArrow.hidden = true
        }
       
                    
    }
    
        @IBAction func pageControllTapped(sender: UIPageControl) {
            
            delegate?.pageControlChanged(self, newPageIndex: sender.currentPage)      }
    
    
    @IBAction func leftArrowTapped(sender: AnyObject) {
        delegate?.pageControlChanged(self, newPageIndex: pageIndex - 1)
        
    }
    
    @IBAction func rightArrowTapped(sender: AnyObject) {
        delegate?.pageControlChanged(self, newPageIndex: pageIndex + 1)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    deinit {
        
    }
    
  
    // MARK: - Navigation
    
 
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let destVC = segue.destinationViewController as! ContentImage
        destVC.contentImageName = picImageFileName
        
        defaults.setBool(true, forKey: "imageTapped")
    }
    
    // MARK: - UITextViewDelegate Method
    
    func textView(textView: UITextView, shouldInteractWithURL URL: NSURL, inRange characterRange: NSRange) -> Bool {
        
        let safariVC = SFSafariViewController(URL: URL)
        safariVC.delegate = self
        presentViewController(safariVC, animated: true, completion: nil)
        
        return false
    }

    
}
