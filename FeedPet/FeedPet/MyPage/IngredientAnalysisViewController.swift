//
//  IngredientAnalysisViewController.swift
//  FeedPet
//
//  Created by 샤인 on 2018. 1. 10..
//  Copyright © 2018년 HwangGisu. All rights reserved.
//

import UIKit

class IngredientAnalysisViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    let goodIngredientTestData = ["닭고기","비타민","유기농 완두콩","감자","건조계란","타우린","연어오일(오메가3)"]
    let cautionIngredientTestData = ["부산물","가금류고기","주의성분1","주의성분2","주의성분3"]
    
    @IBOutlet weak var ingredientSCOut: UISegmentedControl!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if ingredientSCOut.selectedSegmentIndex == 0{ //좋은 성분
            return goodIngredientTestData.count
        }else{ //selectedSegmentIndex == 1 주의 성분
            return cautionIngredientTestData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier = "IngredientNameCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        if ingredientSCOut.selectedSegmentIndex == 0{ //좋은 성분
            cell.textLabel?.text = goodIngredientTestData[indexPath.row]
            cell.textLabel?.textColor = UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0)
            return cell
        }else{ //selectedSegmentIndex == 1 주의 성분
            cell.textLabel?.text = cautionIngredientTestData[indexPath.row]
            cell.textLabel?.textColor = UIColor(red: 188/255, green: 55/255, blue: 41/255, alpha: 1.0)
            return cell
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if ingredientSCOut.selectedSegmentIndex == 0{ //좋은 성분
            let ingredientAnalysisDetailView:IngredientAnalysisDetailViewController = storyboard?.instantiateViewController(withIdentifier: "IngredientAnalysisDetailViewController") as! IngredientAnalysisDetailViewController
            
            for dataIndex in 0...goodIngredientTestData.count{
                if indexPath.row == dataIndex {
                    
                    ingredientAnalysisDetailView.testData = goodIngredientTestData[indexPath.row]
                    ingredientAnalysisDetailView.selectedSegmentIndex = ingredientSCOut.selectedSegmentIndex
                    
                    self.addChildViewController(ingredientAnalysisDetailView)
                    ingredientAnalysisDetailView.view.frame = self.view.frame
                    self.view.addSubview(ingredientAnalysisDetailView.view)
                    ingredientAnalysisDetailView.didMove(toParentViewController: self)
                }
            }
            
        }else{ //selectedSegmentIndex == 1 주의 성분
            
            let ingredientAnalysisDetailView:IngredientAnalysisDetailViewController = storyboard?.instantiateViewController(withIdentifier: "IngredientAnalysisDetailViewController") as! IngredientAnalysisDetailViewController
            
            for dataIndex in 0...goodIngredientTestData.count{
                if indexPath.row == dataIndex{
                    ingredientAnalysisDetailView.testData = cautionIngredientTestData[indexPath.row]
                    ingredientAnalysisDetailView.selectedSegmentIndex = ingredientSCOut.selectedSegmentIndex
                    
                    self.addChildViewController(ingredientAnalysisDetailView)
                    ingredientAnalysisDetailView.view.frame = self.view.frame
                    self.view.addSubview(ingredientAnalysisDetailView.view)
                    ingredientAnalysisDetailView.didMove(toParentViewController: self)
                }
            }
            
        }
        
        
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
    
    
    @IBAction func ingredientSCAction(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{
            tableView.reloadData()
        }else{
            tableView.reloadData()
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
