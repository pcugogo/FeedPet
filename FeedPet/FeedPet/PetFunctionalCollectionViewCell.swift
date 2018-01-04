//
//  PetFunctionalCollectionViewCell.swift
//  FeedPet
//
//  Created by HwangGisu on 2017. 12. 28..
//  Copyright © 2017년 HwangGisu. All rights reserved.
//

import UIKit

class PetFunctionalCollectionViewCell: UICollectionViewCell {
 
    @IBOutlet weak var functionalLabel: UILabel!
    
    
    var petSelectInt: Int = 0 {
        didSet{
            petKindChangeCheck()
        }
    }
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
                petKindChangeCheck()
            }else {
                self.backgroundColor = .gray //.clear
                
            }
        }
    }
    
    func petKindChangeCheck(){
        if petSelectInt == 0{
            self.backgroundColor = UIColor.init(hexString: "#1ABC9C")
            
        }else{
            self.backgroundColor = UIColor.init(hexString: "#F1C40F")
        }
    }
    
}


