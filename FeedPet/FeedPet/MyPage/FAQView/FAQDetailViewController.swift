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
   
    @IBOutlet weak var FAQNaviItem: UINavigationItem!
    @IBOutlet weak var FAQImgView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
       FAQNaviItem.title = barTitle
        // Do any additional setup after loading the view.
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
