//
//  ProfileCell.swift
//  FeedPet
//
//  Created by 샤인 on 2017. 12. 21..
//  Copyright © 2017년 Ios_Park. All rights reserved.
//

import UIKit

class ProfileCell: UITableViewCell,UIImagePickerControllerDelegate {

    var delegate:MyPageCellDelegate?
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var nickNameLb: UILabel!
    @IBOutlet weak var userIdLb: UILabel!
    @IBOutlet weak var petTypeLb: UILabel!
    @IBOutlet weak var petAgeLb: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImg.layer.cornerRadius = 40
        petTypeLb.layer.masksToBounds = true
        petTypeLb.layer.cornerRadius = 3
        petAgeLb.layer.masksToBounds = true
        petAgeLb.layer.cornerRadius = 3
      
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func imageRegistration(){
        delegate?.imgPickerSet()
    }
    @IBAction func profileImgBtnAction(_ sender: UIButton) {
        imageRegistration()
    }
    
}
