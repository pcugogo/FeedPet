//
//  AlarmService.swift
//  FeedPet2
//
//  Created by 샤인 on 2017. 12. 22..
//  Copyright © 2017년 Ios_Park. All rights reserved.
//

import Foundation

class AlarmService {
    static var shared = AlarmService()
    var switchOnOff:[String:Bool] = ["total":false,"morning":false,"lunch":false,"dinner":false]
    var mealTime:[String:String] = ["morning":"오전 00:00","lunch":"오후 00:00","dinner":"오후 00:00"]
    var mealTimeHour:[String:Int] = ["morning":00,"lunch":00,"dinner":00]
    var mealTimeMinute:[String:Int] = ["morning":00,"lunch":00,"dinner":00]
    
}

struct mealTime {
    var total = "total"
    var morning = "morning"
    var lunch = "lunch"
    var dinner = "dinner"
}
