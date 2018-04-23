//
//  MyPageFeedContentsCell.swift
//  FeedPet
//
//  Created by ChanWook Park on 2018. 1. 15..
//  Copyright © 2018년 HwangGisu. All rights reserved.
//

import UIKit

protocol MyPageFeedContentsCellDelegate{
    func alertController()
}


class MyPageFeedContentsCell: UITableViewCell {
    
    var delegate:MyPageFeedContentsCellDelegate?
    
    var favorites:FavoritesData!
    
    //    var favoritesDatas:FavoritesData!
    
    
    @IBOutlet weak var feedImgView: UIImageView!
    @IBOutlet weak var likeBtnOut: UIButton!
    @IBOutlet weak var brandNameLb: UILabel!
    @IBOutlet weak var feedNameLb: UILabel!
    @IBOutlet weak var wordOfMouthImgView: UIImageView!
    
    @IBOutlet weak var mainIngredientNameLb: UILabel!
    
    @IBOutlet weak var feedGradeLb: UILabel!
    
    @IBOutlet weak var packingMethodTextLb: UILabel!
    
    @IBOutlet weak var firstStarImgView: UIImageView!
    
    @IBOutlet weak var secondStarImgView: UIImageView!
    
    @IBOutlet weak var thirdStarImgView: UIImageView!
    
    @IBOutlet weak var fourthStarImgView: UIImageView!
    
    @IBOutlet weak var fifthStarImgView: UIImageView!
    
    @IBOutlet weak var ratingLb: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configureCell(favorites:FavoritesData){
        self.favorites = favorites
        
        FeedGrade(rawValue: self.favorites.feedGradeReturn)?.gradeText(label: self.feedGradeLb)
        //0:오가닉 / 1:홀리스틱 / 2:슈퍼프리미엄 / 3:프리미엄 / 4:마트용
//        switch favorites.feedGradeReturn {
//        case 0:
//            feedGradeLb.text = "오가닉"
//            feedGradeLb.textColor = UIColor.init(hexString: "338FCB")
//        case 1:
//            feedGradeLb.text = "홀리스틱"
//            feedGradeLb.textColor = UIColor.green
//        case 2:
//            feedGradeLb.text = "슈퍼프리미엄"
//            feedGradeLb.textColor = UIColor.blue
//
//        case 3:
//            feedGradeLb.text = "프리미엄"
//            feedGradeLb.textColor = UIColor.blue
//        case 4:
//            feedGradeLb.text = "마트용"
//            feedGradeLb.textColor = UIColor.blue
//        default:
//            print("error")
//        }
        print(MyPageDataCenter.shared.favoriteReviewInfoDatas)
        for favoriteReviewInfoData in MyPageDataCenter.shared.favoriteReviewInfoDatas{
            if favorites.feedKeyReturn == favoriteReviewInfoData.feedKeyReturn{
                let rating = favoriteReviewInfoData.feedRatingReturn
                ratingLb.text = String(favoriteReviewInfoData.numberOfReviewReturn)
                //평점 1부터 시작
                switch rating{
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
                    firstStarImgView.image = #imageLiteral(resourceName: "normalStar")
                    secondStarImgView.image = #imageLiteral(resourceName: "normalStar")
                    thirdStarImgView.image = #imageLiteral(resourceName: "normalStar")
                    fourthStarImgView.image = #imageLiteral(resourceName: "normalStar")
                    fifthStarImgView.image = #imageLiteral(resourceName: "normalStar")
                    print("star error://")
                }
            }
        }
        
       
        switch favorites.feedMouthReturn {    // MOUTH_G : GOOD->0 / MOUTH_S : SOSO->1 /  MOUTH_B : BAD->2
        case 0:
            wordOfMouthImgView.image = #imageLiteral(resourceName: "good")
        case 1:
            wordOfMouthImgView.image = #imageLiteral(resourceName: "soso")
        case 2:
            wordOfMouthImgView.image = #imageLiteral(resourceName: "bad")
        default:
            print("error")
        }
        // 수정중
//        if let url = URL(string:favorites.feedImgReturn){
//            feedImgView.kf.setImage(with: url)
//        }
//
        if let url = URL(string:favorites.feedImgReturn){
            feedImgView.kf.setImage(with: url)
        }
        
        brandNameLb.text = favorites.feedBrandReturn
        feedNameLb.text = favorites.feedNameReturn
        mainIngredientNameLb.text = favorites.feedIngredientReturn
        switch favorites.feedPackageFlagReturn {
        case true :
            packingMethodTextLb.text = "소분포장"
        case false:
            packingMethodTextLb.text = "전체포장"
        }
        
        
        
    }
    
    func alertAction(){
        delegate?.alertController()
    }
    
    
    
    @IBAction func likeBtnAction(_ sender: UIButton) {
        
        MyPageDataCenter.shared.myPageFeedContentsCellLikeBtnTagValue = sender.tag
        alertAction()
    }
    
}
