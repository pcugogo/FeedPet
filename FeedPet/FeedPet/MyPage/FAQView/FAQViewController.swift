//
//  FAQViewController.swift
//  FeedPet
//
//  Created by 샤인 on 2017. 12. 27..
//  Copyright © 2017년 HwangGisu. All rights reserved.
//

import UIKit

class FAQViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    let fAQContentImgNameArr = ["faq_mouth_img","faq_ranking_img","faq_alarm_img","faq_feed_grade_img"]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FAQCell", for: indexPath)
        
        if indexPath.row == 0{
            cell.textLabel?.font = UIFont(name: "System", size: 22)
            cell.textLabel?.text = "1.입소문 지수는 무엇인가요?"
            return cell
        }else if indexPath.row == 1{
            cell.textLabel?.font = UIFont(name: "System", size: 22)
            cell.textLabel?.text = "2.랭킹 기준은 무엇인가요?"
            return cell
        }else if indexPath.row == 2{
            cell.textLabel?.font = UIFont(name: "System", size: 22)
            cell.textLabel?.text = "3.밥 타임 알람은 무엇인가요?"
            return cell
        }else if indexPath.row == 3{
            cell.textLabel?.font = UIFont(name: "System", size: 22)
            cell.textLabel?.text = "4.등급이란 무엇인가요?"
            return cell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let fAQDetailView:FAQDetailViewController = storyboard?.instantiateViewController(withIdentifier: "FAQDetailViewController") as! FAQDetailViewController
        
        if indexPath.row == 0{
            
            fAQDetailView.barTitle = "입소문 지수는 무엇인가요?"
            fAQDetailView.fAQContentImgName = fAQContentImgNameArr[indexPath.row]
            
            self.navigationController?.pushViewController(fAQDetailView, animated: true)
        }else if indexPath.row == 1{
            fAQDetailView.barTitle = "랭킹 기준은 무엇인가요?"
            fAQDetailView.fAQContentImgName = fAQContentImgNameArr[indexPath.row]
            self.navigationController?.pushViewController(fAQDetailView, animated: true)
        }else if indexPath.row == 2{
            fAQDetailView.barTitle = "밥 타임 알람은 무엇인가요?"
            fAQDetailView.fAQContentImgName = fAQContentImgNameArr[indexPath.row]
            self.navigationController?.pushViewController(fAQDetailView, animated: true)
        }else if indexPath.row == 3{
            fAQDetailView.barTitle = "등급이란 무엇인가요?"
            fAQDetailView.fAQContentImgName = fAQContentImgNameArr[indexPath.row]
            self.navigationController?.pushViewController(fAQDetailView, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
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
