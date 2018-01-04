//
//  AddUserInformationViewController.swift
//  FeedPet
//
//  Created by HwangGisu on 2017. 12. 28..
//  Copyright © 2017년 HwangGisu. All rights reserved.
//

import UIKit
import Firebase

class AddUserInformationViewController: UIViewController {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var termCheckBoxBtn: UIButton!
    @IBOutlet weak var userNickNameTextField: UITextField!
    @IBOutlet weak var nickNameDoubleCheckResultLabel: UILabel!
    @IBOutlet weak var nickNameDoubleCheckBtnOutlet: UIButton!
    
    
    var user: [String:Any]?
    // 약관 동의 결과 플래그
    var termsFlag: Bool = false
    // 닉네임 중복 체크 결과 플래그
    var nickNameFlag: Bool = false
    var referecne: DatabaseReference?
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let userData = user else {return}
        userNameLabel.text = userData["name"] as? String
        userEmailLabel.text = userData["email"] as? String
        
        referecne = Database.database().reference()
        // Do any additional setup after loading the view.
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 네비게이션바 다음 버튼 클릭시 세그이동
    @IBAction func petFunctionalMoveBtnTouched(_ sender: UIBarButtonItem){
        // 닉네임 중복확인 결과값과 약관동의가 이루어졌을때 세그 이동하도록 분기처리해야함.
        self.performSegue(withIdentifier: "functionalInformagionSegue", sender: nil)
//        if termsFlag && nickNameFlag {
//            self.performSegue(withIdentifier: "functionalInformagionSegue", sender: nil)
//        }else{
//            let alert = UIAlertController(title: nil, message: "필수 사항을 확인후 이동이 가능합니다.", preferredStyle: .alert)
//            let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
//            alert.addAction(okAction)
//            self.present(alert, animated: true, completion: nil)
//
//        }
    }

    // 약관 동의 버튼 클릭시 이미지 및 타이틀 변경
    @IBAction func termsCheckBtnTouched(_ sender: UIButton){
        
        if termCheckBoxBtn.currentImage == #imageLiteral(resourceName: "checkBoxDisable") {
            termCheckBoxBtn.setImage(#imageLiteral(resourceName: "checkBoxAble"), for: .normal)
            termCheckBoxBtn.setTitle("checkBoxAble", for: .normal)
            
            
        }else{
            termCheckBoxBtn.setImage(#imageLiteral(resourceName: "checkBoxDisable"), for: .normal)
            termCheckBoxBtn.setTitle("checkBoxDisable", for: .normal)
        }
    }
    
    @IBAction func nickNameDoubleCheckBtnTouched(_ sender: UIButton){
        guard let userNickName = userNickNameTextField.text else {return}
        //
        if userNickNameTextField.text != nil && !(userNickNameTextField.text?.isEmpty)! {
            // 네트워크 인디케이터
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
            nickNameDoubleCheckBtnOutlet.isEnabled = false
            
            DataCenter.shared.nicNameDoubleChek(nickName: userNickName) {(result) in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                if result {
                    print("잇어!!")
                    DispatchQueue.main.async {
                        self.nickNameDoubleCheckResultLabel.text = "이미 존재하는 닉네임 입니다 :("
                        self.nickNameDoubleCheckResultLabel.textColor = UIColor.init(hexString: "#FF6600")
                        self.nickNameDoubleCheckResultLabel.isHidden = false
                        self.nickNameDoubleCheckBtnOutlet.isEnabled = true
                        
                    }
                }else{
                    print("없어!!")
                    DispatchQueue.main.async {
                        self.nickNameDoubleCheckResultLabel.text = "사용 가능한 닉네임 입니다!:)"
                        self.nickNameDoubleCheckResultLabel.textColor = UIColor.init(hexString: "#555555")
                        self.nickNameDoubleCheckResultLabel.isHidden = false
                        self.nickNameDoubleCheckBtnOutlet.isEnabled = true
                    }
                }
                
            }
        }
    }
}
