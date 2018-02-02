//
//  MyPageTestViewController.swift
//  FeedPet
//
//  Created by ChanWook Park on 2018. 1. 21..
//  Copyright © 2018년 HwangGisu. All rights reserved.
//

import UIKit

class MyPageTestViewController: UIViewController {

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
    

    @IBAction func toIngredientViewBtnAction(_ sender: UIButton) {
        
        let ingredientView:IngredientAnalysisViewController = self.storyboard?.instantiateViewController(withIdentifier: "IngredientAnalysisViewController") as! IngredientAnalysisViewController
        
        self.navigationController?.pushViewController(ingredientView, animated: true)
        
    }
    

}
