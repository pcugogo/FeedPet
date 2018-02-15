//
//  FunctionalCollectionViewCell.swift
//  FeedPet
//
//  Created by HwangGisu on 2018. 1. 9..
//  Copyright © 2018년 HwangGisu. All rights reserved.
//

import UIKit

class FunctionalCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var functionalImag: UIImageView!
    @IBOutlet weak var functionalLabel: UILabel!
    @IBOutlet weak var dividerImg: UIImageView!
    
    var functionalSelectInt: Int = 0 {
        didSet{
            functionalChangeCheck()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.backgroundColor = UIColor.gray.cgColor
        self.layer.cornerRadius = 3 //self.layer.bounds.size.height/2
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override var isSelected: Bool{
        didSet{
            if isSelected{
                functionalChangeCheck()
            }else {
                self.backgroundColor = .gray //.clear
                
            }
        }
    }
    
    func functionalChangeCheck(){
        if functionalSelectInt == 0{
            self.backgroundColor = UIColor.init(hexString: "#1ABC9C")
            
        }else{
            self.backgroundColor = UIColor.init(hexString: "#F1C40F")
        }
    }
}
