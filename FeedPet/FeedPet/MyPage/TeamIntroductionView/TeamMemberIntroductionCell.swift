//
//  TeamMemberIntroductionCell.swift
//  FeedPet
//
//  Created by 샤인 on 2017. 12. 29..
//  Copyright © 2017년 HwangGisu. All rights reserved.
//

import UIKit

class TeamMemberIntroductionCell: UITableViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var teamMenberNameLb: UILabel!
    @IBOutlet weak var positionLb: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
