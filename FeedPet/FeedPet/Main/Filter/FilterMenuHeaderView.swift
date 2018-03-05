//
//  FilterMenuHeaderView.swift
//  FeedPet
//
//  Created by HwangGisu on 2018. 1. 16..
//  Copyright © 2018년 HwangGisu. All rights reserved.
//

import UIKit

protocol FilterMenuExpendableHeaderViewDelegate {
    func toggleSection(header: FilterMenuHeaderView, section: Int)
    
}
class FilterMenuHeaderView: UITableViewHeaderFooterView {
    
    var delegate: FilterMenuExpendableHeaderViewDelegate?
    var section: Int!
    
    @IBOutlet weak var menuTitleLabel: UILabel!
    @IBOutlet weak var expendedImg: UIImageView!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
//        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectHeaderAction(getstureRecognizer:))))
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectHeaderAction(getstureRecognizer:))))
    }
    
    func selectHeaderAction(getstureRecognizer: UITapGestureRecognizer){
        let cell = getstureRecognizer.view as! FilterMenuHeaderView
        delegate?.toggleSection(header: cell, section: cell.section)
    }
    
    func customInint(title: String, section: Int, delegate: FilterMenuExpendableHeaderViewDelegate){
//        self.textLabel?.text = title
        self.menuTitleLabel?.text = title
        
        self.section = section
        self.delegate = delegate
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.backgroundColor = UIColor.lightGray
    }
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}

