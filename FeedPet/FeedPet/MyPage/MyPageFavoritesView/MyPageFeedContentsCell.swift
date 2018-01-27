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
        
        //0:유기농 / 1:홀리스틱 / 2:슈퍼프리미엄 / 3:프리미엄 / 4:마트용
        switch favorites.feedGradeReturn {
        case 0:
            feedGradeLb.text = "유기농"
            feedGradeLb.textColor = UIColor.blue
        case 1:
            feedGradeLb.text = "홀리스틱"
            feedGradeLb.textColor = UIColor.green
        case 2:
            feedGradeLb.text = "슈퍼프리미엄"
            feedGradeLb.textColor = UIColor.blue
            
        case 3:
            feedGradeLb.text = "프리미엄"
            feedGradeLb.textColor = UIColor.blue
        case 4:
            feedGradeLb.text = "마트용"
            feedGradeLb.textColor = UIColor.blue
        default:
            print("error")
        }
        
        
        //평점 1부터 시작
        switch favorites.ratingReturn{
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
        
        
       
        switch favorites.feedMouthReturn {    // MOUTH_G : GOOD / MOUTH_S : SOSO /  MOUTH_B : BAD
        case "MOUTH_G":
            wordOfMouthImgView.image = #imageLiteral(resourceName: "good")
        case "MOUTH_S":
            wordOfMouthImgView.image = #imageLiteral(resourceName: "soso")
        case "MOUTH_B":
            wordOfMouthImgView.image = #imageLiteral(resourceName: "bad")
        default:
            print("error")
        }
        
        feedImgView.image = UIImage(named:favorites.feedImgReturn)
        brandNameLb.text = favorites.feedBrandReturn
        feedNameLb.text = favorites.feedNameReturn
        mainIngredientNameLb.text = favorites.feedIngredientReturn
        switch favorites.feedPackageFlagReturn {
        case true :
            packingMethodTextLb.text = "소분포장"
        case false:
            packingMethodTextLb.text = "전체포장"
        }
        
        ratingLb.text = String(favorites.numberOfReviewReturn)
        
    }
    
    func alertAction(){
        delegate?.alertController()
    }
    
    
    
    @IBAction func likeBtnAction(_ sender: UIButton) {
        
        MyPageDataCenter.shared.myPageFeedContentsCellLikeBtnTagValue = sender.tag
        alertAction()
    }
    
}
