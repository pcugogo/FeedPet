//
//  LeaveMembershipEtcReasonCell.swift
//  FeedPet
//
//  Created by 샤인 on 2018. 1. 3..
//  Copyright © 2018년 HwangGisu. All rights reserved.
//

import UIKit



class LeaveMembershipEtcReasonCell: UITableViewCell,UITextFieldDelegate {
    
    
    var delegate:LeaveMembershipCustomCellDelegate?
    
    @IBOutlet weak var etcReasonContentTextField: UITextField!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        etcReasonContentTextField.delegate = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func leaveMembershipTableViewReloadData(){
        delegate?.leaveMembershipTableViewReloadData()
    }
    
    func leaveMembershipTableViewLocationUp(){
        delegate?.leaveMembershipTableViewLocationChange()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        leaveMembershipTableViewLocationUp()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let etcReasonContent = etcReasonContentTextField.text{
            MyPageDataCenter.shared.leaveMembarshipEtcReasonContent = etcReasonContent
        }
        leaveMembershipTableViewReloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if let etcReasonContent = etcReasonContentTextField.text{
            MyPageDataCenter.shared.leaveMembarshipEtcReasonContent = etcReasonContent
        }
        print(MyPageDataCenter.shared.leaveMembarshipEtcReasonContent)
        
        leaveMembershipTableViewReloadData()
        
        textField.resignFirstResponder()
        
        return true
    }
    
    
    
}
