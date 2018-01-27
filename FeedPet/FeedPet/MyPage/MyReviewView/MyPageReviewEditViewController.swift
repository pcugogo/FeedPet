//
//  MyPageReviewEditViewController.swift
//  FeedPet
//
//  Created by ChanWook Park on 2018. 1. 18..
//  Copyright © 2018년 HwangGisu. All rights reserved.
//

import UIKit



class MyPageReviewEditViewController: UIViewController {
    
    
    var myReviews:MyReview!
    let dateFormatter : DateFormatter = DateFormatter()
    let date = Date()
    
    
    @IBOutlet weak var feedImgView: UIImageView!
    @IBOutlet weak var feedBrandLb: UILabel!
    @IBOutlet weak var feedNameLb: UILabel!
    @IBOutlet weak var feedWriteContentTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(MyPageDataCenter.shared.myPageMyReviewsCellEditBtnTagValue)
        myReviews = MyPageDataCenter.shared.myReviewDatas[MyPageDataCenter.shared.myPageMyReviewsCellEditBtnTagValue]
        
        //        feedImgView.image = UIImage(named:myReviews.feedImgReturn)
        //        feedBrandLb.text = myReviews.feedBrandReturn
        //        feedNameLb.text = myReviews.feedNameReturn
        feedWriteContentTextView.text = myReviews.feedReviewReturn
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func reviewRemoveAlertController() {
        
        let reviewRemoveAlert:UIAlertController = UIAlertController(title: "", message: "선택하신 리뷰를 삭제하시겠습니까?", preferredStyle: .alert)
        
        let okBtn:UIAlertAction = UIAlertAction(title: "네", style: .default){ (action) in
            
            if let index = MyPageDataCenter.shared.myPageMyReviewsCellEditBtnTagValue {
                print("index",index)
                print("MyPageDataCenter.shared.feedKeys",MyPageDataCenter.shared.myReviewKeyDatas)
                
                let removeFeedData = MyPageDataCenter.shared.myReviewKeyDatas[index]
                
                MyPageDataCenter.shared.myReviewKeyDatas.remove(at: index)
                
                MyPageDataCenter.shared.myReviewDatas.remove(at: index)
                FireBaseData.shared.refMyReviewsReturn.child(MyPageDataCenter.shared.testUUID).child(removeFeedData.feedKeyReturn).removeValue()
                FireBaseData.shared.refFeedReviewsReturn.child(removeFeedData.feedKeyReturn).child("review_info").child(removeFeedData.reviewKeyReturn).removeValue()
                
                
                
                MyPageDataCenter.shared.reviewsCount -= 1
                
                self.navigationController?.popViewController(animated: true)
            }
            
        }
        let noBtn:UIAlertAction = UIAlertAction(title: "아니오", style: .cancel, handler: nil)
        
        reviewRemoveAlert.addAction(okBtn)
        reviewRemoveAlert.addAction(noBtn)
        
        self.present(reviewRemoveAlert, animated: true, completion: nil)
    }
    
    func reviewEditComplate(){
        dateFormatter.dateFormat = "yyyy.MM.dd"
        let dateString = dateFormatter.string(from: date)
        
        if let index = MyPageDataCenter.shared.myPageMyReviewsCellEditBtnTagValue {
            
            let editFeedKey = MyPageDataCenter.shared.myReviewKeyDatas[index]
            
            if let reviewContentText = self.feedWriteContentTextView.text{
                FireBaseData.shared.refFeedReviewsReturn.child(editFeedKey.feedKeyReturn).child("review_info").child(editFeedKey.reviewKeyReturn).updateChildValues(["feed_review":reviewContentText])
                
            }
            FireBaseData.shared.refFeedReviewsReturn.child(editFeedKey.feedKeyReturn).child("review_info").child(editFeedKey.reviewKeyReturn).updateChildValues(["feed_date":dateString])
            FireBaseData.shared.refFeedReviewsDataLoad()
            print("수정 데이터 통신 완료")
        }
        let editComplateAlert:UIAlertController = UIAlertController(title: "", message: "저장되었습니다!", preferredStyle: .alert)
        let okBtn:UIAlertAction = UIAlertAction(title: "OK", style: .default){ (action) in
            
            self.navigationController?.popViewController(animated: true)
        }
        editComplateAlert.addAction(okBtn)
        self.present(editComplateAlert, animated: true, completion: nil)
    }
    
    @IBAction func backBtnAction(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func reviewEditCompleteBtnAction(_ sender: UIBarButtonItem) {
        reviewEditComplate()
    }
    @IBAction func reviewRemoveBtnAction(_ sender: UIButton) {
        reviewRemoveAlertController()
    }
    
}

