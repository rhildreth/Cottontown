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
        

        print("cell content view bounds", cell.contentView.bounds)
        print("cell image width:", cell.stopCellImage.bounds.width)
        print("cell image height:", cell.stopCellImage.bounds.height)
        
    }
    
    func thumbnailForFile(fileName: String, inCell cell: StopCell) -> UIImage? {
        print(fileName)
        let url = NSBundle.mainBundle().URLForResource(fileName, withExtension: "jpg")!
        let src = CGImageSourceCreateWithURL(url, nil)!
        let scale = UIScreen.mainScreen().scale
        
        
        let maxPixelSize = self.stopCellImage.bounds.width * scale
        

        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0)) {
            
            let dict : [NSObject:AnyObject] = [
            kCGImageSourceShouldAllowFloat : true,
            kCGImageSourceCreateThumbnailWithTransform : true,
            kCGImageSourceCreateThumbnailFromImageAlways : true,
            kCGImageSourceThumbnailMaxPixelSize : maxPixelSize
        ]
        
        let imref = CGImageSourceCreateThumbnailAtIndex(src, 0, dict)!
        let im = UIImage(CGImage: imref, scale: scale, orientation: .Up)
        
            dispatch_async(dispatch_get_main_queue()) {
                self.stopCellImage.image = im
                print("image:",im)
                
            }
        }
        
        
        print("**********")
        return nil
        
    }

}
