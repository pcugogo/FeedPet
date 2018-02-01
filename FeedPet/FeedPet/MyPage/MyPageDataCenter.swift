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
    
    //테스트 유저 정보
    let testUUID = "fUUID7aSMmPmv0nhu530oTt3434515"
    var userEmail = ""
    var userNicName = ""
    var userImg = ""
    var petAge = 0
    var petType = "functional_petkey_d"
    var loadPetFunctionKey = ["indoor","immune","performance"]
    //즐겨찾기 데이터
    var favorites = [FavoritesData]()
    var favoritesCount = 0
    var myPageFeedContentsCellLikeBtnTagValue:Int! //몇번 셀의 좋아요 버튼을 터치한건지 체크하기 위한 버튼태그
    
    //내 리뷰 데이터
    var myReviewKeyDatas = [MyReviewKey]()
    var myReviewDatas = [MyReview]()
    
    var reviewsCount = 0
    var myPageMyReviewsCellEditBtnTagValue:Int!
    var myPageMyReviewsCellRemoveBtnTagValue:Int!
    
    var reviewThumbDatas = [ReviewThumb]()
    
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
    private var refUserInfo = Database.database().reference().child("user_info")
    private var refFeed = Database.database().reference().child("feed")
    private var refFavorites = Database.database().reference().child("my_favorite")
    private var refFeedReviews = Database.database().reference().child("feed_review")
    private var refMyReviews = Database.database().reference().child("my_review")
    private var refFeedInfo = Database.database().reference().child("feed_info")
    private var refReviewThumb = Database.database().reference().child("review_thumb")
    
    var refBaseReturn:DatabaseReference{
        return refBase
    }
    var refUserInfoReturn:DatabaseReference{
        return refUserInfo
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
    var refFeedInfoReturn:DatabaseReference{
        return refFeedInfo
    }
    var refReviewThumbReturn:DatabaseReference{
        return refReviewThumb
    }
    func fireBaseUserInfoDataLoad(){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        FireBaseData.shared.refUserInfoReturn.child(MyPageDataCenter.shared.testUUID).observeSingleEvent(of: .value, with: { (snapshot) in
            if let userInfoSnapshot = snapshot.value as? [String:AnyObject]{
                for userInfoSnap in userInfoSnapshot{
                    
                    if userInfoSnap.key == "user_email"{
                        if let userEmail = userInfoSnap.value as? String{
                            MyPageDataCenter.shared.userEmail = userEmail
                        }
                    }
                    if userInfoSnap.key == "user_nic"{
                        if let userNicName = userInfoSnap.value as? String{
                            MyPageDataCenter.shared.userNicName = userNicName
                        }
                    }
                    if userInfoSnap.key == "user_img"{
                        if let userImg = userInfoSnap.value as? String{
                            MyPageDataCenter.shared.userImg = userImg
                        }
                    }
                    if userInfoSnap.key == "user_pet_age"{
                        if let petAge = userInfoSnap.value as? Int{
                            
                            MyPageDataCenter.shared.petAge = petAge
                        }
                    }
                    
                    if userInfoSnap.key == "user_pet"{
                        if let petType = userInfoSnap.value as? String{
                            MyPageDataCenter.shared.petType = petType
                           
                        }
                    }
                    
                    
                    if userInfoSnap.key == "user_pet_funtional"{
                        if let petFuntion = userInfoSnap.value as? [String]{
                            MyPageDataCenter.shared.loadPetFunctionKey = petFuntion
                            print(petFuntion,"petFuntion")
                        }
                    }
                }
            }
        })
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    func fireBaseFavoritesDataLoad(){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        //나중에 밑에 차일드 유아이디 값에 로그인한 유저 값을 넣어야된다
        FireBaseData.shared.refFavorites.child(MyPageDataCenter.shared.testUUID).observeSingleEvent(of: .value, with: { (snapshot) in
            if MyPageDataCenter.shared.favorites.isEmpty == false{ //서버에서 데이터를 불러오기전 데이터를 초기화
                MyPageDataCenter.shared.favorites.removeAll()
            }
            
            MyPageDataCenter.shared.favoritesCount = Int(snapshot.childrenCount)
            
            if let snapShot = snapshot.children.allObjects as? [DataSnapshot]{
                
                
                for snap in snapShot{
                    
                    
                    let favoriteKey = (snap.key)
                    var feedKey:String!
                    var feedImg:[String]!
                    var feedBrand:String!
                    var feedName:String!
                    var feedMouth:String!
                    var feedIngredient:String!
                    var feedGrade:Int!
                    var feedPackageFlag:Bool!
                    var feedRating = 5
                    var numberOfReview = 0
                    var addToFavoritesDate:String!
 
                    if let favoriteDatas = snap.value as? [String:AnyObject] {
                        print(favoriteDatas,"favoriteDatas")
                        for favoriteData in favoriteDatas{
                            if favoriteData.key == "feed_key"{
                                if let feedKeyData = favoriteData.value as? String{
                                    feedKey = feedKeyData
                                    print(feedKeyData,"feed_key")
                                }
                            }
                            if favoriteData.key == "favorites_date"{
                                if let faviritesDate = favoriteData.value as? String {
                                    addToFavoritesDate = faviritesDate
                                    print(faviritesDate,"favorites_date")
                                }
                            }
                        }
                        
                        
                        
                        FireBaseData.shared.refFeedInfo.child("feed_petkey_d").child(feedKey).observeSingleEvent(of: .value, with: { (feedInfoSnapshot) in
                            if let feedSnapshot = feedInfoSnapshot.children.allObjects as? [DataSnapshot]{
                                for feedSnap in feedSnapshot {
                                    print(feedSnap,"favoriteDog")
                                    
                                    if feedSnap.key == "feed_img"{
                                        feedImg = feedSnap.value as! [String]
                                    }
                                    if feedSnap.key == "feed_brand"{
                                        feedBrand = feedSnap.value as! String
                                    }
                                    if feedSnap.key == "feed_name"{
                                        feedName = feedSnap.value as! String
                                    }
                                    if feedSnap.key == "feed_mouth"{
                                        feedMouth = feedSnap.value as! String
                                    }
                                    if feedSnap.key == "feed_ingredient"{
                                        feedIngredient = feedSnap.value as! String
                                    }
                                    if feedSnap.key == "feed_grade"{
                                        feedGrade = feedSnap.value as! Int
                                    }
                                    if feedSnap.key == "feed_package_flag"{
                                        feedPackageFlag = feedSnap.value as! Bool
                                    }
                                }
                            }
                            
                            FireBaseData.shared.refFeedReviews.child(feedKey).observeSingleEvent(of: .value, with: { (reviewSnapshot) in
                                if let reviewSnaps = reviewSnapshot.value as? [String:AnyObject]{
                                    for reviewSnap in reviewSnaps{
                                        if reviewSnap.key == "review_rating"{
                                            if let rating = reviewSnap.value as? Int {
                                                feedRating = rating
                                            }
                                        }
                                        if reviewSnap.key == "review_info"{
                                            if let reviewInfo = reviewSnap.value as? [String:AnyObject]{
                                                numberOfReview = reviewInfo.keys.count
                                            }
                                        }
                                    }
                                }
                                let favorites = FavoritesData(favoriteKey: favoriteKey, feedKey: feedKey, feedImg: feedImg, feedBrand: feedBrand, feedName: feedName, feedMouth: feedMouth, feedIngredient: feedIngredient, feedGrade: feedGrade, feedPackageFlag: feedPackageFlag, feedRating: feedRating, numberOfReview: numberOfReview, addToFavoritesDate: addToFavoritesDate)
                                
                                MyPageDataCenter.shared.favorites.append(favorites)
                                
                               
                                
                                MyPageDataCenter.shared.favorites.sort { (data: FavoritesData, data2: FavoritesData) -> Bool in
                                    // you can have additional code here
                                    return data.addToFavoritesDateReturn > data2.addToFavoritesDateReturn
                                }
                                
                            })
                            
                        })//여기까지 강아지일때 피드값
                        //여기부터 고양이
                        FireBaseData.shared.refFeedInfo.child("feed_petkey_c").child(feedKey).observeSingleEvent(of: .value, with: { (feedInfoSnapshot) in
                            if let feedSnapshot = feedInfoSnapshot.children.allObjects as? [DataSnapshot]{
                                for feedSnap in feedSnapshot {
                                    print(feedSnap,"favoriteCat")
                                    
                                    if feedSnap.key == "feed_img"{
                                        feedImg = feedSnap.value as! [String]
                                    }
                                    if feedSnap.key == "feed_brand"{
                                        feedBrand = feedSnap.value as! String
                                    }
                                    if feedSnap.key == "feed_name"{
                                        feedName = feedSnap.value as! String
                                    }
                                    if feedSnap.key == "feed_mouth"{
                                        feedMouth = feedSnap.value as! String
                                    }
                                    if feedSnap.key == "feed_ingredient"{
                                        feedIngredient = feedSnap.value as! String
                                    }
                                    if feedSnap.key == "feed_grade"{
                                        feedGrade = feedSnap.value as! Int
                                    }
                                    if feedSnap.key == "feed_package_flag"{
                                        feedPackageFlag = feedSnap.value as! Bool
                                    }
                                }
                            }
                            
                            FireBaseData.shared.refFeedReviews.child(feedKey).observeSingleEvent(of: .value, with: { (reviewSnapshot) in
                                if let reviewSnaps = reviewSnapshot.value as? [String:AnyObject]{
                                    for reviewSnap in reviewSnaps{
                                        if reviewSnap.key == "review_rating"{
                                            if let rating = reviewSnap.value as? Int {
                                                feedRating = rating
                                            }
                                        }
                                        if reviewSnap.key == "review_info"{
                                            if let reviewInfo = reviewSnap.value as? [String:AnyObject]{
                                                numberOfReview = reviewInfo.keys.count
                                            }
                                        }
                                    }
                                }
                                let favorites = FavoritesData(favoriteKey: favoriteKey, feedKey: feedKey, feedImg: feedImg, feedBrand: feedBrand, feedName: feedName, feedMouth: feedMouth, feedIngredient: feedIngredient, feedGrade: feedGrade, feedPackageFlag: feedPackageFlag, feedRating: feedRating, numberOfReview: numberOfReview, addToFavoritesDate: addToFavoritesDate)
                                
                                MyPageDataCenter.shared.favorites.append(favorites)
                                
                                MyPageDataCenter.shared.favorites.sort { (data: FavoritesData, data2: FavoritesData) -> Bool in
                                   
                                    return data.addToFavoritesDateReturn > data2.addToFavoritesDateReturn
                                }
                                
                                
                            })
                            
                        })//여기 까지 고양이일때 피드값
                        
                    }
                    
                }
            }
           
        })
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        
       
    }
    
    func fireBaseMyReviewDataLoad(){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        //나중에 밑에 차일드 유아이디 값에 로그인한 유저 값을 넣어야된다
        FireBaseData.shared.refMyReviews.child(MyPageDataCenter.shared.testUUID).observeSingleEvent(of: .value, with: { (snapshot) in
            
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
                self.fireBaseFeedReviewsDataLoad()
                self.FireBaseReviewThumbDataLoad()
            }
        })
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    
    func fireBaseFeedReviewsDataLoad(){
        
        if MyPageDataCenter.shared.myReviewDatas.isEmpty == false{ //서버에서 데이터를 불러오기전 데이터를 초기화
            MyPageDataCenter.shared.myReviewDatas.removeAll()
        }
        
        
        for myReviewData in MyPageDataCenter.shared.myReviewKeyDatas {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            FireBaseData.shared.refFeedReviews.child(myReviewData.feedKeyReturn).child("review_info").child(myReviewData.reviewKeyReturn).observeSingleEvent(of: .value, with: { (snapshot) in
                
                
                if let snapShot = snapshot.value as? [String:AnyObject] {
                    
                            let feedKey = myReviewData.feedKeyReturn
                            let reviewKey = myReviewData.reviewKeyReturn
                            var feedName:String!
                            var feedBrand:String!
                            var feedImg:[String]!
                    
                    FireBaseData.shared.refFeedInfo.child("feed_petkey_d").child(feedKey).observeSingleEvent(of: .value, with: { (feedInfoSnapshot) in
                        if let feedSnapshot = feedInfoSnapshot.children.allObjects as? [DataSnapshot]{
                            print(feedSnapshot,"")
                            for feedSnap in feedSnapshot{
                                if feedSnap.key == "feed_name"{
                                    feedName = feedSnap.value as! String
                                }
                                if feedSnap.key == "feed_brand"{
                                    feedBrand = feedSnap.value as! String
                                }
                                if feedSnap.key == "feed_img"{
                                    feedImg = feedSnap.value as? [String]
                                }
                            }

                        }
                        guard let notEmptyFeedName = feedName,let notEmptyFeedBrand = feedBrand,let notEmptyfeedImg = feedImg else{return}
                        
                        let reviewData = MyReview(feedKey: feedKey, reviewKey: reviewKey, feedName: notEmptyFeedName, feedBrand: notEmptyFeedBrand, feedImg: notEmptyfeedImg, reviewData: snapShot)

                        MyPageDataCenter.shared.myReviewDatas.append(reviewData)
                        MyPageDataCenter.shared.myReviewDatas.sort { (data: MyReview, data2: MyReview) -> Bool in
                            // you can have additional code here
                            return data.feedDateReturn > data2.feedDateReturn
                        }
                    })//여기까지 강아지피드데이터에서 값가져오기
                    
                            FireBaseData.shared.refFeedInfo.child("feed_petkey_c").child(feedKey).observeSingleEvent(of: .value, with: { (feedInfoSnapshot) in
                                if let feedSnapshot = feedInfoSnapshot.children.allObjects as? [DataSnapshot]{
                                    
                                    for feedSnap in feedSnapshot{
                                        if feedSnap.key == "feed_name"{
                                            feedName = feedSnap.value as! String
                                        }
                                        if feedSnap.key == "feed_brand"{
                                            feedBrand = feedSnap.value as! String
                                        }
                                        if feedSnap.key == "feed_img"{
                                            feedImg = feedSnap.value as? [String]
                                        }
                                    }
                                    
                                }

                                guard let notEmptyFeedName = feedName,let notEmptyFeedBrand = feedBrand,let notEmptyfeedImg = feedImg else{return}
                                
                                let reviewData = MyReview(feedKey: feedKey, reviewKey: reviewKey, feedName: notEmptyFeedName, feedBrand: notEmptyFeedBrand, feedImg: notEmptyfeedImg, reviewData: snapShot)
                                
                                MyPageDataCenter.shared.myReviewDatas.append(reviewData)
                                MyPageDataCenter.shared.myReviewDatas.sort { (data: MyReview, data2: MyReview) -> Bool in
                                    
                                    return data.feedDateReturn > data2.feedDateReturn
                                }
                            })//여기까지 고양이 피드데이터에서 값가져오기
                    
        
                }
            })
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
        
        
        
    }
    
    func FireBaseReviewThumbDataLoad(){
        
        for reviewKeyData in MyPageDataCenter.shared.myReviewKeyDatas{
            var reviewLike = 0
            var reviewUnLike = 0
            FireBaseData.shared.refReviewThumb.child(reviewKeyData.reviewKeyReturn).runTransactionBlock({ (reviewThumbSnapshot) -> TransactionResult in
                if let reviewThumbSnap = reviewThumbSnapshot.value as? [String:AnyObject]{
                    for thumbSnap in reviewThumbSnap{
                        if thumbSnap.key == "review_like"{
                            if let likeSnap = thumbSnap.value as? [String:AnyObject]{
                                reviewLike = likeSnap.keys.count
                            }
                        }
                        if thumbSnap.key == "review_unlike"{
                            if let unLikeSnap = thumbSnap.value as? [String:AnyObject]{
                                reviewUnLike = unLikeSnap.keys.count
                            }
                        }
                        
                    }
                    let thumbData = ReviewThumb(reviewKey: reviewKeyData.reviewKeyReturn, numberOfLike: reviewLike, numberOfUnLike: reviewUnLike)
                    MyPageDataCenter.shared.reviewThumbDatas.append(thumbData)
                }
                
                
                return TransactionResult.success(withValue: reviewThumbSnapshot)
            })
        }
    }
    
}




struct FavoritesData {
    private var favoriteKey:String!
    private var feedKey:String!
    private var feedBrand:String!
    private var feedName:String!
    private var feedImg:String!
    private var feedMouth:String! //MOUTH_G : GOOD / MOUTH_S : SOSO /  MOUTH_B : BAD
    private var feedIngredient:String!
    private var feedGrade:Int! //0:유기농 / 1:홀리스틱 / 2:슈퍼프리미엄 / 3:프리미엄 / 4:마트용
    private var feedPackageFlag:Bool!
    private var rating:Int! // 별 1~5개까지
    private var numberOfReview:Int!
    private var addToFavoritesDate:String!
    
    var favoriteKeyReturn:String{
        return favoriteKey
    }
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
    var feedMouthReturn:String{
        return feedMouth
    }
    var feedIngredientReturn:String{
        return feedIngredient
    }
    var feedGradeReturn:Int{
        return feedGrade
    }
    var feedPackageFlagReturn:Bool{
        return feedPackageFlag
    }
    var ratingReturn:Int{
        return rating
    }
    var numberOfReviewReturn:Int{ //총 리뷰 갯수
        return numberOfReview
    }
    var addToFavoritesDateReturn:String{
        return addToFavoritesDate
    }
    
    init(favoriteKey:String,feedKey:String,feedImg:[String],feedBrand:String,feedName:String,feedMouth:String,feedIngredient:String,feedGrade:Int,feedPackageFlag:Bool!,feedRating:Int,numberOfReview:Int,addToFavoritesDate:String){
        self.favoriteKey = favoriteKey
        self.feedKey = feedKey
        self.feedBrand = feedBrand
        self.feedImg = feedImg[0]
        self.feedName = feedName
        self.feedMouth = feedMouth
        self.feedIngredient = feedIngredient
        self.feedGrade = feedGrade
        self.feedPackageFlag = feedPackageFlag
        self.rating = feedRating
        self.numberOfReview = numberOfReview
        self.addToFavoritesDate = addToFavoritesDate
    }
    
}


struct MyReview {
    private var feedKey:String!
    private var reviewKey:String!
    private var userKey:String!
    private var feedRating:Int!
    private var feedReview:String!
    private var feedDate:String!
    private var feedName:String!
    private var feedBrand:String!
    private var feedImg:[String]!
//    private var reviewLike:Int!
//    private var reviewUnLike:Int!
    
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
    var feedNameReturn:String{
        return feedName
    }
    var feedBrandReturn:String{
        return feedBrand
    }
    var feedImgReturn:[String]{
        return feedImg
    }
//    var reviewLikeReturn:Int{
//        return reviewLike
//    }
//    var reviewUnLikeReturn:Int{
//        return reviewUnLike
//    }
    //    mutating func reviewContentUpdeter(newContent:String){
    //        self.feedReview = newContent
    //    }
    
    init(feedKey:String, reviewKey:String,feedName:String,feedBrand:String,feedImg:[String], reviewData:[String:AnyObject]){
        self.feedKey = feedKey
        self.reviewKey = reviewKey
        self.feedName = feedName
        self.feedBrand = feedBrand
        self.feedImg = feedImg
//        self.reviewLike = reviewLike
//        self.reviewUnLike = reviewUnLike
        
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
struct ReviewThumb {
    private var reviewKey:String!
    private var numberOfLike:Int!
    private var numberOfUnLike:Int!
    
    var reviewKeyReturn:String{
        return reviewKey
    }
    var numberOfLikeReturn:Int{
        return numberOfLike
    }
    
    var numberOfUnLikeReturn:Int{
        return numberOfUnLike
    }
    init(reviewKey:String,numberOfLike:Int,numberOfUnLike:Int) {
        self.reviewKey = reviewKey
        self.numberOfLike = numberOfLike
        self.numberOfUnLike = numberOfUnLike
    }
}

