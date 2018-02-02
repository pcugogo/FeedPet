//
//  MyPageTestViewController.swift
//  FeedPet
//
//  Created by ChanWook Park on 2018. 1. 21..
//  Copyright © 2018년 HwangGisu. All rights reserved.
//

import UIKit

class MyPageTestViewController: UIViewController {
    
    let feedKey:String = "feed_key_c177"
    let feedBrand:String = "내추럴발란스"
    let feedName:String = "내추럴발란스 LID 완두&오리 포뮬러"
    let feedImg:String = "http://feedpet.co.kr/wp-content/uploads/feed/feed_key_c177_1.png"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FireBaseData.shared.fireBaseUserInfoDataLoad()
        FireBaseData.shared.fireBaseMyReviewDataLoad()
        FireBaseData.shared.fireBaseFavoritesDataLoad()
        let ingredientGoodKey = ["ingredient_key_g159","ingredient_key_g1","ingredient_key_g12"]
        let ingredientWarningKey = ["ingredient_key_w17","ingredient_key_w9"]
        FireBaseData.shared.feedGoodIngredientDataLoad(ingredientGoodKey: ingredientGoodKey)
        FireBaseData.shared.feedWarningIngredientDataLoad(ingredientWarningKey: ingredientWarningKey)
    }

  
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func toReviewWriteBtnAction(_ sender: UIButton) {
        let writeReviewView:WriteReviewViewController = self.storyboard?.instantiateViewController(withIdentifier: "WriteReviewViewController") as! WriteReviewViewController
        writeReviewView.feedKey = "feed_key_c177"
        writeReviewView.feedBrand = "내추럴발란스"
        writeReviewView.feedName = "내추럴발란스 LID 완두&오리 포뮬러"
        writeReviewView.feedImg = "http://feedpet.co.kr/wp-content/uploads/feed/feed_key_c177_1.png"
        
        self.navigationController?.pushViewController(writeReviewView, animated: true)
    }
    
    @IBAction func toIngredientViewBtnAction(_ sender: UIButton) {
        
        let ingredientView:IngredientAnalysisViewController = self.storyboard?.instantiateViewController(withIdentifier: "IngredientAnalysisViewController") as! IngredientAnalysisViewController
        
        self.navigationController?.pushViewController(ingredientView, animated: true)
        
    }
    

}
