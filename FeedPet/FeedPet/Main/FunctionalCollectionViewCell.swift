//
//  FunctionalCollectionViewCell.swift
//  FeedPet
//
//  Created by HwangGisu on 2018. 1. 9..
//  Copyright © 2018년 HwangGisu. All rights reserved.
//

import UIKit

class FunctionalCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var functionalImag: UIImageView!
    @IBOutlet weak var functionalLabel: UILabel!
    @IBOutlet weak var dividerImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
