//
//  MainPageViewController.swift
//  FeedPet
//
//  Created by HwangGisu on 2018. 1. 9..
//  Copyright © 2018년 HwangGisu. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class MainPageViewController: UIViewController,IndicatorInfoProvider {

    var indicatorTitle: String = ""
   
    
    var scrollDelegate: TableViewScrollDelegate?
    @IBOutlet weak var feedInfoTableView: UITableView!
    
    var dataTest: [[String:Any]] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        feedInfoTableView.dataSource = self
        feedInfoTableView.delegate = self
        
//        scrollDelegate = self
        
        // Do any additional setup after loading the view.
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
}
extension MainPageViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let feeCell = tableView.dequeueReusableCell(withIdentifier: "FeedMainInfoCell", for: indexPath) as! FeedMainInfoTableViewCell
        
        return feeCell
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





