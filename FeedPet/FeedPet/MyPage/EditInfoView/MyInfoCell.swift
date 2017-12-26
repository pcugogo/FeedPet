//
//  MyInfoCellCell.swift
//  FeedPet2
//
//  Created by 샤인 on 2017. 12. 22..
//  Copyright © 2017년 Ios_Park. All rights reserved.
//

import UIKit

class MyInfoCell: UITableViewCell {
    @IBOutlet weak var emailLb: UILabel!
    
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var confirmBtnOut: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        confirmBtnOut.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func confirmBtnAction(_ sender: UIButton) {
    }
    
}
