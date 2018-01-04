//
//  DogMainViewController.swift
//  FeedPet
//
//  Created by HwangGisu on 2018. 1. 3..
//  Copyright © 2018년 HwangGisu. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class DogMainViewController: UIViewController, IndicatorInfoProvider {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        
        return IndicatorInfo(title: "멍", image: #imageLiteral(resourceName: "dogAble"))
    }

}
