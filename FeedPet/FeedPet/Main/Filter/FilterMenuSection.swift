//
//  FilterMenuSection.swift
//  FeedPet
//
//  Created by HwangGisu on 2018. 1. 16..
//  Copyright © 2018년 HwangGisu. All rights reserved.
//

import Foundation

struct FilterMenuSections {
    var menu: String!
    var filterMenuKind: [FilterMenuInner]
    var expanded: Bool!
    
    init(menu: String, filterMenuKind: [FilterMenuInner], expanded: Bool) {
        self.menu = menu
        self.filterMenuKind = filterMenuKind
        self.expanded = expanded
    }
}

struct FilterMenuInner {
    var cellType: String!
    var checkState: Bool!
    var gradeImg: String?
    var textLabel: String!
    
    init(cellType: String, checkState: Bool, gradeImg: String?, textLabel: String) {
        self.cellType = cellType
        self.checkState = checkState
        self.gradeImg = gradeImg
        self.textLabel = textLabel
    }
}
