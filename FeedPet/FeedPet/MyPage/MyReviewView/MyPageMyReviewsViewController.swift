//
//  MyPageMyReviewsViewController.swift
//  FeedPet
//
//  Created by ChanWook Park on 2018. 1. 18..
//  Copyright © 2018년 HwangGisu. All rights reserved.
//

import UIKit

class MyPageMyReviewsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,MyPageMyReviewsCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 300.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        tableView.estimatedRowHeight = 300.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        if MyPageDataCenter.shared.myReviewDatas.isEmpty{
            tableView.isHidden = true
        }else{
            tableView.isHidden = false
        }
        
        tableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if MyPageDataCenter.shared.myReviewDatas.isEmpty{
            return ""
        }else{
            return "총 \(MyPageDataCenter.shared.reviewsCount)개 상품"
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if MyPageDataCenter.shared.myReviewDatas.isEmpty{
            return 1
        }else{
            return MyPageDataCenter.shared.myReviewDatas.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let myPageMyReviewsCell = tableView.dequeueReusableCell(withIdentifier: "MyPageMyReviewsCell", for: indexPath) as! MyPageMyReviewsCell
        
        myPageMyReviewsCell.delegate = self
        
        myPageMyReviewsCell.editBtnOut.tag = indexPath.row
        myPageMyReviewsCell.removeBtnOut.tag = indexPath.row
        
        if MyPageDataCenter.shared.myReviewDatas.isEmpty == false{
            let review = MyPageDataCenter.shared.myReviewDatas[indexPath.row] //reviews가 옵셔널이 아니므로 옵셔널 바인딩 안된다
            myPageMyReviewsCell.configureCell(review: review)
        }
        
        return myPageMyReviewsCell
        
        
    }
    
    func toEditView() {
        let editReviewView:MyPageReviewEditViewController = self.storyboard?.instantiateViewController(withIdentifier: "MyPageReviewEditViewController") as! MyPageReviewEditViewController
        
        navigationController?.pushViewController(editReviewView, animated: true)
    }
    
    func reviewRemoveAlertController() {
        
        let reviewRemoveAlert:UIAlertController = UIAlertController(title: "", message: "선택하신 리뷰를 삭제하시겠습니까?", preferredStyle: .alert)
        
        let okBtn:UIAlertAction = UIAlertAction(title: "네", style: .default){ (action) in
            
            if let index = MyPageDataCenter.shared.myPageMyReviewsCellRemoveBtnTagValue {
                print("index",index)
                print("MyPageDataCenter.shared.feedKeys",MyPageDataCenter.shared.myReviewKeyDatas)
                
                let removeFeedData = MyPageDataCenter.shared.myReviewKeyDatas[index]
                print("removeFeedData",removeFeedData)
                MyPageDataCenter.shared.myReviewKeyDatas.remove(at: index)
                MyPageDataCenter.shared.myReviewDatas.remove(at: index)
                self.tableView.reloadData()
                FireBaseData.shared.refMyReviewsReturn.child(MyPageDataCenter.shared.testUUID).child(removeFeedData.feedKeyReturn).removeValue()
                FireBaseData.shared.refFeedReviewsReturn.child(removeFeedData.feedKeyReturn).child("review_info").child(removeFeedData.reviewKeyReturn).removeValue()
                
                
                MyPageDataCenter.shared.reviewsCount -= 1
                print("removeReviewDidData",MyPageDataCenter.shared.myReviewDatas)
                
            }
            if MyPageDataCenter.shared.myReviewKeyDatas.isEmpty == true{
                self.tableView.isHidden = true
            }else{
                self.tableView.isHidden = false
            }
            
        }
        let noBtn:UIAlertAction = UIAlertAction(title: "아니오", style: .cancel, handler: nil)
        
        reviewRemoveAlert.addAction(okBtn)
        reviewRemoveAlert.addAction(noBtn)
        
        self.present(reviewRemoveAlert, animated: true, completion: nil)
    }
    
    @IBAction func backBtnAction(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
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
