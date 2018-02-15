//
//  FeedDetailITableViewCell.swift
//  FeedPet
//
//  Created by HwangGisu on 2018. 1. 17..
//  Copyright © 2018년 HwangGisu. All rights reserved.
//

import UIKit

class FeedDetailITableViewCell: UITableViewCell {

    @IBOutlet weak var feedImgScrollView: UIScrollView!
    @IBOutlet weak var feedImgScrollPageControl: UIPageControl!
    
    @IBOutlet weak var feedBrandNameLabel: UILabel!
    
    @IBOutlet weak var feedNameLabel: UILabel!
    
    @IBOutlet weak var feedTargetLabel: UILabel!
    
    
    @IBOutlet weak var feedAgeLabel: UILabel!
    
    @IBOutlet weak var feedCountryOriginLabel: UILabel!
    
    @IBOutlet weak var feedIngredientLabel: UILabel!
    @IBOutlet weak var feedPetEvaluationRatingImgView: UIImageView!
    @IBOutlet weak var feedGradeLabel: UILabel!
    @IBOutlet weak var feedEvaluationRatingHelpBtn: UIButton!
    
    // 슬라이드 들어갈 이미지 컨텐츠뷰의 넓이 제약사항
    @IBOutlet weak var feedImgContentVIewWidthConstraints: NSLayoutConstraint!
    
    var feedInfo: FeedInfo?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        guard let feedDetailInfo = feedInfo else {return}
        feedBrandNameLabel.text = feedDetailInfo.feedBrand
        feedNameLabel.text = feedDetailInfo.feedName
        feedAgeLabel.text = ""
        feedTargetLabel.text = ""
        feedCountryOriginLabel.text = feedDetailInfo.feedCountry
        feedIngredientLabel.text = feedDetailInfo.feedIngredient
        FeedGrade(rawValue: feedDetailInfo.feedGrade)?.gradeText(label: feedGradeLabel)
        FeedMouth(rawValue: feedDetailInfo.feedMouth)?.mouthImgSetting(mouthImgView: feedPetEvaluationRatingImgView)
    }

}
