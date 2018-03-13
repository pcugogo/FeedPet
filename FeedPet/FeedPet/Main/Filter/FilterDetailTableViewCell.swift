//
//  FilterDetailTableViewCell.swift
//  FeedPet
//
//  Created by HwangGisu on 2018. 1. 15..
//  Copyright © 2018년 HwangGisu. All rights reserved.
//

import UIKit

class FilterDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var detailCheckImgView: UIImageView!
    
    var selectedState: Bool = false
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
        self.selectedState = selected
        DispatchQueue.main.async {
            
            if self.selectedState{
                //                functionalChangeCheck()
                self.detailCheckImgView.image = #imageLiteral(resourceName: "checkBoxAble")
            }else {
                //                self.backgroundColor = .gray //.clear
                self.detailCheckImgView.image = #imageLiteral(resourceName: "checkBoxDisable")
                
            }
        }
        // Configure the view for the selected state
    }

}
