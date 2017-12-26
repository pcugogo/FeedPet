//
//  EditInfoViewController.swift
//  FeedPet2
//
//  Created by 샤인 on 2017. 12. 22..
//  Copyright © 2017년 Ios_Park. All rights reserved.
//

import UIKit

class EditInfoViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

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
        
        return 1
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 && indexPath.row == 0 {
            let myInfoCell = tableView.dequeueReusableCell(withIdentifier: "MyInfoCell", for: indexPath) as! MyInfoCell
            return myInfoCell
        }else{
            let petInfoCell = tableView.dequeueReusableCell(withIdentifier: "PetInfoCell", for: indexPath) as! PetInfoCell
            return petInfoCell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 0 {
            return 150
        }else{
            return 392
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 30
        }else{
            return 20
        }
    }
    
    @IBAction func backBtnAction(_ sender: UIBarButtonItem) {
        print("Back")
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func saveBtnAction(_ sender: UIBarButtonItem) {
        let savedAlert:UIAlertController = UIAlertController(title: "", message: "내정보 수정 완료!", preferredStyle: .alert)
        
        let okBtn:UIAlertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        savedAlert.addAction(okBtn)
        
        self.present(savedAlert, animated: true, completion: nil)
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
