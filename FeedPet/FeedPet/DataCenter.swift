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
    
    init(socialData: [String:Any]) {
        self.userName = socialData["userName"] as? String ?? "no-name"
        self.userEmail = socialData["userEmail"] as? String ?? "no-email"
        
    }
    
    
}
