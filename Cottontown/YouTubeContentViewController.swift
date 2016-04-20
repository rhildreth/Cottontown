//
//  YouTubeViewController.swift
//  Cottontown
//
//  Created by Ron Hildreth on 3/4/16.
//  Copyright © 2016 Tappdev.com. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class YouTubeContentViewController: UIViewController, UIScrollViewDelegate {
    
    var pageIndex = 0
    var maxPages = 0
    var youTubeID:String = ""
    var youTubeText:String = ""
    
    weak var delegate: PictureContentViewControllerDelegate?

    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var youTubeTextField: UITextView!
    
    @IBOutlet weak var videoThumbnail: UIImageView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var leftArrow: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playButton.accessibilityLabel = "Plays video for stop detail page \(pageIndex + 1) of \(maxPages).  Swipe right for description"
        
        youTubeTextField.text = youTubeText
        
        pageControl.currentPage = pageIndex
        pageControl.numberOfPages = maxPages
        pageControl.currentPageIndicatorTintColor = UIColor.init(colorLiteralRed: 248.0/255, green: 210.0/255.0, blue: 103.0/255.0, alpha: 1.0)


//        let playVars = ["rel": 0,
//                        "showinfo": 0,
//                        "modestbranding": 0,
//                        "playsinline": 0,
//                        ]
//        
//        player.loadWithVideoId(youTubeID, playerVars: playVars)
        
        leftArrow.hidden = false
        leftArrow.accessibilityLabel = "Goes to page \(pageIndex)"
    }
    
 
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        delay(0.25) {
            UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, self.playButton)
        }

    }
    override func viewDidLayoutSubviews() {
        youTubeTextField.setContentOffset(CGPointZero, animated: false)
        
        let maxWidth = videoThumbnail.frame.width
        
        StopsModel.resizeImage(fileName: youTubeID + "_tn", type: "jpg", maxPointSize: maxWidth) { (image) in
            self.videoThumbnail.image = image
        }
    }
    
    deinit {
        
    }
    
    @IBAction func pageControlTapped(sender: UIPageControl) {
       
        // direction is not used in scroll based paging.
        delegate?.pageControlChanged(self, newPageIndex: sender.currentPage)
        
    }
    
    @IBAction func leftArrowTapped(sender: UIButton) {
        
        delegate?.pageControlChanged(self, newPageIndex: pageIndex - 1)
    }
    
    @IBAction func PlayYouTube(sender: UIButton) {
        
        let path = NSBundle.mainBundle().pathForResource(youTubeID, ofType: "mp4")
        let player = AVPlayer(URL: NSURL(fileURLWithPath: path!))
        let playerController = AVPlayerViewController()
        playerController.player = player
        presentViewController(playerController, animated: true) {
            player.play()
        }
        
    }
    
    

}
