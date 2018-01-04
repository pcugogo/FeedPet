//
//  DataCenter.swift
//  FeedPet
//
//  Created by HwangGisu on 2017. 12. 22..
//  Copyright © 2017년 HwangGisu. All rights reserved.
//

import Foundation
import Firebase

class DataCenter {
    // 싱글턴 패턴
    static let shared = DataCenter()
    
    var isLogin: Bool = false
    
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

