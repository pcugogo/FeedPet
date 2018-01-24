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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
