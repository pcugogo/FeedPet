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


class MyPageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,MFMailComposeViewControllerDelegate,LeaveMembershipTableViewUpdater {
    
    let settingMenuName = [ "버전정보","알람설정","FAQ","이용약관","문의하기","팀소개","로그아웃","탈퇴하기" ]
    //설정 메뉴 이름들
    
    let userSystemVersion = UIDevice.current.systemVersion // 현재 사용자 iOS 버전
    let userAppVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String // 현재 사용자 앱 버전
    let leaveMembershipReasonText = ["사용하기 불편해요","정보가 부족해요","다른앱을 사용하고 싶어요","기타"]
    
    
    @IBOutlet weak var myPageTableView: UITableView!
    @IBOutlet weak var leaveMembershipTableView: UITableView!
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
        if tableView == myPageTableView{
            return 3
        }else{
            return 1
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == myPageTableView{
            
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
        }else{
            return 6
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
        
        if tableView == myPageTableView {
            
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
        }else{ //탈퇴하기 TableView
            if indexPath.row == 0 {
                let leaveMembershipHeaderCell:LeaveMembershipHeaderCell = tableView.dequeueReusableCell(withIdentifier: "LeaveMembershipHeaderCell", for: indexPath) as! LeaveMembershipHeaderCell
                return leaveMembershipHeaderCell
            }else if indexPath.row == 5{
                let leaveMembershipBtnCell:LeaveMembershipBtnCell = tableView.dequeueReusableCell(withIdentifier: "LeaveMembershipBtnCell", for: indexPath) as! LeaveMembershipBtnCell
                leaveMembershipBtnCell.delegate = self
                return leaveMembershipBtnCell
            }else{
                let leaveMembershipReasonCell:LeaveMembershipReasonCell = tableView.dequeueReusableCell(withIdentifier: "LeaveMembershipReasonCell", for: indexPath) as! LeaveMembershipReasonCell
                leaveMembershipReasonCell.textLabel?.text = leaveMembershipReasonText[indexPath.row - 1]
                return leaveMembershipReasonCell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == myPageTableView{
            
            if indexPath.section == 0 && indexPath.row == 0{
                let editInfoView:EditInfoViewController = self.storyboard?.instantiateViewController(withIdentifier: "EditInfoViewController") as! EditInfoViewController
                
                self.navigationController?.pushViewController(editInfoView, animated: true)
                
            }else if indexPath.section == 2 && indexPath.row == 1{
                let versionAlert:UIAlertController = UIAlertController(title: "ver 1.1.0", message: "최신 ver 1.2.0", preferredStyle: .alert)
                
                let okBtn:UIAlertAction = UIAlertAction(title: "업데이트 하러가기", style: .default, handler: nil)
                versionAlert.addAction(okBtn)
                
                self.present(versionAlert, animated: true, completion: nil)
                
                
            }else if indexPath.section == 2 && indexPath.row == 2{
                let alarmSettingView:AlarmSettingViewController = self.storyboard?.instantiateViewController(withIdentifier: "AlarmSettingViewController") as! AlarmSettingViewController
                
                self.navigationController?.pushViewController(alarmSettingView, animated: true)
                
            }else if indexPath.section == 2 && indexPath.row == 3{
                let fAQView:FAQViewController = storyboard?.instantiateViewController(withIdentifier: "FAQViewController") as! FAQViewController
                self.navigationController?.pushViewController(fAQView, animated: true)
                
            }else if indexPath.section == 2 && indexPath.row == 4 {
                let termsOfUseView:TermsOfUseViewController = storyboard?.instantiateViewController(withIdentifier: "TermsOfUseViewController") as! TermsOfUseViewController
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
                    print("메일 보내기 성공")
                } else {
                    let mailSendFail:UIAlertController = UIAlertController(title: "문의하기", message: "기기에서 메일을 설정해주세요", preferredStyle: .alert) //문구 어떻게?
                    let okBtn:UIAlertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    mailSendFail.addAction(okBtn)
                    
                    self.present(mailSendFail, animated: true, completion: nil)
                    print("메일 보내기 실패")
                }
            }else if indexPath.section == 2 && indexPath.row == 6 {
                let teamIntroductionView = storyboard?.instantiateViewController(withIdentifier: "TeamIntroductionViewController") as! TeamIntroductionViewController
                self.navigationController?.pushViewController(teamIntroductionView, animated: true)
            }else if indexPath.section == 2 && indexPath.row == 7 {
                let logoutQuestion:UIAlertController = UIAlertController(title: "", message: "로그아웃 하시겠습니까?", preferredStyle: .alert)
                let confirmBtn:UIAlertAction = UIAlertAction(title: "확인", style: .default, handler: nil)
                let cencelBtn:UIAlertAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
                logoutQuestion.addAction(cencelBtn)
                logoutQuestion.addAction(confirmBtn)
                self.present(logoutQuestion, animated: true, completion: nil)
                
            }else if indexPath.section == 2 && indexPath.row == 8 {
                leaveMembershipTableView.isHidden = false
                myPageTableView.alpha = 0.5
            }
        }else{ //leaveMembershipTableView 
            if indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 4{
                
                MyPageDataCenter.shared.leaveMembershipReason = leaveMembershipReasonText[indexPath.row - 1]
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == myPageTableView{
            
            if indexPath.section == 0 && indexPath.row == 0{
                
                return 120
            }else if indexPath.section == 1 && indexPath.row == 0 {
                
                return 130
            }else if indexPath.section == 2 && indexPath.row == 0 {
                
                return 70
            }else{
                
                return 50
            }
        }else{
            if indexPath.row == 5{
                return 70
            }else{
                return 46
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if tableView == myPageTableView{
            if section == 0 {
                return 20
            }else{
                return 20
            }
        }else{
            return 0
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
    
    func leaveMembershipTableViewIsHidden() {
    
        myPageTableView.alpha = 1.0
        leaveMembershipTableView.isHidden = true

    }
}



