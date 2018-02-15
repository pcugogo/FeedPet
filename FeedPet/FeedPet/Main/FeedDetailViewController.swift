//
//  FeedDetailViewController.swift
//  FeedPet
//
//  Created by HwangGisu on 2018. 1. 17..
//  Copyright © 2018년 HwangGisu. All rights reserved.
//

import UIKit

class FeedDetailViewController: UIViewController {

    @IBOutlet weak var feedDetailTableView: UITableView!
    
    var feedDetailInfo: FeedInfo?
    var ingredientData: FeedDetailIngredient?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        feedDetailTableView.delegate = self
        feedDetailTableView.dataSource = self
//        self.navigationController?.isNavigationBarHidden = false
        
        self.feedDetailTableView.register(UINib(nibName: "FeedIngredientProgressChartTableViewCell", bundle: nil), forCellReuseIdentifier: "FeedIngredientProgressChartCell")
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//                self.navigationController?.isNavigationBarHidden = false
//        setupAnimationForNavigationBar(caseOfFunction: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //        self.navigationController?.isNavigationBarHidden = false
//        setupAnimationForNavigationBar(caseOfFunction: false)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setupAnimationForNavigationBar(caseOfFunction: Bool) {
        if caseOfFunction == true {
            UIView.animate(withDuration: 0.5) {
                self.navigationController?.navigationBar.transform = CGAffineTransform(translationX: 0, y: -200)
            }
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                self.navigationController?.navigationBar.transform = CGAffineTransform.identity
            })
        }
        
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
extension FeedDetailViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0{
            return 1
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if indexPath.section == 0 {
//
//            let detailCell = tableView.dequeueReusableCell(withIdentifier: "FeedDetailCell", for: indexPath) as! FeedDetailITableViewCell
//
//            detailCell.feedBrandNameLabel.text = feedDetailInfo?.feedBrand
//            detailCell.feedNameLabel.text = feedDetailInfo?.feedName
//            detailCell.feedAgeLabel.text = feedDetailInfo?.feedAge.description
//            detailCell.feedGradeLabel.text = feedDetailInfo?.feedGrade.description
//            detailCell.feedIngredientLabel.text = feedDetailInfo?.feedIngredient
//
//            return detailCell
//        }else{
//            let cell = tableView.dequeueReusableCell(withIdentifier: "FeedIngredientCell", for: indexPath) as! FeedIngredientTableViewCell
//
//            return cell
//        }
        switch indexPath.section {
        case 0:
            let detailCell = tableView.dequeueReusableCell(withIdentifier: "FeedDetailCell", for: indexPath) as! FeedDetailITableViewCell
            detailCell.feedInfo = feedDetailInfo
            print(feedDetailInfo)
//            detailCell.feedBrandNameLabel.text = feedDetailInfo?.feedBrand
//            detailCell.feedNameLabel.text = feedDetailInfo?.feedName
//            detailCell.feedAgeLabel.text = feedDetailInfo?.feedAge.description
//            detailCell.feedGradeLabel.text = feedDetailInfo?.feedGrade.description
//            detailCell.feedIngredientLabel.text = feedDetailInfo?.feedIngredient
//            
            return detailCell
        case 1:
            let ingredientCell = tableView.dequeueReusableCell(withIdentifier: "FeedIngredientCell", for: indexPath) as! FeedIngredientTableViewCell
            
            let good = ingredientData?.feedIngredientGood ?? []
            let warning = ingredientData?.feedIngredientWarning ?? []
            
            ingredientCell.goodIngredientCountLabel.text = good.count.description
            ingredientCell.goodIngredientCountLabel.text = warning.count.description
            return ingredientCell
        case 2:
            let chartProgressCell = tableView.dequeueReusableCell(withIdentifier: "FeedIngredientProgressChartCell", for: indexPath) as! FeedIngredientProgressChartTableViewCell
            chartProgressCell.ingredeintDataSetting(ingredient: ingredientData)
            return chartProgressCell
        case 3:
            let reviewInfoCell = tableView.dequeueReusableCell(withIdentifier: "FeedReviewInfoCell", for: indexPath) as! FeedReviewInfoTableViewCell
            
            return reviewInfoCell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FeedReviewListTableCell", for: indexPath) as! FeedReviewListTableViewCell
            
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
