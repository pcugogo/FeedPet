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
    @IBOutlet weak var feedImgContentViewWidthConstraints: NSLayoutConstraint!
    var testImg: UIImageView =  UIImageView() {
        didSet{
            
//                 self.feedImgScrollContentView.addSubview(imageView)
//                self.feedImgContentViewWidthConstraints.constant = self.feedImgScrollView.bounds.size.width * CGFloat(imgLoadCount-1)
//                // 뷰를 다시 그리는 메서드-적용된 제약사항을 가지고 새롭게 그리기만 하는 메서드이다.(viewDidLoad 등 다른 메서드와의 관계는 없다)
//                self.feedImgScrollPageControl.numberOfPages = imgLoadCount
//                self.feedImgScrollView.isPagingEnabled = true
//                self.feedImgScrollView.showsHorizontalScrollIndicator = false
//
//                self.feedImgScrollView.layoutIfNeeded()
            
        }
    }
    var feedInfo: FeedInfo?
//    var feedInfo: FeedInfo? {
//        didSet{
//
//            guard let feedDetailInfo = feedInfo else {return}
//            feedBrandNameLabel.text = feedDetailInfo.feedBrand
//            feedNameLabel.text = feedDetailInfo.feedName
//
//            feedGradeLabel.text = feedDetailInfo.feedGrade.description
//            feedIngredientLabel.text = feedDetailInfo.feedIngredient
//            feedCountryOriginLabel.text = feedDetailInfo.feedCountry
//
//            FeedGrade(rawValue: feedDetailInfo.feedGrade)?.gradeText(label: feedGradeLabel)
//            FeedMouth(rawValue: feedDetailInfo.feedMouth)?.mouthImgSetting(mouthImgView: feedPetEvaluationRatingImgView)
//
//            // 해당 사료의반려동물을 확인=> 현재 currentPet으로 확인
//            if DataCenter.shared.currentPetKey == "feed_petkey_d" {
//                feedTargetLabel.text = "댕댕이"
//                if let feedage = feedDetailInfo.feedAge {
//
//                }
//                FeedPetAge(rawValue: (feedDetailInfo.feedAge)!)?.ageText(label: feedAgeLabel, targetPet: "feed_petkey_d")
//            }else{
//                feedTargetLabel.text = "냥냥이"
//                FeedPetAge(rawValue: (feedDetailInfo.feedAge)!)?.ageText(label: feedAgeLabel, targetPet: "feed_petkey_c")
//            }
//
//            FeedGrade(rawValue: (feedDetailInfo.feedGrade)!)?.gradeText(label: feedGradeLabel)
//            FeedMouth(rawValue: (feedDetailInfo.feedMouth)!)?.mouthImgSetting(mouthImgView: feedPetEvaluationRatingImgView)
//
//            var count: CGFloat = 0
//            var countLoad: Int = 0
//            let imgDataCount = feedDetailInfo.feedImg.count
//            print(imgDataCount)
//            DispatchQueue.main.async {
//
//                // ## 제약 사항 변경
//                self.feedImgContentViewWidthConstraints.constant = self.feedImgScrollView.bounds.size.width * CGFloat(imgDataCount-1)
//                // 뷰를 다시 그리는 메서드-적용된 제약사항을 가지고 새롭게 그리기만 하는 메서드이다.(viewDidLoad 등 다른 메서드와의 관계는 없다)
//                self.feedImgScrollPageControl.numberOfPages = imgDataCount
//                self.feedImgScrollView.isPagingEnabled = true
//                self.feedImgScrollView.showsHorizontalScrollIndicator = false
//
//                self.feedImgScrollView.layoutIfNeeded()
//            }
//            for imgCount in 0..<imgDataCount{
//                /*
//                var imageView: UIImageView{
//                    let imgViews = UIImageView(frame: CGRect(x: feedImgScrollContentView.bounds.size.width*CGFloat(imgCount), y: 0, width: feedImgScrollContentView.bounds.size.width, height: feedImgScrollContentView.bounds.size.height))
//                    if let url = URL(string: feedDetailInfo.feedImg[imgCount]){
//
//                        imgViews.kf.setImage(with: url)
//                        imgViews.layer.cornerRadius = 5
//                        imgViews.clipsToBounds = true
//                    }
//
//                    return imgViews
//                }
//                */
//                var imageView: UIImageView{
//                    print(feedImgScrollContentView.bounds.width,"/",feedImgScrollContentView.bounds.size.width,"/",feedImgScrollContentView.bounds.width * CGFloat(imgCount))
//                    let imgViews = UIImageView(frame:
//                        CGRect(x: feedImgScrollContentView.bounds.width * CGFloat(imgCount),                   y: 0,
//                               width: feedImgScrollContentView.bounds.size.width,
//                               height: feedImgScrollContentView.bounds.size.height))
//                    imgViews.contentMode = .scaleAspectFit
//                    //                    imgViews.layer.cornerRadius = 5
////                    imgViews.clipsToBounds = true
//                    if let url = URL(string: (feedDetailInfo.feedImg[imgCount])){
//
//
//                        imgViews.kf.setImage(with: url)
//                        testImg = imgViews
//                    }
//
//                    return imgViews
//                }
//                self.feedImgScrollContentView.addSubview(imageView)
//
//
//            }
//
//
//
//        }
//
//    }
    var detailCellDelegate: FeedDetailCellProtoCol?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        feedImgScrollView.delegate = self
//        feedGradeLabel.numberOfLines = 0
//                feedGradeLabel.adjustsFontSizeToFitWidth = true
//                feedGradeLabel.minimumScaleFactor = 0.5
//                feedGradeLabel.sizeToFit()
        
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
    
    @IBAction func mouthInfoBtnTouched(_ sender: UIButton){
        detailCellDelegate?.viewOnMouthInfoImg(mouthInfoBtnFrame: feedEvaluationRatingHelpBtn.frame, cellHeight: self.bounds.height)
        print("1/",feedEvaluationRatingHelpBtn.bounds)
        print("2/",feedEvaluationRatingHelpBtn.bounds.origin)
        print("3/",feedEvaluationRatingHelpBtn.frame)
        print("4/",feedEvaluationRatingHelpBtn.frame.origin)
        print("5/",self.frame)
        
        
        
    }

}
//extension FeedDetailITableViewCell: UIScrollViewDelegate{
//    
//    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//
//        let pageIndex = round(scrollView.contentOffset.x / feedImgScrollView.frame.width)
//        feedImgScrollPageControl.currentPage = Int(pageIndex)
//        
//    }
//    
//    
//}
//
//protocol  FeedDetailCellProtoCol {
//    func viewOnMouthInfoImg(mouthInfoBtnFrame: CGRect, cellHeight: CGFloat)
//}

