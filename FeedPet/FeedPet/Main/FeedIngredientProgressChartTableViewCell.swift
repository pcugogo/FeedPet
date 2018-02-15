//
//  FeedIngredientProgressChartTableViewCell.swift
//  FeedPet
//
//  Created by HwangGisu on 2018. 2. 6..
//  Copyright © 2018년 HwangGisu. All rights reserved.
//

import UIKit

class FeedIngredientProgressChartTableViewCell: UITableViewCell {

    @IBOutlet weak var proteinValueLabel: UILabel!
    @IBOutlet weak var proteinChartBackgroundView: UIView!
//    @IBOutlet weak var proteinTextLabel: UILabel!
    @IBOutlet weak var proteinProgressBar: UIView!
    @IBOutlet weak var protienHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var fatValueLabel: UILabel!
    @IBOutlet weak var fatChartBackgroundView: UIView!
//    @IBOutlet weak var fatTextLabel: UILabel!
    @IBOutlet weak var fatProgressBar: UIView!
    @IBOutlet weak var fatHeightConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var fibreValueLabel: UILabel!
    @IBOutlet weak var fibreChartBackgroundView: UIView!
//    @IBOutlet weak var fibreTextLabel: UILabel!
    @IBOutlet weak var fibreProgressBar: UIView!
    @IBOutlet weak var fibreHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var ashValueLabel: UILabel!
    @IBOutlet weak var ashChartBackgroundView: UIView!
//    @IBOutlet weak var ashTextLabel: UILabel!
    @IBOutlet weak var ashProgressBar: UIView!
    @IBOutlet weak var ashHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var calcuimValueLabel: UILabel!
    @IBOutlet weak var calcuimChartBackgroundView: UIView!
//    @IBOutlet weak var calcuimTextLabel: UILabel!
    @IBOutlet weak var calcuimProgressBar: UIView!
    @IBOutlet weak var calcuimHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var phosphorusValueLabel: UILabel!
    @IBOutlet weak var phosphorusChartBackgroundView: UIView!
//    @IBOutlet weak var phosphorusTextLabel: UILabel!
    @IBOutlet weak var phosphorusProgressBar: UIView!
    @IBOutlet weak var phosphorusHeightConstraint: NSLayoutConstraint!
    
    
    var backgroundViewHeight: CGFloat = 0.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundViewHeight = phosphorusChartBackgroundView.frame.size.height
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func ingredeintDataSetting(ingredient: FeedDetailIngredient?){
        
        guard let ingredientDetailData = ingredient else {return}
        print(ingredientDetailData)
//        self.progressBarSetting(proteinValue: CGFloat(ingredientDetailData.crudeProtein), fatValue: CGFloat(ingredientDetailData.crudeFat), fibreValue: CGFloat(ingredientDetailData.crudeFibre), ashValue: CGFloat(ingredientDetailData.crudeAsh), calcuimValue: CGFloat(ingredientDetailData.calcium), phosphorusValue: CGFloat(ingredientDetailData.phosphorus))
        
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .allowAnimatedContent, animations: {
            self.progressBarSetting(proteinValue: ingredientDetailData.crudeProtein, fatValue: ingredientDetailData.crudeFat, fibreValue: ingredientDetailData.crudeFibre, ashValue: ingredientDetailData.crudeAsh, calcuimValue: ingredientDetailData.calcium, phosphorusValue: ingredientDetailData.phosphorus)
        }) { (finish) in
            
        }
    }
    func offsetCalculation(value: Float)->CGFloat{
        let yOffset = ((100.0 - value)/100.0) * Float(backgroundViewHeight)/1
        return CGFloat(yOffset)
    }
    private func progressBarSetting(proteinValue: Float, fatValue: Float, fibreValue: Float, ashValue: Float, calcuimValue: Float, phosphorusValue: Float){
        self.protienHeightConstraint.constant = self.proteinChartBackgroundView.frame.size.height - offsetCalculation(value: proteinValue)
        self.proteinProgressBar.frame.origin.y = offsetCalculation(value: proteinValue)
        
        self.proteinChartBackgroundView.layer.cornerRadius = 12
        self.proteinProgressBar.layer.cornerRadius = 12
        self.proteinValueLabel.text = "\(proteinValue)%"
        print(offsetCalculation(value: proteinValue),"/",proteinValue)
        
        self.fatHeightConstraint.constant = self.fatChartBackgroundView.frame.size.height - offsetCalculation(value: fatValue)
        
        self.fatProgressBar.frame.origin.y = offsetCalculation(value: fatValue)
        self.fatChartBackgroundView.layer.cornerRadius = 12
        self.fatProgressBar.layer.cornerRadius = 12
        self.fatValueLabel.text = "\(fatValue)%"
        
        self.fibreHeightConstraint.constant = self.fibreChartBackgroundView.frame.size.height - offsetCalculation(value: fibreValue)
        
        self.fibreProgressBar.frame.origin.y = offsetCalculation(value: fibreValue)
        self.fibreChartBackgroundView.layer.cornerRadius = 12
        self.fibreProgressBar.layer.cornerRadius = 12
        self.fibreValueLabel.text = "\(fibreValue)%"
        
        self.ashHeightConstraint.constant = self.ashChartBackgroundView.frame.size.height - offsetCalculation(value: ashValue)
        
        self.ashProgressBar.frame.origin.y = offsetCalculation(value: ashValue)
        self.ashChartBackgroundView.layer.cornerRadius = 12
        self.ashProgressBar.layer.cornerRadius = 12
        self.ashValueLabel.text = "\(ashValue)%"
        
        self.calcuimHeightConstraint.constant = self.calcuimChartBackgroundView.frame.size.height - offsetCalculation(value: calcuimValue)
        print(self.calcuimHeightConstraint.constant)
        
        self.calcuimProgressBar.frame.origin.y = offsetCalculation(value: calcuimValue)
        self.calcuimChartBackgroundView.layer.cornerRadius = 12
        self.calcuimProgressBar.layer.cornerRadius = 12
        self.calcuimValueLabel.text = "\(calcuimValue)%"
        
        self.phosphorusHeightConstraint.constant = self.phosphorusChartBackgroundView.frame.size.height - offsetCalculation(value: phosphorusValue)
        
        self.phosphorusProgressBar.frame.origin.y = offsetCalculation(value: phosphorusValue)
        self.phosphorusChartBackgroundView.layer.cornerRadius = 12
        self.phosphorusProgressBar.layer.cornerRadius = 12
        self.phosphorusValueLabel.text = "\(phosphorusValue)%"
        
        
    }
    
    
}
