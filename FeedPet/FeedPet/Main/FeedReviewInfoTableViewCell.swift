//
//  FeedReviewInfoTableViewCell.swift
//  FeedPet
//
//  Created by HwangGisu on 2018. 1. 20..
//  Copyright © 2018년 HwangGisu. All rights reserved.
//

import UIKit

class FeedReviewInfoTableViewCell: UITableViewCell {
    @IBOutlet weak var reviewScoreLabel: UILabel!
    
    
    @IBOutlet weak var firstStarImg: UIImageView!
    @IBOutlet weak var secontdStarImg: UIImageView!
    @IBOutlet weak var thirdStarImg: UIImageView!
    @IBOutlet weak var fourthStarImg: UIImageView!
    @IBOutlet weak var FifthStarImg: UIImageView!
    
    
    @IBOutlet weak var reviewCountLabel: UILabel!
    
//    var reviewInfoData:
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var reviewPostBtn: UIButton!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
