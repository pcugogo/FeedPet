//
//  MyPageViewController.swift
//  FeedPet
//
//  Created by 샤인 on 2017. 12. 21..
//  Copyright © 2017년 Ios_Park. All rights reserved.
//

import UIKit

enum enumSettingSection:Int {
    case Profile = 0
    case MyMenu = 1
    case Setting = 2
}


class MyPageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let settingMenuName = [ "버전정보","알람설정","FAQ","이용약관","문의하기","팀소개","로그아웃","탈퇴하기" ]
    //설정 메뉴 이름들
    override func viewDidLoad() {
        super.viewDidLoad()

       
        
        
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case enumSettingSection.Profile.rawValue:
            return 1 // 프로필이 있는 섹션
        case enumSettingSection.MyMenu.rawValue:
            return 1 // 즐겨찾기, 내리뷰등 내 메뉴가 있는 섹션
        case enumSettingSection.Setting.rawValue:
            return settingMenuName.count + 1 //설정셀 갯수 + 설정헤더1
        default:
            return 0
        }
        
//        if section == 0{
//            return 1
//        }else if section == 1{
//            return 1
//        }else{
//            return settingMenuName.count + 1
//        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        
        if indexPath.section == 0 && indexPath.row == 0{

            let profileCell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileCell
            return profileCell

        }else if indexPath.section == 1 && indexPath.row == 0 {

            let myMenuCell = tableView.dequeueReusableCell(withIdentifier: "MyMenuCell", for: indexPath) as! MyMenuCell
            return myMenuCell

        }else if indexPath.section == 2 && indexPath.row == 0 {

            let settingHeaderCell = tableView.dequeueReusableCell(withIdentifier: "SettingHeaderCell", for: indexPath) as! SettingHeaderCell
            return settingHeaderCell

        }else{
            let settingCell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath) as! SettingCell
            settingCell.settingMenuNameLb.text = settingMenuName[indexPath.row - 1]
            return settingCell
        }
      
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let editInfoView:EditInfoViewController = self.storyboard?.instantiateViewController(withIdentifier: "EditInfoViewController") as! EditInfoViewController
        
        let alarmSettingView:AlarmSettingViewController = self.storyboard?.instantiateViewController(withIdentifier: "AlarmSettingViewController") as! AlarmSettingViewController

        if indexPath.section == 0 && indexPath.row == 0{
            
            self.navigationController?.pushViewController(editInfoView, animated: true)
            
        }else if indexPath.section == 2 && indexPath.row == 1{
            let versionAlert:UIAlertController = UIAlertController(title: "ver 1.1.0", message: "최신 ver 1.2.0", preferredStyle: .alert)
            
            let okBtn:UIAlertAction = UIAlertAction(title: "업데이트 하러가기", style: .default, handler: nil)
            versionAlert.addAction(okBtn)
            
            self.present(versionAlert, animated: true, completion: nil)
            
            
        }else if indexPath.section == 2 && indexPath.row == 2{
            
            self.navigationController?.pushViewController(alarmSettingView, animated: true)
            
        }else if indexPath.section == 2 && indexPath.row == 3{
            print("FAQ")
        }else if indexPath.section == 2 && indexPath.row == 4 {
            print("이용약관")
        }else if indexPath.section == 2 && indexPath.row == 5 {
            print("문의하기")
        }else if indexPath.section == 2 && indexPath.row == 6 {
            print("팀소개")
        }else if indexPath.section == 2 && indexPath.row == 7 {
            print("로그아웃")
        }else if indexPath.section == 2 && indexPath.row == 8 {
            print("탈퇴하기")
        }
        
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 && indexPath.row == 0{
           
            return 120
        }else if indexPath.section == 1 && indexPath.row == 0 {
            
            return 130
        }else if indexPath.section == 2 && indexPath.row == 0 {
         
            return 70
        }else{
          
            return 50
        }
        
        
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 20
        }else{
            return 20
        }
    }

}


//extension MyPageViewController: UITableViewDelegate, UITableViewDataSource {
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let reuseIdentifier = "ProfileCell"
//        
//        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ProfileCell
//        return cell
//    }
//}

