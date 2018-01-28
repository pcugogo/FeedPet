//
//  MyPageMyReviewsCell.swift
//  FeedPet
//
//  Created by ChanWook Park on 2018. 1. 18..
//  Copyright © 2018년 HwangGisu. All rights reserved.
//

import UIKit

protocol MyPageMyReviewsCellDelegate{
    func toEditView()
    func reviewRemoveAlertController()
}

class MyPageMyReviewsCell: UITableViewCell {
    
    var delegate:MyPageMyReviewsCellDelegate?
    
    var myReview:MyReview!
    
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
    
    @IBOutlet weak var editBtnOut: UIButton!
    @IBOutlet weak var removeBtnOut: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configureCell(review:MyReview){
        self.myReview = review
        
        
        //평점 1부터 시작
        switch myReview.feedRatingReturn{
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
        
        
        feedBrandLb.text = myReview.feedBrandReturn
        feedNameLb.text = myReview.feedNameReturn
        reviewContentLb.text = myReview.feedReviewReturn
        feedImgView.image = UIImage(named:myReview.feedImgReturn[0])
        reviewWriteDateLb.text = myReview.feedDateReturn
        
        for reviewThumbData in MyPageDataCenter.shared.reviewThumbDatas{
            if myReview.reviewKeyReturn == reviewThumbData.reviewKeyReturn{
                reviewNumberOfGoodLb.text = String(reviewThumbData.numberOfLikeReturn)
                reviewNumberOfNotGoodLb.text = String(reviewThumbData.numberOfUnLikeReturn)
            }
        }
    }
    
    func editViewPresentModally(){
        delegate?.toEditView()
    }
    
    func removeAlertAction(){
        delegate?.reviewRemoveAlertController()
    }
    
    @IBAction func editBtnAction(_ sender: UIButton) {
        MyPageDataCenter.shared.myPageMyReviewsCellEditBtnTagValue = sender.tag
        editViewPresentModally()
    }
    @IBAction func removeBtnAction(_ sender: UIButton) {
        print("QWE",MyPageDataCenter.shared.myReviewDatas[1],"@$@#$#@%")
        MyPageDataCenter.shared.myPageMyReviewsCellRemoveBtnTagValue = sender.tag
        removeAlertAction()
    }
    
    
    
    
}

