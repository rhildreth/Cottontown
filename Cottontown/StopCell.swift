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
        let stopImageFileName = firstStopPictureTitle + "_tn"
        stopCellImage.image = UIImage(named: stopImageFileName)
        
        stopTitle.text = stop.stopTitle
        stopAddress.text = stop.stopAddress
        
        stopTitle.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        stopTitle.numberOfLines = 0
        stopAddress.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        stopAddress.numberOfLines = 0
    }

}
