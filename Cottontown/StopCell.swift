//
//  StopCell.swift
//  Cottontown
//
//  Created by Ron Hildreth on 12/12/15.
//  Copyright © 2015 Tappdev.com. All rights reserved.
//

import UIKit
import ImageIO

class StopCell: UITableViewCell {

    @IBOutlet weak var stopCellImage: UIImageView!
    @IBOutlet weak var stopTitle: UILabel!
    @IBOutlet weak var stopAddress: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(cell: StopCell, forStop stop:Stop) {
        
        let firstStopPictureTitle = (stop.stopPictures[0])["picImage"]!
//        let stopImageFileName = firstStopPictureTitle + "_tn"
        let stopImageFileName = firstStopPictureTitle + ".jpg"
//        stopCellImage.image = UIImage(named: stopImageFileName)
        thumbnailForFile(firstStopPictureTitle, inCell: cell)
        
        stopTitle.text = stop.stopTitle
        stopAddress.text = stop.stopAddress
        stopTitle.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        stopTitle.numberOfLines = 0
        stopAddress.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        stopAddress.numberOfLines = 0
    }
    
    func thumbnailForFile(fileName: String, inCell cell: StopCell) -> UIImage? {
        let url = NSBundle.mainBundle().URLForResource(fileName, withExtension: "jpg")!
        let src = CGImageSourceCreateWithURL(url, nil)!
        let scale = UIScreen.mainScreen().scale
        print("scale:",scale)
        let scaledWidth = cell.stopCellImage.bounds.width * scale
        print("cell width:", cell.stopCellImage.bounds.width)
        print("cell height:", cell.stopCellImage.bounds.height)
        print("scaledWidth:",scaledWidth)
        
        let dict : [NSObject:AnyObject] = [
            kCGImageSourceShouldAllowFloat : true,
            kCGImageSourceCreateThumbnailWithTransform : true,
            kCGImageSourceCreateThumbnailFromImageAlways : true,
            kCGImageSourceThumbnailMaxPixelSize : scaledWidth
        ]
        
        let imref = CGImageSourceCreateThumbnailAtIndex(src, 0, dict)!
        let im = UIImage(CGImage: imref, scale: scale, orientation: .Up)
        stopCellImage.image = im
        print("image:",im)
        print("image size",im.size)
        print("**********")
        
        return im
    }

}
