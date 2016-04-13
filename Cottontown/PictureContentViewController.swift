//
//  PictureContentViewController.swift
//  Cottontown
//
//  Created by Ron Hildreth on 12/20/15.
//  Copyright © 2015 Tappdev.com. All rights reserved.
//

import UIKit
import SafariServices

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentText.text = picText
        
        contentText.selectable = false  // fixes apparent bug in IB preventing changing fonts unless selectable box is checked.  
        
        pageControl.currentPage = pageIndex
        pageControl.numberOfPages = maxPages
        pageControl.currentPageIndicatorTintColor = UIColor.init(colorLiteralRed: 248.0/255, green: 210.0/255.0, blue: 103.0/255.0, alpha: 1.0)
        
        showPageNavigationArrows ()
        
        contentText.delegate = self
        contentText.selectable = true
        contentText.editable = false
        contentText.dataDetectorTypes = UIDataDetectorTypes.Link
        
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
// Make sure the font size matches the one currently selected by the user when the view
// initially diaplays.
        updateFont()
        
// Register for notification of font size changes
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PictureContentViewController.updateFont), name: UIContentSizeCategoryDidChangeNotification, object: nil)
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
 //MARK: - Safari View Controller Delegae methods
    
    func textView(textView: UITextView, shouldInteractWithURL URL: NSURL, inRange characterRange: NSRange) -> Bool {
        
        let safariVC = SFSafariViewController(URL: URL)
        safariVC.delegate = self
        presentViewController(safariVC, animated: true, completion: nil)
        return false
    }
    
    func safariViewControllerDidFinish(controller: SFSafariViewController) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
   
    
}
