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
        
        FireBaseData.shared.fireBaseFavoritesDataLoad()
        
    }

  
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
