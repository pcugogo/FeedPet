//
//  FilterViewController.swift
//  FeedPet
//
//  Created by HwangGisu on 2018. 1. 14..
//  Copyright © 2018년 HwangGisu. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {
    
    @IBOutlet weak var filterMenuTableView: UITableView!
    
    var testFilterMenuSection = [
                FilterMenuSections(menu: "등급",
                                   filterMenuKind: [
                                                    FilterMenuInner(cellType: "GradeDetail",
                                                                    checkState: false,
                                                                    gradeImg: "ratingOrganic",
                                                                    textLabel: "1:유기농"),
                                                    FilterMenuInner(cellType: "GradeDetail",
                                                                    checkState: false,
                                                                    gradeImg: "ratingHolistic",
                                                                    textLabel: "2:홀리스틱"),
                                                    FilterMenuInner(cellType: "GradeDetail",
                                                                    checkState: false,
                                                                    gradeImg: "ratingSuperPremium",
                                                                    textLabel: "3:슈퍼프리미엄"),
                                                    FilterMenuInner(cellType: "GradeDetail",
                                                                    checkState: false,
                                                                    gradeImg: "ratingPremium",
                                                                    textLabel: "4:프리미엄"),
                                                    FilterMenuInner(cellType: "GradeDetail",
                                                                    checkState: false,
                                                                    gradeImg: "ratingGroceryBrand",
                                                                    textLabel: "5:마트용")
                                                    ],
                                   expanded: false),
                FilterMenuSections(menu: "연령대",
                                   filterMenuKind: [
                                    FilterMenuInner(cellType: "Detail",
                                                    checkState: false,
                                                    gradeImg: nil,
                                                    textLabel: "주니어/퍼피"),
                                    FilterMenuInner(cellType: "Detail",
                                                    checkState: false,
                                                    gradeImg: nil,
                                                    textLabel: "어덜트"),
                                    FilterMenuInner(cellType: "Detail",
                                                    checkState: false,
                                                    gradeImg: nil,
                                                    textLabel: "시니어")
                                    ],
                                   expanded: false),
                FilterMenuSections(menu: "주원료",
                                   filterMenuKind: [
                                    FilterMenuInner(cellType: "Detail",
                                                    checkState: false,
                                                    gradeImg: nil,
                                                    textLabel: "닭"),
                                    FilterMenuInner(cellType: "Detail",
                                                    checkState: false,
                                                    gradeImg: nil,
                                                    textLabel: "소"),
                                    FilterMenuInner(cellType: "Detail",
                                                    checkState: false,
                                                    gradeImg: nil,
                                                    textLabel: "오리")
                    ],
                                   expanded: false),
                FilterMenuSections(menu: "브랜드",
                                   filterMenuKind: [
                                    FilterMenuInner(cellType: "Detail",
                                                    checkState: false,
                                                    gradeImg: nil,
                                                    textLabel: "로얄캐닌"),
                                    FilterMenuInner(cellType: "Detail",
                                                    checkState: false,
                                                    gradeImg: nil,
                                                    textLabel: "캣츠랑"),
                                    FilterMenuInner(cellType: "Detail",
                                                    checkState: false,
                                                    gradeImg: nil,
                                                    textLabel: "ANF")
                    ],
                                   expanded: false)
                            
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        filterMenuTableView.delegate = self
//        filterMenuTableView.dataSource = self
        
        let filterMenuNib = UINib(nibName: "FilterMenuHeaderView", bundle: nil)
        filterMenuTableView.register(filterMenuNib, forHeaderFooterViewReuseIdentifier: "filterMenuHeaderView")
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func tapGesture(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
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
extension FilterViewController: UITableViewDataSource, UITableViewDelegate, FilterMenuExpendableHeaderViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return testFilterMenuSection.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return testFilterMenuSection[section].filterMenuKind.count
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if testFilterMenuSection[indexPath.section].expanded {
            return 44
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let header = FilterMenuHeaderView()
//        header.customInint(title: testFilterMenuSection[section].menu, section: section, delegate: self)
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "filterMenuHeaderView") as! FilterMenuHeaderView
        print(testFilterMenuSection[section].menu)
        header.customInint(title: testFilterMenuSection[section].menu, section: section, delegate: self)
        if testFilterMenuSection[section].expanded {
            header.expendedImg.image = UIImage(imageLiteralResourceName: "foldBtn")
        }else{
            header.expendedImg.image = UIImage(imageLiteralResourceName: "unfoldBtn")
        }
        return header
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if testFilterMenuSection[indexPath.section].filterMenuKind[indexPath.row].cellType == "GradeDetail"{
            let gradeDetailCell = tableView.dequeueReusableCell(withIdentifier: "FilterDetailGradeTableViewCell", for: indexPath) as! FilterDetailGradeTableViewCell
            let graerImgString = testFilterMenuSection[indexPath.section].filterMenuKind[indexPath.row].gradeImg ?? "dogDisable"
            gradeDetailCell.gradeImgView.image = UIImage(imageLiteralResourceName: graerImgString)
            gradeDetailCell.detailGradeLabel.text = testFilterMenuSection[indexPath.section].filterMenuKind[indexPath.row].textLabel
            
            
            return gradeDetailCell
        }else{
            let detailCell = tableView.dequeueReusableCell(withIdentifier: "FilterDetailTableViewCell", for: indexPath) as! FilterDetailTableViewCell
            detailCell.detailLabel.text = testFilterMenuSection[indexPath.section].filterMenuKind[indexPath.row].textLabel
            return detailCell
        }
    }
    
    
    func toggleSection(header: FilterMenuHeaderView, section: Int) {
        
        testFilterMenuSection[section].expanded = !testFilterMenuSection[section].expanded
        
        filterMenuTableView.beginUpdates()
//        for i in 0 ..< testFilterMenuSection[section].filterMenuKind.count {
//            filterMenuTableView.reloadRows(at: [IndexPath(row: i, section: section)], with: .automatic)
//        }
        filterMenuTableView.reloadSections([section], with: .automatic)
        
        filterMenuTableView.endUpdates()
        
        
    
    }
    
    
}
