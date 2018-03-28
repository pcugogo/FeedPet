//
//  FeedDetailViewController.swift
//  FeedPet
//
//  Created by HwangGisu on 2018. 1. 17..
//  Copyright © 2018년 HwangGisu. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON
class FeedDetailViewController: UIViewController {

    @IBOutlet weak var feedDetailTableView: UITableView!
    @IBOutlet weak var feedBookMarkBtn: UIBarButtonItem!
    var feedDetailInfo: FeedInfo?
    var ingredientData: FeedDetailIngredient?
    var sortingReviewData: [ReviewInfo] = [] {
        didSet{
            self.feedDetailTableView.reloadData()
        }
    }
    var feedReviewData: FeedReview?
    var delegate: feedMainInfoCellProtocol?
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
    var goodStrArray: [String] = []
    var warningStrArray: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feedDetailTableView.delegate = self
        feedDetailTableView.dataSource = self
        
//        self.navigationController?.isNavigationBarHidden = false
//        self.navigationController?.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "navigation_backBtn")
//        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "navigation_backBtn")
//        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "dkdkdk", style: .plain, target: nil, action: nil)
//        let backButtonItem = UIBarButtonItem(barButtonSystemItem: .redo, target: nil, action: nil)
//
//
//        self.navigationItem.backBarButtonItem = backButtonItem
        // make backButton with UIButton
       
        
        // add backButton into left side of the navigationBar
        
        self.feedDetailTableView.register(UINib(nibName: "FeedIngredientProgressChartTableViewCell", bundle: nil), forCellReuseIdentifier: "FeedIngredientProgressChartCell")
        
        self.feedDetailTableView.register(UINib(nibName: "FeedReviewListCell", bundle: nil), forCellReuseIdentifier: "FeedReviewListCell")
        // Do any additional setup after loading the view.
        
        
        // 서치바에서 선택시 리뷰정보를 가져올수없다.
//        if reviewInfo.reviewInfo.count > 5 {
//
//        }else{
//
//        }
        ingredientInfoSetting()
        
        
        
//        currentReviewSetting()
            // 1. 리뷰의 갯수가 필요하
            //            print(feedDataInfo.feedKey)
//            guard let data = dataSnap.value else {return}
//
//            let oneReviewData = FeedReview(feedReviewJSON: JSON(data), feedKey: dataSnap.key)
//            feedCell.reviewData = oneReviewData
//            print("리뷰하나의정보://",oneReviewData)
//
//            D

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(self.navigationItem)
        // 변경된 리뷰정보 실시간 확인을 위해 세팅
        currentReviewSetting()
        
//        self.navigationItem.backBarButtonItem?.setBackgroundImage(#imageLiteral(resourceName: "navigation_backBtn"), for: .normal, barMetrics: .default)
//        self.navigationItem.backBarButtonItem?.image = #imageLiteral(resourceName: "navigation_backBtn")
//        self.navigationItem.backBarButtonItem?.title = "go"
        
//        print(self.navigationController?.navigationBar.backItem)
//        self.navigationController?.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "navigation_backBtn"), for: .any, barMetrics: .default)
////                self.navigationController?.isNavigationBarHidden = false
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
    
    @IBAction func bookMarkBtnTouched(_ sender: UIBarButtonItem){
        guard let sendFeedKey = feedDetailInfo?.feedKey else { return }
        var bookMarkState: Bool = false
        // 현재 즐겨찾기되있는경우
        if isBookMark {
            // 해당값을 삭제하기 위함이기에 값을 변경해준다
            bookMarkState = false
            isBookMark = false
        }
            // 즐겨찾기가 되어있지 않는경우
        else{
            // 현재 값을 true로 할당
            bookMarkState = true
            isBookMark = true
        }
        
        delegate?.sendBookMarkValue(isBookMark: bookMarkState, feedKey: sendFeedKey)
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
    // 메인화면에서 넘어온 성분 정보를 세팅하기위한 함수
    func ingredientInfoSetting(){
        let good = ingredientData?.feedIngredientGood ?? []
        print("좋은성분데이터://", good, "//",good.count)
        self.goodStrArray = good.map({ (jsonData) -> String in
            return jsonData.stringValue
        })
        print("좋은성분데이터goodStrArray://", goodStrArray, "//",goodStrArray.count)
        let warning = ingredientData?.feedIngredientWarning ?? []
        print("나쁜성분데이터://", warning, "//",warning.count)
        
        self.warningStrArray = warning.map({ (jsonData) -> String in
            return jsonData.stringValue
        })
        print("나쁜성분데이터:badStrArray//", warningStrArray, "//",warningStrArray.count)

    }
    
    // 리뷰정보 세팅
    func currentReviewSetting(){
        guard let feedKey = feedDetailInfo?.feedKey else {return}
        Database.database().reference().child("feed_review").child(feedKey).observeSingleEvent(of: .value) { (dataSnap) in
            print("goㅎㅎㅎㅎ")
            guard let data = dataSnap.value else {return}
            
            self.feedReviewData = FeedReview(feedReviewJSON: JSON(data), feedKey: dataSnap.key)
            //            feedCell.reviewData = oneReviewData
            
            
            let sortingReview = self.feedReviewData?.reviewInfo.sorted(by: { (reviewOne, reviewTwo) -> Bool in
                return reviewOne.reviewDate > reviewTwo.reviewDate
            })
            
            guard let bindingData = sortingReview else {return}
            self.sortingReviewData = bindingData
    
            print("리뷰하나의정보 정렬://",self.sortingReviewData )
            
//            self.feedDetailTableView.reloadData()
        }
    }

}
extension FeedDetailViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 4{
            var reviewInfoCount = 0
            if let feedReview = feedReviewData {
                print(feedReview.reviewInfo.count)
                 reviewInfoCount = feedReview.reviewInfo.count
            }
            
            return reviewInfoCount
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
            // 연령대 Int값을 퍼피/주니어, 어덜트, 시니어로 화면에 그려준다.
//            detailCell.feedAgeLabel.text = feedDetailInfo?.feedAge.description
            detailCell.feedGradeLabel.text = feedDetailInfo?.feedGrade.description
            detailCell.feedIngredientLabel.text = feedDetailInfo?.feedIngredient
            detailCell.feedCountryOriginLabel.text = feedDetailInfo?.feedCountry
            // 해당 사료의반려동물을 확인=> 현재 currentPet으로 확인
            if DataCenter.shared.currentPetKey == "feed_petkey_d" {
                detailCell.feedTargetLabel.text = "댕댕이"
                if let feedage = feedDetailInfo?.feedAge {
                    
                }
                FeedPetAge(rawValue: (feedDetailInfo?.feedAge)!)?.ageText(label: detailCell.feedAgeLabel, targetPet: "feed_petkey_d")
            }else{
                detailCell.feedTargetLabel.text = "냥냥이"
                FeedPetAge(rawValue: (feedDetailInfo?.feedAge)!)?.ageText(label: detailCell.feedAgeLabel, targetPet: "feed_petkey_c")
            }
            
            FeedGrade(rawValue: (feedDetailInfo?.feedGrade)!)?.gradeText(label: detailCell.feedGradeLabel)
            FeedMouth(rawValue: (feedDetailInfo?.feedMouth)!)?.mouthImgSetting(mouthImgView: detailCell.feedPetEvaluationRatingImgView)
            
            var count: CGFloat = 0
            let imgDataCount = feedDetailInfo?.feedImg.count ?? 0
            for imgCount in 0..<imgDataCount{
                var imageView: UIImageView{
                    let imgViews = UIImageView(frame: CGRect(x: detailCell.feedImgScrollContentView.bounds.size.width*CGFloat(imgCount) + 10, y: 0, width: detailCell.feedImgScrollContentView.bounds.size.width, height: detailCell.feedImgScrollContentView.bounds.size.height))
                    imgViews.contentMode = .scaleAspectFit
                    imgViews.layer.cornerRadius = 5
                    imgViews.clipsToBounds = true
                    if let url = URL(string: (feedDetailInfo?.feedImg[imgCount])!){

                        
                        imgViews.kf.setImage(with: url)
                        
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
            
//            let good = ingredientData?.feedIngredientGood ?? []
//            print("좋은성분데이터://", good, "//",good.count)
////            self.goodStrArray = good.map({ (jsonData) -> String in
////                return jsonData.stringValue
////            })
//            print("좋은성분데이터goodStrArray://", goodStrArray, "//",goodStrArray.count)
//            let warning = ingredientData?.feedIngredientWarning ?? []
//            print("나쁜성분데이터://", warning, "//",warning.count)
//
////            self.badStrArray = warning.map({ (jsonData) -> String in
////                return jsonData.stringValue
////            })
//            print("나쁜성분데이터:badStrArray//", badStrArray, "//",badStrArray.count)
//
            ingredientCell.goodIngredientCountLabel.text = goodStrArray.count.description
            ingredientCell.warningIngredientCountLabel.text = warningStrArray.count.description
            return ingredientCell
        case 2:
            let chartProgressCell = tableView.dequeueReusableCell(withIdentifier: "FeedIngredientProgressChartCell", for: indexPath) as! FeedIngredientProgressChartTableViewCell
            chartProgressCell.ingredeintDataSetting(ingredient: ingredientData)
            return chartProgressCell
        case 3:
            let reviewInfoCell = tableView.dequeueReusableCell(withIdentifier: "FeedReviewInfoCell", for: indexPath) as! FeedReviewInfoTableViewCell
            reviewInfoCell.delegate = self
            
            reviewInfoCell.reviewCountLabel.text = feedReviewData?.reviewInfo.count.description
            reviewInfoCell.reviewScoreLabel.text = feedReviewData?.reviewRating.description
            reviewInfoCell.reviewSetting(ratingScore: feedReviewData?.reviewRating)
            
            return reviewInfoCell
         
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FeedReviewListCell", for: indexPath) as! FeedReviewListCell
            print("디테일에서 리뷰정보\(indexPath.row))://",sortingReviewData[indexPath.row])
            
            cell.reviewData = sortingReviewData[indexPath.row]
        return cell
        default:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "FeedReviewListCell", for: indexPath)
           
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectCell = indexPath.section
        switch selectCell {
        case 0:
            print("")
        case 1:
            
//            FireBaseData.shared.feedGoodIngredientDataLoad(ingredientGoodKey: goodStrArray)
            
//            FireBaseData.shared.feedWarningIngredientDataLoad(ingredientWarningKey: badStrArray)
            
            //화면 이동
            let storyBoard: UIStoryboard = UIStoryboard(name: "MyPage", bundle: nil)
            let ingredientView:IngredientAnalysisViewController = storyBoard.instantiateViewController(withIdentifier: "IngredientAnalysisViewController") as! IngredientAnalysisViewController
            ingredientView.ingredientGoodStrArray = goodStrArray
            ingredientView.ingredientWarningStrArray = warningStrArray
            self.navigationController?.pushViewController(ingredientView, animated: true)
        case 2:
            print("")
        case 3:
            print("")
        case 4:
            print("")
        default:
            print("")
        }
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

extension FeedDetailViewController: ReviewInfoCellProtocol{
    func presentReviewView() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "MyPage", bundle: nil)
        let writeReviewView:WriteReviewViewController = storyBoard.instantiateViewController(withIdentifier: "WriteReviewViewController") as! WriteReviewViewController
        guard let currentFeedInfo = feedDetailInfo else { return }
        //아래의 변수에 값을 넣으면된다
        writeReviewView.feedKey = currentFeedInfo.feedKey
        writeReviewView.feedBrand = currentFeedInfo.feedBrand
        writeReviewView.feedName = currentFeedInfo.feedName
        writeReviewView.feedImg = currentFeedInfo.feedImg.first
        self.navigationController?.pushViewController(writeReviewView, animated: true)
    }
    
    
}
enum FeedPetAge: Int {
    case all = 0
    case puppyAndJunior = 1
    case adult = 2
    case senior = 3
    
    func ageText(label: UILabel, targetPet: String){
        switch self {
        case .all:
            label.text = "전연령"
        case .puppyAndJunior:
            if targetPet == "feed_petkey_d" {
                label.text = "퍼피"
            }else{
                label.text = "주니어"
            }
//            label.textColor = UIColor.init(hexString: "338FCB")
            
        case .adult:
//            label.textColor = UIColor.init(hexString: "2EA55E")
            label.text = "어덜트"
        case .senior:
//            label.textColor = UIColor.init(hexString: "FFE200")
            label.text = "시니어"
        
        }
        //case .ratingOrganic:
        //label.textColor = UIColor.init(hexString: "")
        //label.text = "오가닉"
        //return "오가닉"
        //case .ratingHolistic:
        //return "홀리스틱"
        //case .ratingSuperPremium:
        //return "슈퍼프리미엄"
        //case .ratingPremium:
        //return "프리미엄"
        //case .ratingGroceryBrand:
        //return "마트용"
        //default:
        //return "측정 불가"
        //}
        
        
    }
}

protocol FeedDetailViewProtocol {
    
    func sendBookMarkValue(isBookMark: Bool, feedKey: String)
    
}
