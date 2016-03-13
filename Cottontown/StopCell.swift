//
//  StopCell.swift
//  Cottontown
//
//  Created by Ron Hildreth on 12/12/15.
//  Copyright © 2015 Tappdev.com. All rights reserved.
//

import UIKit

class StopCell: UITableViewCell {

    @IBOutlet weak var stopCellImage: UIImageView!
    @IBOutlet weak var stopTitle: UILabel!
    @IBOutlet weak var stopAddress: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCellForStop(stop:Stop) {
        
        let firstStopPictureTitle = (stop.stopPictures[0])["picImage"]!
//        let stopImageFileName = firstStopPictureTitle + "_tn"
//        let stopImageFileName = firstStopPictureTitle
//        stopCellImage.image = UIImage(named: stopImageFileName)
//        print("stop cell bounds:",stopCellImage.bounds)
        
//        stopTitle.text = stop.stopTitle
//        stopAddress.text = stop.stopAddress
//        stopTitle.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
//        stopTitle.numberOfLines = 0
//        stopAddress.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
//        stopAddress.numberOfLines = 0
        
        let stopImageFileName = firstStopPictureTitle + "_tn@2x"
        let bundlePath = NSBundle.mainBundle().pathForResource(stopImageFileName, ofType: "png")
        stopCellImage.image = UIImage(contentsOfFile: bundlePath!)
    }

}
