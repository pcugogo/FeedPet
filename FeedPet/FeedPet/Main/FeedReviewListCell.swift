//
//  FeedReviewListCell.swift
//  FeedPet
//
//  Created by HwangGisu on 2018. 3. 6..
//  Copyright © 2018년 HwangGisu. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher
import SwiftyJSON

class FeedReviewListCell: UITableViewCell {

    @IBOutlet weak var reviewUserProfileImg: UIImageView!
    @IBOutlet weak var reviewUserNicName: UILabel!
    @IBOutlet weak var firstStarImg: UIImageView!
    @IBOutlet weak var secontdStarImg: UIImageView!
    @IBOutlet weak var thirdStarImg: UIImageView!
    @IBOutlet weak var fourthStarImg: UIImageView!
    @IBOutlet weak var fifthStarImg: UIImageView!
    @IBOutlet weak var reviewContent: UILabel!
    @IBOutlet weak var reviewDate: UILabel!
    
    @IBOutlet weak var reviewLikeLabel: UILabel!
    @IBOutlet weak var reviewUnLikeLabel: UILabel!
    

    
    
    var reviewData: ReviewInfo?{
        didSet{
            guard let userRiviewData = reviewData else {return}
//            reviewSetting(ratingScore: userRiviewData.feedRating, reviewCount: userRiviewData)
            print("리뷰리뷰리뷰://",userRiviewData)
            
            reviewSetting(ratingScore: userRiviewData.feedRating)
            self.reviewContent.text = userRiviewData.feedReviewContent
            self.reviewDate.text = userRiviewData.reviewDate
            
           // 리뷰작성자의 닉네임과 프로필이미지를 가져오기 위한 통신
            Database.database().reference().child("user_info").child(userRiviewData.userKey).observeSingleEvent(of: .value, with: {[unowned self] (dataSnap) in
//                print("리뷰작성유저 데이터://",dataSnap.value)
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
//                guard let userData = dataSnap.value as? [String:Any] else {return}
                // 사용자 삭제시 해당 아이디와 프로필 이미지가 변경되지않음
                if let userData = dataSnap.value as? [String:Any] {
                    print("리뷰작성유저 정보://",userData)
                    let userInfo = User(userInfoData: userData)
                    print("리뷰작성유저 1정보1://",userInfo)
                    
                    
                    self.reviewUserNicName.text = userInfo.userNickname
                    
                    
                    DispatchQueue.global(qos: .userInteractive).async {
                        if let urlStr = userInfo.userProfileImgUrl, let userProfileImgURL = URL(string: urlStr) {
                            DispatchQueue.main.async {
                                self.reviewUserProfileImg.clipsToBounds = true
                                self.reviewUserProfileImg.layer.cornerRadius =   self.reviewUserProfileImg.frame.height/2
                                self.reviewUserProfileImg.kf.setImage(with: userProfileImgURL)
                                self.reviewUserProfileImg.layoutIfNeeded()
                            }
                        }
                        
                        
                        
                        
                    }
                }else{
//                    print("없는 유저잇다.")
//                    DispatchQueue.main.async {
//
//                        self.reviewUserNicName.text = "탈퇴한유저"
//                        self.reviewUserProfileImg.image = #imageLiteral(resourceName: "MyPageProfile")
//                    }
                }
                
                
                self.reviewThumbDataLoad(reviewKey: userRiviewData.reviewKey)
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        print("리뷰유저이미지뷰 높이://",reviewUserProfileImg.frame.height)
        
        
    }
    
   
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func reviewSetting(ratingScore: Int){
        
        switch ratingScore {
        case 1:
            self.firstStarImg.image = #imageLiteral(resourceName: "selectStar")
            self.secontdStarImg.image = #imageLiteral(resourceName: "normalStar")
            self.thirdStarImg.image = #imageLiteral(resourceName: "normalStar")
            self.fourthStarImg.image = #imageLiteral(resourceName: "normalStar")
            self.fifthStarImg.image = #imageLiteral(resourceName: "normalStar")
        case 2:
            self.firstStarImg.image = #imageLiteral(resourceName: "selectStar")
            self.secontdStarImg.image = #imageLiteral(resourceName: "selectStar")
            self.thirdStarImg.image = #imageLiteral(resourceName: "normalStar")
            self.fourthStarImg.image = #imageLiteral(resourceName: "normalStar")
            self.fifthStarImg.image = #imageLiteral(resourceName: "normalStar")
        case 3:
            self.firstStarImg.image = #imageLiteral(resourceName: "selectStar")
            self.secontdStarImg.image = #imageLiteral(resourceName: "selectStar")
            self.thirdStarImg.image = #imageLiteral(resourceName: "selectStar")
            self.fourthStarImg.image = #imageLiteral(resourceName: "normalStar")
            self.fifthStarImg.image = #imageLiteral(resourceName: "normalStar")
        case 4:
            self.firstStarImg.image = #imageLiteral(resourceName: "selectStar")
            self.secontdStarImg.image = #imageLiteral(resourceName: "selectStar")
            self.thirdStarImg.image = #imageLiteral(resourceName: "selectStar")
            self.fourthStarImg.image = #imageLiteral(resourceName: "selectStar")
            self.fifthStarImg.image = #imageLiteral(resourceName: "normalStar")
        case 5:
            self.firstStarImg.image = #imageLiteral(resourceName: "selectStar")
            self.secontdStarImg.image = #imageLiteral(resourceName: "selectStar")
            self.thirdStarImg.image = #imageLiteral(resourceName: "selectStar")
            self.fourthStarImg.image = #imageLiteral(resourceName: "selectStar")
            self.fifthStarImg.image = #imageLiteral(resourceName: "selectStar")
        default:
            self.firstStarImg.image = #imageLiteral(resourceName: "normalStar")
            self.secontdStarImg.image = #imageLiteral(resourceName: "normalStar")
            self.thirdStarImg.image = #imageLiteral(resourceName: "normalStar")
            self.fourthStarImg.image = #imageLiteral(resourceName: "normalStar")
            self.fifthStarImg.image = #imageLiteral(resourceName: "normalStar")
        }
        self.layoutIfNeeded()
    }
    
    func reviewThumbDataLoad(reviewKey: String){
        Database.database().reference().child("review_thumb").child(reviewKey).observeSingleEvent(of: .value) { (dataSnap) in
//            guard let thumbData = dataSnap.value as? [String:Any] else {return}
            
//            guard let like = dataSnap.childSnapshot(forPath: "review_like").childSnapshot(forPath: "like_count").value as? Int else { return }
//
//            guard let unlike = dataSnap.childSnapshot(forPath: "review_unlike").childSnapshot(forPath: "unlike_count").value as? Int else { return }
            let likeData = dataSnap.childSnapshot(forPath: "review_like").childSnapshot(forPath: "like_count").value as? Int ?? 0
            let unlikeData = dataSnap.childSnapshot(forPath: "review_unlike").childSnapshot(forPath: "unlike_count").value as? Int ?? 0
            
            DispatchQueue.main.async {
                print("리뷰키@://",reviewKey," 조아요://",likeData, "실어요://",unlikeData)
                
                self.reviewLikeLabel.text = likeData.description
                
                self.reviewUnLikeLabel.text = unlikeData.description
                
                
            }
        }


    }
    @IBAction func reviewLikeUnlikeBtnTouched(_ sender: UIButton){
        // 현재 리뷰의 고유 키값
        guard let reviewKey = self.reviewData?.reviewKey else { return }
        // 사용자 uid
        guard let currentUserUID = Auth.auth().currentUser?.uid else { return}
        Database.database().reference().child("review_thumb").child(reviewKey).observeSingleEvent(of: .value) { (dataSnap) in
            
        }
        // 좋아요 버튼클릭
        if sender.tag == 0 {
            Database.database().reference().child("review_thumb").child(reviewKey).child("review_like").runTransactionBlock({[unowned self] (currentData) -> TransactionResult in
                
                if var post = currentData.value as? [String : Any] {
                    print("있던 없던")
                    var likes = post["data"] as? [String:Bool] ?? [:]
                    var likeCount = post["like_count"] as? Int ?? 0
                    
                    // 현재 리뷰 좋아요 정보에 사용자가 존재시 좋아요 취소
                    if let _ = likes[currentUserUID] {
                        likeCount -= 1
                        likes.removeValue(forKey: currentUserUID)
                        
                    }else{ // 존재하지 않을 경우 좋아요 추가
                        likeCount += 1
                        likes[currentUserUID] = true
                    }
                    post["data"] = likes
                    post["like_count"] = likeCount
                    
                    currentData.value = post
                    DispatchQueue.main.async {
                        self.reviewLikeLabel.text = likeCount.description
                    }
                    return TransactionResult.success(withValue: currentData)
                }else{
                    var post: [String : Any] = [:]
                    var likes: [String:Bool] = [:]
                    let likeCount = 1
                    likes[currentUserUID] = true
                    post["data"] = likes
                    post["like_count"] = likeCount
                    currentData.value = post
                    DispatchQueue.main.async {
                        self.reviewLikeLabel.text = likeCount.description
                    }
                    return TransactionResult.success(withValue: currentData)
                }
//                return TransactionResult.success(withValue: currentData)

                
                /*
                var likeData: [String: Any] = [:]
                print(currentData.children.allObjects)
                print(currentData.childData(byAppendingPath: currentUserUID))
                if currentData.hasChildren(){
                    //                print("똑같은 노드에 값존재 한단다 :/",user_uid)
                    likeData = currentData.value as! [String:Any]
                    print(likeData)
                    let flag = likeData.contains(where: { (key,value) -> Bool in
                        return key == currentUserUID
                    })
                    
                    if flag {
                        likeData.removeValue(forKey: currentUserUID)
                    }else{
                        likeData[currentUserUID] = true
                        
                    }
                }else{
                    likeData[currentUserUID] = true
                    
                    
                }
                currentData.value = likeData
                
                DispatchQueue.main.async {
//                    self.boardLikeCountLabel.text = "\(currentData.childrenCount)"
                }
                return TransactionResult.success(withValue: currentData)
                
                */
            }) { (error, committed, snapshot) in
                if let error = error {
                    print("///// error 4632: \n", error.localizedDescription)
                }
            }
        }else{ // 싫어요 버튼클릭
            Database.database().reference().child("review_thumb").child(reviewKey).child("review_unlike").runTransactionBlock({[unowned self] (currentData) -> TransactionResult in
                if var post = currentData.value as? [String : Any] {
                    print("있던 없던")
                    var unlikes = post["data"] as? [String:Bool] ?? [:]
                    var unlikeCount = post["unlike_count"] as? Int ?? 0
                    
                    // 현재 리뷰 좋아요 정보에 사용자가 존재시 좋아요 취소
                    if let _ = unlikes[currentUserUID] {
                        unlikeCount -= 1
                        unlikes.removeValue(forKey: currentUserUID)
                        
                    }else{ // 존재하지 않을 경우 좋아요 추가
                        unlikeCount += 1
                        unlikes[currentUserUID] = true
                    }
                    post["data"] = unlikes
                    post["unlike_count"] = unlikeCount
                    
                    currentData.value = post
                    DispatchQueue.main.async {
                        self.reviewUnLikeLabel.text = unlikeCount.description
                    }
                    return TransactionResult.success(withValue: currentData)
                }else{
                    var post: [String : Any] = [:]
                    var unlikes: [String:Bool] = [:]
                    let unlikeCount = 1
                    unlikes[currentUserUID] = true
                    post["data"] = unlikes
                    post["unlike_count"] = unlikeCount
                    currentData.value = post
                    DispatchQueue.main.async {
                        self.reviewUnLikeLabel.text = unlikeCount.description
                    }
                    return TransactionResult.success(withValue: currentData)
                }
            
            }) { (error, committed, snapshot) in
                if let error = error {
                    print("///// error 4632: \n", error.localizedDescription)
                }
            }
            
        }
        
        print(self.reviewData?.reviewKey,"/",sender.tag)
    }
    
}


