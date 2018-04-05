//
//  FeedReviewMoreViewController.swift
//  FeedPet
//
//  Created by HwangGisu on 2018. 4. 2..
//  Copyright © 2018년 HwangGisu. All rights reserved.
//

import UIKit

class FeedReviewMoreViewController: UIViewController {

    @IBOutlet weak var reviewTableView: UITableView!
    
    var sortingReviewData: [ReviewInfo] = []
        
    override func viewDidLoad() {
        super.viewDidLoad()
        print(sortingReviewData)
        reviewTableView.delegate = self
        reviewTableView.dataSource = self
        
        self.reviewTableView.register(UINib(nibName: "FeedReviewListCell", bundle: nil), forCellReuseIdentifier: "FeedReviewListCell")
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

extension FeedReviewMoreViewController: UITableViewDelegate,  UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortingReviewData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedReviewListCell", for: indexPath) as! FeedReviewListCell
        print("디테일에서 리뷰정보\(indexPath.row))://",sortingReviewData[indexPath.row])
        
        
        cell.reviewData = sortingReviewData[indexPath.row]
        return cell
    }
    
}



