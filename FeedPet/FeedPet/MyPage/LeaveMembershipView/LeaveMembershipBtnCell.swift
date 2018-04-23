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
    func cancleBtnTouchTableViewDisappear()
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
//        delegate?.navigationbarHiddeFalse()
        delegate?.leaveMembershipTableViewDisappear()
    }
    
    
    @IBAction func cencelBtnAction(_ sender: UIButton) {
//        tableViewDisappear()
//        delegate?.navigationbarHiddeFalse()
        delegate?.cancleBtnTouchTableViewDisappear()
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
            
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
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
                    
    
                    // 탈퇴하려는 현재 로그인된 사용자 정보
                    guard let user = Auth.auth().currentUser else {return}
                    // 탈퇴하려는 로그인 UID
                    let leaveUserUid = user.uid
                    print("탈퇴정보등록후:1//",user)
                    // 소셜로그아웃 진행
                    DataCenter.shared.socialLogOut(completion: { (result) in
                        
                        print("로그아웃결과안오네://",result)
                        // 로그아웃후 결과값 처리->true일 경우
                        if result {
                       //사용자 정보를 지우지 않고 탈퇴여부 flag값 할당=> "user_leave"
                            Database.database().reference().child("user_info").child(leaveUserUid).updateChildValues(["user_leave": true])
                            // 사용자 정보 변경후 Authentication에서 로그인한 사용자 정보 제거
                            
                            user.delete { error in
                                if let error = error {
                                    print("--user delete error://",error.localizedDescription)
                                    
                                } else { // 사용자 정보 제거 완료후
                                    // 탈퇴 tableview dismiss 처리
                                    self.tableViewDisappear()
                                    // 탈퇴이유 초기화
                                    MyPageDataCenter.shared.leaveMembershipReason = "" //초기화
//                                    let leaveUserUid = user.uid
//                                    print("탈퇴정보등록후:2//",leaveUserUid)
                                    
                                    //                            Database.database().reference().child("user_info").child(leaveUserUid).updateChildValues(["user_leave": true])
//                                    DataCenter.shared.socialLogOut(completion: { (result) in
//
//                                        print("로그아웃결과안오네://",result)
//                                        if result {
//
//
//                                            self.tableViewDisappear()
//                                        }else{
//
//                                        }
//
//                                        MyPageDataCenter.shared.leaveMembershipReason = "" //초기화
//
//                                    })
                                    guard let userProfile = DataCenter.shared.userInfo.userProfileImgUrl else {return}
                                    // Storage에 저장된 사용자 파일 제거==> 이미지가 있을경우 분기처리해한다.
                                    let storageRef = Storage.storage().reference().child("UserProfile/").child(leaveUserUid)
//                                    storageRef.delete(completion: nil)
                                    storageRef.delete(completion: { (error) in
                                        if let error = error{

                                        }else{
                                            
                                        }
                                        
                                    })
                                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                                }
                            }

                           
                            
                        }else{
                            print("--user logout error--")
                        }
                        
                    })
                }
            }

    
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
