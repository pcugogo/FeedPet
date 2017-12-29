//
//  MyPageDataCenter.swift
//  FeedPet
//
//  Created by 샤인 on 2017. 12. 29..
//  Copyright © 2017년 HwangGisu. All rights reserved.
//

import Foundation

class MyPageDataCenter {
    static var shared = MyPageDataCenter()
    
    //펫 식사 시간 알림 데이터
    var switchOnOff:[String:Bool] = ["total":false,"morning":false,"lunch":false,"dinner":false]
    var mealTime:[String:String] = ["morning":"오전 00:00","lunch":"오후 00:00","dinner":"오후 00:00"]
    var mealTimeHour:[String:Int] = ["morning":00,"lunch":00,"dinner":00]
    var mealTimeMinute:[String:Int] = ["morning":00,"lunch":00,"dinner":00]
    var mealTimeAMPM:[String:String] = ["morning":"nil","lunch":"nil","dinner":"nil"]
    
    //탈퇴하기 내용
    var leaveMembershipReason = ""
    
}


struct userDefaultsName {   //알림 서비스에서 이용하는 유저디폴트 이름들
    static var mealTime = "mealTime"
    static var mealTimeAMPM = "mealTimeAMPM"
    static var mealTimeHour = "mealTimeHour"
    static var mealTimeMinute = "mealTimeMinute"
    static var alarmOnOff = "alarmOnOff"
}
