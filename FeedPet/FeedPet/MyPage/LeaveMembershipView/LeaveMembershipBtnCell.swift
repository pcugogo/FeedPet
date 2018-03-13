//
//  LeaveMembershipBtnCell.swift
//  FeedPet
//
//  Created by 샤인 on 2017. 12. 29..
//  Copyright © 2017년 HwangGisu. All rights reserved.
//

import UIKit


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
        
        if MyPageDataCenter.shared.leaveMembershipReason != "" { //reloadData가 되기때문에 초기 색상을 지정해준다
            
            if MyPageDataCenter.shared.leaveMembershipReason == "기타" {
                if MyPageDataCenter.shared.leaveMembarshipEtcReasonContent == "" { //기타를 누르고 내용이 비었을때
                    // print 내용 서버로
                    print("기타 내용이 없음")
                    MyPageDataCenter.shared.leaveMembershipReason = "" //초기화
                    // 로그아웃 후 처음 화면이동 -> tableViewDisappear() 삭제
                    tableViewDisappear()
                }else{
                    print(MyPageDataCenter.shared.leaveMembershipReason)    //기타
                    print(MyPageDataCenter.shared.leaveMembarshipEtcReasonContent) //내용
                    MyPageDataCenter.shared.leaveMembershipReason = "" //초기화
                    tableViewDisappear()
                }
            }else{//여기까지 기타일때
                
                print(MyPageDataCenter.shared.leaveMembershipReason) // 이 부분에서 탈퇴 이유를 서버로 보낸다
                MyPageDataCenter.shared.leaveMembershipReason = "" //초기화
                tableViewDisappear()
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
