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
        petTypeLb.layer.cornerRadius = 5
        petAgeLb.layer.masksToBounds = true
        petAgeLb.layer.cornerRadius = 5
        
        userIdLb.text = MyPageDataCenter.shared.userEmail
        nickNameLb.text = MyPageDataCenter.shared.userNicName
        if let userProfileImgURL = URL(string:MyPageDataCenter.shared.userImg) {
            profileImg.kf.setImage(with: userProfileImgURL)
            profileImg.layer.cornerRadius = 40
            profileImg.clipsToBounds = true
        }
        if MyPageDataCenter.shared.petType == "functional_petkey_d"{
            petTypeLb.text = "#멍"
            switch MyPageDataCenter.shared.petAge{
            case 0:
                petAgeLb.text = "#퍼피"
            case 1:
                petAgeLb.text = "#어덜트"
            case 2:
                petAgeLb.text = "#시니어"
            default:
                print("error")
            }
        }else{
            petTypeLb.text = "#냥"
            switch MyPageDataCenter.shared.petAge{
            case 0:
                petAgeLb.text = "#키튼"
            case 1:
                petAgeLb.text = "#어덜트"
            case 2:
                petAgeLb.text = "#시니어"
            default:
                print("error")
            }
        }
        
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
