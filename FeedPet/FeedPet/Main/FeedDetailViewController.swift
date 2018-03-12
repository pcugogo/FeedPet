//
//  FeedDetailViewController.swift
//  FeedPet
//
//  Created by HwangGisu on 2018. 1. 17..
//  Copyright © 2018년 HwangGisu. All rights reserved.
//

import UIKit
import Firebase

class FeedDetailViewController: UIViewController {

    @IBOutlet weak var feedDetailTableView: UITableView!
    @IBOutlet weak var feedBookMarkBtn: UIBarButtonItem!
    var feedDetailInfo: FeedInfo?
    var ingredientData: FeedDetailIngredient?
    var isBookMark: Bool = false {
        didSet{
            if isBookMark {
//                feedBookMarkBtn.setBackgroundImage(#imageLiteral(resourceName: "bookMarkAble"), for: .normal, barMetrics: .default)
                feedBookMarkBtn.image = #imageLiteral(resourceName: "bookMarkAble")
            }else{
                
                feedBookMarkBtn.image = #imageLiteral(resourceName: "bookMarkDisable")
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        feedDetailTableView.delegate = self
        feedDetailTableView.dataSource = self
//        self.navigationController?.isNavigationBarHidden = false
//        self.navigationController?.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "navigation_backBtn")
//        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "navigation_backBtn")
//        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "dkdkdk", style: .plain, target: nil, action: nil)
        
        
        
        self.feedDetailTableView.register(UINib(nibName: "FeedIngredientProgressChartTableViewCell", bundle: nil), forCellReuseIdentifier: "FeedIngredientProgressChartCell")
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//                self.navigationController?.isNavigationBarHidden = false
//        setupAnimationForNavigationBar(caseOfFunction: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //        self.navigationController?.isNavigationBarHidden = false
//        setupAnimationForNavigationBar(caseOfFunction: false)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setupAnimationForNavigationBar(caseOfFunction: Bool) {
        if caseOfFunction == true {
            UIView.animate(withDuration: 0.5) {
                self.navigationController?.navigationBar.transform = CGAffineTransform(translationX: 0, y: -200)
            }
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                self.navigationController?.navigationBar.transform = CGAffineTransform.identity
            })
        }
        
    }
    
    func feedBookMarkLoadData(userUID: String, feedKey: String){
        Database.database().reference().child("my_favorite").child(userUID).child(feedKey).observeSingleEvent(of: .value, with: { (dataSnap) in
            
            if dataSnap.hasChildren() {
                self.feedBookMarkBtn.image = #imageLiteral(resourceName: "bookMarkAble")
                self.isBookMark = true
            }else{
                self.feedBookMarkBtn.image = #imageLiteral(resourceName: "bookMarkDisable")
                self.isBookMark = false
            }

        })
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension FeedDetailViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0{
            return 1
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if indexPath.section == 0 {
//
//            let detailCell = tableView.dequeueReusableCell(withIdentifier: "FeedDetailCell", for: indexPath) as! FeedDetailITableViewCell
//
//            detailCell.feedBrandNameLabel.text = feedDetailInfo?.feedBrand
//            detailCell.feedNameLabel.text = feedDetailInfo?.feedName
//            detailCell.feedAgeLabel.text = feedDetailInfo?.feedAge.description
//            detailCell.feedGradeLabel.text = feedDetailInfo?.feedGrade.description
//            detailCell.feedIngredientLabel.text = feedDetailInfo?.feedIngredient
//
//            return detailCell
//        }else{
//            let cell = tableView.dequeueReusableCell(withIdentifier: "FeedIngredientCell", for: indexPath) as! FeedIngredientTableViewCell
//
//            return cell
//        }
        switch indexPath.section {
        case 0:
            let detailCell = tableView.dequeueReusableCell(withIdentifier: "FeedDetailCell", for: indexPath) as! FeedDetailITableViewCell
            detailCell.feedInfo = feedDetailInfo
            detailCell.detailCellDelegate = self
//            print(feedDetailInfo)
            detailCell.feedBrandNameLabel.text = feedDetailInfo?.feedBrand ?? "no-brand"
            detailCell.feedNameLabel.text = feedDetailInfo?.feedName
            detailCell.feedAgeLabel.text = feedDetailInfo?.feedAge.description
            detailCell.feedGradeLabel.text = feedDetailInfo?.feedGrade.description
            detailCell.feedIngredientLabel.text = feedDetailInfo?.feedIngredient
            detailCell.feedCountryOriginLabel.text = feedDetailInfo?.feedCountry
            detailCell.feedTargetLabel.text = "cat"
            
            
            FeedGrade(rawValue: (feedDetailInfo?.feedGrade)!)?.gradeText(label: detailCell.feedGradeLabel)
            FeedMouth(rawValue: (feedDetailInfo?.feedMouth)!)?.mouthImgSetting(mouthImgView: detailCell.feedPetEvaluationRatingImgView)
            
            var count: CGFloat = 0
            let imgDataCount = feedDetailInfo?.feedImg.count ?? 0
            for imgCount in 0..<imgDataCount{
                var imageView: UIImageView{
                    let imgViews = UIImageView(frame: CGRect(x: detailCell.feedImgScrollContentView.bounds.size.width*CGFloat(imgCount)+10, y: 0, width: detailCell.feedImgScrollContentView.bounds.size.width, height: detailCell.feedImgScrollContentView.bounds.size.height))
                    if let url = URL(string: (feedDetailInfo?.feedImg[imgCount])!){

                        
                        imgViews.kf.setImage(with: url)
                        imgViews.contentMode = .scaleAspectFit
                        imgViews.layer.cornerRadius = 5
                        imgViews.clipsToBounds = true
                    }

                    return imgViews
                }
                detailCell.feedImgScrollContentView.addSubview(imageView)
            }
            detailCell.feedImgScrollPageControl.numberOfPages = imgDataCount
            
            
            // ## 제약 사항 변경 
            detailCell.feedImgContentViewWidthConstraints.constant = detailCell.feedImgScrollView.bounds.width * CGFloat(imgDataCount-1)
            // 뷰를 다시 그리는 메서드-적용된 제약사항을 가지고 새롭게 그리기만 하는 메서드이다.(viewDidLoad 등 다른 메서드와의 관계는 없다)
            detailCell.feedImgScrollView.layoutIfNeeded()
            detailCell.feedImgScrollView.isPagingEnabled = true
            detailCell.feedImgScrollView.showsHorizontalScrollIndicator = false
            return detailCell
        case 1:
            let ingredientCell = tableView.dequeueReusableCell(withIdentifier: "FeedIngredientCell", for: indexPath) as! FeedIngredientTableViewCell
            
            let good = ingredientData?.feedIngredientGood ?? []
            let warning = ingredientData?.feedIngredientWarning ?? []
            
            ingredientCell.goodIngredientCountLabel.text = good.count.description
            ingredientCell.goodIngredientCountLabel.text = warning.count.description
            return ingredientCell
        case 2:
            let chartProgressCell = tableView.dequeueReusableCell(withIdentifier: "FeedIngredientProgressChartCell", for: indexPath) as! FeedIngredientProgressChartTableViewCell
            chartProgressCell.ingredeintDataSetting(ingredient: ingredientData)
            return chartProgressCell
        case 3:
            let reviewInfoCell = tableView.dequeueReusableCell(withIdentifier: "FeedReviewInfoCell", for: indexPath) as! FeedReviewInfoTableViewCell
            
            return reviewInfoCell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FeedReviewListTableCell", for: indexPath) as! FeedReviewListTableViewCell
            
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
extension FeedDetailViewController: FeedDetailCellProtoCol{
    
    func viewOnMouthInfoImg(mouthInfoBtnFrame: CGRect, cellHeight: CGFloat) {
        let backGroundView = UIView(frame: self.view.bounds)
        print("6/",feedDetailTableView.frame)
        print("7/",self.view.frame)
        let mouthInfoView: UIImageView = {
            let imgView = UIImageView(frame: CGRect(x: self.view.bounds.width * 0.025, y: mouthInfoBtnFrame.origin.y + mouthInfoBtnFrame.height, width: self.view.bounds.width * 0.95, height: cellHeight))
            imgView.image = #imageLiteral(resourceName: "mouth_info_img")
            imgView.contentMode = .scaleAspectFit
            imgView.clipsToBounds = true
            return imgView
        }()
        backGroundView.backgroundColor = UIColor.init(hexString: "#333333", alpha: 0.0)
        backGroundView.addSubview(mouthInfoView)
        // 지우려고하는 뷰를 구분짓기 위해 tag값 할당
        backGroundView.tag = 100
        backGroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapGestureRemoveView(handleGesture:))))
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            backGroundView.backgroundColor = UIColor.init(hexString: "#333333", alpha: 0.5)
            self.view.addSubview(backGroundView)
        }) { (result) in
            
        }
        
    }

    @objc func tapGestureRemoveView(handleGesture: UITapGestureRecognizer){
        print(self.view.subviews)
        for subView in self.view.subviews{
            if subView.tag == 100 {
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
                    subView.backgroundColor = UIColor.init(hexString: "#333333", alpha: 0.0)
                }) { (result) in
                    subView.removeFromSuperview()
                    
                }
                
            }
        }
    }
    
    
}
