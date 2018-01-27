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
    var feedKey:String = "feed_key_c5"
    var feedBrand:String = "이즈칸"
    var feedName:String = "이즈칸 캣 그레인 프리 키튼"
    var feedImg:String = "http://feedpet.co.kr/wp-content/uploads/feed/feed_key_c5_1.png"
    //여기까지 상세화면에서 받아야 될 데이터
    
    var ratingNumberOfStars = 5 //서버에 넘겨질 평점 초기 별 갯수 5개
    
    let dateFormatter : DateFormatter = DateFormatter()
    let date = Date()
    
    let textViewPlaceHolderText = "사용하신 상품의 리뷰를 남겨주세요:)"
 
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
        feedImgView.image = UIImage(named:feedImg)
        
        createToolbar(textView: reviewContentsTextView)
        
        reviewContentsTextView.delegate = self

        reviewContentsTextView.text = textViewPlaceHolderText
        reviewContentsTextView.textColor = UIColor.lightGray
        
        
        //        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil) //키보드 올라오는 것을 옵저브
        //        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil) //키보드 사라지는 것을 옵저브
        
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
    func keyboardDisappears(){
        self.view.endEditing(true)
    }
    
    func keyboardWasShown(_ notification : Notification) {
//        self.tableView.contentOffset = CGPoint(x: 0, y: self.tableView.contentOffset.y + 150)
    }
    
    func keyboardWillHide(_ notification : Notification)
    {
//        self.tableView.contentOffset = CGPoint(x: 0, y: self.tableView.contentOffset.y - 150)
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
    
    @IBAction func backBtnAction(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func saveBtnAction(_ sender: UIBarButtonItem) {
            
        self.dateFormatter.dateFormat = "yyyy.MM.dd"
        let dateString = self.dateFormatter.string(from: self.date)
        //안들어옴
        if reviewContentsTextView.text.isEmpty || reviewContentsTextView.text == textViewPlaceHolderText {
            let blankContents:UIAlertController = UIAlertController(title: "", message: "리뷰 내용을 입력해주세요~^^", preferredStyle: .alert)
            let okBtn = UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                self.reviewContentsTextView.becomeFirstResponder()
            })
            blankContents.addAction(okBtn)
            self.present(blankContents, animated: true, completion: nil)
        }else{
            let feedReviewInfoDic = ["feed_date":dateString,"feed_rating":self.ratingNumberOfStars,"feed_review":reviewContentsTextView.text,"user_key":MyPageDataCenter.shared.testUUID] as [String : Any]

            //로그인한 계정으로 같은 사료의 리뷰가 이미 있을때 경우는 처리하지않았고 전화면에서 리뷰를 등록했으면 수정하기 화면으로 가는 플로우로 생각했다

            let reviewAutoKey = FireBaseData.shared.refFeedReviewsReturn.child(feedKey).child("review_info").childByAutoId()


            FireBaseData.shared.refFeedReviewsReturn.child(feedKey).child("review_info").child(reviewAutoKey.key).updateChildValues(feedReviewInfoDic)
                FireBaseData.shared.refMyReviewsReturn.child(MyPageDataCenter.shared.testUUID).child(feedKey).updateChildValues(["review_key" :reviewAutoKey.key])
            let completedReview:UIAlertController = UIAlertController(title: "리뷰 등록 완료!", message: "소중한 리뷰 감사합니다:)", preferredStyle: .alert)

            let okBtn:UIAlertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            completedReview.addAction(okBtn)

            self.present(completedReview, animated: true, completion: nil)
            //디스미스나 팝뷰해서 전 화면으로
        }
        
        
        
    }
    
    @IBAction func ratingBtnAction(_ sender: UIButton) {
        switch sender.tag{
        case 1 :
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
