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
        
        etcReasonContentTextField.addTarget(self, action: #selector(textFieldDidChanged), for: .editingChanged)//
        //텍스트필드의 텍스트가 변경되는 것을 체크한다
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func leaveMembershipTableViewReloadData(){
        delegate?.leaveMembershipTableViewReloadData()
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let etcReasonContent = etcReasonContentTextField.text{
            MyPageDataCenter.shared.leaveMembarshipEtcReasonContent = etcReasonContent
        }
        leaveMembershipTableViewReloadData()
    }
    @objc func textFieldDidChanged(){ //텍스트필드의 텍스트가 변경되면 변경내용을 변수에 담는다
        if let etcReasonContent = etcReasonContentTextField.text{
            MyPageDataCenter.shared.leaveMembarshipEtcReasonContent = etcReasonContent
        }
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
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        return newLength <= 27
    }
    
    
    
}
