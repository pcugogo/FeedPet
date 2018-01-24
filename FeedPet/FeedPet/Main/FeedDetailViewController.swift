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
   
    override func viewDidLoad() {
        super.viewDidLoad()
        feedDetailTableView.delegate = self
        feedDetailTableView.dataSource = self
        self.navigationController?.isNavigationBarHidden = false
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0{
            return 1
        }else{
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            
            let detailCell = tableView.dequeueReusableCell(withIdentifier: "FeedDetailCell", for: indexPath) as! FeedDetailITableViewCell
            
            return detailCell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "FeedIngredientCell", for: indexPath) as! FeedIngredientTableViewCell
            
            return cell
        }
    }
}
