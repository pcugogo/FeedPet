//
//  MyPageMyReviewsViewController.swift
//  FeedPet
//
//  Created by ChanWook Park on 2018. 1. 18..
//  Copyright © 2018년 HwangGisu. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON

class MyPageMyReviewsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,MyPageMyReviewsCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var deleteData: MyReview? {
        didSet{
            guard let data = deleteData else {return}
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 300.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        tableView.estimatedRowHeight = 300.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
//        if MyPageDataCenter.shared.myReviewDatas.isEmpty{
//            tableView.isHidden = true
//        }else{
//            tableView.isHidden = false
//        }
//
//        tableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return " 총 \(MyPageDataCenter.shared.reviewsCount)개 상품"
        
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = UIFont(name: "GodoM", size: 15)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if MyPageDataCenter.shared.myReviewDatas.isEmpty{
            self.tableView.isHidden = true
            return 0
        }else{
            self.tableView.isHidden = false
            return MyPageDataCenter.shared.myReviewDatas.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let myPageMyReviewsCell = tableView.dequeueReusableCell(withIdentifier: "MyPageMyReviewsCell", for: indexPath) as! MyPageMyReviewsCell
        
        myPageMyReviewsCell.delegate = self
        
        myPageMyReviewsCell.editBtnOut.tag = indexPath.row
        myPageMyReviewsCell.removeBtnOut.tag = indexPath.row
        
        if MyPageDataCenter.shared.myReviewDatas.isEmpty == false{
            
            myPageMyReviewsCell.configureCell(review: MyPageDataCenter.shared.myReviewDatas[indexPath.row])
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
            guard let userUid = Auth.auth().currentUser?.uid else {return}
            if let index = MyPageDataCenter.shared.myPageMyReviewsCellRemoveBtnTagValue {
                print("index",index)
                print("MyPageDataCenter.shared.myReviewDatas",MyPageDataCenter.shared.myReviewDatas)
                print("keykey",MyPageDataCenter.shared.myReviewKeyDatas)
                let removeFeedData = MyPageDataCenter.shared.myReviewDatas[index]
                
                print("removeFeedData",removeFeedData)
//                MyPageDataCenter.shared.myReviewDatas.remove(at: index)
//                self.deleteData = MyPageDataCenter.shared.myReviewDatas.remove(at: index)
//                self.tableView.reloadData()
               UIApplication.shared.isNetworkActivityIndicatorVisible = true
               
                
                FireBaseData.shared.refFeedReviewsReturn.child(removeFeedData.feedKeyReturn).runTransactionBlock({ (currentData) -> TransactionResult in
                    // 리뷰정보가 존재할경우
                    if var post = currentData.value as? [String:Any]{
                        print("있던 없던://",post)
                        var reviewInfo = post["review_info"] as? [String:Any] ?? [:]
                        print(reviewInfo)
                        var reviewRating = post["review_rating"] as? Int ?? 0
                        var reviewTotalRating = post["total_rating"] as? Int ?? 0
                        // 지우려고하는 리뷰의 별점
                        let removeUserRating = removeFeedData.feedRatingReturn
                        print(removeUserRating)
                        reviewInfo.removeValue(forKey: removeFeedData.reviewKeyReturn)
                        print(reviewInfo)
                        
                        print(reviewTotalRating)
                        
                        if !reviewInfo.isEmpty {
                            post["review_info"] = reviewInfo
                            reviewTotalRating -= removeUserRating
                            reviewRating = reviewTotalRating / reviewInfo.count
                            post["review_rating"] = reviewRating
                            post["total_rating"] = reviewTotalRating
                            currentData.value = post
                        }else{
                            currentData.value = nil
                        }
                        return TransactionResult.success(withValue: currentData)
                    }
                    
                    return TransactionResult.success(withValue: currentData)
                }, andCompletionBlock: { (error, result, dataSnap) in
                    if result {
                        
                    
                    // 내리뷰에서도 삭제
                    FireBaseData.shared.refMyReviewsReturn.child(userUid).child(removeFeedData.feedKeyReturn).removeValue()
                    // 리뷰의 좋아요/싫어요 데이터삭제
                    FireBaseData.shared.refReviewThumbReturn.child(removeFeedData.reviewKeyReturn).removeValue()
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    
                        // 싱글톤 리뷰카운트 감소
                        MyPageDataCenter.shared.reviewsCount -= 1
                        MyPageDataCenter.shared.myReviewDatas.remove(at: index)
                        
                        self.tableView.reloadData()
                        print("removeReviewDidData",MyPageDataCenter.shared.myReviewDatas)
                    }
                    
                    
                })
                
                
                
                
                
                
                
                
// 내리뷰에서도 삭제                FireBaseData.shared.refMyReviewsReturn.child(userUid).child(removeFeedData.feedKeyReturn).removeValue()
//                FireBaseData.shared.refFeedReviewsReturn.child(removeFeedData.feedKeyReturn).child("review_info").child(removeFeedData.reviewKeyReturn).removeValue()
//                
               
                
                
//                FireBaseData.shared.refFeedReviewsReturn.child(removeFeedData.feedKeyReturn).child("review_info").child(removeFeedData.reviewKeyReturn).removeValue(completionBlock: { (error, reference) in
//                    print(reference.parent)
//                    reference.parent?.runTransactionBlock({[unowned self] (currentData) -> TransactionResult in
//
//                        // 리뷰정보가 nil일수있다. 전체 별점만 남아있고 reviewInfo는 없게되어 nil이 나옴
//                        print(currentData.value)
//                        print(currentData.value as? [[String:Any]])
//
//                        if var post = currentData.value as? [String : Any] {
//                            print("있던 없던")
//                            var likes = post["data"] as? [String:Bool] ?? [:]
//                            var likeCount = post["like_count"] as? Int ?? 0
//
//                            // 현재 리뷰 좋아요 정보에 사용자가 존재시 좋아요 취소
//                            if let _ = likes["d"] {
//                                likeCount -= 1
////                                likes.removeValue(forKey: currentUserUID)
//
//                            }else{ // 존재하지 않을 경우 좋아요 추가
//                                likeCount += 1
////                                likes[currentUserUID] = true
//                            }
//                            post["data"] = likes
//                            post["like_count"] = likeCount
//
////                            currentData.value = post
//                            DispatchQueue.main.async {
////                                self.reviewLikeLabel.text = likeCount.description
//                            }
////                            return TransactionResult.success(withValue: currentData)
//                        }else{
//                            var post: [String : Any] = [:]
//                            var likes: [String:Bool] = [:]
//                            let likeCount = 1
////                            likes[currentUserUID] = true
//                            post["data"] = likes
//                            post["like_count"] = likeCount
////                            currentData.value = post
//                            DispatchQueue.main.async {
////                                self.reviewLikeLabel.text = likeCount.description
//                            }
////                            return TransactionResult.success(withValue: currentData)
//                        }
//                        return TransactionResult.success(withValue: currentData)
//                    }) { (error, committed, snapshot) in
//                        if let error = error {
//                            print("///// error 4632: \n", error.localizedDescription)
//                        }
//                    }
//
//
////                    MyPageDataCenter.shared.myReviewDatas.remove(at: index)
//                })
//
               
               
               // 리뷰의 좋아요/싫어요 데이터삭제 FireBaseData.shared.refReviewThumbReturn.child(removeFeedData.reviewKeyReturn).removeValue()
//                UIApplication.shared.isNetworkActivityIndicatorVisible = false
//
//
//                // 싱글톤 리뷰카운트 감소
////                MyPageDataCenter.shared.reviewsCount -= 1
//                print("removeReviewDidData",MyPageDataCenter.shared.myReviewDatas)
//
            }
            if MyPageDataCenter.shared.myReviewDatas.isEmpty == true{
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
