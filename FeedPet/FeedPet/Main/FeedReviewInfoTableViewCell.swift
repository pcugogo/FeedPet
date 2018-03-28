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
    @IBOutlet weak var fifthStarImg: UIImageView!
    
    
    @IBOutlet weak var reviewCountLabel: UILabel!
    var delegate: ReviewInfoCellProtocol?
    
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

    
    @IBAction func reviewWritebtnTouched(_ sender: UIButton){
        delegate?.presentReviewView()

    }
    func reviewSetting(ratingScore: Int?){
        
        guard let score = ratingScore else {return}
        switch score {
        case 1:
            self.firstStarImg.image = #imageLiteral(resourceName: "selectStar")
            self.secontdStarImg.image = #imageLiteral(resourceName: "normalStar")
            self.thirdStarImg.image = #imageLiteral(resourceName: "normalStar")
            self.fourthStarImg.image = #imageLiteral(resourceName: "normalStar")
            self.fifthStarImg.image = #imageLiteral(resourceName: "normalStar")
        case 2:
            self.firstStarImg.image = #imageLiteral(resourceName: "selectStar")
            self.secontdStarImg.image = #imageLiteral(resourceName: "selectStar")
            self.thirdStarImg.image = #imageLiteral(resourceName: "normalStar")
            self.fourthStarImg.image = #imageLiteral(resourceName: "normalStar")
            self.fifthStarImg.image = #imageLiteral(resourceName: "normalStar")
        case 3:
            self.firstStarImg.image = #imageLiteral(resourceName: "selectStar")
            self.secontdStarImg.image = #imageLiteral(resourceName: "selectStar")
            self.thirdStarImg.image = #imageLiteral(resourceName: "selectStar")
            self.fourthStarImg.image = #imageLiteral(resourceName: "normalStar")
            self.fifthStarImg.image = #imageLiteral(resourceName: "normalStar")
        case 4:
            self.firstStarImg.image = #imageLiteral(resourceName: "selectStar")
            self.secontdStarImg.image = #imageLiteral(resourceName: "selectStar")
            self.thirdStarImg.image = #imageLiteral(resourceName: "selectStar")
            self.fourthStarImg.image = #imageLiteral(resourceName: "selectStar")
            self.fifthStarImg.image = #imageLiteral(resourceName: "normalStar")
        case 5:
            self.firstStarImg.image = #imageLiteral(resourceName: "selectStar")
            self.secontdStarImg.image = #imageLiteral(resourceName: "selectStar")
            self.thirdStarImg.image = #imageLiteral(resourceName: "selectStar")
            self.fourthStarImg.image = #imageLiteral(resourceName: "selectStar")
            self.fifthStarImg.image = #imageLiteral(resourceName: "selectStar")
        default:
            self.firstStarImg.image = #imageLiteral(resourceName: "normalStar")
            self.secontdStarImg.image = #imageLiteral(resourceName: "normalStar")
            self.thirdStarImg.image = #imageLiteral(resourceName: "normalStar")
            self.fourthStarImg.image = #imageLiteral(resourceName: "normalStar")
            self.fifthStarImg.image = #imageLiteral(resourceName: "normalStar")
        }
        self.layoutIfNeeded()
    }
    
}

protocol ReviewInfoCellProtocol {
    func presentReviewView()
}
