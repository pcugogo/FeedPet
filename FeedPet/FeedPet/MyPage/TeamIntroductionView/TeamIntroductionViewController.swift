//
//  TeamIntroductionViewController.swift
//  FeedPet
//
//  Created by 샤인 on 2017. 12. 28..
//  Copyright © 2017년 HwangGisu. All rights reserved.
//

import UIKit

class TeamIntroductionViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    let teamMenberName = ["서지현","황기수","김수현","서경호","박찬욱","홍종민"]
    let position = ["기획·개발","IOS개발","기획·디자인","디자인","IOS개발","Android개발"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else{
            return 7
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        if indexPath.section == 0{
            let introductionImageCell = tableView.dequeueReusableCell(withIdentifier: "introductionImageCell", for: indexPath)
            return introductionImageCell
        }else{
            if indexPath.row == 0 {
                let teamLbCell = tableView.dequeueReusableCell(withIdentifier: "teamLbCell", for: indexPath) as! TeamLbCell
                return teamLbCell
            }else{
                let teamMemberIntroductionCell = tableView.dequeueReusableCell(withIdentifier: "teamMemberIntroductionCell", for: indexPath) as! TeamMemberIntroductionCell
                //                teamMemberIntroductionCell.imgView.image = 이미지 설정해야됨
                teamMemberIntroductionCell.teamMenberNameLb.text = teamMenberName[indexPath.row - 1]
                teamMemberIntroductionCell.positionLb.text = position[indexPath.row - 1]
                return teamMemberIntroductionCell
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 381
        }else{
            if indexPath.row == 0{
                return 27
            }else{
                return 70
            }
        }
        
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
