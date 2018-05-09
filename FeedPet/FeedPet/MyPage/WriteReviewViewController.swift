//
//  WriteReviewViewController.swift
//  FeedPet
//
//  Created by 샤인 on 2018. 1. 10..
//  Copyright © 2018년 HwangGisu. All rights reserved.
//

import UIKit
import Firebase

class WriteReviewViewController: UIViewController,UITextViewDelegate {
    
    //여기서부터
    var feedKey:String = ""
    var feedBrand:String = ""
    var feedName:String = ""
    var feedImg:String?
    //여기까지 상세화면에서 받아야 될 데이터
    
    var totalRating = 0
    var ratingNumberOfStars = 5 //서버에 넘겨질 평점 초기 별 갯수 5개
    
    let reviewWriteDateFormatter : DateFormatter = DateFormatter()
    let dateFormatterHour : DateFormatter = DateFormatter()
    let dateFormatterAMPM : DateFormatter = DateFormatter()
    let date = Date()
    
    let textViewPlaceHolderText = "사용하신 상품의 리뷰를 남겨주세요:)"
    
    @IBOutlet weak var writeReviewScrollView: UIScrollView!
    @IBOutlet weak var feedImgView: UIImageView!
    
    @IBOutlet weak var feedBrandLb: UILabel!
    
    @IBOutlet weak var feedNameLb: UILabel!
    
    @IBOutlet weak var firstStarBtnOut: UIButton!
    
    @IBOutlet weak var secondStarBtnOut: UIButton!
    
    @IBOutlet weak var thirdStarBtnOut: UIButton!
    
    @IBOutlet weak var fourthStarBtnOut: UIButton!
    
    @IBOutlet weak var fifthStarBtnOut: UIButton!
    
    
    @IBOutlet weak var reviewContentsTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        feedNameLb.text = feedName
        feedBrandLb.text = feedBrand
        if let urlStr = feedImg, let url = URL(string: urlStr){
            feedImgView.kf.setImage(with: url)
        }
        
        
        createToolbar(textView: reviewContentsTextView)
        
        reviewContentsTextView.delegate = self
        
        reviewContentsTextView.text = textViewPlaceHolderText
        reviewContentsTextView.textColor = UIColor.lightGray
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil) //키보드 올라오는 것을 옵저브
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil) //키보드 사라지는 것을 옵저브
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if reviewContentsTextView.text == textViewPlaceHolderText{ //텍스트 에디팅이 시작될때 플레이스홀더 내용이면 내용을 비우고 글씨색상을 검정으로
            reviewContentsTextView.text = ""                       //작성 초기화를 한다
            reviewContentsTextView.textColor = .black
        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if reviewContentsTextView.text == ""{                     //작성이 끝난후 텍스트가 비어있을때 플레이스홀더를 만든다
            reviewContentsTextView.text = textViewPlaceHolderText
            reviewContentsTextView.textColor = UIColor.lightGray
        }
        
    }
    @objc func keyboardDisappears(){
        self.view.endEditing(true)
    }
    
    
    
    func createToolbar(textView : UITextView) { //텍스트 뷰 키보드 위에 올라갈 툴바
        let toolbar = UIToolbar()
        toolbar.barStyle = UIBarStyle.default
        toolbar.sizeToFit()
        
        let flexsibleSpace: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let complateBtn = UIBarButtonItem(title: "완료", style: UIBarButtonItemStyle.plain, target: self, action: #selector(WriteReviewViewController.keyboardDisappears))
        
        toolbar.items = [flexsibleSpace,complateBtn]
        textView.inputAccessoryView = toolbar
    }
    @objc func keyboardWasShown(_ notification : Notification) {
        //self.writeReviewScrollView.contentOffset.y + 160
        
        self.writeReviewScrollView.contentOffset = CGPoint(x: 0, y:160)
    }
    
    @objc func keyboardWillHide(_ notification : Notification) {
        self.writeReviewScrollView.contentOffset = CGPoint(x: 0, y:0)
    }
    
    
    @IBAction func backBtnAction(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveBtnAction(_ sender: UIBarButtonItem) {
        reviewWriteDateFormatter.locale = Locale(identifier: "ko")
        dateFormatterHour.dateFormat = "hh"
        dateFormatterAMPM.dateFormat = "aa"
        
        let amPmStr = dateFormatterAMPM.string(from: date)
        let hourString = dateFormatterHour.string(from: date)
        
        if amPmStr == "AM" {
            if hourString == "12"{
                reviewWriteDateFormatter.dateFormat = "yyyy.MM.dd 00:mm" //오전12시일경우 매칭할 시간이 0시가 됩니다 그래서 0으로 바꿔줍니다
            }else{
                reviewWriteDateFormatter.dateFormat = "yyyy.MM.dd hh:mm"
            }
        }else if amPmStr == "PM" {
            if hourString == "12"{
                reviewWriteDateFormatter.dateFormat = "yyyy.MM.dd hh:mm"
            }else{
                reviewWriteDateFormatter.dateFormat = "yyyy.MM.dd \(Int(hourString)! + 12):mm"
                //오후 1시일 경우 매칭할 숫자가 13시입니다 그래서 12를 더해 담습니다
            }
            
        }
        
        let dateString = self.reviewWriteDateFormatter.string(from: self.date)
        
        if reviewContentsTextView.text.isEmpty || reviewContentsTextView.text == textViewPlaceHolderText {
            let blankContents:UIAlertController = UIAlertController(title: "", message: "리뷰 내용을 입력해주세요~^^", preferredStyle: .alert)
            let okBtn = UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                self.reviewContentsTextView.becomeFirstResponder()
            })
            blankContents.addAction(okBtn)
            self.present(blankContents, animated: true, completion: nil)
        }else{
            guard let userUID = Auth.auth().currentUser?.uid else { return }
            let feedReviewInfoDic = ["feed_date":dateString,"feed_rating":self.ratingNumberOfStars,"feed_review":reviewContentsTextView.text,"user_key": userUID] as [String : Any]
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            //나중에 피드키 부분 옵셔널 되면 옵셔널바인딩 해줘야된다
            let reviewAutoKey = FireBaseData.shared.refFeedReviewsReturn.child(self.feedKey).child("review_info").childByAutoId()
            print(reviewAutoKey.key)
           //트랜젝션처리 필요
            FireBaseData.shared.refFeedReviewsReturn.child(feedKey).runTransactionBlock({ (currentData) -> TransactionResult in
                
                // 리뷰정보가 존재할경우
                if var post = currentData.value as? [String : Any] {
                    print("있던 없던://",post)
                    var reviewInfo = post["review_info"] as? [String:Any] ?? [:]
                    var reviewRating = post["review_rating"] as? Int ?? 0
                    var reviewTotalRating = post["total_rating"] as? Int ?? 0
                    
                    // 현재 사료정보에 작성된 리뷰가 없을경우
                    print(!reviewInfo.contains(where: { (key, value) -> Bool in
                        return value as? String == userUID
                    }))
                    if !reviewInfo.contains(where: { (key, value) -> Bool in
                        return value as? String == userUID
                    }) {
                        reviewInfo.updateValue(feedReviewInfoDic, forKey: reviewAutoKey.key)
                        reviewTotalRating += feedReviewInfoDic["feed_rating"] as! Int
                        reviewRating = reviewTotalRating / reviewInfo.count
                    
                        post["review_info"] = reviewInfo
                        post["review_rating"] = reviewRating
                        post["total_rating"] = reviewTotalRating
                        print(post)
                    }
                    currentData.value = post
                    // 현재 리뷰 좋아요 정보에 사용자가 존재시 좋아요 취소
//                    if let _ = reviewInfo["currentUserUID"] {
//                        reviewRating -= 1
//                        reviewInfo.removeValue(forKey: "currentUserUID")
//
//                    }else{ // 존재하지 않을 경우 좋아요 추가
//                        reviewRating += 1
//                        reviewInfo["currentUserUID"] = true
//                    }
//                    post["data"] = reviewInfo
//                    post["like_count"] = reviewRating
//
////                    currentData.value = post
//                    DispatchQueue.main.async {
//
//                    }
                    return TransactionResult.success(withValue: currentData)
                }
//                else{
//
//                    var post: [String : Any] = [:]
//                    var reviewInfo: [String:Any] = [:]
//                    var reviewRating = 0
//                    var reviewTotalRating = 0
//
//                    reviewInfo.updateValue(feedReviewInfoDic, forKey: reviewAutoKey.key)
//                    reviewTotalRating += feedReviewInfoDic["feed_rating"] as! Int
//                    reviewRating = reviewTotalRating
//
//                    post["review_info"] = reviewInfo
//                    post["review_rating"] = reviewRating
//                    post["total_rating"] = reviewTotalRating
//
//                    print(post)
//                    currentData.value = post
////
////                    var post: [String : Any] = [:]
////                    var likes: [String:Bool] = [:]
////                    let likeCount = 1
////                    likes["currentUserUID"] = true
////                    post["data"] = likes
////                    post["like_count"] = likeCount
////                    currentData.value = post
////                    DispatchQueue.main.async {
////
////                    }
//                    return TransactionResult.success(withValue: currentData)
//                }
            
                
                return TransactionResult.success(withValue: currentData)
            }, andCompletionBlock: { (error, result, dataSnap) in
                if result {

                    FireBaseData.shared.refMyReviewsReturn.child(userUID).child(self.feedKey).updateChildValues(["review_key" :reviewAutoKey.key])
                }
            })
            
//            FireBaseData.shared.refFeedReviewsReturn.child(feedKey).child("review_rating").observeSingleEvent(of: .value, with: { (snapShot) in
//                if let feedTotalRating = snapShot.value as? Int{ //리뷰데이터에 "review_rating"가있으면 평균내고 없으면 그냥 값을 넣는다
//                    self.totalRating = feedTotalRating
//
//                    self.totalRating += self.ratingNumberOfStars
//                    self.totalRating /= 2
//
//                }else{
//                    self.totalRating = self.ratingNumberOfStars
//                }
//
//
//            FireBaseData.shared.refFeedReviewsReturn.child(self.feedKey).child("review_info").child(reviewAutoKey.key).updateChildValues(feedReviewInfoDic)
//            FireBaseData.shared.refFeedReviewsReturn.child(self.feedKey).updateChildValues(["review_rating":self.totalRating])
//
//
            FireBaseData.shared.refMyReviewsReturn.child(userUID).child(self.feedKey).updateChildValues(["review_key" :reviewAutoKey.key])
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            let completedReview:UIAlertController = UIAlertController(title: "리뷰 등록 완료!", message: "소중한 리뷰 감사합니다:)", preferredStyle: .alert)
            
            let okBtn:UIAlertAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                self.navigationController?.popViewController(animated: true)
            })
            completedReview.addAction(okBtn)
            
            self.present(completedReview, animated: true, completion: nil)
            //디스미스나 팝뷰해서 전 화면으로
            
        }
        
        
        
    }//여기까지 saveBtnAction
    
    @IBAction func ratingBtnAction(_ sender: UIButton) {
        switch sender.tag{
        case 1:
            ratingNumberOfStars = 1 // 서버에 넘겨질 평점
            
            firstStarBtnOut.setImage(#imageLiteral(resourceName: "selectStar"), for: .normal)
            secondStarBtnOut.setImage(#imageLiteral(resourceName: "normalStar"), for: .normal)
            thirdStarBtnOut.setImage(#imageLiteral(resourceName: "normalStar"), for: .normal)
            fourthStarBtnOut.setImage(#imageLiteral(resourceName: "normalStar"), for: .normal)
            fifthStarBtnOut.setImage(#imageLiteral(resourceName: "normalStar"), for: .normal)
        case 2:
            ratingNumberOfStars = 2 // 서버에 넘겨질 평점
            
            firstStarBtnOut.setImage(#imageLiteral(resourceName: "selectStar"), for: .normal)
            secondStarBtnOut.setImage(#imageLiteral(resourceName: "selectStar"), for: .normal)
            thirdStarBtnOut.setImage(#imageLiteral(resourceName: "normalStar"), for: .normal)
            fourthStarBtnOut.setImage(#imageLiteral(resourceName: "normalStar"), for: .normal)
            fifthStarBtnOut.setImage(#imageLiteral(resourceName: "normalStar"), for: .normal)
        case 3:
            ratingNumberOfStars = 3 // 서버에 넘겨질 평점
            
            firstStarBtnOut.setImage(#imageLiteral(resourceName: "selectStar"), for: .normal)
            secondStarBtnOut.setImage(#imageLiteral(resourceName: "selectStar"), for: .normal)
            thirdStarBtnOut.setImage(#imageLiteral(resourceName: "selectStar"), for: .normal)
            fourthStarBtnOut.setImage(#imageLiteral(resourceName: "normalStar"), for: .normal)
            fifthStarBtnOut.setImage(#imageLiteral(resourceName: "normalStar"), for: .normal)
        case 4:
            ratingNumberOfStars = 4 // 서버에 넘겨질 평점
            
            firstStarBtnOut.setImage(#imageLiteral(resourceName: "selectStar"), for: .normal)
            secondStarBtnOut.setImage(#imageLiteral(resourceName: "selectStar"), for: .normal)
            thirdStarBtnOut.setImage(#imageLiteral(resourceName: "selectStar"), for: .normal)
            fourthStarBtnOut.setImage(#imageLiteral(resourceName: "selectStar"), for: .normal)
            fifthStarBtnOut.setImage(#imageLiteral(resourceName: "normalStar"), for: .normal)
        case 5:
            ratingNumberOfStars = 5 // 서버에 넘겨질 평점
            
            firstStarBtnOut.setImage(#imageLiteral(resourceName: "selectStar"), for: .normal)
            secondStarBtnOut.setImage(#imageLiteral(resourceName: "selectStar"), for: .normal)
            thirdStarBtnOut.setImage(#imageLiteral(resourceName: "selectStar"), for: .normal)
            fourthStarBtnOut.setImage(#imageLiteral(resourceName: "selectStar"), for: .normal)
            fifthStarBtnOut.setImage(#imageLiteral(resourceName: "selectStar"), for: .normal)
        default:
            print("error")
        }
    }
    
    
}
