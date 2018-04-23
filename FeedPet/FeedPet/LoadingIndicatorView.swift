//
//  LoadingIndicatorView.swift
//  FeedPet
//
//  Created by HwangGisu on 2018. 4. 5..
//  Copyright © 2018년 HwangGisu. All rights reserved.
//

import UIKit
import SwiftyGif

class LoadingIndicatorView: UIView {

    @IBOutlet weak var indicatorImgView: UIImageView!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    class func instanceFromNib() -> LoadingIndicatorView {
        var view = UINib(nibName: "LoadingIndicatorView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! LoadingIndicatorView
        let gifManager = SwiftyGifManager(memoryLimit:30)
        let gif = UIImage(gifName: "loading_img@3x2.gif")
        view.indicatorImgView.setGifImage(gif, manager: gifManager)
        
        return view
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    

}
