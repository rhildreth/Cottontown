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
    }
    
    
    override func viewDidLayoutSubviews() {
        youTubeTextField.setContentOffset(CGPointZero, animated: false)
        
    }
    
    deinit {
        print("denint youTubeContentViewController")
    }
    
    @IBAction func pageControlTapped(sender: UIPageControl) {
         print("pageIndex:", pageIndex)
        print("sender current page:", sender.currentPage)
        
        delegate?.pageControlChanged(self, newPageIndex: sender.currentPage, direction: .Forward)
        
    }
}
