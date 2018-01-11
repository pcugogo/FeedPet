//
//  FeedMainInfoTableViewCell.swift
//  FeedPet
//
//  Created by HwangGisu on 2018. 1. 10..
//  Copyright © 2018년 HwangGisu. All rights reserved.
//

import UIKit

class FeedMainInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var feedImgView: UIImageView!
    @IBOutlet weak var feedBrandLabel: UILabel!
    @IBOutlet weak var feedNameLabel: UILabel!
    @IBOutlet weak var feedPetEvaluationRatingImgView: UIImageView!
    @IBOutlet weak var feedMainMaterialLabel: UILabel!
    @IBOutlet weak var feedGradeLabel: UILabel!
    @IBOutlet weak var feedWrapTypeLabel: UILabel!
    
    @IBOutlet weak var feedRatingScoreLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
