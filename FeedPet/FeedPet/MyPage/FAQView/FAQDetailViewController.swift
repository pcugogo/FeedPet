//
//  FAQDetailViewController.swift
//  FeedPet
//
//  Created by 샤인 on 2017. 12. 27..
//  Copyright © 2017년 HwangGisu. All rights reserved.
//

import UIKit

class FAQDetailViewController: UIViewController {
    
    var barTitle = ""
    var fAQContentImgName = ""
    @IBOutlet weak var fAQNaviItem: UINavigationItem!
    @IBOutlet weak var fAQImgView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
       fAQNaviItem.title = barTitle
        fAQImgView.image = UIImage(named: fAQContentImgName)
    }
    

  
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backBtnAction(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
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
