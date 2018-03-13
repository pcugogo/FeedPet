//
//  EditInfoViewPetFunctionCollectionViewCell.swift
//  FeedPet
//
//  Created by ChanWook Park on 2018. 2. 1..
//  Copyright © 2018년 HwangGisu. All rights reserved.
//

import UIKit

class EditInfoViewPetFunctionCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var functionalLabel: UILabel!
    
    
    var petSelectInt: Int = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        self.functionalLabel.textColor = .white
        //        self.layer.backgroundColor = #colorLiteral(red: 1, green: 0.8288275599, blue: 0, alpha: 1).cgColor
        self.layer.backgroundColor = UIColor.gray.cgColor
        self.layer.cornerRadius = 3 //self.layer.bounds.size.height/2
        
    }
    override var isSelected: Bool{
        didSet{
            if isSelected{
                if petSelectInt == 0{
                    self.backgroundColor = UIColor.init(hexString: "#1ABC9C")
                    
                }else{
                    self.backgroundColor = UIColor.init(hexString: "#F1C40F")
                }
            }else {
                self.backgroundColor = .gray //.clear
                
            }
        }
    }
    
    
}
