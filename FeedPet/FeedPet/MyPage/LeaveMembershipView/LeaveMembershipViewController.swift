//
//  LeaveMembershipViewController.swift
//  FeedPet
//
//  Created by 샤인 on 2018. 1. 4..
//  Copyright © 2018년 HwangGisu. All rights reserved.
//

import UIKit



class LeaveMembershipViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,LeaveMembershipCustomCellDelegate {
    
    
    let leaveMembershipReasonText = ["사용하기 불편해요","정보가 부족해요","다른앱을 사용하고 싶어요","기타"] //탈퇴 이유 텍스트들
    
    @IBOutlet weak var leaveMemberShipScrollView: UIScrollView!
    
    @IBOutlet weak var scrollContentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        MyPageDataCenter.shared.leaveMembershipReason = ""              //탈퇴이유 데이터 초기화
        MyPageDataCenter.shared.leaveMembarshipEtcReasonContent = ""
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.leaveMemberShipScrollView.backgroundColor = UIColor.black.withAlphaComponent(0)
        self.scrollContentView.backgroundColor = UIColor.black.withAlphaComponent(0)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil) //키보드 올라오는 것을 옵저브
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil) //키보드 사라지는 것을 옵저브
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 6
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        //탈퇴하기 TableView
        if indexPath.row == 0 {
            let leaveMembershipHeaderCell:LeaveMembershipHeaderCell = tableView.dequeueReusableCell(withIdentifier: "LeaveMembershipHeaderCell", for: indexPath) as! LeaveMembershipHeaderCell
            return leaveMembershipHeaderCell
            
        }else if indexPath.row == 4{
            let leaveMembershipEtcReasonCell:LeaveMembershipEtcReasonCell = tableView.dequeueReusableCell(withIdentifier: "LeaveMembershipEtcReasonCell", for: indexPath) as! LeaveMembershipEtcReasonCell
            
            leaveMembershipEtcReasonCell.delegate = self
            
            if MyPageDataCenter.shared.leaveMembershipReason == leaveMembershipReasonText.last{ //이유가 "기타"일 경우
                leaveMembershipEtcReasonCell.backgroundColor = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 1.0)
            }else{
                leaveMembershipEtcReasonCell.backgroundColor = UIColor.white
                leaveMembershipEtcReasonCell.etcReasonContentTextField.text = ""
            }
            
            return leaveMembershipEtcReasonCell
        }else if indexPath.row == 5{
            let leaveMembershipBtnCell:LeaveMembershipBtnCell = tableView.dequeueReusableCell(withIdentifier: "LeaveMembershipBtnCell", for: indexPath) as! LeaveMembershipBtnCell
            leaveMembershipBtnCell.delegate = self
            leaveMembershipBtnCell.confirmBtnOut.layer.cornerRadius = 5
            leaveMembershipBtnCell.cencelBtnOut.layer.cornerRadius = 5
            
            if MyPageDataCenter.shared.leaveMembershipReason != "" { //reloadData가 되기때문에 초기 색상을 지정해준다
                
                leaveMembershipBtnCell.confirmBtnOut.backgroundColor = UIColor(red: 236/255, green: 97/255, blue: 0/255, alpha: 1.0)     //탈퇴 이유 데이터가 들어왔을때 확인버튼 색상을 바꿔준다
                
            }else{
                leaveMembershipBtnCell.confirmBtnOut.backgroundColor = UIColor(red: 158/255, green: 158/255, blue: 161/255, alpha: 1.0)    //rgbColor를 사용할때 /255를 표시해줘야 색상이 제대로 나온다
            }
            
            return leaveMembershipBtnCell
        }else{
            let leaveMembershipReasonCell:LeaveMembershipReasonCell = tableView.dequeueReusableCell(withIdentifier: "LeaveMembershipReasonCell", for: indexPath) as! LeaveMembershipReasonCell
            leaveMembershipReasonCell.textLabel?.text = leaveMembershipReasonText[indexPath.row - 1]
            
            if MyPageDataCenter.shared.leaveMembershipReason == leaveMembershipReasonText[indexPath.row - 1]{
                leaveMembershipReasonCell.backgroundColor = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 1.0)
            }else{
                leaveMembershipReasonCell.backgroundColor = UIColor.white
            }
            //didSelectRowAt에서 tableview.reloadData를 실행하기때문에 leaveMembershipReasonCell이 드래그 되었다가 초기화된다 그래서 드래그 되게 코딩했다 (데이터 센터에 각 셀에 해당하는 데이터가 들어오면 드래그)
            
            return leaveMembershipReasonCell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //leaveMembershipTableView
        if indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3{
          
            MyPageDataCenter.shared.leaveMembershipReason = leaveMembershipReasonText[indexPath.row - 1]
            tableView.reloadData()
            
            
            self.tableView.frame = CGRect(x: self.tableView.frame.minX, y: self.view.center.y - 140, width: self.tableView.frame.width, height: 300)
            
            
        }else if indexPath.row == 4{
           
            if let etcText = leaveMembershipReasonText.last {
                MyPageDataCenter.shared.leaveMembershipReason = etcText // 이유가 기타일 경우
            }
            
            
            tableView.reloadData()
            
            
            self.tableView.frame = CGRect(x: self.tableView.frame.minX, y: self.view.center.y  - 180, width: self.tableView.frame.width, height: 350)
            
            
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        //leaveMembershipTableView
        if indexPath.row == 5{
            return 70
        }else if indexPath.row == 4 && MyPageDataCenter.shared.leaveMembershipReason == "기타" {
            return 95
        }else{
            return 46
        }
        
        
    }
    
   
    func keyboardEndEditing(){
        
        self.view.endEditing(true)
        self.tableView.frame = CGRect(x: self.tableView.frame.minX, y: self.view.center.y - 180 , width: self.tableView.frame.width, height: 350)
    }
    
    
    func leaveMembershipTableViewDisappear() {    // 프로토콜 메서드 키보드 사라질때 뷰 위치
        
        MyPageDataCenter.shared.leaveMembershipReason = ""
        MyPageDataCenter.shared.leaveMembarshipEtcReasonContent = ""
        
//        self.tableView.frame = CGRect(x: self.tableView.frame.minX, y: self.view.center.y - 140 , width: self.tableView.frame.width, height: 300)
        
        tableView.reloadData()
        self.view.endEditing(true)
        self.view.removeFromSuperview()
        
    }
    
    func leaveMembershipTableViewReloadData(){
        tableView.reloadData()
    }
    
    func keyboardWasShown(_ notification : Notification) {
        self.leaveMemberShipScrollView.contentOffset = CGPoint(x: 0, y: self.tableView.contentOffset.y + 230)
    }
    
    func keyboardWillHide(_ notification : Notification) {
        self.leaveMemberShipScrollView.contentOffset = CGPoint(x: 0, y: self.tableView.contentOffset.y)
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
