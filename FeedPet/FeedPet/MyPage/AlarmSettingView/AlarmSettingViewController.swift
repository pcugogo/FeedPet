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
    let dateFormatterHour:DateFormatter = DateFormatter() // hh
    let dateFormatterMinute:DateFormatter = DateFormatter() // mm
    let locKo = Locale(identifier: "ko")
    var cellIdentificationNumber = 0
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var timePickerViewOut: UIDatePicker!
    @IBOutlet weak var timePickConfirmBtnOut: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let alarmOnOffData = UserDefaults.standard.dictionary(forKey: "AlarmOnOff"){
            AlarmService.shared.switchOnOff = alarmOnOffData as! [String : Bool]
        }
        
        if let mealTimeData = UserDefaults.standard.dictionary(forKey: "MealTime"){
            AlarmService.shared.mealTime = mealTimeData as! [String:String]
        }
     
        if let mealTimeHourDate = UserDefaults.standard.dictionary(forKey: "mealTimeHour"){
            AlarmService.shared.mealTimeHour = mealTimeHourDate as! [String:Int]
        }
        
        if let mealTimeMinuteDate = UserDefaults.standard.dictionary(forKey: "mealTimeMinute"){
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
                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["mealTimeNTF"])
                    AlarmService.shared.switchOnOff = ["total":false,"morning":false,"lunch":false,"dinner":false]
                    UserDefaults.standard.set(AlarmService.shared.switchOnOff, forKey: "AlarmOnOff")
                    
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
    
     func setMealTimeAlarmNotification() {
         
        
        dateFormatterHour.dateFormat = "HH"
        
        dateFormatterMinute.dateFormat = "mm"
        
        var notificationDateComponents = DateComponents()
        
       
        
        // 01. UNMutableNotificationContent
        let notificationContent = UNMutableNotificationContent()
        
        if AlarmService.shared.switchOnOff["morning"] == true{
            
            notificationDateComponents.hour = AlarmService.shared.mealTimeHour["morning"]
            notificationDateComponents.minute = AlarmService.shared.mealTimeMinute["morning"]
            
            notificationContent.body = "아침 식사 시간입니다!"
            
            // 02. UNTimeIntervalNotificationTrigger
            let notificationTrigger = UNCalendarNotificationTrigger(dateMatching: notificationDateComponents, repeats: true)
            
            // 03. UNNotificationRequest
            let morningRequest: UNNotificationRequest = UNNotificationRequest(identifier: "morningAlarm", content: notificationContent, trigger: notificationTrigger)
            
            // 04. UNUserNotificationCenter
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
        
        // 기존 알림 확인
        UNUserNotificationCenter.current().getPendingNotificationRequests { (notificationRequests) in
            print("///// notificationRequests.count- 7892: \n", notificationRequests.count)
            print("///// notificationRequests detail- 7892: \n", notificationRequests)
        }
        
        notificationContent.sound = UNNotificationSound.default()
        
       
    }
    
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.view.endEditing(true)
//        timePickerViewOut.isHidden = true
//        timePickConfirmBtnOut.isHidden = true
//    }

    
    
    
    
    @IBAction func backBtnAction(_ sender: UIBarButtonItem) {
        UserDefaults.standard.set(AlarmService.shared.switchOnOff, forKey: "AlarmOnOff")
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func saveBtnAction(_ sender: UIBarButtonItem) {
        UserDefaults.standard.set(AlarmService.shared.switchOnOff, forKey: "AlarmOnOff")
    
    }
    

    
    @IBAction func timePickConfirmBtnAction(_ sender: UIButton) {
        
        tableView.isHidden = false
        
        formatter.locale = locKo
        formatter.dateFormat = "aa hh:mm"
        
        dateFormatterHour.dateFormat = "hh"
        dateFormatterMinute.dateFormat = "mm"
        
        let dateString = formatter.string(from: timePickerViewOut.date)
        let hourString = dateFormatterHour.string(from: timePickerViewOut.date)
        let minuteStr = dateFormatterMinute.string(from: timePickerViewOut.date)
        
        if cellIdentificationNumber == 1{
            
            AlarmService.shared.mealTime["morning"] = dateString
            AlarmService.shared.mealTimeHour["morning"] = Int(hourString)
            AlarmService.shared.mealTimeMinute["morning"] = Int(minuteStr)
            
            AlarmService.shared.switchOnOff["total"] = true
            AlarmService.shared.switchOnOff["morning"] = true
            
            tableView.reloadData()
            
        }else if cellIdentificationNumber == 2{
            
            AlarmService.shared.mealTime["lunch"] = dateString
            AlarmService.shared.mealTimeHour["lunch"] = Int(hourString)
            AlarmService.shared.mealTimeMinute["lunch"] = Int(minuteStr)
            
            AlarmService.shared.switchOnOff["total"] = true
            AlarmService.shared.switchOnOff["lunch"] = true
            
            tableView.reloadData()
            
        }else if cellIdentificationNumber == 3{
            
            AlarmService.shared.mealTime["dinner"] = dateString
            AlarmService.shared.mealTimeHour["dinner"] = Int(hourString)
            AlarmService.shared.mealTimeMinute["dinner"] = Int(minuteStr)
            
            AlarmService.shared.switchOnOff["total"] = true
            AlarmService.shared.switchOnOff["dinner"] = true
            
            tableView.reloadData()
            
        }
        
        UserDefaults.standard.setValue(AlarmService.shared.mealTime, forKey: "MealTime")
        UserDefaults.standard.setValue(AlarmService.shared.mealTimeHour, forKey: "mealTimeHour")
        UserDefaults.standard.setValue(AlarmService.shared.mealTimeMinute, forKey: "mealTimeMinute")
        
        UserDefaults.standard.setValue(AlarmService.shared.switchOnOff, forKey: "AlarmOnOff")
        
        print(UserDefaults.standard.setValue(AlarmService.shared.switchOnOff, forKey: "AlarmOnOff"))
        setMealTimeAlarmNotification()
        
        
        
        timePickerViewOut.isHidden = true
        timePickConfirmBtnOut.isHidden = true
    }
    
}
