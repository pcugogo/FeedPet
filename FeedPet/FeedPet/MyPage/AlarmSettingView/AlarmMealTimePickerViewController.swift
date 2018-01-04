//
//  AlarmMealTimePickerViewController.swift
//  FeedPet
//
//  Created by 샤인 on 2017. 12. 28..
//  Copyright © 2017년 HwangGisu. All rights reserved.
//

import UIKit

class AlarmMealTimePickerViewController: UIViewController {

    var delegate: AlarmCustomCellUpdater?
    var cellIdentificationNumber = 0 //몇번째셀의 알람인지 didSelectRowAt에서 보내준다
    
    let formatter:DateFormatter = DateFormatter() // "aa hh:mm"
    let dateFormatterAMPM = DateFormatter()
    let dateFormatterHour:DateFormatter = DateFormatter() // hh
    let dateFormatterMinute:DateFormatter = DateFormatter() // mm
    let locKo = Locale(identifier: "ko")
    
    @IBOutlet weak var timePickerViewOut: UIDatePicker!
    @IBOutlet weak var timePickConfirmBtnOut: UIButton!
    @IBOutlet weak var contentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerViewUp()
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        
        timePickerViewOut.locale = locKo
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableViewReload() {
        delegate?.updateTableView()
    }
    
    func setMealTimeAlarmNotification(){
        delegate?.UpdateMealTimeAlarmNotification()
    }
    
    func mealTimeSetting(){
        //피커뷰의 시간 데이터를 저장하고 시간데이터로 노티피케이션을 등록()하는 함수 
        
        print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@",cellIdentificationNumber)
        
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
            
            MyPageDataCenter.shared.mealTime["morning"] = dateString          //셀의 레이블에 담을 피커뷰의 시간을 담습니다
            
            MyPageDataCenter.shared.mealTimeAMPM["morning"] = AMPMStr
            
            if MyPageDataCenter.shared.mealTimeAMPM["morning"] == "AM" || MyPageDataCenter.shared.mealTimeAMPM["morning"] == "오전" {
                if hourString == "12"{
                    MyPageDataCenter.shared.mealTimeHour["morning"] = 0 //오전12시일경우 매칭할 시간이 0시가 됩니다 그래서 0으로 바꿔줍니다
                }else{
                    MyPageDataCenter.shared.mealTimeHour["morning"] = Int(hourString)
                }
            }else if MyPageDataCenter.shared.mealTimeAMPM["morning"] == "PM" || MyPageDataCenter.shared.mealTimeAMPM["morning"] == "오후"{
                if hourString == "12"{
                    MyPageDataCenter.shared.mealTimeHour["morning"] = Int(hourString)
                }else{
                    MyPageDataCenter.shared.mealTimeHour["morning"] = Int(hourString)! + 12 //오후 1시일 경우 매칭할 숫자가 13시입니다 그래서 12를 더해 담습니다
                }
                
            }
            
            MyPageDataCenter.shared.mealTimeMinute["morning"] = Int(minuteStr) //피커뷰의 분을 담습니다
            
            MyPageDataCenter.shared.switchOnOff["total"] = true
            MyPageDataCenter.shared.switchOnOff["morning"] = true
            
            
            
        }else if cellIdentificationNumber == 2{
            
            MyPageDataCenter.shared.mealTime["lunch"] = dateString
            
            
            MyPageDataCenter.shared.mealTimeAMPM["lunch"] = AMPMStr
            
            if MyPageDataCenter.shared.mealTimeAMPM["lunch"] == "AM" || MyPageDataCenter.shared.mealTimeAMPM["lunch"] == "오전" {
                if hourString == "12"{
                    MyPageDataCenter.shared.mealTimeHour["lunch"] = 0 //오전12시일경우 매칭할 시간이 0시가 됩니다 그래서 0으로 바꿔줍니다
                }else{
                    MyPageDataCenter.shared.mealTimeHour["lunch"] = Int(hourString)
                }
            }else if MyPageDataCenter.shared.mealTimeAMPM["lunch"] == "PM" || MyPageDataCenter.shared.mealTimeAMPM["lunch"] == "오후"{
                if hourString == "12"{
                    MyPageDataCenter.shared.mealTimeHour["lunch"] = Int(hourString)
                }else{
                    MyPageDataCenter.shared.mealTimeHour["lunch"] = Int(hourString)! + 12 //오후 1시일 경우 매칭할 숫자가 13시입니다 그래서 12를 더해 담습니다
                }
                
            }
            
            MyPageDataCenter.shared.mealTimeMinute["lunch"] = Int(minuteStr)
            
            MyPageDataCenter.shared.switchOnOff["total"] = true
            MyPageDataCenter.shared.switchOnOff["lunch"] = true
            
            
            
        }else if cellIdentificationNumber == 3{
            
            MyPageDataCenter.shared.mealTime["dinner"] = dateString
            
            MyPageDataCenter.shared.mealTimeAMPM["dinner"] = AMPMStr
            
            if MyPageDataCenter.shared.mealTimeAMPM["dinner"] == "AM" || MyPageDataCenter.shared.mealTimeAMPM["dinner"] == "오전" {
                if hourString == "12"{
                    MyPageDataCenter.shared.mealTimeHour["dinner"] = 0 //오전12시일경우 매칭할 시간이 0시가 됩니다 그래서 0으로 바꿔줍니다
                }else{
                    MyPageDataCenter.shared.mealTimeHour["dinner"] = Int(hourString)
                }
            }else if MyPageDataCenter.shared.mealTimeAMPM["dinner"] == "PM" || MyPageDataCenter.shared.mealTimeAMPM["dinner"] == "오후"{
                if hourString == "12"{
                    MyPageDataCenter.shared.mealTimeHour["dinner"] = Int(hourString)
                }else{
                    MyPageDataCenter.shared.mealTimeHour["dinner"] = Int(hourString)! + 12 //오후 1시일 경우 매칭할 숫자가 13시입니다 그래서 12를 더해 담습니다
                }
                
            }
            
            MyPageDataCenter.shared.mealTimeMinute["dinner"] = Int(minuteStr)
            
            MyPageDataCenter.shared.switchOnOff["total"] = true
            MyPageDataCenter.shared.switchOnOff["dinner"] = true
            
            
            
        }
        
        UserDefaults.standard.setValue(MyPageDataCenter.shared.mealTime, forKey: userDefaultsName.mealTime)
        UserDefaults.standard.setValue(MyPageDataCenter.shared.mealTimeHour, forKey: userDefaultsName.mealTimeHour)
        UserDefaults.standard.setValue(MyPageDataCenter.shared.mealTimeMinute, forKey: userDefaultsName.mealTimeMinute)
        UserDefaults.standard.setValue(MyPageDataCenter.shared.mealTimeAMPM, forKey: userDefaultsName.mealTimeAMPM)
        UserDefaults.standard.setValue(MyPageDataCenter.shared.switchOnOff, forKey: userDefaultsName.alarmOnOff)
        
        print(UserDefaults.standard.dictionary(forKey: userDefaultsName.alarmOnOff) ?? "알람OnOff값이 없음")
        print(MyPageDataCenter.shared.mealTimeAMPM)
        
        tableViewReload()
        
        setMealTimeAlarmNotification() //위에 세팅된 시간으로 노티피케이션 등록하는 함수
        
        
    } //여기까지가 mealTimeSetting()
    
    func pickerViewUp(){  // 피커뷰가 올라옴
        UIView.animate(withDuration: 0.3, animations: {
            self.contentView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 245.0)
        }){ (finished) in
            if finished {
                
            }
        }
    }
    
    func pickerViewDown(){ //피커뷰가 내려감
        UIView.animate(withDuration: 0.3, animations: {  //contentView의 y축이 self.view의 y축 끝으로 가게하기
            self.contentView.frame = CGRect(x: 0, y: self.view.frame.maxY, width: self.view.bounds.width, height: 245.0)
        }){ (finished) in
            if finished {
                self.view.removeFromSuperview()
                
            }
        }
        
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        mealTimeSetting() //피커뷰의 시간 데이터를 저장하고 시간데이터로 노티피케이션을 등록하는 함수
//        removeAnimate()
//    }
    
    @IBAction func timePickConfirmBtnAction(_ sender: UIButton) {
        mealTimeSetting()   //피커뷰의 시간 데이터를 저장하고 시간데이터로 노티피케이션을 등록하는 함수
        pickerViewDown()
    }
    
    @IBAction func pickerCancelBtnAction(_ sender: UIButton) {
        pickerViewDown()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
