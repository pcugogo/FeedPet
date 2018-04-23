//
//  AlarmSettingViewController.swift
//  FeedPet2
//
//  Created by 샤인 on 2017. 12. 22..
//  Copyright © 2017년 Ios_Park. All rights reserved.
//

import UIKit
import UserNotifications

class AlarmSettingViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,AlarmCustomCellDelegate {
    
    var isGrantedNotificationAccess = false
        
    var cellIdentificationNumber = 0
    
    let alarmIconImg = [#imageLiteral(resourceName: "morningAlarm"),#imageLiteral(resourceName: "LunchAlarm"),#imageLiteral(resourceName: "DinnerAlarm")]
    
    @IBOutlet weak var tableView: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //전에 입력한 정보들을 불러온다
        if let alarmOnOffData = UserDefaults.standard.dictionary(forKey: userDefaultsName.alarmOnOff){
            MyPageDataCenter.shared.switchOnOff = alarmOnOffData as! [String : Bool]
        }
        
        if let mealTimeData = UserDefaults.standard.dictionary(forKey: userDefaultsName.mealTime){
            MyPageDataCenter.shared.mealTime = mealTimeData as! [String:String]
        }
     
        if let mealTimeAMPM = UserDefaults.standard.dictionary(forKey: userDefaultsName.mealTimeAMPM){
            MyPageDataCenter.shared.mealTimeAMPM = mealTimeAMPM as! [String:String]
        }
        
        if let mealTimeHourDate = UserDefaults.standard.dictionary(forKey: userDefaultsName.mealTimeHour){
            MyPageDataCenter.shared.mealTimeHour = mealTimeHourDate as! [String:Int]
        }
        
        if let mealTimeMinuteDate = UserDefaults.standard.dictionary(forKey: userDefaultsName.mealTimeMinute){
            MyPageDataCenter.shared.mealTimeMinute = mealTimeMinuteDate as! [String:Int]
        }
        
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(
                options: [.alert,.sound,.badge],
                completionHandler: { (granted,error) in
                    self.isGrantedNotificationAccess = granted
                    if !granted{
                        
                        // 사용자가 직접 iOS 설정에서 알림을 off 하는 케이스 예외처리
                        // 아래의 세팅을 하지 않으면, notification들이 쌓여 있다가, 알림을 on 할 때, 터질 가능성이 있는 케이스의 예외처리입니다.
                        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                        MyPageDataCenter.shared.switchOnOff = ["total":false,"morning":false,"lunch":false,"dinner":false]
                        UserDefaults.standard.set(MyPageDataCenter.shared.switchOnOff, forKey: userDefaultsName.alarmOnOff)
                        
                    }
            })
        }else{
            
        }
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
            if let totalSwitch = MyPageDataCenter.shared.switchOnOff["total"]{
                totalSwitchCell.totalAlarmSwitchOut.isOn = totalSwitch
            }
            totalSwitchCell.delegate = self
            
            return totalSwitchCell
            
        }else{
            let switchCell:AlarmSwitchCell = tableView.dequeueReusableCell(withIdentifier: "AlarmSwitchCell", for: indexPath) as! AlarmSwitchCell
            
            switchCell.delegate = self
            switchCell.mealTimeImg.image = alarmIconImg[indexPath.row - 1]
            
            if indexPath.row == 1{
                if let morningTime = MyPageDataCenter.shared.mealTime["morning"], let morningSwitchOnOff = MyPageDataCenter.shared.switchOnOff["morning"]{
                    switchCell.mealTimeLb.text = morningTime
                    switchCell.indexPath = indexPath.row
                    switchCell.alarmSwitchOut.isOn = morningSwitchOnOff
                }
                
            }else if indexPath.row == 2{
                if let lunchTime = MyPageDataCenter.shared.mealTime["lunch"], let lunchSwitchOnOff = MyPageDataCenter.shared.switchOnOff["lunch"]{
                    switchCell.mealTimeLb.text = lunchTime
                    switchCell.indexPath = indexPath.row
                    switchCell.alarmSwitchOut.isOn = lunchSwitchOnOff
                }
                
            }else if indexPath.row == 3{
                if let dinnerTime = MyPageDataCenter.shared.mealTime["dinner"], let dinnerSwitchOnOff = MyPageDataCenter.shared.switchOnOff["dinner"]{
                    switchCell.mealTimeLb.text = dinnerTime
                    switchCell.indexPath = indexPath.row
                    switchCell.alarmSwitchOut.isOn = dinnerSwitchOnOff
                }
                
            }
            
            return switchCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let alarmMealTimePickerView:AlarmMealTimePickerViewController = storyboard?.instantiateViewController(withIdentifier: "AlarmMealTimePickerViewController") as! AlarmMealTimePickerViewController
        
        if indexPath.row == 1{
            
            cellIdentificationNumber = 1
            alarmMealTimePickerView.cellIdentificationNumber = 1
            
            alarmMealTimePickerView.delegate = self //델리게이트 권한 위임
            
            self.addChildViewController(alarmMealTimePickerView) //alarmMealTimePickerView에 있는 피커뷰를 addsubview
            self.navigationController?.isNavigationBarHidden = true 
            alarmMealTimePickerView.view.frame = self.view.frame //참고 사이트 https://www.youtube.com/watch?v=FgCIRMz_3dE
            self.view.addSubview(alarmMealTimePickerView.view)
            alarmMealTimePickerView.didMove(toParentViewController: self)
        }else if indexPath.row == 2{
            cellIdentificationNumber = 2
            alarmMealTimePickerView.cellIdentificationNumber = 2
            
            alarmMealTimePickerView.delegate = self
            
            self.addChildViewController(alarmMealTimePickerView)
            self.navigationController?.isNavigationBarHidden = true
            alarmMealTimePickerView.view.frame = self.view.frame
            self.view.addSubview(alarmMealTimePickerView.view)
            alarmMealTimePickerView.didMove(toParentViewController: self)
            
        }else if indexPath.row == 3{
            cellIdentificationNumber = 3
            alarmMealTimePickerView.cellIdentificationNumber = 3
            
            alarmMealTimePickerView.delegate = self
            
            self.addChildViewController(alarmMealTimePickerView)
            self.navigationController?.isNavigationBarHidden = true
            alarmMealTimePickerView.view.frame = self.view.frame
            self.view.addSubview(alarmMealTimePickerView.view)
            alarmMealTimePickerView.didMove(toParentViewController: self)
            
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
        
        
        var notificationDateComponents = DateComponents()
        
        if #available(iOS 10.0, *) { //10.0 버전 이상 지원가능한 알람 세팅입니다
            
            // 01. UNMutableNotificationContent
            let notificationContent = UNMutableNotificationContent() //알림에 필요한 기본 콘텐츠 설정을 할 수 있습니다.
            //알람 제목,내용,뱃지,알람사운드 등 세팅들을 설정할 수 있습니다.
            notificationContent.sound = UNNotificationSound.default() // 사운드를 기본으로 설정
            
            
            //각각 아침,점심,저녁 각각 알람마다 세팅
            if MyPageDataCenter.shared.switchOnOff["morning"] == true{
                
                notificationDateComponents.hour = MyPageDataCenter.shared.mealTimeHour["morning"]
                //시간 세팅해준 포메터에 피커뷰에서 받은 시간을 세팅
                
                notificationDateComponents.minute = MyPageDataCenter.shared.mealTimeMinute["morning"]
                //분 세팅해준 포메터에 피커뷰에서 받은 분을 세팅
                notificationContent.body = "아이들 아침을 챙겨주세요!"
                
                // 02. UNTimeIntervalNotificationTrigger
                //여기서 시간과 매칭하는 트리거를 사용할 수도 있고 TimeIntervald을 체크하는 트리거를 사용할 수도 있습니다 반복여부도 설정가능
                let notificationTrigger = UNCalendarNotificationTrigger(dateMatching: notificationDateComponents, repeats: true)
                
                // 03. UNNotificationRequest 알림 요청 객체 생성
                let morningRequest: UNNotificationRequest = UNNotificationRequest(identifier: "morningAlarm", content: notificationContent, trigger: notificationTrigger)
                
                // 04. UNUserNotificationCenter 스케줄러, add(_:)를 통해 알림 요청 객체 추가로 알림 등록 과정 완료.
                
                UNUserNotificationCenter.current().add(morningRequest, withCompletionHandler: nil)
            }
            if MyPageDataCenter.shared.switchOnOff["lunch"] == true{
                
                notificationDateComponents.hour = MyPageDataCenter.shared.mealTimeHour["lunch"]
                notificationDateComponents.minute = MyPageDataCenter.shared.mealTimeMinute["lunch"]
                
                notificationContent.body = "아이들 점심을 챙겨주세요!"
                
                // 02. UNTimeIntervalNotificationTrigger
                let notificationTrigger = UNCalendarNotificationTrigger(dateMatching: notificationDateComponents, repeats: true)
                
                // 03. UNNotificationRequest
                let lunchRequest: UNNotificationRequest = UNNotificationRequest(identifier: "lunchAlarm", content: notificationContent, trigger: notificationTrigger)
                
                // 04. UNUserNotificationCenter
               
                UNUserNotificationCenter.current().add(lunchRequest, withCompletionHandler: nil)
            }
            if MyPageDataCenter.shared.switchOnOff["dinner"] == true{
                notificationContent.body = "아이들 저녁을 챙겨주세요!"
                
                notificationDateComponents.hour = MyPageDataCenter.shared.mealTimeHour["dinner"]
                notificationDateComponents.minute = MyPageDataCenter.shared.mealTimeMinute["dinner"]
                
                // 02. UNTimeIntervalNotificationTrigger
                let notificationTrigger = UNCalendarNotificationTrigger(dateMatching: notificationDateComponents, repeats: true)
                
                // 03. UNNotificationRequest
                let dinnerRequest: UNNotificationRequest = UNNotificationRequest(identifier: "dinnerAlarm", content: notificationContent, trigger: notificationTrigger)
                
                // 04. UNUserNotificationCenter
                UNUserNotificationCenter.current().add(dinnerRequest, withCompletionHandler: nil)
                
            }
        }else{ // 10.0버전 미만 버전
            if MyPageDataCenter.shared.switchOnOff["morning"] == true{
                
                let notification = UILocalNotification()
                
                notificationDateComponents.hour = MyPageDataCenter.shared.mealTimeHour["morning"]
                notificationDateComponents.minute = MyPageDataCenter.shared.mealTimeMinute["morning"]
                
                notification.fireDate = notificationDateComponents.date
                notification.alertBody = "아침 식사 시간입니다!"
                notification.alertAction = "아침"
                notification.soundName = UILocalNotificationDefaultSoundName
                
                UIApplication.shared.scheduleLocalNotification(notification)
            }
            if MyPageDataCenter.shared.switchOnOff["lunch"] == true{
                let notification = UILocalNotification()
                
                notificationDateComponents.hour = MyPageDataCenter.shared.mealTimeHour["lunch"]
                notificationDateComponents.minute = MyPageDataCenter.shared.mealTimeMinute["lunch"]
                
                notification.fireDate = notificationDateComponents.date
                notification.alertBody = "점심 식사 시간입니다!"
                notification.alertAction = "점심"
                notification.soundName = UILocalNotificationDefaultSoundName
                
                UIApplication.shared.scheduleLocalNotification(notification)
            }
            if MyPageDataCenter.shared.switchOnOff["dinner"] == true{
                let notification = UILocalNotification()
                
                notificationDateComponents.hour = MyPageDataCenter.shared.mealTimeHour["dinner"]
                notificationDateComponents.minute = MyPageDataCenter.shared.mealTimeMinute["dinner"]
                
                notification.fireDate = notificationDateComponents.date
                notification.alertBody = "저녁 식사 시간입니다!"
                notification.alertAction = "저녁"
                notification.soundName = UILocalNotificationDefaultSoundName
                
                UIApplication.shared.scheduleLocalNotification(notification)
            }
        }
        
        if #available(iOS 10.0, *) {
            // 기존 알림 확인
            UNUserNotificationCenter.current().getPendingNotificationRequests { (notificationRequests) in
                print("///// notificationRequests.count- 7892: \n", notificationRequests.count)
                print("///// notificationRequests detail- 7892: \n", notificationRequests)
            }
            
        }else{
            
        }
    }
    
    func navigationbarHiddeFalse(){
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func backBtnAction(_ sender: UIBarButtonItem) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func alarmResetBtnAction(_ sender: UIBarButtonItem) {
        
        MyPageDataCenter.shared.switchOnOff = ["total":false,"morning":false,"lunch":false,"dinner":false]
        MyPageDataCenter.shared.mealTime = ["morning":"오전 08:00","lunch":"오후 12:30","dinner":"오후 07:00"]
        MyPageDataCenter.shared.mealTimeHour = ["morning":08,"lunch":12,"dinner":19]
        MyPageDataCenter.shared.mealTimeMinute = ["morning":00,"lunch":30,"dinner":00]
        MyPageDataCenter.shared.mealTimeAMPM = ["morning":"nil","lunch":"nil","dinner":"nil"]
        UserDefaults.standard.removeObject(forKey: userDefaultsName.mealTime)
        UserDefaults.standard.removeObject(forKey: userDefaultsName.mealTimeHour)
        UserDefaults.standard.removeObject(forKey: userDefaultsName.mealTimeMinute)
        UserDefaults.standard.removeObject(forKey: userDefaultsName.mealTimeAMPM)
        UserDefaults.standard.removeObject(forKey: userDefaultsName.alarmOnOff)
//        UserDefaults.standard.setValue(MyPageDataCenter.shared.mealTime, forKey: userDefaultsName.mealTime)
//        UserDefaults.standard.setValue(MyPageDataCenter.shared.mealTimeHour, forKey: userDefaultsName.mealTimeHour)
//        UserDefaults.standard.setValue(MyPageDataCenter.shared.mealTimeMinute, forKey: userDefaultsName.mealTimeMinute)
//        UserDefaults.standard.setValue(MyPageDataCenter.shared.mealTimeAMPM, forKey: userDefaultsName.mealTimeAMPM)
//        UserDefaults.standard.setValue(MyPageDataCenter.shared.switchOnOff, forKey: userDefaultsName.alarmOnOff)
        
        if #available(iOS 10.0, *) {
            //removeAllPendingNotificationRequests() 토탈스위치가 off일때 모든 알람을 지워줍니다.
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            
            // 기존 알림 확인
            UNUserNotificationCenter.current().getPendingNotificationRequests { (notificationRequests) in
                print("///// notificationRequests.count- 7892: \n", notificationRequests.count)
                print("///// notificationRequests detail- 7892: \n", notificationRequests)
            }
        }
        tableView.reloadData()
    }
    

    
}
