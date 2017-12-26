//
//  MyMenuCell.swift
//  FeedPet
//
//  Created by 샤인 on 2017. 12. 21..
//  Copyright © 2017년 Ios_Park. All rights reserved.
//

import UIKit

class MyMenuCell: UITableViewCell {
    @IBOutlet weak var favoritesNumLb: UILabel!
    
    @IBOutlet weak var myReviewsNumLb: UILabel!
    @IBOutlet weak var favoritesBtnOut: UIButton!
    
    @IBOutlet weak var myReviewBtnOut: UIButton!
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        favoritesBtnOut.layer.cornerRadius = 5
        myReviewBtnOut.layer.cornerRadius = 5
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func favoritesBtnAction(_ sender: UIButton) {
        
    }
    @IBAction func myReviewBtnAction(_ sender: UIButton) {
        
    }
    
}
