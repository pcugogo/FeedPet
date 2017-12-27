//
//  MyPageViewController.swift
//  FeedPet
//
//  Created by 샤인 on 2017. 12. 21..
//  Copyright © 2017년 Ios_Park. All rights reserved.
//

import UIKit
import MessageUI

enum enumSettingSection:Int { //섹션 이름
    case Profile = 0
    case MyMenu = 1
    case Setting = 2
}


class MyPageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,MFMailComposeViewControllerDelegate {

    let settingMenuName = [ "버전정보","알람설정","FAQ","이용약관","문의하기","팀소개","로그아웃","탈퇴하기" ]
    //설정 메뉴 이름들
    
    let userSystemVersion = UIDevice.current.systemVersion // 현재 사용자 iOS 버전
    let userAppVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String // 현재 사용자 앱 버전
    
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

        let fAQView:FAQViewController = storyboard?.instantiateViewController(withIdentifier: "FAQViewController") as! FAQViewController
        let termsOfUseView:TermsOfUseViewController = storyboard?.instantiateViewController(withIdentifier: "TermsOfUseViewController") as! TermsOfUseViewController
        
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
            
            self.navigationController?.pushViewController(fAQView, animated: true)
            
        }else if indexPath.section == 2 && indexPath.row == 4 {
            
            self.navigationController?.pushViewController(termsOfUseView, animated: true)
            
        }else if indexPath.section == 2 && indexPath.row == 5 {
            if MFMailComposeViewController.canSendMail() {
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setToRecipients(["kisu9830@gmail.com"])
                mail.setSubject("문의합니다")
                
                guard let AppVersion = userAppVersion else{
                    return
                }
                
                mail.setMessageBody("* iOS Version: \(userSystemVersion) / App Version: \(String(describing: AppVersion))\n\n문의 내용을 입력해주세요", isHTML: false)
                present(mail, animated: true)
            } else {
                let mailSendFail:UIAlertController = UIAlertController(title: "문의하기", message: "기기에서 메일을 설정해주세요", preferredStyle: .alert) //문구 어떻게?
                let okBtn:UIAlertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                mailSendFail.addAction(okBtn)
                
                self.present(mailSendFail, animated: true, completion: nil)
                print("메일 보내기 실패")
            }
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
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .cancelled:
            print("취소")
        case .saved:
            print("임시저장")
        case .sent:
            let mailSendSuccessfulAlert:UIAlertController = UIAlertController(title: "문의하기", message: "메일 보내기 성공", preferredStyle: .alert) //문구 어떻게?
            
            let okBtn:UIAlertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            mailSendSuccessfulAlert.addAction(okBtn)
            
            self.present(mailSendSuccessfulAlert, animated: true, completion: nil)
            print("전송완료")
        default:
            print("전송실패")
        }
        dismiss(animated: true, completion: nil)
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

