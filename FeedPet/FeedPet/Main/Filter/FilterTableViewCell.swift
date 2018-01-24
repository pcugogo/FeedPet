//
//  FilterTableViewCell.swift
//  FeedPet
//
//  Created by HwangGisu on 2018. 1. 15..
//  Copyright © 2018년 HwangGisu. All rights reserved.
//

import UIKit

class FilterTableViewCell: UITableViewCell {

    @IBOutlet weak var filterMenuLabel: UILabel!
    
    @IBOutlet weak var detailTableView: UITableView!
    var filterMenuRow: Int = 0
    var filterMenuItems: [String:Any] = [:]
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
   
   

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension FilterTableViewCell{
    func setTableViewDatSourceDelegate<D: UITableViewDelegate & UITableViewDataSource> (_ dataSoruceDelegate: D, forRow row: Int){
        detailTableView.delegate = dataSoruceDelegate
        detailTableView.dataSource = dataSoruceDelegate
        
        detailTableView.reloadData()
    }
}
//extension FilterTableViewCell: UITableViewDataSource, UITableViewDelegate{
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 5
//
//
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        print(filterMenuRow)
//        if filterMenuRow == 0{
//           let filterGradeCell = tableView.dequeueReusableCell(withIdentifier: "FilterDetailGrade Cell", for: indexPath) as! FilterDetailGradeTableViewCell
//            return filterGradeCell
//        }
//        else{
//            let filterDetailCell = tableView.dequeueReusableCell(withIdentifier: "FilterDetail Cell", for: indexPath) as! FilterDetailTableViewCell
//            return filterDetailCell
//        }
//
//    }
//
//
//}

