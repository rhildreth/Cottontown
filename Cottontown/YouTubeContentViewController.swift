//
//  YouTubeViewController.swift
//  Cottontown
//
//  Created by Ron Hildreth on 3/4/16.
//  Copyright © 2016 Tappdev.com. All rights reserved.
//
// Videos are now local and YouTube is not used.  Also, I ran into numerous problems - 
// poor handling of VoiceOver and failure to go full screen on the iPad automatically.
// I left this in so that if many additional videos are used it would not be practical to store them
// locally.

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
        pageControl.currentPageIndicatorTintColor = UIColor.init(colorLiteralRed: 242.0/255, green: 169.0/255.0, blue: 40.0/255.0, alpha: 1.0)


//        let playVars = ["rel": 0,
//                        "showinfo": 0,
//                        "modestbranding": 0,
//                        "playsinline": 0,
//                        ]
//        
//        player.loadWithVideoId(youTubeID, playerVars: playVars)
        
        leftArrow.isHidden = false
        leftArrow.accessibilityLabel = "Goes to page \(pageIndex)"
    }
    
 
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        pageControl.isAccessibilityElement = false
        
        delay(0.25) {
            UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, self.playButton)
        }

    }
    override func viewDidLayoutSubviews() {
        youTubeTextField.setContentOffset(CGPoint.zero, animated: false)
        
        let maxWidth = videoThumbnail.frame.width
        
        StopsModel.resizeImage(fileName: youTubeID + "_tn", type: "jpg", maxPointSize: maxWidth) { (image) in
            self.videoThumbnail.image = image
        }
    }
    
    deinit {
        
    }
    
    @IBAction func pageControlTapped(_ sender: UIPageControl) {
       
        // direction is not used in scroll based paging.
        delegate?.pageControlChanged(self, newPageIndex: sender.currentPage)
        
    }
    
    @IBAction func leftArrowTapped(_ sender: UIButton) {
        
        delegate?.pageControlChanged(self, newPageIndex: pageIndex - 1)
    }
    
    @IBAction func PlayYouTube(_ sender: UIButton) {
        
        let path = Bundle.main.path(forResource: youTubeID, ofType: "mp4")
        let player = AVPlayer(url: URL(fileURLWithPath: path!))
        let playerController = AVPlayerViewController()
        playerController.player = player
        present(playerController, animated: true) {
            player.play()
        }
        
    }
    
    

}
