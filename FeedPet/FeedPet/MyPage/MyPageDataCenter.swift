//
//  MyPageDataCenter.swift
//  FeedPet
//
//  Created by 샤인 on 2017. 12. 29..
//  Copyright © 2017년 HwangGisu. All rights reserved.
//

import Foundation
import Firebase

struct MyPageDataCenter {
    static var shared = MyPageDataCenter()
    
    //펫 식사 시간 알림 데이터
    var switchOnOff:[String:Bool] = ["total":false,"morning":false,"lunch":false,"dinner":false]
    var mealTime:[String:String] = ["morning":"오전 00:00","lunch":"오후 00:00","dinner":"오후 00:00"]
    var mealTimeHour:[String:Int] = ["morning":00,"lunch":00,"dinner":00]
    var mealTimeMinute:[String:Int] = ["morning":00,"lunch":00,"dinner":00]
    var mealTimeAMPM:[String:String] = ["morning":"nil","lunch":"nil","dinner":"nil"]
    
    //테스트용 유저 아이디
    let testUUID = "fUUID7aSMmPmv0nhu530oTt3434515"
    
    //유저 데이터
    
   
    
    //즐겨찾기 데이터
    var favorites = [FavoritesData]()
    var favoritesFeedKeys = [String]()
     var favoritesCount = 0
    var myPageFeedContentsCellLikeBtnTagValue:Int! //몇번 셀의 좋아요 버튼을 터치한건지 체크하기 위한 버튼태그
    
    //내 리뷰 데이터
    var myReviewKeyDatas = [MyReviewKey]()
    var myReviewDatas = [MyReview]()
    
    var reviewsCount = 0
    var myPageMyReviewsCellEditBtnTagValue:Int!
    var myPageMyReviewsCellRemoveBtnTagValue:Int!
    
    
    //탈퇴하기 내용
    var leaveMembershipReason = ""
    var leaveMembarshipEtcReasonContent = ""
}

struct userDefaultsName {   //알림 서비스에서 이용하는 유저디폴트 이름들
    static var mealTime = "mealTime"
    static var mealTimeAMPM = "mealTimeAMPM"
    static var mealTimeHour = "mealTimeHour"
    static var mealTimeMinute = "mealTimeMinute"
    static var alarmOnOff = "alarmOnOff"
    
    static var favoritesDatasCount = "favoritesDatasCount"
    static var reviewDatasCount = "reviewDatasCount"
}

struct FireBaseData{
    
    static let shared = FireBaseData()
    
    private var refBase = Database.database().reference()
    private var refUserData = Database.database().reference().child("user_data")
    private var refFeed = Database.database().reference().child("feed")
    private var refFavorites = Database.database().reference().child("favorites")
    private var refFeedReviews = Database.database().reference().child("feed_review")
    private var refMyReviews = Database.database().reference().child("my_review")
    
    var refBaseReturn:DatabaseReference{
        return refBase
    }
    var refUserDataReturn:DatabaseReference{
        return refUserData
    }
    var refFeedReturn:DatabaseReference{
        return refFeed
    }
    var refFavoritesReturn:DatabaseReference{
        return refFavorites
    }
    var refFeedReviewsReturn:DatabaseReference{
        return refFeedReviews
    }
    var refMyReviewsReturn:DatabaseReference{
        return refMyReviews
    }
    func fireBaseFavoritesDataLoad(){
        
        //나중에 밑에 차일드 유아이디 값에 로그인한 유저 값을 넣어야된다
        FireBaseData.shared.refFavorites.child(MyPageDataCenter.shared.testUUID).observe(.value, with: { (snapshot) in
            if MyPageDataCenter.shared.favorites.isEmpty == false{ //서버에서 데이터를 불러오기전 데이터를 초기화
                MyPageDataCenter.shared.favorites.removeAll()
            }
            if MyPageDataCenter.shared.favoritesFeedKeys.isEmpty == false{  //서버에서 데이터를 불러오기전 데이터를 초기화
                MyPageDataCenter.shared.favoritesFeedKeys.removeAll()
            }
            MyPageDataCenter.shared.favoritesCount = Int(snapshot.childrenCount)
            
            
            //초기화 후 다시 데이터를 담는다
            if let snapShot = snapshot.children.allObjects as? [DataSnapshot]{
                print(snapShot)
                for snap in snapShot{ //snap = 피드키:{피드정보키:피드정보값}
                    
                    if let favoritesDic = snap.value as? [String:AnyObject]{ //"feed_name" : "오가닉스",
                        let feedKey = (snap.key) //"피드키"
                        MyPageDataCenter.shared.favoritesFeedKeys.append(feedKey)
                        
                        let favorites = FavoritesData(feedKey: feedKey, feedData: favoritesDic)
                        MyPageDataCenter.shared.favorites.append(favorites)
                        
                    }
                }
            }
        })
        
        
        
    }
    
    func fireBaseMyReviewDataLoad(){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        //나중에 밑에 차일드 유아이디 값에 로그인한 유저 값을 넣어야된다
        FireBaseData.shared.refMyReviews.child(MyPageDataCenter.shared.testUUID).observe(.value, with: { (snapshot) in
            
            if MyPageDataCenter.shared.myReviewKeyDatas.isEmpty == false{ //서버에서 데이터를 불러오기전 데이터를 초기화
                MyPageDataCenter.shared.myReviewKeyDatas.removeAll()
            }
            
            MyPageDataCenter.shared.reviewsCount = Int(snapshot.childrenCount)
            
            if let snapShot = snapshot.children.allObjects as? [DataSnapshot]{
                
                for snap in snapShot{
                    
                    if let reviewKeyDic = snap.value as? [String:AnyObject]{
                        let feedKey = (snap.key)
                        let reviewData = MyReviewKey(feedKey: feedKey, reviewKeyDic: reviewKeyDic)
                        MyPageDataCenter.shared.myReviewKeyDatas.append(reviewData)
                        
                    }
                    
                }
                self.refFeedReviewsDataLoad()
            }
        })
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }

    
    func refFeedReviewsDataLoad(){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        if MyPageDataCenter.shared.myReviewDatas.isEmpty == false{ //서버에서 데이터를 불러오기전 데이터를 초기화
            MyPageDataCenter.shared.myReviewDatas.removeAll()
        }
      
        
        for myReviewData in MyPageDataCenter.shared.myReviewKeyDatas {
            FireBaseData.shared.refFeedReviews.child(myReviewData.feedKeyReturn).child("review_info").observeSingleEvent(of: .value, with: { (snapshot) in
            
                
                if let snapShot = snapshot.children.allObjects as? [DataSnapshot] {
                    print("snapapspd",snapShot)
                    for snap in snapShot{
                        if snap.key == myReviewData.reviewKeyReturn{
                            print("forin",snap)
                            let feedKey = myReviewData.feedKeyReturn
                            let reviewKey = snap.key
                            //피드 불러온다
                            if let reviewInfoDic = snap.value as? [String:AnyObject]{
                                let reviewData = MyReview(feedKey: feedKey, reviewKey: reviewKey, reviewData: reviewInfoDic) //피드 담는다
                                
                                if MyPageDataCenter.shared.myReviewDatas.isEmpty {
                                MyPageDataCenter.shared.myReviewDatas.append(reviewData)
                                }else{
                                    for i in MyPageDataCenter.shared.myReviewDatas{
                                        if feedKey != i.feedKeyReturn {
                                            MyPageDataCenter.shared.myReviewDatas.append(reviewData)
                                        }
                                    }
                                }
                               
                                
                                
                            }
                            
                            print(MyPageDataCenter.shared.myReviewDatas,"MyPageDataCenter.shared.myReviewDatas")
                        }
                        
                    }
                }
            })
            
        }
        
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}




struct FavoritesData {
    private var feedKey:String!
    private var feedBrand:String!
    private var feedName:String!
    private var feedImg:String!
    private var feedMouth:Int! //0:GOOD / 1:SOSO / 2:BAD
    private var feedIngredientKey:String!
    private var feedGrade:Int! //0:유기농 / 1:홀리스틱 / 2:슈퍼프리미엄 / 3:프리미엄 / 4:마트용
    private var feedpackingMethod:String!
    private var rating:Int! // 별 1~5개까지
    
    var feedKeyReturn:String{
        return feedKey
    }
    var feedBrandReturn:String{
        return feedBrand
    }
    var feedNameReturn:String{
        return feedName
    }
    var feedImgReturn:String{
        return feedImg
    }
    var feedMouthReturn:Int{
        return feedMouth
    }
    var feedIngredientKeyReturn:String{
        return feedIngredientKey
    }
    var feedGradeReturn:Int{
        return feedGrade
    }
    var feedpackingMethodReturn:String{
        return feedpackingMethod
    }
    var ratingReturn:Int{
        return rating
    }
    init(feedBrand:String,feedName:String,feedImg:String,feedMouth:Int,feedIngredientKey:String,feedGrade:Int,feedpackingMethod:String,rating:Int){
        
        self.feedBrand = feedBrand
        self.feedName = feedName
        self.feedImg = feedImg
        self.feedMouth = feedMouth
        self.feedIngredientKey = feedIngredientKey
        self.feedGrade = feedGrade
        self.feedpackingMethod = feedpackingMethod
        self.rating = rating
        
    }
    init(feedKey:String, feedData:[String:AnyObject]){
        self.feedKey = feedKey

        if let feedBrand = feedData["feed_brand_key"]{
            self.feedBrand = feedBrand as? String
        }
        
        if let feedName = feedData["feed_name"]{
            self.feedName = feedName as? String
        }
        if let feedImg = feedData["feed_Image"]{
            self.feedImg = feedImg as? String
        }
        if let feedMouth = feedData["feed_mouth"]{
            self.feedMouth = feedMouth as? Int
        }
        if let feedIngredientKey = feedData["feed_ingredient_key"]{
            self.feedIngredientKey = feedIngredientKey as? String
        }
        if let feedGrade = feedData["feed_grade"]{
            self.feedGrade = feedGrade as? Int
        }
        if let feedpackingMethod = feedData["packing_method"]{
            self.feedpackingMethod = feedpackingMethod as? String
        }
        
        if let rating = feedData["rating"]{
            self.rating = rating as? Int
        }
        
    }
    
}


struct MyReview {
    private var feedKey:String!
    private var reviewKey:String!
    private var userKey:String!
    private var feedRating:Int!
    private var feedReview:String!
    private var feedDate:String!

    
    
    var feedKeyReturn:String{
        return feedKey
    }
    var reviewKeyReturn:String{
        return reviewKey
    }
    var userKeyReturn:String{
        return userKey
    }
    var feedRatingReturn:Int{
        return feedRating
    }
    var feedReviewReturn:String{
        return feedReview
    }
    var feedDateReturn:String{
        return feedDate
    }
   
    
    mutating func reviewContentUpdeter(newContent:String){
        self.feedReview = newContent
    }
    
    init(feedKey:String,reviewKey:String,userKey:String,feedRating:Int,feedReview:String,feedDate:String){
        
        self.feedKey = feedKey
        self.reviewKey = reviewKey
        self.userKey = userKey
        self.feedRating = feedRating
        self.feedReview = feedReview
        self.feedDate = feedDate
       
        
    }
 
    
    init(feedKey:String, reviewKey:String, reviewData:[String:AnyObject]){
        self.feedKey = feedKey
        self.reviewKey = reviewKey
       
        
        if let userKey = reviewData["user_key"]{
            self.userKey = userKey as? String
        }
        if let feedRating = reviewData["feed_rating"]{
            self.feedRating = feedRating as? Int
        }
        if let feedReview = reviewData["feed_review"]{
            self.feedReview = feedReview as? String
        }
        if let feedDate = reviewData["feed_date"]{
            self.feedDate = feedDate as? String
        }
        
       
    }
    
}

struct MyReviewKey {
    private var feedKey:String!
    private var reviewKey:String!
    
    var feedKeyReturn:String{
        return feedKey
    }
    var reviewKeyReturn:String{
        return reviewKey
    }
    init(feedKey:String,reviewKeyDic:[String:AnyObject]) {
        self.feedKey = feedKey
        if let reviewKey = reviewKeyDic["review_key"]{
            self.reviewKey = reviewKey as? String
        }
    }
}




