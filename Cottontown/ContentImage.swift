//
//  ContentImage.swift
//  Cottontown
//
//  Created by Ron Hildreth on 1/13/16.
//  Copyright © 2016 Tappdev.com. All rights reserved.
//
// The sole purpose of this view is to allow you to scroll the stop image

import UIKit

class ContentImage: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    var contentImageName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let contentImage = UIImage(named: contentImageName! + ".jpg")
        imageView.image = contentImage
        
        scrollView.delegate = self
        
        scrollView.maximumZoomScale = 1.0
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setZoomScale()
    }
    
    func setZoomScale () {
        let imageSize = imageView.image!.size
        let scrollSize = scrollView.bounds.size
        
        
        let widthScale = scrollSize.width / imageSize.width
        let heightScale = scrollSize.height / imageSize.height
        let minScale = min(widthScale, heightScale)
        
        scrollView.minimumZoomScale = minScale
        
        scrollView.zoomScale = minScale
        
        let scaledImageWidth = imageSize.width * minScale
        let scaledImageHeight = imageSize.height * minScale
        
        let  verticalPadding = scaledImageHeight < scrollSize.height ? (scrollSize.height - scaledImageHeight) / 2.0 : 0
        let horizontalPadding = scaledImageWidth < scrollSize.width ? (scrollSize.width - scaledImageWidth) / 2.0 : 0
        
        scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
        
        
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        
        let imageViewSize = imageView.frame.size
        let scrollViewSize = scrollView.bounds.size
        
        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0
        
        scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
    }
    
    
}
