//
//  StopContentViewController.swift
//  Cottontown
//
//  Created by Ron Hildreth on 12/20/15.
//  Copyright © 2015 Tappdev.com. All rights reserved.
//

import UIKit

class StopContentViewController: UIViewController {
    
    @IBOutlet weak var contentImage: UIImageView!
    @IBOutlet weak var contentText: UITextView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    var picImageFileName = ""
    var picText = ""
    var pageIndex = 0
    var maxPages = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentImage.image = UIImage(named: picImageFileName)
        contentText.text = picText
        
        contentText.selectable = false  // fixes apparent bug in IB preventing changing fonts unless selectable box is checked.  
        
        pageControl.currentPage = pageIndex
        pageControl.numberOfPages = maxPages
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
  
    // MARK: - Navigation
    
 
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let destVC = segue.destinationViewController as! ContentImage
        destVC.contentImageName = picImageFileName
        
    
    }
   
    
}