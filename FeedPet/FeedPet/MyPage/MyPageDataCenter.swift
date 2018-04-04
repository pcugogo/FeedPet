//
//  MyPageDataCenter.swift
//  FeedPet
//
//  Created by 샤인 on 2017. 12. 29..
//  Copyright © 2017년 HwangGisu. All rights reserved.
//

import Foundation
import Firebase

class MyPageDataCenter {
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
    var favoriteReviewInfoDatas = [FavoriteReviewInfoData]()
    //내 리뷰 데이터
    var myReviewKeyDatas = [MyReviewKey]()
    var myReviewDatas = [MyReview]()
    
    var reviewsCount = 0
    var myPageMyReviewsCellEditBtnTagValue:Int!
    var myPageMyReviewsCellRemoveBtnTagValue:Int!
    
    var reviewThumbDatas = [ReviewThumb]()
    
    //성분분석 데이터
    var feedIngredientGoodDatas = [FeedIngredientGood]()
    var feedIngredientWarningDatas = [FeedIngredientWarning]()
    
    //탈퇴하기 내용
    var leaveMembershipReason = ""
    var leaveMembarshipEtcReasonContent = ""
    
}

struct userDefaultsName {   //알림 서비스에서 이용하는 유저디폴트 이름들
    static let mealTime = "mealTime"
    static let mealTimeAMPM = "mealTimeAMPM"
    static let mealTimeHour = "mealTimeHour"
    static let mealTimeMinute = "mealTimeMinute"
    static let alarmOnOff = "alarmOnOff"
    
    static let favoritesDatasCount = "favoritesDatasCount"
    static let reviewDatasCount = "reviewDatasCount"
}

struct FireBaseData{
    
    static let shared = FireBaseData()
    
    private let refBase = Database.database().reference()
    private let refUserInfo = Database.database().reference().child("user_info")
    private let refFeed = Database.database().reference().child("feed")
    private let refFavorites = Database.database().reference().child("my_favorite")
    private let refFeedReviews = Database.database().reference().child("feed_review")
    private let refMyReviews = Database.database().reference().child("my_review")
    private let refFeedInfo = Database.database().reference().child("feed_info")
    private let refReviewThumb = Database.database().reference().child("review_thumb")
    private let refFeedIngredientGood = Database.database().reference().child("feed_ingredient").child("ingredient_key_g")
    private let refFeedIngredientWarning = Database.database().reference().child("feed_ingredient").child("ingredient_key_w")
    
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
    var refFeedIngredientGoodReturn:DatabaseReference{
        return refFeedIngredientGood
    }
    var refFeedIngredientWarningReturn:DatabaseReference{
        return refFeedIngredientWarning
    }
    
    func fireBaseUserInfoDataLoad(){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        print("LOAD uid://",UserDefaults.standard.string(forKey: "userUID") )
        guard let userUID = UserDefaults.standard.string(forKey: "userUID") else { return }
        
        
        FireBaseData.shared.refUserInfoReturn.child(userUID).observeSingleEvent(of: .value, with: { (snapshot) in
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
                            
                        }
                    }
                }
            }
        })
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func fireBaseUserInfoLoadData(userUID: String, completion: @escaping (User)->Void){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        
        FireBaseData.shared.refUserInfoReturn.child(userUID).observeSingleEvent(of: .value, with: { (snapshot) in
            if let userInfoSnapshot = snapshot.value as? [String:Any]{
                print("조회한 유저데이터://,",userInfoSnapshot)
                let userInfo = User(allInfoData: userInfoSnapshot)
                print("조회한 유저데이터2://,",userInfo)
                completion(userInfo)
                
            }
        })
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    // 닉네임 중복 체크 메서드
    func nicNameDoubleChek(nickName: String, completion: @escaping (Bool)->Void){
        
        Database.database().reference().child("user_profiles").queryOrdered(byChild: "nickName").queryEqual(toValue: nickName).observeSingleEvent(of: .value, with: { (snapShot) in
            
            if let snapDict = snapShot.value as? [String:AnyObject]{
                print(snapDict)
                completion(true)
            }else{
                completion(false)
            }
        }, withCancel: {(Err) in
            
            print(Err.localizedDescription)
            
        })
    }
    
    
    func fireBaseFavoritesDataLoad(){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        guard let useruid = Auth.auth().currentUser?.uid else {return}
        FireBaseData.shared.refFavorites.child(useruid).observeSingleEvent(of: .value, with: { (snapshot) in
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
                    var addToFavoritesDate:String!
                    
                    if let favoriteDatas = snap.value as? [String:AnyObject] {
                       
                        for favoriteData in favoriteDatas{
                            if favoriteData.key == "feed_key"{
                                if let feedKeyData = favoriteData.value as? String{
                                    feedKey = feedKeyData 
                                }
                            }
                            if favoriteData.key == "favorites_date"{
                                if let faviritesDate = favoriteData.value as? String {
                                    addToFavoritesDate = faviritesDate
                                }
                            }
                        }
                        
                        
                        
                        FireBaseData.shared.refFeedInfo.child("feed_petkey_d").child(feedKey).observeSingleEvent(of: .value, with: { (feedInfoSnapshot) in
                            if let feedSnapshot = feedInfoSnapshot.children.allObjects as? [DataSnapshot]{
                                for feedSnap in feedSnapshot {
                                    
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
                            
                        })//여기까지 강아지일때 피드값
                        
                        
                        //여기부터 고양이
                        FireBaseData.shared.refFeedInfo.child("feed_petkey_c").child(feedKey).observeSingleEvent(of: .value, with: { (feedInfoSnapshot) in
                            if let feedSnapshot = feedInfoSnapshot.children.allObjects as? [DataSnapshot]{
                                for feedSnap in feedSnapshot {
                                    
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
                                guard let notEmptyFeedKey = feedKey,let notEmptyFeedImg = feedImg,let notEmptyFeedBrand = feedBrand,let notEmptyFeedName = feedName,let notEmptyFeedMouth = feedMouth,let notEmptyFeedIngredient = feedIngredient, let notEmptyFeedGrade = feedGrade,let notEmptyFeedPackageFlag = feedPackageFlag,let notEmptyAddToFavoritesDate = addToFavoritesDate  else{return}
                                
                                let favorites = FavoritesData(favoriteKey: favoriteKey, feedKey: notEmptyFeedKey, feedImg: notEmptyFeedImg, feedBrand: notEmptyFeedBrand, feedName: notEmptyFeedName, feedMouth: notEmptyFeedMouth, feedIngredient: notEmptyFeedIngredient, feedGrade: notEmptyFeedGrade, feedPackageFlag: notEmptyFeedPackageFlag,addToFavoritesDate: notEmptyAddToFavoritesDate)
                                
                                MyPageDataCenter.shared.favorites.append(favorites)
                                
                                MyPageDataCenter.shared.favorites.sort { (data: FavoritesData, data2: FavoritesData) -> Bool in
                                    return data.addToFavoritesDateReturn > data2.addToFavoritesDateReturn
                                }
                                
                            }
                            
                            self.favoriteReviewData()
                            
                        })//여기 까지 고양이일때 피드값
                        
                    }
                    
                }
                
            }
            
        })
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
    }
    
    func favoriteReviewData(){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        for favorite in MyPageDataCenter.shared.favorites{
            print(favorite,"favoo")
            FireBaseData.shared.refFeedReviews.child(favorite.feedKeyReturn).observeSingleEvent(of: .value, with: { (reviewSnapshot) in
                print(reviewSnapshot,"ssamdlas,")
                let feedKey = favorite.feedKeyReturn
                var feedRating = 5
                var numberOfReview = 0
                if let reviewSnaps = reviewSnapshot.value as? [String:AnyObject]{
                    for reviewSnap in reviewSnaps{
                        print(reviewSnap,"asd")
                        if reviewSnap.key == "review_rating"{
                            if let rating = reviewSnap.value as? Int {
                                feedRating = rating
                            }
                        }
                        if reviewSnap.key == "review_info"{
                             print(reviewSnap.value,"ccccount1")
                            if let reviewInfo = reviewSnap.value as? [String:AnyObject]{
                                numberOfReview = reviewInfo.keys.count
                                print(reviewInfo.keys.count,"ccccount")
                            }
                        }
                    }
                    let reviewInfoData = FavoriteReviewInfoData(feedKey: feedKey, feedRating: feedRating, numberOfReview: numberOfReview)
                    MyPageDataCenter.shared.favoriteReviewInfoDatas.append(reviewInfoData)
                }
                
                
            })
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    // 마이페이지 데이터 클로져 작업중 --2018.04.03
    func fireBaseMyReviewDataOnLoad(completion: @escaping (Bool)->Void){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        //나중에 밑에 차일드 유아이디 값에 로그인한 유저 값을 넣어야된다
        guard let useruid = Auth.auth().currentUser?.uid else {return}
        FireBaseData.shared.refMyReviews.child(useruid).observeSingleEvent(of: .value, with: { (snapshot) in
            
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
                completion(true)
                self.fireBaseFeedReviewsDataLoad()
                self.fireBaseReviewThumbDataLoad()
            }
            else{
                completion(false)
            }
        })
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func fireBaseMyReviewDataLoad(){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        //나중에 밑에 차일드 유아이디 값에 로그인한 유저 값을 넣어야된다
        guard let useruid = Auth.auth().currentUser?.uid else {return}
        FireBaseData.shared.refMyReviews.child(useruid).observeSingleEvent(of: .value, with: { (snapshot) in
            
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
                self.fireBaseReviewThumbDataLoad()
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
    
    
    func fireBaseReviewThumbDataLoad(){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        for reviewKeyData in MyPageDataCenter.shared.myReviewKeyDatas{
            var reviewLike = 0
            var reviewUnLike = 0
            Database.database().reference().child("review_thumb").child(reviewKeyData.reviewKeyReturn).observeSingleEvent(of: .value) { (dataSnap) in
                //            guard let thumbData = dataSnap.value as? [String:Any] else {return}
                
                //            guard let like = dataSnap.childSnapshot(forPath: "review_like").childSnapshot(forPath: "like_count").value as? Int else { return }
                //
                //            guard let unlike = dataSnap.childSnapshot(forPath: "review_unlike").childSnapshot(forPath: "unlike_count").value as? Int else { return }
                let likeData = dataSnap.childSnapshot(forPath: "review_like").childSnapshot(forPath: "like_count").value as? Int ?? 0
                let unlikeData = dataSnap.childSnapshot(forPath: "review_unlike").childSnapshot(forPath: "unlike_count").value as? Int ?? 0
                
                DispatchQueue.main.async {
                    print("리뷰키@://",reviewKeyData.reviewKeyReturn," 조아요://",likeData, "실어요://",unlikeData)
                    let thumbData = ReviewThumb(reviewKey: reviewKeyData.reviewKeyReturn, numberOfLike: likeData, numberOfUnLike: unlikeData)
                    print(thumbData)
                    MyPageDataCenter.shared.reviewThumbDatas.append(thumbData)
//                    self.reviewLikeLabel.text = likeData.description
                    
//                    self.reviewUnLikeLabel.text = unlikeData.description
                    
                    
                }
            }

           /* FireBaseData.shared.refReviewThumb.child(reviewKeyData.reviewKeyReturn).runTransactionBlock({ (reviewThumbSnapshot) -> TransactionResult in
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
            
            */
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    //좋은 성분 정보 데이터 불러오기
    func feedGoodIngredientDataLoad(ingredientGoodKey:[String]) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        MyPageDataCenter.shared.feedIngredientGoodDatas = []
        for goodKey in ingredientGoodKey{
            refFeedIngredientGood.child(goodKey).observeSingleEvent(of: .value, with: { (snapshot) in
                if let ingredientSnapshot = snapshot.value as? [String:AnyObject]{
                    var goodIngredientName:String?
                    var goodIngredientText:String?
                    for ingredientSnap in ingredientSnapshot{
                        if ingredientSnap.key == "ingredient_name"{
                            goodIngredientName = ingredientSnap.value as? String
                        }
                        if ingredientSnap.key == "ingredient_text"{
                            goodIngredientText = ingredientSnap.value as? String
                        }
                    }
                    guard let ingredientName = goodIngredientName,let ingredientText = goodIngredientText else {return}
                    let goodIngredientInfo = FeedIngredientGood(ingredientName: ingredientName, ingredientText: ingredientText)
                   
                    MyPageDataCenter.shared.feedIngredientGoodDatas.append(goodIngredientInfo)
                }
            })
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    //좋은 성분 정보 데이터 불러오기 -> 수정본
    func feedGoodIngredientDataOnLoad(ingredientGoodKey:[String], completion:@escaping ([FeedIngredientGood])->Void) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        var goodIngredientData: [FeedIngredientGood] = []
        
        for goodKey in ingredientGoodKey{
            refFeedIngredientGood.child(goodKey).observeSingleEvent(of: .value, with: { (snapshot) in
                if let ingredientSnapshot = snapshot.value as? [String:AnyObject]{
                    var goodIngredientName:String?
                    var goodIngredientText:String?
                    for ingredientSnap in ingredientSnapshot{
                        if ingredientSnap.key == "ingredient_name"{
                            goodIngredientName = ingredientSnap.value as? String
                        }
                        if ingredientSnap.key == "ingredient_text"{
                            goodIngredientText = ingredientSnap.value as? String
                        }
                    }
                    guard let ingredientName = goodIngredientName,let ingredientText = goodIngredientText else {return}
                    let goodIngredientInfo = FeedIngredientGood(ingredientName: ingredientName, ingredientText: ingredientText)
                    
                    goodIngredientData.append(goodIngredientInfo)
                }
                if ingredientGoodKey.last == goodKey{
                    completion(goodIngredientData)
                }
            })
            
        }
       
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    //주의 성분 데이터 불러오기
    func feedWarningIngredientDataOnLoad(ingredientWarningKey:[String], completion:@escaping ([FeedIngredientWarning])->Void){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        var warningIngredientData: [FeedIngredientWarning] = []
        for warningKey in ingredientWarningKey{
            refFeedIngredientWarning.child(warningKey).observeSingleEvent(of: .value, with: { (snapshot) in
                if let ingredientSnapshot = snapshot.value as? [String:AnyObject]{
                    var warningIngredientName:String?
                    var warningIngredientText:String?
                    for ingredientSnap in ingredientSnapshot{
                        if ingredientSnap.key == "ingredient_name"{
                            warningIngredientName = ingredientSnap.value as? String
                        }
                        if ingredientSnap.key == "ingredient_text"{
                            warningIngredientText = ingredientSnap.value as? String
                        }
                    }
                    guard let ingredientName = warningIngredientName,let ingredientText = warningIngredientText else {return}
                    let warningIngredientInfo = FeedIngredientWarning(ingredientName: ingredientName, ingredientText: ingredientText)
                    warningIngredientData.append(warningIngredientInfo)
                }
                if ingredientWarningKey.last == warningKey{
                    completion(warningIngredientData)
                }
            })
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    //주의 성분 데이터 불러오기
    func feedWarningIngredientDataLoad(ingredientWarningKey:[String]) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        MyPageDataCenter.shared.feedIngredientWarningDatas = []
        for warningKey in ingredientWarningKey{
            refFeedIngredientWarning.child(warningKey).observeSingleEvent(of: .value, with: { (snapshot) in
                if let ingredientSnapshot = snapshot.value as? [String:AnyObject]{
                    var warningIngredientName:String?
                    var warningIngredientText:String?
                    for ingredientSnap in ingredientSnapshot{
                        if ingredientSnap.key == "ingredient_name"{
                            warningIngredientName = ingredientSnap.value as? String
                        }
                        if ingredientSnap.key == "ingredient_text"{
                            warningIngredientText = ingredientSnap.value as? String
                        }
                    }
                    guard let ingredientName = warningIngredientName,let ingredientText = warningIngredientText else {return}
                    let warningIngredientInfo = FeedIngredientWarning(ingredientName: ingredientName, ingredientText: ingredientText)
                    
                    MyPageDataCenter.shared.feedIngredientWarningDatas.append(warningIngredientInfo)
                }
            })
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
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
    //    private var rating:Int! // 별 1~5개까지
    //    private var numberOfReview:Int!
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
    var addToFavoritesDateReturn:String{
        return addToFavoritesDate
    }
    
    init(favoriteKey:String,feedKey:String,feedImg:[String],feedBrand:String,feedName:String,feedMouth:String,feedIngredient:String,feedGrade:Int,feedPackageFlag:Bool!,addToFavoritesDate:String){
        self.favoriteKey = favoriteKey
        self.feedKey = feedKey
        self.feedBrand = feedBrand
        self.feedImg = feedImg[0]
        self.feedName = feedName
        self.feedMouth = feedMouth
        self.feedIngredient = feedIngredient
        self.feedGrade = feedGrade
        self.feedPackageFlag = feedPackageFlag
        self.addToFavoritesDate = addToFavoritesDate
    }
    
}
//즐겨찾기를 불러온 후 피드키로 불러오는 리뷰정보 데이터
struct FavoriteReviewInfoData {
    private var feedKey:String!
    private var feedRating:Int!
    private var numberOfReview:Int!
    var feedKeyReturn:String{
        return feedKey
    }
    var feedRatingReturn:Int{
        return feedRating
    }
    var numberOfReviewReturn:Int{
        return numberOfReview
    }
    init(feedKey:String,feedRating:Int,numberOfReview:Int) {
        self.feedKey = feedKey
        self.feedRating = feedRating
        self.numberOfReview = numberOfReview
    }
}



//리뷰키 데이터 구조체
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

//리뷰키로 불러온 내리뷰 데이터 구조체
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
    
    mutating func feedDateEdit(feedDate:String){
        self.feedDate = feedDate
    }
    
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

//리뷰키로 불러온 좋아요 정보 데이터
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

struct FeedIngredientGood {
    
    private var ingredientName:String!
    private var ingredientText:String!
    
    var ingredientNameReturn:String{
        return ingredientName
    }
    var ingredientTextReturn:String{
        return ingredientText
    }
    init(ingredientName:String,ingredientText:String){
        self.ingredientName = ingredientName
        self.ingredientText = ingredientText
    }
}
struct FeedIngredientWarning{
    
    private var ingredientName:String!
    private var ingredientText:String!
    
    var ingredientNameReturn:String{
        return ingredientName
    }
    var ingredientTextReturn:String{
        return ingredientText
    }
    init(ingredientName:String,ingredientText:String){
        
        self.ingredientName = ingredientName
        self.ingredientText = ingredientText
    }
}
