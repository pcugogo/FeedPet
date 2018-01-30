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
    func keyboardEndEditing()
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
        delegate?.leaveMembershipTableViewDisappear()
    }
    
    
    @IBAction func cencelBtnAction(_ sender: UIButton) {
        tableViewDisappear()
    }
    @IBAction func confirmBtnAction(_ sender: UIButton) {
        
        if MyPageDataCenter.shared.leaveMembershipReason != "" { //reloadData가 되기때문에 초기 색상을 지정해준다
            
            if MyPageDataCenter.shared.leaveMembershipReason == "기타" {
                if MyPageDataCenter.shared.leaveMembarshipEtcReasonContent == "" { //기타를 누르고 내용이 비었을때
                    print("기타 내용이 없음")
                }else{
                    print(MyPageDataCenter.shared.leaveMembershipReason)    //기타
                    print(MyPageDataCenter.shared.leaveMembarshipEtcReasonContent) //내용
                }
            }else{//여기까지 기타일때

            print(MyPageDataCenter.shared.leaveMembershipReason) // 이 부분에서 탈퇴 이유를 서버로 보낸다
            }
        }else{
            print("내용 선택이 되지 않았음")
        }
        
        MyPageDataCenter.shared.leaveMembershipReason = "" //초기화
        
        //탈퇴완료 확인 취소 알럿 후 회원가입 페이지로 이동
    }
    
    
}
