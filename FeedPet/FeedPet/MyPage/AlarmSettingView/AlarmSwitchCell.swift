//
//  AlarmSwitchCell.swift
//  FeedPet2
//
//  Created by 샤인 on 2017. 12. 22..
//  Copyright © 2017년 Ios_Park. All rights reserved.
//

import UIKit
import UserNotifications

class AlarmSwitchCell: UITableViewCell {

    var delegate: CustomCellUpdater?
    var indexPath:Int = 0
    
    @IBOutlet weak var alarmSwitchOut: UISwitch!
    @IBOutlet weak var mealTimeImg: UIImageView!
    @IBOutlet weak var mealTimeLb: UILabel!
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
    
    @IBAction func alarmSwitchAction(_ sender: UISwitch) {
        
        
        if indexPath == 1{
            AlarmService.shared.switchOnOff["morning"] = sender.isOn
            if sender.isOn == true{
                AlarmService.shared.switchOnOff["total"] = true
                
                setMealTimeAlarmNotification()
                
            }else if sender.isOn == false{
                
                //removePendingNotificationRequests(withIdentifiers: [""]) 스위치가 off일때 알람이름을 선택하여 해당 알람을 지웁니다.
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["morningAlarm"])
                
                if AlarmService.shared.switchOnOff["morning"] == false &&  AlarmService.shared.switchOnOff["lunch"] == false && AlarmService.shared.switchOnOff["dinner"] == false {
                    AlarmService.shared.switchOnOff["total"] = false
                    tvReload()
                }
            }
            tvReload()
            print(AlarmService.shared.switchOnOff)
        }else if indexPath == 2{
            AlarmService.shared.switchOnOff["lunch"] = sender.isOn
            if sender.isOn == true{
                
                AlarmService.shared.switchOnOff["total"] = true
                
                setMealTimeAlarmNotification()
                
            }else if sender.isOn == false{
                
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["lunchAlarm"])
                
                if AlarmService.shared.switchOnOff["morning"] == false &&  AlarmService.shared.switchOnOff["lunch"] == false && AlarmService.shared.switchOnOff["dinner"] == false {
                    
                    AlarmService.shared.switchOnOff["total"] = false
                    tvReload()
                }
            }
            tvReload()
            print(AlarmService.shared.switchOnOff)
        }else if indexPath == 3{
            AlarmService.shared.switchOnOff["dinner"] = sender.isOn
            if sender.isOn == true{
                
                AlarmService.shared.switchOnOff["total"] = true
                
                setMealTimeAlarmNotification()
                
            }else if sender.isOn == false{
                
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["dinnerAlarm"])
                
                if AlarmService.shared.switchOnOff["morning"] == false &&  AlarmService.shared.switchOnOff["lunch"] == false && AlarmService.shared.switchOnOff["dinner"] == false {
                    AlarmService.shared.switchOnOff["total"] = false
                    tvReload()
                }
            }
            
            tvReload()
            print(AlarmService.shared.switchOnOff)
            
        }
        
        UserDefaults.standard.setValue(AlarmService.shared.switchOnOff, forKey: userDefaultsName.alarmOnOff)
        print("=====================UserDefaults Set=====================",UserDefaults.standard.dictionary(forKey: userDefaultsName.alarmOnOff) ?? "알람OnOff값이 없음")
        
    }
    //토탈 스위치는 모든 스위치를 끄고 켤 수 있다 일반 스위치는 하나가 켜지면 토탈 스위치도 켜지고 일반스위치가 다꺼지면 토탈 스위치도 꺼진다
    
}
