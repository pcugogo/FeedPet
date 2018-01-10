//
//  WriteReviewVCFeedImgCell.swift
//  FeedPet
//
//  Created by 샤인 on 2018. 1. 10..
//  Copyright © 2018년 HwangGisu. All rights reserved.
//

import UIKit

class WriteReviewVCFeedImgCell: UITableViewCell {
    
    @IBOutlet weak var feedImgView: UIImageView!
    
    @IBOutlet weak var feedNameLb: UILabel!
    
    @IBOutlet weak var feedDetailName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

