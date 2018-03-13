//
//  MyPageViewController.swift
//  FeedPet
//
//  Created by 샤인 on 2017. 12. 21..
//  Copyright © 2017년 Ios_Park. All rights reserved.
//

import UIKit
import MessageUI
import Firebase
import Photos

enum enumSettingSection:Int { //섹션 이름
    case Profile = 0
    case MyMenu = 1
    case Setting = 2
}

class MyPageViewController: UIViewController, UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,MyPageCellDelegate {
    
    let settingMenuName = ["버전정보","알람설정","FAQ","이용약관","문의하기","팀소개","로그아웃","탈퇴하기" ]
    let settingMenuImg = [#imageLiteral(resourceName: "MyPageVersionInfo"),#imageLiteral(resourceName: "MyPageAlarmSetting"),#imageLiteral(resourceName: "MyPageFAQ"),#imageLiteral(resourceName: "MyPageTermsOfUse"),#imageLiteral(resourceName: "MyPageContactUs"),#imageLiteral(resourceName: "MyPageTeamIntroduction"),#imageLiteral(resourceName: "MyPageLogOut"),#imageLiteral(resourceName: "MyPageLeaveMembership")]
    //설정 메뉴 이름들
    
    let deviceInfo = UIDevice.current.model
    let userSystemNameAndVersion = "\(UIDevice.current.systemName) \(UIDevice.current.systemVersion)" // 현재 사용자 iOS 버전
    let userAppVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String // 현재 사용자 앱 버전
    var profileImg:UIImage?
    var userData: User?
    var spinerView = UIView()
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var loadingImgView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print(MyPageDataCenter.shared.favorites)
        
        
        // 프로필 정보 데이터 통신
        if let userUID = UserDefaults.standard.string(forKey: "userUID"){
            spinerView = DataCenter.shared.displsyLoadingIndicator(onView: self.view)
            
            // 통신부분
            FireBaseData.shared.fireBaseUserInfoLoadData(userUID: userUID, completion: { (userInfo) in
                self.userData = userInfo
                DataCenter.shared.removeSpinner(spinner: self.spinerView)
                
                self.tableView.reloadData()
            })
        }

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        tableView.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
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
        
       
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 && indexPath.row == 0{
            
            let profileCell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileCell
            profileCell.delegate = self
            print("유저data://",userData)
            if let userInfo = userData {
                profileCell.userInfo = userInfo
                
                print("셀와서 데이터://", userInfo)
                if let pickImg = self.profileImg {
                    profileCell.profileImg.image = pickImg
                    profileCell.profileImg.clipsToBounds = true
                }
                
                
            }
//            if let userUID = UserDefaults.standard.string(forKey: "userUID"){
//                spinerView = DataCenter.shared.displsyLoadingIndicator(onView: self.view)
//                FireBaseData.shared.fireBaseUserInfoLoadData(userUID: userUID, completion: { (userInfo) in
//                    profileCell.userInfo = userInfo
//                    print("셀와서 데이터://", userInfo)
//                    if let pickImg = self.profileImg {
//                        profileCell.profileImg.image = pickImg
//                        profileCell.profileImg.clipsToBounds = true
//                    }
//                    DataCenter.shared.removeSpinner(spinner: self.spinerView)
//
//                })
//            }
            return profileCell
            
            
            
        }else if indexPath.section == 1 && indexPath.row == 0 {
            
            let myMenuCell = tableView.dequeueReusableCell(withIdentifier: "MyMenuCell", for: indexPath) as! MyMenuCell

            myMenuCell.delegate = self
            myMenuCell.favoritesNumLb.text = "\(MyPageDataCenter.shared.favoritesCount)개"
            myMenuCell.myReviewsNumLb.text = "\(MyPageDataCenter.shared.reviewsCount)개"
            
            return myMenuCell
            
        }else if indexPath.section == 2 && indexPath.row == 0 {
            
            let settingHeaderCell = tableView.dequeueReusableCell(withIdentifier: "SettingHeaderCell", for: indexPath) as! SettingHeaderCell
            return settingHeaderCell
            
        }else{
            let settingCell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath) as! SettingCell
            settingCell.settingMenuNameLb.text = settingMenuName[indexPath.row - 1]
            settingCell.settingIconimg.image = settingMenuImg[indexPath.row - 1]
            
            return settingCell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if indexPath.section == 0 && indexPath.row == 0{              //프로필 수정
            let editInfoView:EditInfoViewController = self.storyboard?.instantiateViewController(withIdentifier: "EditInfoViewController") as! EditInfoViewController
            editInfoView.dataIsLoaded = true
            self.navigationController?.pushViewController(editInfoView, animated: true)
            
        }else if indexPath.section == 2 && indexPath.row == 1{        //버전
            DispatchQueue.main.async{
                guard let appVersion = self.userAppVersion else{
                    return
                }
                
                let versionAlert:UIAlertController = UIAlertController(title: "ver \(appVersion)", message: "최신 ver 1.1.0", preferredStyle: .alert)
                
                let okBtn:UIAlertAction = UIAlertAction(title: "업데이트 하러가기", style: .default, handler: nil)
                versionAlert.addAction(okBtn)
                
                self.present(versionAlert, animated: true, completion: nil)
            }
            
        }else if indexPath.section == 2 && indexPath.row == 2{        //알람 설정
            let alarmSettingView:AlarmSettingViewController = self.storyboard?.instantiateViewController(withIdentifier: "AlarmSettingViewController") as! AlarmSettingViewController
            
            self.navigationController?.pushViewController(alarmSettingView, animated: true)
            
        }else if indexPath.section == 2 && indexPath.row == 3{        //FAQ
            let fAQView:FAQViewController = storyboard?.instantiateViewController(withIdentifier: "FAQViewController") as! FAQViewController
            self.navigationController?.pushViewController(fAQView, animated: true)
            
        }else if indexPath.section == 2 && indexPath.row == 4 {        //이용 약관
            let termsOfUseView:TermsOfUseViewController = storyboard?.instantiateViewController(withIdentifier: "TermsOfUseViewController") as! TermsOfUseViewController

            self.navigationController?.pushViewController(termsOfUseView, animated: true)    
        }else if indexPath.section == 2 && indexPath.row == 5 {        //문의하기
            if MFMailComposeViewController.canSendMail() {
                let mail = MFMailComposeViewController()
                mail.navigationBar.isTranslucent = false
                mail.mailComposeDelegate = self
                mail.setToRecipients(["feedpet2018@gmail.com"])
                mail.navigationBar.isTranslucent = false
                mail.setSubject("Feedpet Support")
                
                guard let appVersion = userAppVersion else{
                    return
                }
                //Please type your feedback above the line./ 앱버전/ 디바이스:아이폰 /프로세서/ os: /langauge
                mail.setMessageBody("\n\n\n\n\n\n\n------------------------------\nPlease type your feedback above the line.\n\nFeedPet v\(appVersion)\nDevice: \(deviceInfo)\nOS: \(userSystemNameAndVersion)", isHTML: false)
                present(mail, animated: true)
                print("메일 보내기 성공")
            } else {
                let mailSendFail:UIAlertController = UIAlertController(title: "문의하기", message: "기기에서 메일을 설정해주세요", preferredStyle: .alert) //문구 어떻게?
                let okBtn:UIAlertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                mailSendFail.addAction(okBtn)
                
                self.present(mailSendFail, animated: true, completion: nil)
                print("메일 보내기 실패")
            }
        }else if indexPath.section == 2 && indexPath.row == 6 {     //팀 소개
            let teamIntroductionView = storyboard?.instantiateViewController(withIdentifier: "TeamIntroductionViewController") as! TeamIntroductionViewController
            self.navigationController?.pushViewController(teamIntroductionView, animated: true)
        }else if indexPath.section == 2 && indexPath.row == 7 {     //로그 아웃
            
            DispatchQueue.main.async {
                let logoutQuestion:UIAlertController = UIAlertController(title: "", message: "로그아웃 하시겠습니까?", preferredStyle: .alert)
                let confirmBtn:UIAlertAction = UIAlertAction(title: "확인", style: .default, handler: nil)
                let cencelBtn:UIAlertAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
                logoutQuestion.addAction(cencelBtn)
                logoutQuestion.addAction(confirmBtn)
                
                // Completion 부분에서 로그아웃 처리 필요
                self.present(logoutQuestion, animated: true, completion: nil)
            }
            
            
        }else if indexPath.section == 2 && indexPath.row == 8 {     //탈퇴하기
            let leaveMembershipView:LeaveMembershipViewController = storyboard?.instantiateViewController(withIdentifier: "LeaveMembershipViewController") as! LeaveMembershipViewController
            
            self.addChildViewController(leaveMembershipView) //alarmMealTimePickerView에 있는 피커뷰를 addsubview
            self.navigationController?.isNavigationBarHidden = true
            leaveMembershipView.view.frame = self.view.frame //참고 사이트 https://www.youtube.com/watch?v=FgCIRMz_3dE
            self.view.addSubview(leaveMembershipView.view)
            leaveMembershipView.didMove(toParentViewController: self)
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
            return 20
    }
    
    func toFavoritesView() {
        let myPageFavoritesView:MyPageFavoritesViewController = storyboard?.instantiateViewController(withIdentifier: "MyPageFavoritesViewController") as! MyPageFavoritesViewController
        navigationController?.pushViewController(myPageFavoritesView, animated: true)
    }
    
    func toMyReviewView() {
        let myPageMyReviewsView:MyPageMyReviewsViewController = storyboard?.instantiateViewController(withIdentifier: "MyPageMyReviewsViewController") as! MyPageMyReviewsViewController
        navigationController?.pushViewController(myPageMyReviewsView, animated: true)
    }
    func imgPickerSet() {
        //UINavigationControllerDelegate델리게이트를 사용해야 사용할수있다
        spinerView = DataCenter.shared.displsyLoadingIndicator(onView: self.view)
        let photos = PHPhotoLibrary.authorizationStatus()
        if photos == .notDetermined {
            PHPhotoLibrary.requestAuthorization({status in
                if status == .authorized{
                    
                } else {}
            })
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePickerController:UIImagePickerController =
                UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.navigationBar.isTranslucent = false
            self.present(imagePickerController, animated: true, completion: {
                DispatchQueue.main.async {
                    DataCenter.shared.removeSpinner(spinner: self.spinerView)
                }
            })
            
        }
        
    }
    
    @IBAction func backBtnAction(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension MyPageViewController:MFMailComposeViewControllerDelegate{
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

extension MyPageViewController:UIImagePickerControllerDelegate{
    func imagePickerController(_ picker:UIImagePickerController,didFinishPickingMediaWithInfo info: [String:Any]){
        print("info:",info)
        
        guard let pickImg = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            return
        }
        pickImg.withRenderingMode(.alwaysOriginal) // 색상이 파란색으로 나오는 경우의 이유는 시스템 버튼을 쓰게 되면 자동 랜더링을 쓰게 되는 경우가 있는데 이렇게 모드를 바꿔주면 내가 고른 이미지를 띄워줘라는 뜻이다
        profileImg = pickImg
        tableView.reloadData()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
                 guard let uploadData = UIImagePNGRepresentation(pickImg) else {return}
        
                Storage.storage().reference().child("UserProfile/").child(MyPageDataCenter.shared.testUUID).putData(uploadData, metadata: nil, completion: { (metaData, error) in
        
                    if let error = error{
                        print("error://",error)
                        return
                    }
                    
//                    print("metaData://",metaData)
                    guard let urlStr = metaData?.downloadURL()?.absoluteString else {return}//업로드한 이미지 다운받는 URL
                    print(urlStr)
                    
                    
                    FireBaseData.shared.refUserInfoReturn.child(MyPageDataCenter.shared.testUUID).updateChildValues(["user_img":urlStr])
                    
                    
                })
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        self.dismiss(animated: true, completion: nil)
        
    }
}


