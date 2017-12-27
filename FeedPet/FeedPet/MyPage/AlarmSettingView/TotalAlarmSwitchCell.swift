//
//  TotalAlarmSwitchCell.swift
//  FeedPet2
//
//  Created by 샤인 on 2017. 12. 22..
//  Copyright © 2017년 Ios_Park. All rights reserved.
//

import UIKit
import UserNotifications

protocol CustomCellUpdater {
    func updateTableView()
    func UpdateMealTimeAlarmNotification()
}

class TotalAlarmSwitchCell: UITableViewCell {

    var delegate: CustomCellUpdater?
    
    @IBOutlet weak var totalAlarmSwitchOut: UISwitch!
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func tvReload() {
            delegate?.updateTableView()
    }
    func setMealTimeAlarmNotification(){
        delegate?.UpdateMealTimeAlarmNotification()
    }
    
    @IBAction func totalAlarmSwitchAction(_ sender: UISwitch) {
       
        
        
        AlarmService.shared.switchOnOff["total"] = sender.isOn
        
        if sender.isOn == false{
            AlarmService.shared.switchOnOff = ["total":false,"morning":false,"lunch":false,"dinner":false]

            UserDefaults.standard.set(AlarmService.shared.switchOnOff, forKey: userDefaultsName.alarmOnOff)
            
            //removeAllPendingNotificationRequests() 토탈스위치가 off일때 모든 알람을 지워줍니다.
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            
            // 기존 알림 확인
            UNUserNotificationCenter.current().getPendingNotificationRequests { (notificationRequests) in
                print("///// notificationRequests.count- 7892: \n", notificationRequests.count)
                print("///// notificationRequests detail- 7892: \n", notificationRequests)
            }
            
            tvReload()
            
        }else{
            AlarmService.shared.switchOnOff = ["total":true,"morning":true,"lunch":true,"dinner":true]
            
            UserDefaults.standard.set(AlarmService.shared.switchOnOff, forKey: userDefaultsName.alarmOnOff)
            
            setMealTimeAlarmNotification() //토탈스위치가 on일때 모든 알람을 켜줍니다.
            
            tvReload()
        }

        print(AlarmService.shared.switchOnOff)
        
        UserDefaults.standard.setValue(AlarmService.shared.switchOnOff, forKey: userDefaultsName.alarmOnOff)
        
        print(UserDefaults.standard.dictionary(forKey: userDefaultsName.alarmOnOff) ?? "알람OnOff값이 없음")
    }
    
}
