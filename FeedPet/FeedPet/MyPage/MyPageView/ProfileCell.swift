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
    // 옵저버프로퍼티를 사용하여 MyPageViewController에서 ProfileCell의 userInfo값을 할당하면 호출되게 구현
    // awakeFromNib()은 데이터가 오기전에 이미 호출
    var userInfo: User? {
        didSet{
            
            guard let userInfo = userInfo else {return}
            
            userIdLb.text = userInfo.userEmail
            nickNameLb.text = userInfo.userNickname
//            if let userImg = userInfo.userProfileImgUrl, let userProfileImgURL = URL(string: userImg) {
//                profileImg.kf.setImage(with: userProfileImgURL)
//
//            }else{
//                profileImg.image = #imageLiteral(resourceName: "MyPageProfile")
//
//            }
            guard let userImg = userInfo.userProfileImgUrl else {return}
//            DispatchQueue.global(qos: .userInteractive).async {
//                if let userProfileImgURL = URL(string: userImg) {
//                    DispatchQueue.main.async {
//
//                        self.profileImg.kf.setImage(with: userProfileImgURL)
//                        self.profileImg.layer.cornerRadius = 40
//                        self.profileImg.clipsToBounds = true
//                    }
//                }
//
//            }
            
            if let userProfileImgURL = URL(string: userImg) {
                DispatchQueue.main.async {
                    
                    self.profileImg.kf.setImage(with: userProfileImgURL)
                    self.profileImg.layer.cornerRadius = 40
                    self.profileImg.clipsToBounds = true
                }
            }
            
            if userInfo.userPet == "feed_petkey_d"{
                petTypeLb.text = "#멍"
                petTypeLb.backgroundColor = UIColor.init(hexString: "#1ABC9C")
                petAgeLb.backgroundColor = UIColor.init(hexString: "#1ABC9C")
                switch userInfo.userPetAge{
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
                petTypeLb.backgroundColor = UIColor.init(hexString: "#F1C40F")
                petAgeLb.backgroundColor = UIColor.init(hexString: "#F1C40F")
                switch userInfo.userPetAge {
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
    }
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var nickNameLb: UILabel!
    @IBOutlet weak var userIdLb: UILabel!
    @IBOutlet weak var petTypeLb: UILabel!
    @IBOutlet weak var petAgeLb: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
     
        // 그려질때 데이터 없이 UI부분이라 상관없이 사용가능
        profileImg.layer.cornerRadius = 40
        profileImg.clipsToBounds = true
        
        petTypeLb.layer.masksToBounds = true
        petTypeLb.layer.cornerRadius = 5
        
        petAgeLb.layer.masksToBounds = true
        petAgeLb.layer.cornerRadius = 5
        

      
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
