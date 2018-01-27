//
//  MainPageViewController.swift
//  FeedPet
//
//  Created by HwangGisu on 2018. 1. 9..
//  Copyright © 2018년 HwangGisu. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SwiftyJSON
import Firebase
import Kingfisher

class MainPageViewController: UIViewController,IndicatorInfoProvider {

    var indicatorTitle: String = ""{
        didSet{
            currentPetCheck()
        }
    }
   
    
    var scrollDelegate: TableViewScrollDelegate?
//    var feedData: [FeedInfo] = []
    var testReference: DatabaseReference = Database.database().reference()
    var ref: DatabaseReference!
    
    
    
    var feedPagenationData = [FeedInfo]()
    var feedInfoStartKey: String!
    var currentPet = String()
    
    @IBOutlet weak var feedInfoTableView: UITableView!
    @IBOutlet weak var feedListCountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feedInfoTableView.dataSource = self
        feedInfoTableView.delegate = self
        print(self.navigationController?.topViewController)
        print(self.parent?.navigationController)
//        기존 테이블 전체 데이터 호출
        getLoadFeedList()
        
        // 페이지네이션 데이터
        feedDataHandlePagination()
        DispatchQueue.main.async {
            self.feedListCountLabel.text = self.feedPagenationData.count.description
        }
//        ref.database.reference()
//        scrollDelegate = self
//        self.navigationController?.isNavigationBarHidden = true
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.navigationController?.isNavigationBarHidden = true
//        setupAnimationForNavigationBar(caseOfFunction: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        self.navigationController?.isNavigationBarHidden = false
//        setupAnimationForNavigationBar(caseOfFunction: false)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        var indicator = IndicatorInfo(title: nil, image: nil)
        if indicatorTitle == "멍" {
            indicator.title = "멍"
            indicator.image = #imageLiteral(resourceName: "dogAble")
            
        }
        else{
            indicator.title = "냥"
            indicator.image = #imageLiteral(resourceName: "catAble")
            
        }
        return indicator
        
    }
    func getLoadFeedList(){
        testReference.child("feed_info").child("feed_petkey_c").observeSingleEvent(of: .value, with: { (dataSnap) in
            DispatchQueue.main.async {
                self.feedListCountLabel.text = dataSnap.childrenCount.description
            }
//            print("-----datsnap----- : " ,dataSnap.value)
//            guard let feedInfoList = dataSnap.value  else {return}
//            let feedInfoJsonList = JSON(feedInfoList)
//            let test = JSON(dataSnap.value as Any)
//            print("-----[feedInfoJsonList]----- : ", feedInfoJsonList)
//            var list = FeedInfoList(feedsJson: feedInfoJsonList)
//            print("-----[list]----- : ", list)
//
//
//
//            var list2 = FeedInfoList(feedsJsonTest: test.arrayValue)
//            print("-----[list2]----- : ", list2)
//
//            print("-----[test]----- : ", test)
//
//            DispatchQueue.main.async {
//                self.feedPagenationData = list.feed
//                self.feedListCountLabel.text = self.feedPagenationData.count.description
//                self.feedInfoTableView.reloadData()
//            }
        }) { (error) in
            print(error)
        }
        
    }
    
    // MARK: 사료 정보 페이징 처리를 위한 함수
    func feedDataHandlePagination(){
        print(currentPet)
        // 현재 고양이 데이터만 존재하므로 curretnPet 부분을 "feed_petkey_c"로 임시 작업
        let reference = Database.database().reference().child("feed_info").child("feed_petkey_c").queryOrderedByKey()
        if feedInfoStartKey == nil{
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            reference.queryLimited(toFirst: 10).observeSingleEvent(of: .value, with: { (dataSnap) in
                guard let children = dataSnap.children.allObjects.last as? DataSnapshot else {return}
                guard let feedInfoListJson = dataSnap.value else {return}
                let feedJson = JSON(feedInfoListJson)
                
                if dataSnap.childrenCount > 0 {
                    for feed in feedJson{
                        print(feed.0)
                        let feedOne = FeedInfo(feedJsonData: feed)
                        self.feedPagenationData.append(feedOne)
                    }
                    self.feedInfoStartKey = children.key
                    DispatchQueue.main.async {
                        
                        self.feedInfoTableView.reloadData()
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    }
                    print(self.feedInfoStartKey)
                    print(self.feedPagenationData)
                }
            })
        }else {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            reference.queryStarting(atValue: self.feedInfoStartKey).queryLimited(toFirst: 5).observeSingleEvent(of: .value, with: { (dataSnap) in
                guard let children = dataSnap.children.allObjects.last as? DataSnapshot else {return}
                print(children.key)
                guard let feedInfoListJson = dataSnap.value else {return}
                let feedJson = JSON(feedInfoListJson)
                if dataSnap.childrenCount > 0 {
                    for feed in feedJson{

                        if feed.0 != self.feedInfoStartKey {
                            let feedOne = FeedInfo(feedJsonData: feed)
                            self.feedPagenationData.insert(feedOne, at: self.feedPagenationData.count)
                        }
                        
                    }
                    self.feedInfoStartKey = children.key
                    DispatchQueue.main.async {
                        self.feedInfoTableView.reloadData()
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    }
                    print(self.feedInfoStartKey)
                    print(self.feedPagenationData)
                }
            })
        }
        
//        ref.child("feed_info").child(currentPet).queryOrderedByKey().queryLimited(toLast: 10).observeSingleEvent(of: .value, with: { (dataSnap) in
//
//            if dataSnap.childrenCount > 0{
//                for child in dataSnap.children.allObjects as! [DataSnapshot]{
//                    let item = child.value as! (String, JSON)
//                    let feedInfo = FeedInfo(feedJsonData: item)
//                    self.feedPagenationData.insert(feedInfo, at: 0)
//                }
//
//            }
//        }) { (error) in
//            print(error)
//        }
    }
    func currentPetCheck(){
        if indicatorTitle == "멍" {
            currentPet = "feed_petkey_d"
        }else{
            currentPet = "feed_petkey_c"
        }
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
    
}
extension MainPageViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedPagenationData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let feedCell = tableView.dequeueReusableCell(withIdentifier: "FeedMainInfoCell", for: indexPath) as! FeedMainInfoTableViewCell
        feedCell.feedBrandLabel.text = self.feedPagenationData[indexPath.row].feedBrand
        feedCell.feedNameLabel.text = self.feedPagenationData[indexPath.row].feedName

        let gradeInt: Int = self.feedPagenationData[indexPath.row].feedGrade
//        let gradeText: String = FeedGrade.init(rawValue: gradeInt)?.gardeText() ?? "no-data"
//        feedCell.feedGradeLabel.text = gradeText
        
        // Enum을 통해 해당 셀의 레이블의 값 할당 과 텍스트 컬러 변경 => 좋은방법일지 생각해보고 좋지않다면 함수로 분리하여 호출하자
        FeedGrade.init(rawValue: gradeInt)?.gardeText(label: feedCell.feedGradeLabel)
        // Enum을 통한 입소문 이미지 할당 위에 코드와 동일 한 구조
        FeedMouth.init(rawValue: self.feedPagenationData[indexPath.row].feedMouth)?.mouthImgSetting(mouthImgView: feedCell.feedMouthImgView)
        
        // 포장방식 분기처리
        if self.feedPagenationData[indexPath.row].feedPackageFlag {
            feedCell.feedPackageLabel.text = "소분포장"
        }else{
            feedCell.feedPackageLabel.text = "전체포장"
        }
        feedCell.feedIngredientLabel.text = self.feedPagenationData[indexPath.row].feedIngredient
        
    
        if let urlStr = self.feedPagenationData[indexPath.row].feedImg.first?.stringValue, let url = URL(string: urlStr){

            feedCell.feedImgView.kf.setImage(with: url)
//            DispatchQueue.main.async {
//
//            }

        }
        
        return feedCell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        let feedDetailData: FeedInfo = feedPagenationData[indexPath.row]
        print("----select FeedData ----",feedDetailData)
        let feedDeatilView: FeedDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "FeedDetailView") as! FeedDetailViewController
        feedDeatilView.feedDetailInfo = feedDetailData
//        self.parent?.navigationController?.pushViewController(feedDeatilView, animated: true)

        self.parent?.navigationController?.pushViewController(feedDeatilView, animated: true)
//        self.present(feedDeatilView, animated: true, completion: nil)
    }
    
    // 테이블뷰 페이지네이션
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == feedPagenationData.count - 1 {
            // 데이터 호출
            feedDataHandlePagination()
        }
        
    }
    
    
    // 스크롤 뷰가 끝나는 시점 델리게이트 메서드
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        let currentOffset = scrollView.contentOffset.y
        print("-- CurrentOffSet --- " , currentOffset)
        print("-- scrollView.contentSize.height --- " , scrollView.contentSize.height)
        print("-- scrollView.frame.height --- " , scrollView.frame.height)
        
        let maxOffSet = scrollView.contentSize.height - scrollView.frame.height
        print("-- maxOffSet --- " , maxOffSet)
        
        print(maxOffSet - currentOffset)
        // 수정필요
        if maxOffSet - currentOffset <= 600 {
//            self.feedDataHandlePagination()
        }
        
    }
    
    
        
    
    
}
enum FeedGrade: Int{
    case ratingOrganic = 0
    case ratingHolistic = 1
    case ratingSuperPremium = 2
    case ratingPremium = 3
    case ratingGroceryBrand = 4
    case ratingNo = 5
    
    func gardeText(label: UILabel){
        switch self {
        case .ratingOrganic:
            label.textColor = UIColor.init(hexString: "338FCB")
            label.text = "오가닉"
        case .ratingHolistic:
            label.textColor = UIColor.init(hexString: "2EA55E")
            label.text = "홀리스틱"
        case .ratingSuperPremium:
            label.textColor = UIColor.init(hexString: "FFE200")
            label.text = "슈퍼프리미엄"
        case .ratingPremium:
            label.textColor = UIColor.init(hexString: "F39800")
            label.text = "프리미엄"
        case .ratingGroceryBrand:
            label.textColor = UIColor.init(hexString: "C30D23")
            label.text = "마트용"
        case .ratingNo:
            label.textColor = UIColor.init(hexString: "bebebe")
            label.text = "측정불가"
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


// 현재는 테스트로 작성
// 입소문 부분 이부분은 에셋이미지 명을 변경하여 구현가능 찬욱이와 상의후 제거 할수있음
enum FeedMouth: String{
    case Good = "mouth_g"
    case Soso = "mouth_s"
    case Bad = "mouth_b"

    
    func mouthImgSetting(mouthImgView: UIImageView!){
        switch self {
        case .Good:
            mouthImgView.image = #imageLiteral(resourceName: "good")
        case .Soso:
            mouthImgView.image = #imageLiteral(resourceName: "soso")
        case .Bad:
            mouthImgView.image = #imageLiteral(resourceName: "bad")
        
        }
        
    }
}



