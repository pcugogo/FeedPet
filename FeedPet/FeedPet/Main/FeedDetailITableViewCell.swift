//
//  FeedDetailITableViewCell.swift
//  FeedPet
//
//  Created by HwangGisu on 2018. 1. 17..
//  Copyright © 2018년 HwangGisu. All rights reserved.
//

import UIKit
import Kingfisher
class FeedDetailITableViewCell: UITableViewCell {

    @IBOutlet weak var feedImgScrollView: UIScrollView!
    @IBOutlet weak var feedImgScrollContentView: UIView!
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
        feedImgScrollView.delegate = self
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
//        guard let feedDetailInfo = feedInfo else {return}
//        feedBrandNameLabel.text = feedDetailInfo.feedBrand
//        feedNameLabel.text = feedDetailInfo.feedName
//        feedAgeLabel.text = ""
//        feedTargetLabel.text = ""
//        feedCountryOriginLabel.text = feedDetailInfo.feedCountry
//        feedIngredientLabel.text = feedDetailInfo.feedIngredient
//        FeedGrade(rawValue: feedDetailInfo.feedGrade)?.gradeText(label: feedGradeLabel)
//        FeedMouth(rawValue: feedDetailInfo.feedMouth)?.mouthImgSetting(mouthImgView: feedPetEvaluationRatingImgView)
//
//        var count: CGFloat = 0
//        let imgDataCount = feedDetailInfo.feedImg.count
//        for imgCount in 0..<imgDataCount{
//            var imageView: UIImageView{
//                let imgViews = UIImageView(frame: CGRect(x: feedImgScrollContentView.bounds.size.width*CGFloat(imgCount), y: 0, width: feedImgScrollContentView.bounds.size.width, height: feedImgScrollContentView.bounds.size.height))
//                if let url = URL(string: feedDetailInfo.feedImg[imgCount]){
//
//                    imgViews.kf.setImage(with: url)
//                    imgViews.layer.cornerRadius = 5
//                    imgViews.clipsToBounds = true
//                }
//
//                return imgViews
//            }
//            self.feedImgScrollContentView.addSubview(imageView)
//        }
//
//        // ## 제약 사항 변경
//        self.feedImgContentVIewWidthConstraints.constant = self.feedImgScrollView.bounds.size.width * CGFloat(imgDataCount-1)
//        // 뷰를 다시 그리는 메서드-적용된 제약사항을 가지고 새롭게 그리기만 하는 메서드이다.(viewDidLoad 등 다른 메서드와의 관계는 없다)
//        self.feedImgScrollView.layoutIfNeeded()
    }

}
extension FeedDetailITableViewCell: UIScrollViewDelegate{
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let pageIndex = round(scrollView.contentOffset.x / feedImgScrollView.frame.width)
        feedImgScrollPageControl.currentPage = Int(pageIndex)
        
    }
    
    
}
