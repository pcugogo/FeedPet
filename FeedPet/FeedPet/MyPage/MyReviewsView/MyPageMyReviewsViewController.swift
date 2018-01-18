//
//  MyPageMyReviewsViewController.swift
//  FeedPet
//
//  Created by ChanWook Park on 2018. 1. 18..
//  Copyright © 2018년 HwangGisu. All rights reserved.
//

import UIKit

class MyPageMyReviewsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 300.0
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MyPageDataCenter.shared.reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reviews = MyPageDataCenter.shared.reviews[indexPath.row]
        
        let myPageMyReviewsCell = tableView.dequeueReusableCell(withIdentifier: "MyPageMyReviewsCell", for: indexPath) as! MyPageMyReviewsCell
        myPageMyReviewsCell.configureCell(reviews: reviews)
        return myPageMyReviewsCell
    }
    
    @IBAction func backBtnAction(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
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
