//
//  FilterDetailGradeTableViewCell.swift
//  FeedPet
//
//  Created by HwangGisu on 2018. 1. 15..
//  Copyright © 2018년 HwangGisu. All rights reserved.
//

import UIKit

class FilterDetailGradeTableViewCell: UITableViewCell {

    @IBOutlet weak var gradeImgView: UIImageView!
    
    @IBOutlet weak var detailGradeLabel: UILabel!
    @IBOutlet weak var detailCheckImgView: UIImageView!
    
    var selectedState: Bool = false
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        print(selected)
        self.selectedState = selected
        if selectedState{
            //                functionalChangeCheck()
            self.detailCheckImgView.image = #imageLiteral(resourceName: "checkBoxAble")
        }else {
            //                self.backgroundColor = .gray //.clear
            self.detailCheckImgView.image = #imageLiteral(resourceName: "checkBoxDisable")
            
        }
        // Configure the view for the selected state
    }

}
