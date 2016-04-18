//
//  PictureContentViewController.swift
//  Cottontown
//
//  Created by Ron Hildreth on 12/20/15.
//  Copyright © 2015 Tappdev.com. All rights reserved.
//

import UIKit

protocol PictureContentViewControllerDelegate: class {
    func pageControlChanged(sender: UIViewController, newPageIndex: Int)
}

class PictureContentViewController: UIViewController, UITextViewDelegate {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentText.text = picText
        
        contentText.selectable = false  // fixes apparent bug in IB preventing changing fonts unless selectable box is checked.  
        
        pageControl.currentPage = pageIndex
        pageControl.numberOfPages = maxPages
        pageControl.currentPageIndicatorTintColor = UIColor.init(colorLiteralRed: 248.0/255, green: 210.0/255.0, blue: 103.0/255.0, alpha: 1.0)
        
        // Disable page control for Voice Over.  Navigation is confusing using this
        // and there is directional arrows that are easier to use in this mode.
        pageControl.isAccessibilityElement = false
     
        showPageNavigationArrows ()
        
        contentText.delegate = self
        contentText.selectable = true
        contentText.editable = false
        contentText.dataDetectorTypes = UIDataDetectorTypes.Link
        
        contentImage.isAccessibilityElement = true
        contentImage.accessibilityLabel = "Detail view one of six for tour stop."
        contentImage.accessibilityHint = "Three finger swipe to navigate to other pages"
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
// Make sure the font size matches the one currently selected by the user
//when the view initially displays.
        updateFont()
        
// Register for notification of font size changes
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PictureContentViewController.updateFont), name: UIContentSizeCategoryDidChangeNotification, object: nil)
        
        pageControl.accessibilityTraits = UIAccessibilityTraitNone
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    

    override func viewDidLayoutSubviews() {
        
        // scroll text to top
        contentText.setContentOffset(CGPointZero, animated: false)
        let maxWidth = contentImage.frame.width
        
        guard   let picImageFileName = picImageFileName  else {return}
        StopsModel.resizeImage(fileName: picImageFileName, type: "jpg", maxPointSize: maxWidth) { (image) in
            self.contentImage.image = image
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
        } else {
            rightArrow.hidden = true
        }
        
        if pageIndex + 1 > 1 {
            leftArrow.hidden = false
        } else {
            leftArrow.hidden = true
        }
       
                    
    }
    
        @IBAction func pageControllTapped(sender: UIPageControl) {
            
            delegate?.pageControlChanged(self, newPageIndex: sender.currentPage)      }
    
    
    @IBAction func leftArrowTapped(sender: UIButton) {
        delegate?.pageControlChanged(self, newPageIndex: pageIndex - 1)
        
    }
    
    @IBAction func rightArrowTapped(sender: UIButton) {
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
        
    
    }
 //MARK: - Accessibility methods
    
    override func accessibilityPerformEscape() -> Bool {
        return false
    }
    
    override func accessibilityScroll(direction: UIAccessibilityScrollDirection) -> Bool {
        return false
    }
   
    
}
