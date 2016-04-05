//
//  YouTubeViewController.swift
//  Cottontown
//
//  Created by Ron Hildreth on 3/4/16.
//  Copyright © 2016 Tappdev.com. All rights reserved.
//

import UIKit

class YouTubeContentViewController: UIViewController, UIScrollViewDelegate {
    
    var pageIndex = 0
    var maxPages = 0
    var youTubeID:String = ""
    var youTubeText:String = ""
    var stopPageVC: StopPageViewController?
    weak var delegate: PictureContentViewControllerDelegate?

    @IBOutlet weak var player: YTPlayerView!

    @IBOutlet weak var youTubeTextField: UITextView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var leftArrow: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        youTubeTextField.text = youTubeText
        
        pageControl.currentPage = pageIndex
        pageControl.numberOfPages = maxPages


        let playVars = ["rel": 0,
                        "showinfo": 0,
                        "modestbranding": 0,
                        "playsinline": 0,
                        ]
        
        player.loadWithVideoId(youTubeID, playerVars: playVars)
        
        leftArrow.hidden = false
    }
    
    
    override func viewDidLayoutSubviews() {
        youTubeTextField.setContentOffset(CGPointZero, animated: false)
        
    }
    
    deinit {
        print("denint youTubeContentViewController")
    }
    
    @IBAction func pageControlTapped(sender: UIPageControl) {
       
        // direction is not used in scroll based paging.
        delegate?.pageControlChanged(self, newPageIndex: sender.currentPage)
        
    }
    
    @IBAction func leftArrowTapped(sender: UIButton) {
        
        delegate?.pageControlChanged(self, newPageIndex: pageIndex - 1)
    }
    
}
