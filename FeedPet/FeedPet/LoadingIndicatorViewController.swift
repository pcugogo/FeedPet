//
//  LodingIndicatorViewController.swift
//  FeedPet
//
//  Created by HwangGisu on 2018. 4. 12..
//  Copyright © 2018년 HwangGisu. All rights reserved.
//
import UIKit
import SwiftyGif

class LoadingIndicatorViewController: UIViewController {

    @IBOutlet weak var indicatorImgView: UIImageView!
    var loadingState = false
    override func viewDidLoad() {
        super.viewDidLoad()
        let gifManager = SwiftyGifManager(memoryLimit: 30)
        let gif = UIImage(gifName: "loading_img@3x2.gif")
        self.indicatorImgView.setGifImage(gif, manager: gifManager, loopCount: 10)
        
    
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func loadingViewDismiss(){
//        self.dismiss(animated: false, completion: nil)
//        if self.loadingState {
            self.dismiss(animated: true) {
                self.loadingState = false
            }
//        }
        
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
