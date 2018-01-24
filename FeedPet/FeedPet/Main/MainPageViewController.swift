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

    var indicatorTitle: String = ""
   
    
    var scrollDelegate: TableViewScrollDelegate?
    @IBOutlet weak var feedInfoTableView: UITableView!
    
    @IBOutlet weak var feedListCountLabel: UILabel!
    var feedData: [FeedInfo] = []
    var testReference: DatabaseReference = Database.database().reference()
    var dataTest: [[String:Any]] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        feedInfoTableView.dataSource = self
        feedInfoTableView.delegate = self
        getLoadFeedList()
//        scrollDelegate = self
        self.navigationController?.isNavigationBarHidden = true
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
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
            print("-----datsnap----- : " ,dataSnap.value)
            
            guard let feedInfoList = dataSnap.value  else {return}
            let feedInfoJsonList = JSON(feedInfoList)
            let test = JSON(dataSnap.value as Any)
            print("-----[feedInfoJsonList]----- : ", feedInfoJsonList)
            var list = FeedInfoList(feedsJson: feedInfoJsonList)
            print("-----[list]----- : ", list)
            
            
            
            var list2 = FeedInfoList(feedsJsonTest: test.arrayValue)
            print("-----[list2]----- : ", list2)
            
            print("-----[test]----- : ", test)
            
            DispatchQueue.main.async {
                self.feedData = list.feed
                self.feedListCountLabel.text = self.feedData.count.description
                self.feedInfoTableView.reloadData()
            }
        }) { (error) in
            print(error)
        }
    }
}
extension MainPageViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let feedCell = tableView.dequeueReusableCell(withIdentifier: "FeedMainInfoCell", for: indexPath) as! FeedMainInfoTableViewCell
        feedCell.feedBrandLabel.text = self.feedData[indexPath.row].feedBrand
        feedCell.feedNameLabel.text = self.feedData[indexPath.row].feedName
        feedCell.feedGradeLabel.text = self.feedData[indexPath.row].feedGrade.description
        if self.feedData[indexPath.row].feedPackageFlag {
            feedCell.feedPackageLabel.text = "소분포장"
        }else{
            feedCell.feedPackageLabel.text = "전체포장"
        }
        feedCell.feedIngredientLabel.text = self.feedData[indexPath.row].feedIngredient
        
        let test =  self.feedData[indexPath.row].feedImg.first?.stringValue

        print("사료 데이터 : ..",self.feedData[indexPath.row].feedName,"/",test)
        if let urlStr = self.feedData[indexPath.row].feedImg.first?.stringValue, let url = URL(string: urlStr){

            feedCell.feedImgView.kf.setImage(with: url)
//            DispatchQueue.main.async {
//
//            }


        }
        return feedCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        let feedDetailData: FeedInfo = feedData[indexPath.row]
        print("----select FeedData ----",feedDetailData)
        let feedDeatilView: FeedDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "FeedDetailView") as! FeedDetailViewController
        feedDeatilView.feedDetailInfo = feedDetailData
//        self.parent?.navigationController?.pushViewController(feedDeatilView, animated: true)
        self.navigationController?.pushViewController(feedDeatilView, animated: true)
//        self.present(feedDeatilView, animated: true, completion: nil)
    }
    // 테이블뷰 페이지네이션
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == dataTest.count - 1 {
            // 데이터 호출
            
        }
        
    }
    func moreData(){
        for _ in 0...9{
            
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("스크롤")
        print(scrollView.contentOffset)
        
    }
    
}




