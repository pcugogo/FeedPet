//
//  MyMenuCell.swift
//  FeedPet
//
//  Created by 샤인 on 2017. 12. 21..
//  Copyright © 2017년 Ios_Park. All rights reserved.
//

import UIKit

protocol MyMenuCellDelegate{
    func toFavoritesView()
    func toMyReviewView()
}

class MyMenuCell: UITableViewCell {

    var delegate:MyMenuCellDelegate?
    
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
    
    func pushFavoriteView(){
        delegate?.toFavoritesView()
    }
    func pushtoMyReviewView(){
        delegate?.toMyReviewView()
    }
    
    @IBAction func favoritesBtnAction(_ sender: UIButton) {
        pushFavoriteView()
    }
    @IBAction func myReviewBtnAction(_ sender: UIButton) {
        pushtoMyReviewView()
    }
    
    
}
