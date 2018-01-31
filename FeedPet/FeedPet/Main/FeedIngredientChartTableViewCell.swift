//
//  FeedIngredientChartTableViewCell.swift
//  FeedPet
//
//  Created by HwangGisu on 2018. 1. 21..
//  Copyright © 2018년 HwangGisu. All rights reserved.
//

import UIKit
import ChartProgressBar

class FeedIngredientChartTableViewCell: UITableViewCell {
@IBOutlet weak var ingredientChartBar: ChartProgressBar!
    
    var ingredientDataTest: FeedDetailIngredientTest?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
//        ingredientLoadData(ingredientData: ingredientDataTest!)
        // Configure the view for the selected state
    }

    func ingredientLoadData(ingredientData: FeedDetailIngredientTest) {
        var data: [BarData] = []
        
        data.append(BarData.init(barTitle: "조단백질", barValue: ingredientData.crudeProtein, pinText: "\(ingredientData.crudeProtein)%"))
        data.append(BarData.init(barTitle: "조지방", barValue: ingredientData.crudeFat, pinText: "\(ingredientData.crudeFat)%"))
        data.append(BarData.init(barTitle: "조섬유", barValue: ingredientData.crudeFibre, pinText: "\(ingredientData.crudeFibre)%"))
        data.append(BarData.init(barTitle: "조회분", barValue: ingredientData.crudeAsh, pinText: "\(ingredientData.crudeAsh)%"))
        data.append(BarData.init(barTitle: "칼슘", barValue: ingredientData.calcium, pinText: "\(ingredientData.calcium)%"))
        data.append(BarData.init(barTitle: "인", barValue: ingredientData.phosphorus, pinText: "\(ingredientData.phosphorus)%"))
        
        
        
        ingredientChartBar.data = data
        ingredientChartBar.barsCanBeClick = true
        ingredientChartBar.maxValue = 100
        ingredientChartBar.barWidth = 27
        ingredientChartBar.barTitleWidth = 42
        
        ingredientChartBar.barHeight = Float(ingredientChartBar.layer.frame.height)
        ingredientChartBar.emptyColor = UIColor.init(hexString: "e0e0e0")
        ingredientChartBar.progressColor = UIColor.init(hexString: "#F39800")
        ingredientChartBar.barsCanBeClick = false
        
        //chart.progressClickColor = UIColor.init(hexString: "09467D")
        //chart.pinTxtColor = UIColor.white
        //chart.pinBackgroundColor = UIColor.darkGray
        ingredientChartBar.barRadius = 5
        
        //chart.barTitleColor = UIColor.init(hexString: "598DBC")
        //chart.barTitleTxtSize = 12
        //chart.barTitleWidth = 30
        //chart.barTitleHeight = 25
        //chart.pinTxtSize = 10
        //chart.pinWidth = 30
        //chart.pinHeigh = 30
        ingredientChartBar.build()
    }
}
