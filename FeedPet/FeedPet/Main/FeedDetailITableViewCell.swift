//
//  FeedDetailITableViewCell.swift
//  FeedPet
//
//  Created by HwangGisu on 2018. 1. 17..
//  Copyright © 2018년 HwangGisu. All rights reserved.
//

import UIKit

class FeedDetailITableViewCell: UITableViewCell {

    // 슬라이드 들어갈 이미지 컨텐츠뷰의 넓이 제약사항
    @IBOutlet weak var feedImgContentVIewWidthConstraints: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
