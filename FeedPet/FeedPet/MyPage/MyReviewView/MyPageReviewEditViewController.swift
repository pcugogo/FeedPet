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
    let reviewEditDateFormatter : DateFormatter = DateFormatter()
    let dateFormatterHour : DateFormatter = DateFormatter()
    let dateFormatterAMPM : DateFormatter = DateFormatter()
    let date = Date()
    
    var keyboardHeight = 0
    
    @IBOutlet weak var myReviewScrollView: UIScrollView!
    @IBOutlet weak var feedImgView: UIImageView!
    @IBOutlet weak var feedBrandLb: UILabel!
    @IBOutlet weak var feedNameLb: UILabel!
    @IBOutlet weak var feedWriteContentTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(MyPageDataCenter.shared.myPageMyReviewsCellEditBtnTagValue)
        myReviews = MyPageDataCenter.shared.myReviewDatas[MyPageDataCenter.shared.myPageMyReviewsCellEditBtnTagValue]
       
        if let url = URL(string:myReviews.feedImgReturn[0]){
            feedImgView.kf.setImage(with: url)
        }
        
        feedBrandLb.text = myReviews.feedBrandReturn
        feedNameLb.text = myReviews.feedNameReturn
        feedWriteContentTextView.text = myReviews.feedReviewReturn
        
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil) //키보드 올라오는 것을 옵저브
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil) //키보드 사라지는 것을 옵저브
        createToolbar(textView: feedWriteContentTextView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    //리뷰삭제 메서드
    func reviewRemoveAlertController() {
        
        let reviewRemoveAlert:UIAlertController = UIAlertController(title: "", message: "선택하신 리뷰를 삭제하시겠습니까?", preferredStyle: .alert)
        
        let okBtn:UIAlertAction = UIAlertAction(title: "네", style: .default){ (action) in
            
            if let index = MyPageDataCenter.shared.myPageMyReviewsCellEditBtnTagValue {
                print("index",index)
                print("myReviewDatas",MyPageDataCenter.shared.myReviewDatas)
                
                let removeFeedData = MyPageDataCenter.shared.myReviewDatas[index]
        
                MyPageDataCenter.shared.myReviewDatas.remove(at: index)
               
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
                FireBaseData.shared.refMyReviewsReturn.child(MyPageDataCenter.shared.testUUID).child(removeFeedData.feedKeyReturn).removeValue()
                FireBaseData.shared.refFeedReviewsReturn.child(removeFeedData.feedKeyReturn).child("review_info").child(removeFeedData.reviewKeyReturn).removeValue()
                
                    FireBaseData.shared.refReviewThumbReturn.child(removeFeedData.reviewKeyReturn).removeValue()
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
                MyPageDataCenter.shared.reviewsCount -= 1
                
                self.navigationController?.popViewController(animated: true)
            }
            
        }
        let noBtn:UIAlertAction = UIAlertAction(title: "아니오", style: .cancel, handler: nil)
        
        reviewRemoveAlert.addAction(okBtn)
        reviewRemoveAlert.addAction(noBtn)
        
        self.present(reviewRemoveAlert, animated: true, completion: nil)
    }
    
    //리뷰 수정 메서드
    func reviewEditComplate(){
       
        reviewEditDateFormatter.locale = Locale(identifier: "ko")
        dateFormatterHour.dateFormat = "hh"
        dateFormatterAMPM.dateFormat = "aa"
        
        let amPmStr = dateFormatterAMPM.string(from: date)
        let hourString = dateFormatterHour.string(from: date)
        
        if amPmStr == "AM" {
            if hourString == "12"{
                reviewEditDateFormatter.dateFormat = "yyyy.MM.dd 00:mm" //오전12시일경우 매칭할 시간이 0시가 됩니다 그래서 0으로 바꿔줍니다
            }else{
                reviewEditDateFormatter.dateFormat = "yyyy.MM.dd hh:mm"
            }
        }else if amPmStr == "PM" || MyPageDataCenter.shared.mealTimeAMPM["morning"] == "오후"{
            if hourString == "12"{
                reviewEditDateFormatter.dateFormat = "yyyy.MM.dd hh:mm"
            }else{
                reviewEditDateFormatter.dateFormat = "yyyy.MM.dd \(Int(hourString)! + 12):mm"
                //오후 1시일 경우 매칭할 숫자가 13시입니다 그래서 12를 더해 담습니다
            }
            
        }
        let dateString = self.reviewEditDateFormatter.string(from: self.date)
        
        
        if let index = MyPageDataCenter.shared.myPageMyReviewsCellEditBtnTagValue {
            
            var editFeedKey = MyPageDataCenter.shared.myReviewDatas[index]
           
            
            if let reviewContentText = self.feedWriteContentTextView.text{
                FireBaseData.shared.refFeedReviewsReturn.child(editFeedKey.feedKeyReturn).child("review_info").child(editFeedKey.reviewKeyReturn).updateChildValues(["feed_review":reviewContentText])
                
            }
            FireBaseData.shared.refFeedReviewsReturn.child(editFeedKey.feedKeyReturn).child("review_info").child(editFeedKey.reviewKeyReturn).updateChildValues(["feed_date":dateString])
            FireBaseData.shared.fireBaseFeedReviewsDataLoad()
            editFeedKey.feedDateEdit(feedDate: dateString)
            MyPageDataCenter.shared.favorites.sort { (data: FavoritesData, data2: FavoritesData) -> Bool in
                return data.addToFavoritesDateReturn > data2.addToFavoritesDateReturn
            }
            print("수정 데이터 통신 완료")
        }
        let editComplateAlert:UIAlertController = UIAlertController(title: "", message: "저장되었습니다!", preferredStyle: .alert)
        let okBtn:UIAlertAction = UIAlertAction(title: "OK", style: .default){ (action) in
            
            self.navigationController?.popViewController(animated: true)
        }
        editComplateAlert.addAction(okBtn)
        self.present(editComplateAlert, animated: true, completion: nil)
    }
    
    
    
    
    func keyboardWasShown(_ notification : Notification) {
                            self.myReviewScrollView.contentOffset = CGPoint(x: 0, y: self.myReviewScrollView.contentOffset.y + 140)
    }
    
    func keyboardWillHide(_ notification : Notification) {
        self.myReviewScrollView.contentOffset = CGPoint(x: 0, y: self.myReviewScrollView.contentOffset.y - 140)
    }

    
    func createToolbar(textView : UITextView) { //텍스트 뷰 키보드 위에 올라갈 툴바
        let toolbar = UIToolbar()
        toolbar.barStyle = UIBarStyle.default
        toolbar.sizeToFit()
        
        let flexsibleSpace: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let complateBtn = UIBarButtonItem(title: "완료", style: UIBarButtonItemStyle.plain, target: self, action: #selector(MyPageReviewEditViewController.keyboardDisappears))
        
        toolbar.items = [flexsibleSpace,complateBtn]
        textView.inputAccessoryView = toolbar
    }
    func keyboardDisappears(){
        self.view.endEditing(true)
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

