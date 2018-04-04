//
//  LeaveMembershipBtnCell.swift
//  FeedPet
//
//  Created by 샤인 on 2017. 12. 29..
//  Copyright © 2017년 HwangGisu. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import GoogleSignIn

protocol LeaveMembershipCustomCellDelegate {
    func leaveMembershipTableViewReloadData()
    func leaveMembershipTableViewDisappear()
    func navigationbarHiddeFalse()
}



class LeaveMembershipBtnCell: UITableViewCell {
    
    var delegate:LeaveMembershipCustomCellDelegate?
    
    @IBOutlet weak var confirmBtnOut: UIButton!
    @IBOutlet weak var cencelBtnOut: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func tableViewDisappear(){
        delegate?.navigationbarHiddeFalse()
        delegate?.leaveMembershipTableViewDisappear()
    }
    
    
    @IBAction func cencelBtnAction(_ sender: UIButton) {
        tableViewDisappear()
    }
    @IBAction func confirmBtnAction(_ sender: UIButton) {
        print(MyPageDataCenter.shared.leaveMembershipReason)
        if MyPageDataCenter.shared.leaveMembershipReason != "" { //reloadData가 되기때문에 초기 색상을 지정해준다
            
            if MyPageDataCenter.shared.leaveMembershipReason == "기타" {
                if MyPageDataCenter.shared.leaveMembarshipEtcReasonContent == "" { //기타를 누르고 내용이 비었을때
                    // print 내용 서버로
                    print("기타 내용이 없음")
                    MyPageDataCenter.shared.leaveMembershipReason = "기타 내용이 없음" //기타 내용이 없음
                    // 로그아웃 후 처음 화면이동 -> tableViewDisappear() 삭제
//                    tableViewDisappear()
                }else{
                    print(MyPageDataCenter.shared.leaveMembershipReason)    //기타
                    print(MyPageDataCenter.shared.leaveMembarshipEtcReasonContent) //내용
                    MyPageDataCenter.shared.leaveMembershipReason = MyPageDataCenter.shared.leaveMembarshipEtcReasonContent
//                    MyPageDataCenter.shared.leaveMembershipReason = "" //초기화
//                    tableViewDisappear()
                }
            }else{//여기까지 기타일때
                
                print(MyPageDataCenter.shared.leaveMembershipReason) // 이 부분에서 탈퇴 이유를 서버로 보낸다
//                MyPageDataCenter.shared.leaveMembershipReason = "" //초기화
//                tableViewDisappear()
            }
            
            // 탈퇴데이터에 정보를 쌓고  유저정보에서 탈퇴정보를 추가해준다. 플래그로 분리
            
            
            Database.database().reference().child("leave_user").childByAutoId().runTransactionBlock({[unowned self] (currentData) -> TransactionResult in
                
//                var currentLeaveData = currentData.value as? [String:Any] ?? [:]
//                print(currentLeaveData)
//                var boardCount = currentLeaveData["leave_reason"] as? String
//                var boardData =  currentLeaveData["leave_date"] as? [String:Any] ?? [:]
            
                var leaveUserData: [String: Any] = [:]
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "ko")
                formatter.dateFormat = "yyyy.MM.dd HH:mm"
                let currentDataString = formatter.string(from: Date())
                
                print("탈뢰이유://.",MyPageDataCenter.shared.leaveMembershipReason,"/")
                leaveUserData.updateValue(MyPageDataCenter.shared.leaveMembershipReason, forKey: "leave_reason")
                leaveUserData.updateValue(currentDataString, forKey: "leave_date")
                var newBoard: [String:Any] = [:]
                let autoID = Database.database().reference().childByAutoId()
                
//                newBoard[autoID] = leaveUserData
                
                print(autoID.description())
                currentData.value = leaveUserData
//                currentData.value = newBoard
                
                    // 현재 리뷰 좋아요 정보에 사용자가 존재시 좋아요 취소
//                    if let _ = unlikes[currentUserUID] {
//                        unlikeCount -= 1
//                        unlikes.removeValue(forKey: currentUserUID)
//
//                    }else{ // 존재하지 않을 경우 좋아요 추가
//                        unlikeCount += 1
//                        unlikes[currentUserUID] = true
//                    }
//                    post["data"] = unlikes
//                    post["unlike_count"] = unlikeCount
//
//                    currentData.value = post
//                    DispatchQueue.main.async {
//                        self.reviewUnLikeLabel.text = unlikeCount.description
//                    }
//               MyPageDataCenter.shared.leaveMembershipReason = "" //초기화
                    return TransactionResult.success(withValue: currentData)
                
                
            }) { (error, committed, snapshot) in
                if let error = error {
                    print("///// error 4632: \n", error.localizedDescription)
                }
                
                // 탈퇴정보 등록후 로그아웃 처리 및 Auth에 계정삭제
                if committed {
                    
    
//                    guard let leaveUserUid = Auth.auth().currentUser?.uid else { return}
                    let user = Auth.auth().currentUser
                    user?.delete { error in
                        if let error = error {
                            print("--user delete error://",error.localizedDescription)
                        } else {
                            
                            guard let leaveUserUid = user?.uid else { return }
                            Database.database().reference().child("user_info").child(leaveUserUid).updateChildValues(["user_leave": true])
                            DataCenter.shared.socialLogOut(completion: { (result) in
                                
                                if result {
                                    self.tableViewDisappear()
                                }else{
                                    
                                }
                                
                                MyPageDataCenter.shared.leaveMembershipReason = "" //초기화
                                
                            })
                            
                        }
                    }
                    
                    
                }
            }

            // 탈퇴 데이터구조는 탈퇴한 이유, 탈퇴일 기록
            
            let user = Auth.auth().currentUser
//            guard let proviederID = Auth.auth().currentUser?.providerData.first?.providerID else { return }
//            var credential: AuthCredential
//            if proviederID == "google.com" {
////                let authentication = user.authentication
//                
////                credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
//            }else{
//                credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
//            }

            
//            user?.delete(completion: { (error) in
//                if let error = error {
//                    // An error happened
//                    print(error.localizedDescription)
//                } else {
//                    // Account deleted.
//
//                }
//            })
            
            
            // Prompt the user to re-provide their sign-in credentials
            
//            user?.reauthenticate(with: credential) { error in
//                if let error = error {
//                    // An error happened.
//                } else {
//                    // User re-authenticated.
//                }
//            }
            /*
            user?.reauthenticate(with:credential) { error in
                if let error = error {
                    // An error happened.
                    showAlertWithErrorMessage(message: error.localizedDescription)
                } else {
                    // User re-authenticated.
                    user?.delete { error in
                        if let error = error {
                            // An error happened.
                            showAlertWithErrorMessage(message: error.localizedDescription)
                        } else {
                            // Account deleted.
                            let userID = HelperFunction.helper.FetchFromUserDefault(name: kUID)
                            Database.database().reference(fromURL: kFirebaseLink).child(kUser).child(userID).removeValue()
                            
                            try!  Auth.auth().signOut()
                            showAlertWithErrorMessage(message: "Your account deleted successfully...")
                            return
                        }
                    }
                    
                }
            }
            */
        }else{
            // Alert 처리
            print("내용 선택이 되지 않았음")
        }
        
        
        
        //탈퇴완료 확인 취소 알럿 후 회원가입 페이지로 이동
    }
    
    
}
extension LeaveMembershipCustomCellDelegate{
    func leaveMembershipTableViewReloadData(){
        
    }
    func leaveMembershipTableViewDisappear(){
        
    }
    
}
