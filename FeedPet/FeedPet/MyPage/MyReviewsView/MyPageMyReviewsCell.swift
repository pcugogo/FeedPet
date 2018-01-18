//
//  MyPageMyReviewsCell.swift
//  FeedPet
//
//  Created by ChanWook Park on 2018. 1. 18..
//  Copyright © 2018년 HwangGisu. All rights reserved.
//

import UIKit

class MyPageMyReviewsCell: UITableViewCell {

    var reviews:ReviewsData!
    
    @IBOutlet weak var feedImgView: UIImageView!
    @IBOutlet weak var reviewWriteDateLb: UILabel!
    @IBOutlet weak var feedBrandLb: UILabel!
    @IBOutlet weak var feedNameLb: UILabel!
    @IBOutlet weak var firstStarImgView: UIImageView!
    @IBOutlet weak var secondStarImgView: UIImageView!
    @IBOutlet weak var thirdStarImgView: UIImageView!
    @IBOutlet weak var fourthStarImgView: UIImageView!
    @IBOutlet weak var fifthStarImgView: UIImageView!
    @IBOutlet weak var reviewContentLb: UILabel!
    
    @IBOutlet weak var reviewNumberOfGoodLb: UILabel!
    @IBOutlet weak var reviewNumberOfNotGoodLb: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(reviews:ReviewsData){
        self.reviews = reviews
        
        
        //평점 1부터 시작
        switch reviews.ratingReturn{
        case 1 :
            firstStarImgView.image = #imageLiteral(resourceName: "selectStar")
            secondStarImgView.image = #imageLiteral(resourceName: "normalStar")
            thirdStarImgView.image = #imageLiteral(resourceName: "normalStar")
            fourthStarImgView.image = #imageLiteral(resourceName: "normalStar")
            fifthStarImgView.image = #imageLiteral(resourceName: "normalStar")
        case 2:
            
            firstStarImgView.image = #imageLiteral(resourceName: "selectStar")
            secondStarImgView.image = #imageLiteral(resourceName: "selectStar")
            thirdStarImgView.image = #imageLiteral(resourceName: "normalStar")
            fourthStarImgView.image = #imageLiteral(resourceName: "normalStar")
            fifthStarImgView.image = #imageLiteral(resourceName: "normalStar")
        case 3:
            
            firstStarImgView.image = #imageLiteral(resourceName: "selectStar")
            secondStarImgView.image = #imageLiteral(resourceName: "selectStar")
            thirdStarImgView.image = #imageLiteral(resourceName: "selectStar")
            fourthStarImgView.image = #imageLiteral(resourceName: "normalStar")
            fifthStarImgView.image = #imageLiteral(resourceName: "normalStar")
        case 4:
            firstStarImgView.image = #imageLiteral(resourceName: "selectStar")
            secondStarImgView.image = #imageLiteral(resourceName: "selectStar")
            thirdStarImgView.image = #imageLiteral(resourceName: "selectStar")
            fourthStarImgView.image = #imageLiteral(resourceName: "selectStar")
            fifthStarImgView.image = #imageLiteral(resourceName: "normalStar")
        case 5:
            firstStarImgView.image = #imageLiteral(resourceName: "selectStar")
            secondStarImgView.image = #imageLiteral(resourceName: "selectStar")
            thirdStarImgView.image = #imageLiteral(resourceName: "selectStar")
            fourthStarImgView.image = #imageLiteral(resourceName: "selectStar")
            fifthStarImgView.image = #imageLiteral(resourceName: "selectStar")
        default:
            print("error")
        }
        
        
        feedBrandLb.text = reviews.feedBrandReturn
        feedNameLb.text = reviews.feedNameReturn
        reviewContentLb.text = reviews.reviewContentReturn
        feedImgView.image = UIImage(named:reviews.feedImgReturn)
        reviewWriteDateLb.text = reviews.writeDateReturn
        reviewNumberOfGoodLb.text = String(reviews.reviewGoodsReturn)
        reviewNumberOfNotGoodLb.text = String(reviews.reviewNotGoodsReturn)
        
    }
    
    @IBAction func editBtnAction(_ sender: UIButton) {
    }
    @IBAction func removeBtnAction(_ sender: UIButton) {
    }
    
    
    
    
}
