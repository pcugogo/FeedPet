//
//  FeedIngredientTableViewCell.swift
//  FeedPet
//
//  Created by HwangGisu on 2018. 1. 20..
//  Copyright © 2018년 HwangGisu. All rights reserved.
//

import UIKit

class FeedIngredientTableViewCell: UITableViewCell {

    
    @IBOutlet weak var goodIngredientCountLabel: UILabel!
    
    @IBOutlet weak var warningIngredientCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
