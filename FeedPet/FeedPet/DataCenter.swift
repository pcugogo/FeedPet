//
//  DataCenter.swift
//  FeedPet
//
//  Created by HwangGisu on 2017. 12. 22..
//  Copyright © 2017년 HwangGisu. All rights reserved.
//

import Foundation
import SwiftyJSON
import Firebase
import SwiftyGif
import GoogleSignIn

class DataCenter {
    // 싱글턴 패턴
    static let shared = DataCenter()
    
    var isLogin: Bool = false
    let dogFunctionalData: [[String:String]] = [
        ["functional":"피부","functionalImg":"dogFunctional-Skin", "functionalKey":"skin"],
        ["functional":"알러지","functionalImg": "dogFunctional-Allergy", "functionalKey":"allergy"],
        ["functional":"관절","functionalImg":"dogFunctional-Joint", "functionalKey":"joint"],
        ["functional":"다이어트","functionalImg":"dogFunctional-Diet", "functionalKey":"diet"],
        ["functional":"인도어","functionalImg":"dogFunctional-Indoor", "functionalKey":"indoor"],
        ["functional":"장&면역","functionalImg":"dogFunctional-Immune", "functionalKey":"immune"],
        ["functional":"퍼포먼스","functionalImg":"dogFunctional-Performance", "functionalKey":"performance"],
        ["functional":"비뇨기","functionalImg":"dogFunctional-Urinary", "functionalKey":"urinary"],
        ["functional":"전체","functionalImg":"dogFunctional-All", "functionalKey":"all"]
    ]
    let catFunctionalData: [[String:String]] = [
        ["functional":"피부","functionalImg":"catFunctional-Skin", "functionalKey":"skin"],
        ["functional":"알러지","functionalImg": "catFunctional-Allergy", "functionalKey":"allergy"],
        ["functional":"관절","functionalImg":"catFunctional-Joint", "functionalKey":"joint"],
        ["functional":"다이어트","functionalImg":"catFunctional-Diet", "functionalKey":"diet"],
        ["functional":"인도어","functionalImg":"catFunctional-Indoor", "functionalKey":"indoor"],
        ["functional":"장&면역","functionalImg":"catFunctional-Immune", "functionalKey":"immune"],
        ["functional":"헤어볼","functionalImg":"catFunctional-Hairball", "functionalKey":"hairball"],
        ["functional":"비뇨기","functionalImg":"catFunctional-Urinary","functionalKey":"urinary"],
        ["functional":"전체","functionalImg":"catFunctional-All", "functionalKey":"all"]
    ]
    

    var currentPetKey: String = "feed_petkey_d"
    
    var loginUserData: [String:Any] = [:]
    
    var filterGrade: [IndexPath] = []
    
    var filterIndexPathArr: [IndexPath] = []
    var filterIndexPathDicArr : [Int:[IndexPath]] = [:]
    var filterDogIndexPathDicArr : [Int:[IndexPath]] = [:]
    var filterCatIndexPathDicArr : [Int:[IndexPath]] = [:]
    // Login 확인 요청 메서드
    func requestIsLogin() -> Bool {
        if Auth.auth().currentUser == nil {
            return false
        }else{
            isLogin = true
            return true
        }
       
    }
    func requestUserData(withCompletion comlition: @escaping (_ complition:User)->Void){
        // 로컬에 저장하기 위해 가입 uid를 가지고 리얼타임 디비 조회
        guard let uid = Auth.auth().currentUser?.uid else {return}
        print(uid)
        Database.database().reference().child(uid).child("UserInfo").observeSingleEvent(of: .value, with: { (snapshot) in
            //            print(snapshot.value)
            let dict = snapshot.value as! [String:Any]
            comlition(User(socialData: dict))
        })
        
    }
    func getUserData()->[String:Any]{
     
        return loginUserData
    }
    func googleLogOut(){
        
        do{
            try Auth.auth().signOut()
            GIDSignIn.sharedInstance().signOut()
        }catch{
            
        }
        
       
        
    }
    
    // 닉네임 중복 체크 메서드
    func nicNameDoubleChek(nickName: String, completion: @escaping (Bool)->Void){
        
        Database.database().reference().child("user_info").queryOrdered(byChild: "user_nic").queryEqual(toValue: nickName).observeSingleEvent(of: .value, with: { (snapShot) in
            
            if let snapDict = snapShot.value as? [String:AnyObject]{
                print(snapDict)
                //                for each in snapDict{
                //                    let key  = each.key
                //                    let name = each.value["name"] as! String
                //                    print(key)
                //                    print(name)
                //                }
                completion(true)
            }else{
                completion(false)
            }
        }, withCancel: {(Err) in
            
            print(Err.localizedDescription)
            
        })
    }
    
    func getFeedData(){
        
    }
    func functionalSettingData(currentPet: String)->[[String:String]]{
        if currentPet == "feed_petkey_d"{
            return dogFunctionalData
        }else{
            return catFunctionalData
        }
    }
    @objc func testto(nofi: Notification) {
        print(1)
    }
    func feedDetailIngredientDataLoad(feedKey: String, comlition:@escaping (FeedDetailIngredient)->Void){
        let ref = Database.database().reference().child("feed_detail").child(feedKey)
        ref.observeSingleEvent(of: .value, with: { (dataSnap) in
            guard let data = dataSnap.value else {return}
            let jsonData = JSON(data)
            let feedDetailIngredientData = FeedDetailIngredient(ingredientData: jsonData)
            print("###상세 성분데이터##://",feedDetailIngredientData)
            comlition(feedDetailIngredientData)
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    ///**************test******
    func indicatorStart(viewController: UIViewController, indicatorImgView: UIImageView){
        let backgroundView: UIView = UIView(frame: viewController.view.bounds)
        backgroundView.backgroundColor = .gray
        backgroundView.bringSubview(toFront: indicatorImgView)
        viewController.view.addSubview(backgroundView)
    }
    func showActivityIndicatory(uiView: UIView, animating: Bool) {
        let backgroundView: UIView = UIView()
        backgroundView.frame = uiView.frame
        backgroundView.center = uiView.center
        backgroundView.backgroundColor = .gray
        
       
        let loadingIndicatorView = UIImageView()
        
        loadingIndicatorView.frame = CGRect(x: 0.0, y: 0.0, width: 60.0, height: 60.0)
        loadingIndicatorView.center = CGPoint(x: backgroundView.frame.size.width/2, y: backgroundView.frame.size.height/2)
        let gifManager = SwiftyGifManager(memoryLimit:30)
        let gif = UIImage(gifName: "loading_img@3.gif")
        loadingIndicatorView.setGifImage(gif, manager: gifManager)
        
//        backgroundView.addSubview(loadingIndicatorView)
//        uiView.addSubview(backgroundView)
        
        if animating {
            backgroundView.addSubview(loadingIndicatorView)
            uiView.addSubview(backgroundView)

        }
    }
    
    func nibRemove(toViewController: UIViewController){
        toViewController.view.removeFromSuperview()
    }
    //**************test end****
    
    // MARK: Gif LoadingIndicaotr 호출 메서드(통신시작) - 디자인 관련 추후 옮길예정
    // 사용법: 데이터센턴 싱글턴 패턴으로 함수 호출 하여 사용
    // ex) let spiner = DataCenter.shard.displayLoadingIndicator(onView: 현재사용할 뷰컨의 뷰)
    func displsyLoadingIndicator(onView: UIView)->UIView {
        let spinner = UIView(frame: onView.bounds)
//        spinner.autoLayoutAnchor(top: onView.topAnchor,
//                                  left: onView.leftAnchor,
//                                  right: onView.rightAnchor,
//                                  bottom: onView.bottomAnchor,
//                                  topConstant: 0,
//                                  leftConstant: 0,
//                                  rigthConstant: 0,
//                                  bottomConstant: 0,
//                                  width: 0,
//                                  height: 0,
//                                  centerX: nil,
//                                  centerY: nil)
        spinner.backgroundColor = UIColor.init(hexString: "#333333", alpha: 0.5)
        let loadingIndicator: UIImageView = {
           let imgView = UIImageView()
            let gifManager = SwiftyGifManager(memoryLimit:30)
            let gif = UIImage(gifName: "loading_img.gif")
            imgView.setGifImage(gif, manager: gifManager)
            imgView.contentMode = .scaleToFill
            imgView.clipsToBounds = true
            return imgView
        }()
//        loadingIndicator.autoLayoutAnchor(top: onView.topAnchor,
//                                          left: nil,
//                                          right: nil,
//                                          bottom: nil,
//                                          topConstant: 300,
//                                          leftConstant: 0,
//                                          rigthConstant: 0,
//                                          bottomConstant: 0,
//                                          width: 80,
//                                          height: 80,
//                                          centerX: onView.centerXAnchor,
//                                          centerY: nil)
//        loadingIndicator.center = spinner.center
        let gifManager = SwiftyGifManager(memoryLimit:30)
        let gif = UIImage(gifName: "loading_img@3x2.gif")
        loadingIndicator.setGifImage(gif, manager: gifManager)
        DispatchQueue.main.async {
//            spinner.addSubview(loadingIndicator)
            
            onView.addSubview(spinner)
            spinner.autoLayoutAnchor(top: onView.topAnchor,
                                     left: onView.leftAnchor,
                                     right: onView.rightAnchor,
                                     bottom: onView.bottomAnchor,
                                     topConstant: 0,
                                     leftConstant: 0,
                                     rigthConstant: 0,
                                     bottomConstant: 0,
                                     width: 0,
                                     height: 0,
                                     centerX: nil,
                                     centerY: nil)
            spinner.addSubview(loadingIndicator)
            loadingIndicator.autoLayoutAnchor(top: nil,
                                              left: nil,
                                              right: nil,
                                              bottom: nil,
                                              topConstant: 0,
                                              leftConstant: 0,
                                              rigthConstant: 0,
                                              bottomConstant: 0,
                                              width: spinner.layer.frame.width * 0.22,
                                              height: spinner.layer.frame.width * 0.22,
                                              centerX: spinner.centerXAnchor,
                                              centerY: spinner.centerYAnchor)
//            loadingIndicator.widthAnchor.constraint(equalTo: <#T##NSLayoutDimension#>, multiplier: <#T##CGFloat#>)
        }
        return spinner
    }
    
    // gif인디케이터 삭제 메서드
    // 사용법 - 상위 메서드에서 생성한 spiner를 파라미터로 전달
    // ex) DataCenter.shard.removeSpiner(spiner: spiner)
    func removeSpinner(spinner :UIView) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3, animations: {
                spinner.alpha = 0
            }, completion: { (finish) in
                
                spinner.removeFromSuperview()
            })
        }
    }
}

// Firebase User 데이터 구조
struct User {
    // 소셜 로그인 제공 정보
    var userName: String!
    var userEmail: String!
    
    // 추가 가입정보
    var userNickname: String!
    var userProfileImgUrl: String?
    var userGender: String!
    
    // 반려동물 가입정보
    var userPet: String!
    var userPetAge: Int!
    var userPetFunctional: [String]!
    
    var userPetFunctionalIndexPathRow: [Int]!
    init() {
        
       
    }
    init(socialData: [String:Any]) {
        self.userName = socialData["user_name"] as? String ?? "no-name"
        self.userEmail = socialData["user_emial"] as? String ?? "no-email"
        
    }
    
    init(allInfoData: [String:Any]) {
        self.userName = allInfoData["user_name"] as! String
        self.userEmail = allInfoData["user_email"] as! String
        self.userNickname = allInfoData["user_nic"] as! String
        self.userGender = allInfoData["user_gender"] as! String
        self.userPet = allInfoData["user_pet"] as! String
        self.userPetAge = allInfoData["user_petage"] as! Int
        self.userProfileImgUrl = allInfoData["user_img"] as? String
        self.userPetFunctional = allInfoData["user_pet_functional"] as! [String]
    }
    
    init(userInfoData: [String:Any]) {
        
        self.userName = userInfoData["user_name"] as! String
        self.userEmail = userInfoData["user_email"] as! String
        self.userNickname = userInfoData["user_nic"] as! String
        self.userGender = userInfoData["user_gender"] as! String
        self.userPet = userInfoData["user_pet"] as! String
        self.userPetAge = userInfoData["user_petage"] as! Int
        self.userProfileImgUrl = userInfoData["user_img"] as? String
        self.userPetFunctional = userInfoData["user_pet_functional"] as! [String]
        self.userPetFunctionalIndexPathRow = userInfoData["user_pet_functional_indexpath_row"] as! [Int]
    }
    init(testDataJson: JSON) {
        
    }
    
}


// 사료 정보 데이터구조
struct FeedInfo{
    var feedKey: String!
    var feedBrand: String!
    var feedName: String!
    var feedIngredient: String!
    var feedAge: Int!
    var feedWeight: [Double]!
    var feedFunctional: [String]!
    var feedImg: [String]!
    var feedMouth: String!
    var feedGrade: Int!
    var feedCountry: String!
    var feedPackageFlag: Bool!
    var grainfreeFlag: Bool!
    var organicFlag: Bool!
    var lidFlag: Bool!
    var bigFlag: Bool!
    
    init(feedJsonData: (String,JSON)) {
        self.feedKey = feedJsonData.0
        self.feedBrand = feedJsonData.1["feed_brand"].stringValue
        self.feedName = feedJsonData.1["feed_name"].stringValue
        self.feedIngredient = feedJsonData.1["feed_ingredient"].stringValue
        self.feedAge = feedJsonData.1["feed_age"].intValue
        self.feedWeight = feedJsonData.1["feed_weight"].arrayObject as! [Double]
        self.feedFunctional = feedJsonData.1["feed_functional"].arrayObject as! [String]
        self.feedImg = feedJsonData.1["feed_img"].arrayObject as! [String]
        self.feedMouth = feedJsonData.1["feed_mouth"].stringValue
        self.feedGrade = feedJsonData.1["feed_grade"].intValue
        self.feedCountry = feedJsonData.1["feed_country"].stringValue
        self.feedPackageFlag = feedJsonData.1["feed_package_flag"].boolValue
        self.grainfreeFlag = feedJsonData.1["grainfree_flag"].boolValue
        self.organicFlag = feedJsonData.1["organic_flag"].boolValue
        self.lidFlag = feedJsonData.1["lid_flag"].boolValue
        self.bigFlag = feedJsonData.1["big_flag"].boolValue
        
        
        
        
    }
    
    init(feedJsonDataTest: JSON) {
        self.feedKey = feedJsonDataTest["feed_key"].stringValue
        self.feedBrand = feedJsonDataTest["feed_brand"].stringValue
        self.feedName = feedJsonDataTest["feed_name"].stringValue
        self.feedIngredient = feedJsonDataTest["feed_ingredient"].stringValue
        self.feedAge = feedJsonDataTest["feed_age"].intValue
        self.feedWeight = feedJsonDataTest["feed_weight"].arrayObject as! [Double]
        self.feedFunctional = feedJsonDataTest["feed_functional"].arrayObject as! [String]
        self.feedImg = feedJsonDataTest["feed_img"].arrayObject as! [String]
        self.feedMouth = feedJsonDataTest["feed_mouth"].stringValue
        self.feedGrade = feedJsonDataTest["feed_grade"].intValue
        self.feedCountry = feedJsonDataTest["feed_country"].stringValue
        self.feedPackageFlag = feedJsonDataTest["feed_package_flag"].boolValue
        self.grainfreeFlag = feedJsonDataTest["grainfree_flag"].boolValue
        self.organicFlag = feedJsonDataTest["organic_flag"].boolValue
        self.lidFlag = feedJsonDataTest["lid_flag"].boolValue
        self.bigFlag = feedJsonDataTest["big_flag"].boolValue
        
        
        
    }
    init() {
        
    }
}
// 사료 리스트
struct FeedInfoList {
    
    var feed: [FeedInfo]!
    
    init(feedsJsonTest: [JSON]) {
        var feedList: [FeedInfo] = []
        print("=feedsJsonTest=",feedsJsonTest)
        for feed in feedsJsonTest{
            let feedOne = FeedInfo(feedJsonDataTest: feed)
            feedList.append(feedOne)
            
        }
        
        print(feedList)
        
        self.feed = feedList
    }
    init(feedsJson: JSON) {
        var feedList: [FeedInfo] = []
        for feed in feedsJson{
            let feedOne = FeedInfo(feedJsonData: feed)
            feedList.append(feedOne)
            
        }
        
        
        self.feed = feedList
    }
}

// 성분 데이터 모델
struct FeedDetailIngredient {
    // 좋은 성분 고유키 배열
    var feedIngredientGood: [JSON]!
    // 주의 성분 고유키 배열
    var feedIngredientWarning: [JSON]!
    // 조단백
    var crudeProtein: Float!
    // 조지방
    var crudeFat: Float!
    // 조섬유
    var crudeFibre: Float!
    // 조회분
    var crudeAsh: Float!
    // 칼슘
    var calcium: Float!
    // 인
    var phosphorus: Float!
    
    init(ingredientData: JSON) {
        self.feedIngredientGood = ingredientData["feed_ingredient_good"].arrayValue
        self.feedIngredientWarning = ingredientData["feed_ingredient_warning"].arrayValue
        self.crudeProtein = ingredientData["crude_protein"].floatValue
        self.crudeFat = ingredientData["crude_fat"].floatValue
        self.crudeAsh = ingredientData["crude_ash"].floatValue
        self.crudeFibre = ingredientData["crude_figre"].floatValue
        self.calcium = ingredientData["calcium"].floatValue
        self.phosphorus = ingredientData["phosphorus"].floatValue
    }
    
}
// 성분 데이터 모델-TEST
struct FeedDetailIngredientTest {
    // 좋은 성분 고유키 배열
    var feedIngredientGood: [String]!
    // 주의 성분 고유키 배열
    var feedIngredientWarning: [String]!
    // 조단백
    var crudeProtein: Float!
    // 조지방
    var crudeFat: Float!
    // 조섬유
    var crudeFibre: Float!

    // 조회분
    var crudeAsh: Float!
    // 칼슘
    var calcium: Float!
    // 인
    var phosphorus: Float!
    
    init(ingredientData: [String:Any]) {
        self.feedIngredientGood = ingredientData["feed_ingredient_good"] as! [String]
        self.feedIngredientWarning = ingredientData["feed_ingredient_warning"] as! [String]
        self.crudeProtein = ingredientData["crude_protein"] as! Float
        self.crudeFat = ingredientData["crude_fat"] as! Float
        self.crudeFibre = ingredientData["crude_fibre"] as! Float
        self.crudeAsh = ingredientData["crude_ash"] as! Float
        self.calcium = ingredientData["calcium"] as! Float
        self.phosphorus = ingredientData["phosphorus"] as! Float
    }
    
}

// 기능성 정보 모델링
struct Functional{
    var functionalKey: String!
    var functionalName: String!
    var functionalImg: String!
    
    init(functionalJSON: (String,JSON)) {
        self.functionalKey = functionalJSON.0
        self.functionalName = functionalJSON.1["functional_name"].stringValue
        self.functionalImg = functionalJSON.1["functional_img"].stringValue
    }
    
}
struct FunctionalList {
    var functional: [Functional]
    
    init(functionJson: JSON) {
        var functionalList: [Functional] = []
        for function in functionJson{
            let functionOne = Functional(functionalJSON: function)
            functionalList.append(functionOne)
            
        }
        self.functional = functionalList
    }
    
}

struct FeedReview {
    var feedKey: String!
    var reviewInfo: [ReviewInfo]?
    var reviewRation: Int!
    
    init(feedReviewJSON: (String,JSON)) {
        self.feedKey = feedReviewJSON.0
        
    }
    
}

struct ReviewInfo {
    var reviewKey: String!
    var userKey: String!
    var feedRating: Int!
    var feedReviewCon: String!
    var reviewDate: String!
    
}


struct FilterData {
    var grade: [Int]?
    var age: [Int]?
    var ingredient: [String]?
    var brand: [String]?
    var grinfreeFlag: Bool?
    var organicFlag: Bool?
    var lidFlag: Bool?
    var bigPetFlag: Bool?
    
    init(filterDic: [Int:[IndexPath]], filterinMenuSection: [FilterMenuSections]) {
        
        for filterOne in filterDic{
            
            switch filterOne.key {
            case 0:
                
                self.grade = filterOne.value.map({ (indexPath) -> Int in
                    filterinMenuSection[indexPath.section].filterMenuKind[indexPath.row].filterValue as! Int
                })
            case 1:
                
                self.age = filterOne.value.map({ (indexPath) -> Int in
                    filterinMenuSection[indexPath.section].filterMenuKind[indexPath.row].filterValue as! Int
                })
            case 2:
                
                self.ingredient = filterOne.value.map({ (indexPath) -> String in
                    filterinMenuSection[indexPath.section].filterMenuKind[indexPath.row].filterValue as! String
                })
            case 3:
                
                self.brand = filterOne.value.map({ (indexPath) -> String in
                    filterinMenuSection[indexPath.section].filterMenuKind[indexPath.row].filterValue as! String
                })
            case 4:
                // 그레인프리의 키값이 존재하면 true 만약 선택값이 없다면 default에서 추가적 처리
//                if !filterOne.value.isEmpty {
//                    self.grinfreeFlag = true
//                }else{
//                    self.grinfreeFlag = false
//                }
                self.grinfreeFlag = true
//                guard let grainFreeMenu = filterinMenuSection[filterOne.key].filterMenuKind.first else{return}
//                self.grinfreeFlag = grainFreeMenu.checkState
            case 5:
                self.organicFlag = true
            case 6:
                self.lidFlag = true
            case 7:
                bigPetFlag = true
            default:
                print("예외상황 처리 ")
            }
            
        }
    }
    
    
    
}
