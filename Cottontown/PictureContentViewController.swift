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
    func pageControlChanged(_ sender: UIViewController, newPageIndex: Int)
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
    
    let defaults = UserDefaults.standard
    
    var scrolledToTop = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentText.text = picText
        
        contentText.isSelectable = false  // fixes apparent bug in IB preventing changing fonts unless selectable box is checked.  
        
        pageControl.currentPage = pageIndex
        pageControl.numberOfPages = maxPages
        pageControl.currentPageIndicatorTintColor = UIColor.init(colorLiteralRed: 242.0/255, green: 169.0/255.0, blue: 40.0/255.0, alpha: 1.0)
        
        // Disable page control for Voice Over.  Navigation is confusing using this
        // and there is directional arrows that are easier to use in this mode.
        pageControl.isAccessibilityElement = false
     
        showPageNavigationArrows ()
        
        contentText.delegate = self
        contentText.isSelectable = true
        contentText.isEditable = false
        contentText.dataDetectorTypes = UIDataDetectorTypes.link
       
        
        contentImage.isAccessibilityElement = true
        contentImage.accessibilityLabel = "Image for stop detail page \(pageIndex + 1) of \(maxPages).  Swipe right for description"
        contentImage.accessibilityHint = "Double tap to enable zoom and scroll"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
// Make sure the font size matches the one currently selected by the user
//when the view initially displays.
        updateFont()
        
// Register for notification of font size changes
        NotificationCenter.default.addObserver(self, selector: #selector(PictureContentViewController.updateFont), name: NSNotification.Name.UIContentSizeCategoryDidChange, object: nil)
        
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
    
    override func viewDidAppear(_ animated: Bool) {
        
            super.viewDidAppear(animated)
        
        
            
            // Alert the user only once if they have visited the detail view, but did not 
            // tap the image to zoom it
            
            if  !defaults.bool(forKey: "shownDetailMessage") && !defaults.bool(forKey: "imageTapped") && defaults.integer(forKey: "detailSelectedCount") > 2 {
                
                let alert = UIAlertController(title: "Hint!", message: "Tap the image to zoom and scroll.", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                navigationController!.present(alert, animated: true) {
                    self.defaults.set(true, forKey: "shownDetailMessage")
                }
                
            }
        
        defaults.set((defaults.integer(forKey: "detailSelectedCount") + 1), forKey: "detailSelectedCount")
        
    }
    

    override func viewDidLayoutSubviews() {
        
        // scroll text to top only once
        if !scrolledToTop {
        contentText.setContentOffset(CGPoint.zero, animated: false)
            scrolledToTop = true
        }
    

        
    }
    
    func updateFont () {
        
        let style = contentText.font?.fontDescriptor.object(forKey: UIFontDescriptorTextStyleAttribute) as! String
        contentText.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle(rawValue: style))
        
    }
    
    func showPageNavigationArrows () {
        
        if maxPages == 1 {
            leftArrow.isHidden = true
            rightArrow.isHidden = true
            return
        }
        
        if maxPages - (pageIndex + 1) > 0 {
            rightArrow.isHidden = false
            rightArrow.accessibilityLabel = "Goes to page \(pageIndex + 2)"
        } else {
            rightArrow.isHidden = true
        }
        
        if pageIndex + 1 > 1 {
            leftArrow.isHidden = false
            leftArrow.accessibilityLabel = "Goes to page \(pageIndex)"
        } else {
            leftArrow.isHidden = true
        }
       
                    
    }
    
        @IBAction func pageControllTapped(_ sender: UIPageControl) {
            
            delegate?.pageControlChanged(self, newPageIndex: sender.currentPage)      }
    
    
    @IBAction func leftArrowTapped(_ sender: AnyObject) {
        delegate?.pageControlChanged(self, newPageIndex: pageIndex - 1)
        
    }
    
    @IBAction func rightArrowTapped(_ sender: AnyObject) {
        delegate?.pageControlChanged(self, newPageIndex: pageIndex + 1)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    deinit {
        
    }
    
  
    // MARK: - Navigation
    
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destVC = segue.destination as! ContentImage
        destVC.contentImageName = picImageFileName
        
        defaults.set(true, forKey: "imageTapped")
    }
    
    // MARK: - UITextViewDelegate Method
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        
        let safariVC = SFSafariViewController(url: URL)
        safariVC.delegate = self
        present(safariVC, animated: true, completion: nil)
        
        return false
    }

    
}
