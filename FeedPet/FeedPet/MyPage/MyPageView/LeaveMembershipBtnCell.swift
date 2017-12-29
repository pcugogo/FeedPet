//
//  LeaveMembershipBtnCell.swift
//  FeedPet
//
//  Created by 샤인 on 2017. 12. 29..
//  Copyright © 2017년 HwangGisu. All rights reserved.
//

import UIKit

protocol LeaveMembershipTableViewUpdater {
    func leaveMembershipTableViewIsHidden()
}

class LeaveMembershipBtnCell: UITableViewCell {

    var delegate:LeaveMembershipTableViewUpdater?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func leaveMembershipTableViewIsHiddenOn(){
        delegate?.leaveMembershipTableViewIsHidden()
    }
    
    @IBAction func cencelBtnAction(_ sender: UIButton) {
        leaveMembershipTableViewIsHiddenOn()
    }
    @IBAction func confirmBtnAction(_ sender: UIButton) {
        print(MyPageDataCenter.shared.leaveMembershipReason)
    }
    
}
