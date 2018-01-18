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
    
    //탈퇴하기 내용
    var leaveMembershipReason = ""
    var leaveMembarshipEtcReasonContent = ""
    
    //즐겨찾기 데이터
    var favorites = [FavoritesData]()
    var favoritesFeedKeys = [String]()
    var myPageFeedContentsCellLikeBtnTagValue:Int! //몇번 셀의 좋아요 버튼을 터치한건지 체크하기 위한 버튼태그
    
    //내 리뷰 데이터
    var reviews = [ReviewsData]()
    var reviewsFeedKeys = [String]()
    var myPageMyReviewsCellEditBtnTagValue:Int!
    var myPageMyReviewsCellRemoveBtnTagValue:Int!
}

struct userDefaultsName {   //알림 서비스에서 이용하는 유저디폴트 이름들
    static var mealTime = "mealTime"
    static var mealTimeAMPM = "mealTimeAMPM"
    static var mealTimeHour = "mealTimeHour"
    static var mealTimeMinute = "mealTimeMinute"
    static var alarmOnOff = "alarmOnOff"
}

struct FireBaseData{
    
    static let shared = FireBaseData()
    
    private var refBase = Database.database().reference()
    private var refFeed = Database.database().reference().child("feed")
    private var refFavorites = Database.database().reference().child("favorites")
    private var refReviews = Database.database().reference().child("reviews")
    
    var refBaseReturn:DatabaseReference{
        return refBase
    }
    var refFeedReturn:DatabaseReference{
        return refFeed
    }
    var refFavoritesReturn:DatabaseReference{
        return refFavorites
    }
    var refReviewsReturn:DatabaseReference{
        return refReviews
    }
    
    func fireBaseFavoritesDataLoad(){
        
        //나중에 밑에 차일드 유아이디 값에 로그인한 유저 값을 넣어야된다
        FireBaseData.shared.refFavoritesReturn.child(MyPageDataCenter.shared.testUUID).observeSingleEvent(of: .value, with: { (snapshot) in  //페이보릿안의 유저아이디키 작성해서 들어가는데 아예 페이보릿 값이 없거나 현재로그인 유저키값이 없으면 어떻게 될까? 시뮬레이터테스트는 이상 없었다 파이어베이스에서 닐값처리 해주나보다
            if MyPageDataCenter.shared.favorites.isEmpty == false{ //서버에서 데이터를 불러오기전 데이터를 초기화
                MyPageDataCenter.shared.favorites.removeAll()
            }
            if MyPageDataCenter.shared.favoritesFeedKeys.isEmpty == false{  //서버에서 데이터를 불러오기전 데이터를 초기화
                MyPageDataCenter.shared.favoritesFeedKeys.removeAll()
            }
            //초기화 후 다시 데이터를 담는다
            if let snapShot = snapshot.children.allObjects as? [DataSnapshot]{
                
                for snap in snapShot{
                    
                    if let favoritesDic = snap.value as? [String:AnyObject]{
                        let feedKey = (snap.key)
                        MyPageDataCenter.shared.favoritesFeedKeys.append(feedKey)
                        
                        let favorites = FavoritesData(feedKey: feedKey, feedData: favoritesDic)
                        MyPageDataCenter.shared.favorites.append(favorites)
                       
                        
                        
                    }
                    print("favoritesConut",MyPageDataCenter.shared.favorites.count)
                   
                }
            }
        })
        
        print("DataCenter",MyPageDataCenter.shared.favorites)
    }
    
    func fireBaseReviewsDataLoad(){
        
        //나중에 밑에 차일드 유아이디 값에 로그인한 유저 값을 넣어야된다
        FireBaseData.shared.refReviewsReturn.child(MyPageDataCenter.shared.testUUID).observeSingleEvent(of: .value, with: { (snapshot) in
           
            if MyPageDataCenter.shared.reviews.isEmpty == false{ //서버에서 데이터를 불러오기전 데이터를 초기화
                MyPageDataCenter.shared.reviews.removeAll()
            }
            if MyPageDataCenter.shared.reviewsFeedKeys.isEmpty == false{  //서버에서 데이터를 불러오기전 데이터를 초기화
                MyPageDataCenter.shared.reviewsFeedKeys.removeAll()
            }
            //초기화 후 다시 데이터를 담는다
            if let snapShot = snapshot.children.allObjects as? [DataSnapshot]{
                
                for snap in snapShot{
                    
                    if let reviewsDic = snap.value as? [String:AnyObject]{
                        let feedKey = (snap.key)
                        MyPageDataCenter.shared.reviewsFeedKeys.append(feedKey)
                        
                        let reviews = ReviewsData(feedKey: feedKey, reviewData: reviewsDic)
                        MyPageDataCenter.shared.reviews.append(reviews)
                        
                    }
                    print("reviewsCount",MyPageDataCenter.shared.reviews.count)
                    
                }
            }
        })
        
        print("DataCenter",MyPageDataCenter.shared.favorites)
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


struct ReviewsData {
    private var feedKey:String!
    private var feedBrand:String!
    private var feedName:String!
    private var feedImg:String!
    private var writeDate:String!
    private var reviewContent:String!
    private var reviewGoods:Int!
    private var reviewNotGoods:Int!
    private var rating:Int!
    
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
    var writeDateReturn:String{
        return writeDate
    }
    var reviewContentReturn:String{
        return reviewContent
    }
    var reviewGoodsReturn:Int{
        return reviewGoods
    }
    var reviewNotGoodsReturn:Int{
        return reviewNotGoods
    }
    var ratingReturn:Int{
        return rating
    }

    mutating func reviewContentUpdeter(newContent:String){
        self.reviewContent = newContent
    }
    
    init(feedBrand:String,feedName:String,feedImg:String,writeDate:String,reviewContent:String,reviewGoods:Int,reviewNotGoods:Int,rating:Int){
        
        self.feedBrand = feedBrand
        self.feedName = feedName
        self.feedImg = feedImg
        self.writeDate = writeDate
        self.reviewContent = reviewContent
        self.reviewGoods = reviewGoods
        self.reviewNotGoods = reviewNotGoods
        self.rating = rating
    }
    
    init(feedKey:String, reviewData:[String:AnyObject]){
        self.feedKey = feedKey
        
        if let feedBrand = reviewData["feed_brand_key"]{
            self.feedBrand = feedBrand as? String
        }
        if let feedName = reviewData["feed_name"]{
            self.feedName = feedName as? String
        }
        if let feedImg = reviewData["feed_Image"]{
            self.feedImg = feedImg as? String
        }
        if let writeDate = reviewData["write_date"]{
            self.writeDate = writeDate as? String
        }
        if let reviewContent = reviewData["review_content"]{
            self.reviewContent = reviewContent as? String
        }
        if let reviewGoods = reviewData["review_goods"]{
            self.reviewGoods = reviewGoods as? Int
        }
        if let reviewNotGoods = reviewData["review_not_goods"]{
            self.reviewNotGoods = reviewNotGoods as? Int
        }
        if let rating = reviewData["rating"]{
            self.rating = rating as? Int
        }
        
    }
    
}


