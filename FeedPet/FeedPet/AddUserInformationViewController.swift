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
    @IBOutlet weak var genderSegmentedControl: UISegmentedControl!
    @IBOutlet weak var userInformationScrollView: UIScrollView!
    
    var user: [String:Any]?
    // 약관 동의 결과 플래그
    var termsFlag: Bool = false
    // 닉네임 중복 체크 결과 플래그
    var nickNameFlag: Bool = false
    // 닉네임 데이터
    var nickName: String = ""
    var genderString: String = "M"
    var referecne: DatabaseReference?
    var delegate: ViewDismissProtocol?
    
    var delegateToViewController: LoginViewController?
    fileprivate let MAX_LENGTH = 10
    fileprivate let MIN_LENGTH = 2
    override func viewDidLoad() {
        super.viewDidLoad()
//        guard let userData = user else {return}
        user = DataCenter.shared.getUserData()
        guard let userData = user else {return}
        
        userNameLabel.text = userData["user_name"] as? String
        userEmailLabel.text = userData["user_email"] as? String
        userNickNameTextField.delegate = self
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textDidChange(_:)),
                                               name: NSNotification.Name.UITextFieldTextDidChange,
                                               object: userNickNameTextField)
        
        // 현재 뷰컨의 뷰에 탭제스쳐를 사용하여 키보드가 내려가도록 셀렉터로 호출
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(userNickNameTextField.endEditing(_:))))
        
        referecne = Database.database().reference()
        // Do any additional setup after loading the view.
    }


    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    deinit {
        // 옵저버 등록 해제
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
        
    }
    //    override func performSegue(withIdentifier identifier: String, sender: Any?) {
    //        print("Segue 이동전")
    //    }
    
    @IBAction func canCelBtnTouched(_ sender: UIBarButtonItem){
        
       self.dismiss(animated: true, completion: nil)
        
    }
    // 네비게이션바 다음 버튼 클릭시 세그이동
    @IBAction func petFunctionalMoveBtnTouched(_ sender: UIBarButtonItem){
        // 닉네임 중복확인 결과값과 약관동의가 이루어졌을때 세그 이동하도록 분기처리해야함.
        print(termsFlag,"/",nickNameFlag,"/",userNickNameTextField.text)
        if termsFlag && nickNameFlag && userNickNameTextField.text != nil && !(userNickNameTextField.text?.isEmpty)!{
            
            self.performSegue(withIdentifier: "functionalInformagionSegue", sender: nil)
        }else{
            let alert = UIAlertController(title: nil, message: "필수 사항을 입력해주세요.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)

        }
    }
    @IBAction func genderSegmentChanged(_ sender: UISegmentedControl){
        print(sender.selectedSegmentIndex)
        if sender.selectedSegmentIndex == 0 {
//            genderString = "M"
            user?.updateValue("M", forKey: "user_gender")
        }else{
            user?.updateValue("W", forKey: "user_gender")
//            genderString = "W"
        }
        
        print("###추가 회원정보:###",user)
    }
    // 약관 동의 버튼 클릭시 이미지 및 타이틀 변경
    @IBAction func termsCheckBtnTouched(_ sender: UIButton){
        
        if termCheckBoxBtn.currentImage == #imageLiteral(resourceName: "checkBoxDisable") {
            termCheckBoxBtn.setImage(#imageLiteral(resourceName: "checkBoxAble"), for: .normal)
            termCheckBoxBtn.setTitle("checkBoxAble", for: .normal)
            termsFlag = true
            
        }else{
            termCheckBoxBtn.setImage(#imageLiteral(resourceName: "checkBoxDisable"), for: .normal)
            termCheckBoxBtn.setTitle("checkBoxDisable", for: .normal)
            termsFlag = false
        }
    }
    
    @IBAction func termsViewMove(_ sender: UIButton){
        let termsWebView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TermsView") as! TermsViewController
        self.navigationController?.pushViewController(termsWebView, animated: true)
    }
    @IBAction func nickNameDoubleCheckBtnTouched(_ sender: UIButton){
        guard let userNickName = userNickNameTextField.text else {return}
        
        
//        if userNickNameTextField.text != nil && !(userNickNameTextField.text?.isEmpty)! {
            // 네트워크 인디케이터
            if userNickName.characters.count < MIN_LENGTH || userNickName.isEmpty {
                self.nickNameDoubleCheckResultLabel.text = "닉네임은 2~10자리로 입력하세요."
                self.nickNameDoubleCheckResultLabel.textColor = UIColor.init(hexString: "#FF6600")
                self.nickNameDoubleCheckResultLabel.isHidden = false
                self.nickNameDoubleCheckBtnOutlet.isEnabled = true
                self.nickNameFlag = false
            }else{
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
                            self.nickNameFlag = false
                        }
                    }else{
                        print("없어!!")
                        DispatchQueue.main.async {
                            self.nickNameDoubleCheckResultLabel.text = "사용 가능한 닉네임 입니다!:)"
                            self.nickNameDoubleCheckResultLabel.textColor = UIColor.init(hexString: "#555555")
                            self.nickNameDoubleCheckResultLabel.isHidden = false
                            self.nickNameDoubleCheckBtnOutlet.isEnabled = true
                            self.nickNameFlag = true
                            self.user?.updateValue(userNickName, forKey: "user_nic")
                        }
                    }
                    
                }
            }
            
//        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Menual Segue 호출
        if segue.identifier == "functionalInformagionSegue"
        {
            if let petinformationVC = segue.destination as? AddPetInformationViewController {
                guard let delegatVC = delegateToViewController else {return}
                self.user?.updateValue(genderString, forKey: "user_gender")
                guard let userData = self.user else {return}
         
                petinformationVC.delegate = delegatVC
                petinformationVC.userData = userData
                print("세그데이터://",userData)
            }
        }
        
    
    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        // segue전 문제 확인
        print(sender)
        return true
    }
    
    // 글자수 초과시 키보를 내리기위한 메서드
    @objc fileprivate func textDidChange(_ notification: Notification) {
        if let textField = notification.object as? UITextField {
            if let text = textField.text {
                // 초과되는 텍스트 제거
                if text.characters.count >= MAX_LENGTH {
                    textField.resignFirstResponder()
                }
            }
        }
    }
    
}


extension AddUserInformationViewController: UITextFieldDelegate{
    /*******************************************/
    // MARK: -  UITextFieldDelegate Method  //
    /*******************************************/
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 글자수 제한을 위한 길이체크 => // Swift 4에서는 String.count로 API변경됨
        let newLength = (textField.text?.characters.count)! + string.characters.count - range.length
        
        return !(newLength > MAX_LENGTH)
    }
  
    // 뷰 올리기
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.userInformationScrollView.setContentOffset(CGPoint(x: 0.0, y: 100.0), animated:true)
    }
    
    // 뷰 내리기
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.userInformationScrollView.setContentOffset(CGPoint(x: 0.0, y: 0.0), animated: true)
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }

    
}
