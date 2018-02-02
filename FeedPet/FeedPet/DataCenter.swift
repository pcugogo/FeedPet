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
    var currentPetKey: String = ""
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
    
    func singOut(){
        do{
            try Auth.auth().signOut()
        }catch{
            
        }
    }
    
    // 닉네임 중복 체크 메서드
    func nicNameDoubleChek(nickName: String, completion: @escaping (Bool)->Void){
        
        Database.database().reference().child("user_profiles").queryOrdered(byChild: "nickName").queryEqual(toValue: nickName).observeSingleEvent(of: .value, with: { (snapShot) in
            
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
    
}

// Firebase User 데이터 구조
struct User {
    // 소셜 로그인 제공 정보
    var userName: String?
    var userEmail: String?
    
    // 추가 가입정보
    var userNickname: String?
    var userProfileImgUrl: String?
    var ueerGender: String?
    
    // 반려동물 가입정보
    var petAge: Int?
    var petFunctional: [Int]?
    
    
    init() {
        
        
    }
    init(socialData: [String:Any]) {
        self.userName = socialData["userName"] as? String ?? "no-name"
        self.userEmail = socialData["userEmail"] as? String ?? "no-email"
        
    }
    
    init(allInfoData: [String:Any]) {
        self.userName = allInfoData["userName"] as? String ?? "no-name"
        self.userEmail = allInfoData["userEmail"] as? String ?? "no-email"
        
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
    
    let feed: [FeedInfo]
    
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
    var crudeProtein: Int!
    // 조지방
    var crudeFat: Int!
    // 조섬유
    var crudeFibre: Int!
    // 조회분
    var crudeAsh: Int!
    // 칼슘
    var calcium: Int!
    // 인
    var phosphorus: Int!
    
    init(ingredientData: JSON) {
        self.feedIngredientGood = ingredientData["feed_ingredient_good"].arrayValue
        self.feedIngredientWarning = ingredientData["feed_ingredient_warning"].arrayValue
        self.crudeProtein = ingredientData["crude_protein"].intValue
        self.crudeFat = ingredientData["crude_fat"].intValue
        self.crudeAsh = ingredientData["crude_ash"].intValue
        self.crudeFibre = ingredientData["crude_figre"].intValue
        self.calcium = ingredientData["calcium"].intValue
        self.phosphorus = ingredientData["phosphorus"].intValue
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
