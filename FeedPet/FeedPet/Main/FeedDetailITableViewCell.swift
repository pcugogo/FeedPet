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
    
    @IBOutlet weak var feedMainMaterialLabel: UILabel!
    @IBOutlet weak var feedPetEvaluationRatingImgView: UIImageView!
    
    @IBOutlet weak var feedEvaluationRatingHelpBtn: UIButton!
    
    // 슬라이드 들어갈 이미지 컨텐츠뷰의 넓이 제약사항
    @IBOutlet weak var feedImgContentVIewWidthConstraints: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
