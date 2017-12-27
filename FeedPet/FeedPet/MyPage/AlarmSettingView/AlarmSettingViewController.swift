//
//  AlarmSettingViewController.swift
//  FeedPet2
//
//  Created by 샤인 on 2017. 12. 22..
//  Copyright © 2017년 Ios_Park. All rights reserved.
//

import UIKit
import UserNotifications



class AlarmSettingViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,CustomCellUpdater {
    
    var isGrantedNotificationAccess = false
    
    let formatter:DateFormatter = DateFormatter() // "aa hh:mm"
    let dateFormatterAMPM = DateFormatter()
    let dateFormatterHour:DateFormatter = DateFormatter() // hh
    let dateFormatterMinute:DateFormatter = DateFormatter() // mm
    let locKo = Locale(identifier: "ko")
    var cellIdentificationNumber = 0
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var timePickerViewOut: UIDatePicker!
    @IBOutlet weak var timePickConfirmBtnOut: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let alarmOnOffData = UserDefaults.standard.dictionary(forKey: userDefaultsName.alarmOnOff){
            AlarmService.shared.switchOnOff = alarmOnOffData as! [String : Bool]
        }
        
        if let mealTimeData = UserDefaults.standard.dictionary(forKey: userDefaultsName.mealTime){
            AlarmService.shared.mealTime = mealTimeData as! [String:String]
        }
     
        if let mealTimeAMPM = UserDefaults.standard.dictionary(forKey: userDefaultsName.mealTimeAMPM){
            AlarmService.shared.mealTimeAMPM = mealTimeAMPM as! [String:String]
        }
        
        if let mealTimeHourDate = UserDefaults.standard.dictionary(forKey: userDefaultsName.mealTimeHour){
            AlarmService.shared.mealTimeHour = mealTimeHourDate as! [String:Int]
        }
        
        if let mealTimeMinuteDate = UserDefaults.standard.dictionary(forKey: userDefaultsName.mealTimeMinute){
            AlarmService.shared.mealTimeMinute = mealTimeMinuteDate as! [String:Int]
        }
        
        
        formatter.locale = locKo
        timePickerViewOut.locale = locKo
        
//        let center = UNUserNotificationCenter.current() // 로컬 및 원격 Notification에 대한 권한 요청
//        center.delegate = self
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert,.sound,.badge],
            completionHandler: { (granted,error) in
                self.isGrantedNotificationAccess = granted
                if !granted{
                    
                    // 사용자가 직접 iOS 설정에서 알림을 off 하는 케이스 예외처리
                    //                    if !(granted) {
                    //                        // 아래의 세팅을 하지 않으면, notification들이 쌓여 있다가, 알림을 on 할 때, 터질 가능성이 있는 케이스의 예외처리입니다.
                    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                    AlarmService.shared.switchOnOff = ["total":false,"morning":false,"lunch":false,"dinner":false]
                    UserDefaults.standard.set(AlarmService.shared.switchOnOff, forKey: userDefaultsName.alarmOnOff)
                    
                    //                    }
                }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateTableView() {
        tableView.reloadData()
    }
    
    func UpdateMealTimeAlarmNotification() {
        setMealTimeAlarmNotification()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        if indexPath.row == 0 {
           
            let totalSwitchCell:TotalAlarmSwitchCell = tableView.dequeueReusableCell(withIdentifier: "TotalAlarmSwitchCell", for: indexPath) as! TotalAlarmSwitchCell
                totalSwitchCell.totalAlarmSwitchOut.isOn = AlarmService.shared.switchOnOff["total"]!
                totalSwitchCell.delegate = self 
            
            return totalSwitchCell
            
        }else{
            let switchCell:AlarmSwitchCell = tableView.dequeueReusableCell(withIdentifier: "AlarmSwitchCell", for: indexPath) as! AlarmSwitchCell
            
                switchCell.delegate = self
            
            if indexPath.row == 1{
                switchCell.mealTimeLb.text = AlarmService.shared.mealTime["morning"]!
                switchCell.indexPath = indexPath.row
                switchCell.alarmSwitchOut.isOn = AlarmService.shared.switchOnOff["morning"]!
            }else if indexPath.row == 2{
                switchCell.mealTimeLb.text = AlarmService.shared.mealTime["lunch"]!
                switchCell.indexPath = indexPath.row
                switchCell.alarmSwitchOut.isOn = AlarmService.shared.switchOnOff["lunch"]!
            }else if indexPath.row == 3{
                switchCell.mealTimeLb.text = AlarmService.shared.mealTime["dinner"]!
                switchCell.indexPath = indexPath.row
                switchCell.alarmSwitchOut.isOn = AlarmService.shared.switchOnOff["dinner"]!
            }
            
            return switchCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 1{
            cellIdentificationNumber = 1
            
            tableView.isHidden = true
            
            timePickerViewOut.isHidden = false
            timePickConfirmBtnOut.isHidden = false
            
            print("morning",AlarmService.shared.mealTime["morning"]!)
            
        }else if indexPath.row == 2{
            cellIdentificationNumber = 2
           
            tableView.isHidden = true
            
            timePickerViewOut.isHidden = false
            timePickConfirmBtnOut.isHidden = false
            
             print("lunch",AlarmService.shared.mealTime["lunch"]!)
        }else if indexPath.row == 3{
            cellIdentificationNumber = 3
            
            tableView.isHidden = true
            
            timePickerViewOut.isHidden = false
            timePickConfirmBtnOut.isHidden = false
            
            print("dinner",AlarmService.shared.mealTime["dinner"]!)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0{
            
            return 130
        }else{
            return 70
        }
    }
    
    func setMealTimeAlarmNotification() { //알람 Notification을 셋팅 해주는 함수입니다
        
        dateFormatterHour.dateFormat = "HH" //포메터를 시간으로 세팅을 해줍니다
        
        dateFormatterMinute.dateFormat = "mm" //포메터를 분으로 세팅을 해줍니다
        
        var notificationDateComponents = DateComponents()
        
        if #available(iOS 10.0, *) { //10.0 버전 이상 지원가능한 알람 세팅입니다
            
            // 01. UNMutableNotificationContent
            let notificationContent = UNMutableNotificationContent() //알림에 필요한 기본 콘텐츠 설정을 할 수 있습니다.
            //알람 제목,내용,뱃지,알람사운드 등 세팅들을 설정할 수 있습니다.
            notificationContent.sound = UNNotificationSound.default() // 사운드를 기본으로 설정
            
            if AlarmService.shared.switchOnOff["morning"] == true{
                
                notificationDateComponents.hour = AlarmService.shared.mealTimeHour["morning"]
                //시간 세팅해준 포메터에 피커뷰에서 받은 시간을 세팅
                
                notificationDateComponents.minute = AlarmService.shared.mealTimeMinute["morning"]
                //분 세팅해준 포메터에 피커뷰에서 받은 분을 세팅
                notificationContent.body = "아침 식사 시간입니다!"
                
                // 02. UNTimeIntervalNotificationTrigger
                //여기서 시간과 매칭하는 트리거를 사용할 수도 있고 TimeIntervald을 체크하는 트리거를 사용할 수도 있습니다 반복여부도 설정가능
                let notificationTrigger = UNCalendarNotificationTrigger(dateMatching: notificationDateComponents, repeats: true)
               
                // 03. UNNotificationRequest 알림 요청 객체 생성
                let morningRequest: UNNotificationRequest = UNNotificationRequest(identifier: "morningAlarm", content: notificationContent, trigger: notificationTrigger)
                
                // 04. UNUserNotificationCenter 스케줄러, add(_:)를 통해 알림 요청 객체 추가로 알림 등록 과정 완료.
                UNUserNotificationCenter.current().add(morningRequest, withCompletionHandler: { [unowned self](_) in
                    self.dismiss(animated: true, completion: nil)
                    
                    
                })
                
            }
            if AlarmService.shared.switchOnOff["lunch"] == true{
                
                notificationDateComponents.hour = AlarmService.shared.mealTimeHour["lunch"]
                notificationDateComponents.minute = AlarmService.shared.mealTimeMinute["lunch"]
                
                notificationContent.body = "점심 식사 시간입니다!"
                
                // 02. UNTimeIntervalNotificationTrigger
                let notificationTrigger = UNCalendarNotificationTrigger(dateMatching: notificationDateComponents, repeats: true)
                
                // 03. UNNotificationRequest
                let lunchRequest: UNNotificationRequest = UNNotificationRequest(identifier: "lunchAlarm", content: notificationContent, trigger: notificationTrigger)
                
                // 04. UNUserNotificationCenter
                UNUserNotificationCenter.current().add(lunchRequest, withCompletionHandler: { [unowned self](_) in
                    self.dismiss(animated: true, completion: nil)
                    
                })
                
            }
            if AlarmService.shared.switchOnOff["dinner"] == true{
                notificationContent.body = "저녁 식사 시간입니다!"
                
                notificationDateComponents.hour = AlarmService.shared.mealTimeHour["dinner"]
                notificationDateComponents.minute = AlarmService.shared.mealTimeMinute["dinner"]
                
                // 02. UNTimeIntervalNotificationTrigger
                let notificationTrigger = UNCalendarNotificationTrigger(dateMatching: notificationDateComponents, repeats: true)
                
                // 03. UNNotificationRequest
                let dinnerRequest: UNNotificationRequest = UNNotificationRequest(identifier: "dinnerAlarm", content: notificationContent, trigger: notificationTrigger)
                
                // 04. UNUserNotificationCenter
                UNUserNotificationCenter.current().add(dinnerRequest, withCompletionHandler: { [unowned self](_) in
                    self.dismiss(animated: true, completion: nil)
                    
                })
                
            }
        }else{ // 10.0버전 미만 버전
            if AlarmService.shared.switchOnOff["morning"] == true{
               
                let notification = UILocalNotification()
                
                notificationDateComponents.hour = AlarmService.shared.mealTimeHour["morning"]
                notificationDateComponents.minute = AlarmService.shared.mealTimeMinute["morning"]
                
                notification.fireDate = notificationDateComponents.date
                notification.alertBody = "아침 식사 시간입니다!"
                notification.alertAction = "아침"
                notification.soundName = UILocalNotificationDefaultSoundName
                
                UIApplication.shared.scheduleLocalNotification(notification)
            }
            if AlarmService.shared.switchOnOff["lunch"] == true{
                let notification = UILocalNotification()
                
                notificationDateComponents.hour = AlarmService.shared.mealTimeHour["lunch"]
                notificationDateComponents.minute = AlarmService.shared.mealTimeMinute["lunch"]
                
                notification.fireDate = notificationDateComponents.date
                notification.alertBody = "점심 식사 시간입니다!"
                notification.alertAction = "점심"
                notification.soundName = UILocalNotificationDefaultSoundName
                
                UIApplication.shared.scheduleLocalNotification(notification)
            }
            if AlarmService.shared.switchOnOff["dinner"] == true{
                let notification = UILocalNotification()
                
                notificationDateComponents.hour = AlarmService.shared.mealTimeHour["dinner"]
                notificationDateComponents.minute = AlarmService.shared.mealTimeMinute["dinner"]
                
                notification.fireDate = notificationDateComponents.date
                notification.alertBody = "저녁 식사 시간입니다!"
                notification.alertAction = "저녁"
                notification.soundName = UILocalNotificationDefaultSoundName
                
                UIApplication.shared.scheduleLocalNotification(notification)
            }
        }
        
        
        // 기존 알림 확인
        UNUserNotificationCenter.current().getPendingNotificationRequests { (notificationRequests) in
            print("///// notificationRequests.count- 7892: \n", notificationRequests.count)
            print("///// notificationRequests detail- 7892: \n", notificationRequests)
        }
        
    }
    
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.view.endEditing(true)
//        timePickerViewOut.isHidden = true
//        timePickConfirmBtnOut.isHidden = true
//    }

    
    
    
    
    @IBAction func backBtnAction(_ sender: UIBarButtonItem) {
        UserDefaults.standard.set(AlarmService.shared.switchOnOff, forKey: userDefaultsName.alarmOnOff)
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func saveBtnAction(_ sender: UIBarButtonItem) {
      
    
    }
    

    
    @IBAction func timePickConfirmBtnAction(_ sender: UIButton) {
        
        tableView.isHidden = false
        
        formatter.locale = locKo // 포메터 지역을 한국(Ko)으로 설정
        formatter.dateFormat = "aa hh:mm" //ex) 오전 11:00
        
        dateFormatterAMPM.dateFormat = "aa"
        dateFormatterHour.dateFormat = "hh"
        dateFormatterMinute.dateFormat = "mm"
        
        let dateString = formatter.string(from: timePickerViewOut.date)
        let hourString = dateFormatterHour.string(from: timePickerViewOut.date)
        let minuteStr = dateFormatterMinute.string(from: timePickerViewOut.date)
        let AMPMStr = dateFormatterAMPM.string(from: timePickerViewOut.date)
        print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!",hourString)
        if cellIdentificationNumber == 1{
            
            AlarmService.shared.mealTime["morning"] = dateString          //셀의 레이블에 담을 피커뷰의 시간을 담습니다
            
            AlarmService.shared.mealTimeAMPM["morning"] = AMPMStr
            
            if AlarmService.shared.mealTimeAMPM["morning"] == "AM" || AlarmService.shared.mealTimeAMPM["morning"] == "오전" {
                if hourString == "12"{
                    AlarmService.shared.mealTimeHour["morning"] = 0 //오전12시일경우 매칭할 시간이 0시가 됩니다 그래서 0으로 바꿔줍니다
                }else{
                AlarmService.shared.mealTimeHour["morning"] = Int(hourString)
                }
            }else if AlarmService.shared.mealTimeAMPM["morning"] == "PM" || AlarmService.shared.mealTimeAMPM["morning"] == "오후"{
                if hourString == "12"{
                    AlarmService.shared.mealTimeHour["morning"] = Int(hourString)
                }else{
                    AlarmService.shared.mealTimeHour["morning"] = Int(hourString)! + 12 //오후 1시일 경우 매칭할 숫자가 13시입니다 그래서 12를 더해 담습니다
                }
                
            }
            
            AlarmService.shared.mealTimeMinute["morning"] = Int(minuteStr) //피커뷰의 분을 담습니다
            
            AlarmService.shared.switchOnOff["total"] = true
            AlarmService.shared.switchOnOff["morning"] = true
            
            tableView.reloadData()
            
        }else if cellIdentificationNumber == 2{
            
            AlarmService.shared.mealTime["lunch"] = dateString
            
            
            AlarmService.shared.mealTimeAMPM["lunch"] = AMPMStr
            
            if AlarmService.shared.mealTimeAMPM["lunch"] == "AM" || AlarmService.shared.mealTimeAMPM["lunch"] == "오전" {
                if hourString == "12"{
                    AlarmService.shared.mealTimeHour["lunch"] = 0 //오전12시일경우 매칭할 시간이 0시가 됩니다 그래서 0으로 바꿔줍니다
                }else{
                    AlarmService.shared.mealTimeHour["lunch"] = Int(hourString)
                }
            }else if AlarmService.shared.mealTimeAMPM["lunch"] == "PM" || AlarmService.shared.mealTimeAMPM["lunch"] == "오후"{
                if hourString == "12"{
                    AlarmService.shared.mealTimeHour["lunch"] = Int(hourString)
                }else{
                    AlarmService.shared.mealTimeHour["lunch"] = Int(hourString)! + 12 //오후 1시일 경우 매칭할 숫자가 13시입니다 그래서 12를 더해 담습니다
                }
                
            }
            
            AlarmService.shared.mealTimeMinute["lunch"] = Int(minuteStr)
            
            AlarmService.shared.switchOnOff["total"] = true
            AlarmService.shared.switchOnOff["lunch"] = true
            
            tableView.reloadData()
            
        }else if cellIdentificationNumber == 3{
            
            AlarmService.shared.mealTime["dinner"] = dateString
            
            AlarmService.shared.mealTimeAMPM["dinner"] = AMPMStr
            
            if AlarmService.shared.mealTimeAMPM["dinner"] == "AM" || AlarmService.shared.mealTimeAMPM["dinner"] == "오전" {
                if hourString == "12"{
                    AlarmService.shared.mealTimeHour["dinner"] = 0 //오전12시일경우 매칭할 시간이 0시가 됩니다 그래서 0으로 바꿔줍니다
                }else{
                    AlarmService.shared.mealTimeHour["dinner"] = Int(hourString)
                }
            }else if AlarmService.shared.mealTimeAMPM["dinner"] == "PM" || AlarmService.shared.mealTimeAMPM["dinner"] == "오후"{
                if hourString == "12"{
                    AlarmService.shared.mealTimeHour["dinner"] = Int(hourString)
                }else{
                    AlarmService.shared.mealTimeHour["dinner"] = Int(hourString)! + 12 //오후 1시일 경우 매칭할 숫자가 13시입니다 그래서 12를 더해 담습니다
                }
                
            }
            
            AlarmService.shared.mealTimeMinute["dinner"] = Int(minuteStr)
            
            AlarmService.shared.switchOnOff["total"] = true
            AlarmService.shared.switchOnOff["dinner"] = true
            
            tableView.reloadData()
            
        }
        
        UserDefaults.standard.setValue(AlarmService.shared.mealTime, forKey: userDefaultsName.mealTime)
        UserDefaults.standard.setValue(AlarmService.shared.mealTimeHour, forKey: userDefaultsName.mealTimeHour)
        UserDefaults.standard.setValue(AlarmService.shared.mealTimeMinute, forKey: userDefaultsName.mealTimeMinute)
        UserDefaults.standard.setValue(AlarmService.shared.mealTimeAMPM, forKey: userDefaultsName.mealTimeAMPM)
        UserDefaults.standard.setValue(AlarmService.shared.switchOnOff, forKey: userDefaultsName.alarmOnOff)
        
        print(UserDefaults.standard.dictionary(forKey: userDefaultsName.alarmOnOff) ?? "알람OnOff값이 없음")
        print(AlarmService.shared.mealTimeAMPM)
        
        setMealTimeAlarmNotification()

        timePickerViewOut.isHidden = true
        timePickConfirmBtnOut.isHidden = true
        
       
    }
    
}
