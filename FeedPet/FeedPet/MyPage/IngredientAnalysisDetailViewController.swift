//
//  IngredientAnalysisDetailViewController.swift
//  FeedPet
//
//  Created by ChanWook Park on 2018. 1. 10..
//  Copyright © 2018년 HwangGisu. All rights reserved.
//

import UIKit

class IngredientAnalysisDetailViewController: UIViewController {
    
    var ingredientName = ""
    var ingredientContent = ""
    var selectedSegmentIndex = 0
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var ingredientNameLb: UILabel!
    @IBOutlet weak var asteriskLb: UILabel!
    @IBOutlet weak var ingredientDetailLb: UILabel!
    
    @IBOutlet weak var okBtnOut: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ingredientNameLb.text = ingredientName
        ingredientDetailLb.text = ingredientContent
        
        if selectedSegmentIndex == 0{
            ingredientNameLb.textColor = UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0)
            asteriskLb.textColor = UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0)
        }else{
            ingredientNameLb.textColor = UIColor(red: 188/255, green: 55/255, blue: 41/255, alpha: 1.0)
            asteriskLb.textColor = UIColor(red: 188/255, green: 55/255, blue: 41/255, alpha: 1.0)
        }
        
        
        contentView.layer.cornerRadius = 5
        okBtnOut.layer.cornerRadius = 5
//        self.view.backgroundColor = nil
//        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func okBtnAction(_ sender: UIButton) {
//        self.view.removeFromSuperview()
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
