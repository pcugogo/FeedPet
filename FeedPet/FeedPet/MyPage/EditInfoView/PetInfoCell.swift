//
//  PetInfoCell.swift
//  FeedPet2
//
//  Created by 샤인 on 2017. 12. 22..
//  Copyright © 2017년 Ios_Park. All rights reserved.
//

import UIKit

class PetInfoCell: UITableViewCell {

    @IBOutlet weak var kittenBtnOut: UIButton!
    @IBOutlet weak var adultBtnOut: UIButton!
    @IBOutlet weak var seniorBtnOut: UIButton!
    @IBOutlet weak var skinBtnOut: UIButton!
    @IBOutlet weak var allergyBtnOut: UIButton!
    @IBOutlet weak var jointBtnOut: UIButton!
    @IBOutlet weak var dietBtnOut: UIButton!
    @IBOutlet weak var indoorBtnOut: UIButton!
    @IBOutlet weak var immuneBtnOut: UIButton!
    @IBOutlet weak var hairBallBtnOut: UIButton!
    @IBOutlet weak var urologyBtnOut: UIButton!
    @IBOutlet weak var allBallBtnOut: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        kittenBtnOut.layer.cornerRadius = 5
        adultBtnOut.layer.cornerRadius = 5
        seniorBtnOut.layer.cornerRadius = 5
        skinBtnOut.layer.cornerRadius = 5
        allergyBtnOut.layer.cornerRadius = 5
        jointBtnOut.layer.cornerRadius = 5
        dietBtnOut.layer.cornerRadius = 5
        indoorBtnOut.layer.cornerRadius = 5
        immuneBtnOut.layer.cornerRadius = 5
        hairBallBtnOut.layer.cornerRadius = 5
        urologyBtnOut.layer.cornerRadius = 5
        allBallBtnOut.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func puppyBtnAction(_ sender: UIButton) {
    }
    @IBAction func catBtnAction(_ sender: UIButton) {
    }

    @IBAction func kittenBtnAction(_ sender: UIButton) {
    }
    @IBAction func adultBtnAction(_ sender: UIButton) {
    }
    @IBAction func seniorBtnAction(_ sender: UIButton) {
    }
    
    @IBAction func skinBtnAction(_ sender: UIButton) {
    }
    @IBAction func allergyBtnAction(_ sender: UIButton) {
    }
    @IBAction func jointBtnAction(_ sender: UIButton) {
    }
    @IBAction func dietBtnAction(_ sender: UIButton) {
    }
    @IBAction func indoorBtnAction(_ sender: UIButton) {
    }
    
    @IBAction func immuneBtnAction(_ sender: UIButton) {
    }
  
    @IBAction func hairBallBtnAction(_ sender: UIButton) {
    }
    @IBAction func urologyBtnAction(_ sender: UIButton) {
    }
    
    @IBAction func allBtnAction(_ sender: UIButton) {
    }
}
