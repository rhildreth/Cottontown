//
//  PictureContentViewController.swift
//  Cottontown
//
//  Created by Ron Hildreth on 12/20/15.
//  Copyright © 2015 Tappdev.com. All rights reserved.
//

import UIKit

protocol PictureContentViewControllerDelegate: class {
    func pageControlChanged(sender: UIViewController, newPageIndex: Int, direction: UIPageViewControllerNavigationDirection )
}

class PictureContentViewController: UIViewController {
    
    @IBOutlet weak var contentImage: UIImageView!
    @IBOutlet weak var contentText: UITextView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    weak var delegate: PictureContentViewControllerDelegate?
    
    var picImageFileName: String?
    var picText = ""
    var pageIndex = 0
    var maxPages = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentText.text = picText
        
        contentText.selectable = false  // fixes apparent bug in IB preventing changing fonts unless selectable box is checked.  
        
        pageControl.currentPage = pageIndex
        pageControl.numberOfPages = maxPages
        pageControl.currentPageIndicatorTintColor = UIColor.init(colorLiteralRed: 248.0/255, green: 210.0/255.0, blue: 103.0/255.0, alpha: 1.0)
        pageControl.defersCurrentPageDisplay = false
        
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
    
        @IBAction func pageControllTapped(sender: UIPageControl) {
        
        print("pageIndex:", pageIndex)
        print("sender current page:", sender.currentPage)
            
            delegate?.pageControlChanged(self, newPageIndex: sender.currentPage, direction: .Forward)
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
   
    
}
