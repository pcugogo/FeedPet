//
//  LoadingIndicatorImgView.swift
//  FeedPet
//
//  Created by HwangGisu on 2018. 2. 5..
//  Copyright © 2018년 HwangGisu. All rights reserved.
//

import UIKit
import SwiftyGif

class LoadingIndicatorImgView: UIImageView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var backgroudView: UIView = UIView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        let gifManager = SwiftyGifManager(memoryLimit:30)
//        let gif = UIImage(gifName: "loading_img@3.gif")
//        self.setGifImage(gif, manager: gifManager)
        
        //        self.isHidden = false
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let gifManager = SwiftyGifManager(memoryLimit:30)
        let gif = UIImage(gifName: "loading_img.gif")
        self.setGifImage(gif, manager: gifManager)

    }
    
    func loadingStart(){
        
        self.isHidden = false
    }
    func loadingStop(){
        self.isHidden = true
    }
}
