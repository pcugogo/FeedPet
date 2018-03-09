//
//  FeedMainInfoTableViewCell.swift
//  FeedPet
//
//  Created by HwangGisu on 2018. 1. 10..
//  Copyright © 2018년 HwangGisu. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON

class FeedMainInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var feedImgView: UIImageView!
    @IBOutlet weak var feedBrandLabel: UILabel!
    @IBOutlet weak var feedNameLabel: UILabel!
    @IBOutlet weak var feedMouthImgView: UIImageView!
    @IBOutlet weak var feedIngredientLabel: UILabel!
    @IBOutlet weak var feedGradeLabel: UILabel!
    @IBOutlet weak var feedPackageLabel: UILabel!
    
    @IBOutlet weak var feedReviewCount: UILabel!
    @IBOutlet weak var firstStarImg: UIImageView!
    @IBOutlet weak var secontdStarImg: UIImageView!
    @IBOutlet weak var thirdStarImg: UIImageView!
    @IBOutlet weak var fourthStarImg: UIImageView!
    @IBOutlet weak var fifthStarImg: UIImageView!
    
    @IBOutlet weak var bookMarkBtn: UIButton!
    
    var feedData: FeedInfo?
    var feedKey: String = String()
    var isBookMark: Bool = false {
        didSet{
            if isBookMark {
                
                self.bookMarkBtn.setBackgroundImage(#imageLiteral(resourceName: "bookMarkAble"), for: .normal)
            }else{
                self.bookMarkBtn.setBackgroundImage(#imageLiteral(resourceName: "bookMarkDisable"), for: .normal)
            }
        }
    }
    var delegate: feedMainInfoCellProtocol?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
/*
        guard let feedDataInfo = feedData else {return}
        print("FeedMainInfoTableViewCell-setSelected://",feedDataInfo)
        feedBrandLabel.text = feedDataInfo.feedBrand
        feedNameLabel.text = feedDataInfo.feedName
        
        let gradeInt: Int = feedDataInfo.feedGrade
        
        // Enum을 통해 해당 셀의 레이블의 값 할당 과 텍스트 컬러 변경 => 좋은방법일지 생각해보고 좋지않다면 함수로 분리하여 호출하자
        FeedGrade(rawValue: feedDataInfo.feedGrade)?.gradeText(label: feedGradeLabel)
        FeedMouth(rawValue: feedDataInfo.feedMouth)?.mouthImgSetting(mouthImgView: feedMouthImgView)
        
        // 포장방식 분기처리
        if feedDataInfo.feedPackageFlag {
            feedPackageLabel.text = "소분포장"
        }else{
            feedPackageLabel.text = "전체포장"
        }
        feedIngredientLabel.text = feedDataInfo.feedIngredient
        
        
        if let urlStr = feedDataInfo.feedImg.first, let url = URL(string: urlStr){
            
            feedImgView.kf.setImage(with: url)
            //            DispatchQueue.main.async {
            //
            //            }
            
        }
        // 리뷰데이터 필요
        
        let ref = Database.database().reference()
    
        ref.child("feed_review").child(feedDataInfo.feedKey).observeSingleEvent(of: .value, with: { (dataSnap) in
            // 1. 리뷰의 갯수가 필요하
            print(feedDataInfo.feedKey)
            // 2. 선택한 사료에 대한 자식데이터 분기
            if dataSnap.childrenCount > 0 {
                guard let reviewData = dataSnap.value else {return}
                let reviewDataJSON = JSON(reviewData)
                print(reviewDataJSON)
                print(dataSnap.childSnapshot(forPath: "review_info").childrenCount)
                DispatchQueue.main.async {
                    
                    self.feedReviewCount.text = dataSnap.childSnapshot(forPath: "review_info").childrenCount.description
                    guard let reviewRating = dataSnap.childSnapshot(forPath: "review_rating").value as? Int else {return}
                    print(reviewRating)
                    switch reviewRating {
                    case 1:
                        self.firstStarImg.image = #imageLiteral(resourceName: "selectStar")
                        self.secontdStarImg.image = #imageLiteral(resourceName: "normalStar")
                        self.thirdStarImg.image = #imageLiteral(resourceName: "normalStar")
                        self.fourthStarImg.image = #imageLiteral(resourceName: "normalStar")
                        self.FifthStarImg.image = #imageLiteral(resourceName: "normalStar")
                    case 2:
                        self.firstStarImg.image = #imageLiteral(resourceName: "selectStar")
                        self.secontdStarImg.image = #imageLiteral(resourceName: "selectStar")
                        self.thirdStarImg.image = #imageLiteral(resourceName: "normalStar")
                        self.fourthStarImg.image = #imageLiteral(resourceName: "normalStar")
                        self.FifthStarImg.image = #imageLiteral(resourceName: "normalStar")
                    case 3:
                        self.firstStarImg.image = #imageLiteral(resourceName: "selectStar")
                        self.secontdStarImg.image = #imageLiteral(resourceName: "selectStar")
                        self.thirdStarImg.image = #imageLiteral(resourceName: "selectStar")
                        self.fourthStarImg.image = #imageLiteral(resourceName: "normalStar")
                        self.FifthStarImg.image = #imageLiteral(resourceName: "normalStar")
                    case 4:
                        self.firstStarImg.image = #imageLiteral(resourceName: "selectStar")
                        self.secontdStarImg.image = #imageLiteral(resourceName: "selectStar")
                        self.thirdStarImg.image = #imageLiteral(resourceName: "selectStar")
                        self.fourthStarImg.image = #imageLiteral(resourceName: "selectStar")
                        self.FifthStarImg.image = #imageLiteral(resourceName: "normalStar")
                    case 5:
                        self.firstStarImg.image = #imageLiteral(resourceName: "selectStar")
                        self.secontdStarImg.image = #imageLiteral(resourceName: "selectStar")
                        self.thirdStarImg.image = #imageLiteral(resourceName: "selectStar")
                        self.fourthStarImg.image = #imageLiteral(resourceName: "selectStar")
                        self.FifthStarImg.image = #imageLiteral(resourceName: "selectStar")
                    default:
                        self.firstStarImg.image = #imageLiteral(resourceName: "normalStar")
                        self.secontdStarImg.image = #imageLiteral(resourceName: "normalStar")
                        self.thirdStarImg.image = #imageLiteral(resourceName: "normalStar")
                        self.fourthStarImg.image = #imageLiteral(resourceName: "normalStar")
                        self.FifthStarImg.image = #imageLiteral(resourceName: "normalStar")
                    }
                    
                }
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
 */
    }
    @IBAction func bookMarkBtnTouched(_ sender: UIBarButtonItem){
        var bookMarkState: Bool = false
        // 현재 즐겨찾기되있는경우
        if isBookMark {
            // 해당값을 삭제하기 위함이기에 값을 변경해준다
            bookMarkState = false

        }
        // 즐겨찾기가 되어있지 않는경우
        else{
            // 현재 값을 true로 할당
            bookMarkState = true
        }
        delegate?.sendBookMarkValue(isBookMark: bookMarkState, feedKey: feedKey)
    }
    
}

protocol feedMainInfoCellProtocol {
    func sendBookMarkValue(isBookMark: Bool, feedKey: String)
    
}
