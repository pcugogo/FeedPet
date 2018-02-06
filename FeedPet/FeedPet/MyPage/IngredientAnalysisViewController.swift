//
//  IngredientAnalysisViewController.swift
//  FeedPet
//
//  Created by 샤인 on 2018. 1. 10..
//  Copyright © 2018년 HwangGisu. All rights reserved.
//

import UIKit

class IngredientAnalysisViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var ingredientSCOut: UISegmentedControl!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if ingredientSCOut.selectedSegmentIndex == 0{ //좋은 성분
            return MyPageDataCenter.shared.feedIngredientGoodDatas.count
        }else{ //selectedSegmentIndex == 1 주의 성분
            return MyPageDataCenter.shared.feedIngredientWarningDatas.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier = "IngredientNameCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        if ingredientSCOut.selectedSegmentIndex == 0{ //좋은 성분
            cell.textLabel?.text = MyPageDataCenter.shared.feedIngredientGoodDatas[indexPath.row].ingredientNameReturn
            cell.textLabel?.textColor = UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0)
            return cell
        }else{ //selectedSegmentIndex == 1 주의 성분
            cell.textLabel?.text = MyPageDataCenter.shared.feedIngredientWarningDatas[indexPath.row].ingredientNameReturn
            cell.textLabel?.textColor = UIColor(red: 188/255, green: 55/255, blue: 41/255, alpha: 1.0)
            return cell
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if ingredientSCOut.selectedSegmentIndex == 0{ //좋은 성분
            let ingredientAnalysisDetailView:IngredientAnalysisDetailViewController = storyboard?.instantiateViewController(withIdentifier: "IngredientAnalysisDetailViewController") as! IngredientAnalysisDetailViewController
            
            for dataIndex in 0...MyPageDataCenter.shared.feedIngredientGoodDatas.count{
                if indexPath.row == dataIndex {
                    
                    ingredientAnalysisDetailView.ingredientName = MyPageDataCenter.shared.feedIngredientGoodDatas[indexPath.row].ingredientNameReturn
                    ingredientAnalysisDetailView.ingredientContent = MyPageDataCenter.shared.feedIngredientGoodDatas[indexPath.row].ingredientTextReturn
                    ingredientAnalysisDetailView.selectedSegmentIndex = ingredientSCOut.selectedSegmentIndex
                    
                    self.addChildViewController(ingredientAnalysisDetailView)
                    ingredientAnalysisDetailView.view.frame = self.view.frame
                    self.view.addSubview(ingredientAnalysisDetailView.view)
                    ingredientAnalysisDetailView.didMove(toParentViewController: self)
                }
            }
            
        }else{ //selectedSegmentIndex == 1 주의 성분
            
            let ingredientAnalysisDetailView:IngredientAnalysisDetailViewController = storyboard?.instantiateViewController(withIdentifier: "IngredientAnalysisDetailViewController") as! IngredientAnalysisDetailViewController
            
            for dataIndex in 0...MyPageDataCenter.shared.feedIngredientWarningDatas.count{
                if indexPath.row == dataIndex{
                    ingredientAnalysisDetailView.ingredientName = MyPageDataCenter.shared.feedIngredientWarningDatas[indexPath.row].ingredientNameReturn
                          ingredientAnalysisDetailView.ingredientContent = MyPageDataCenter.shared.feedIngredientWarningDatas[indexPath.row].ingredientTextReturn
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
    
    @IBAction func backBtnAction(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
