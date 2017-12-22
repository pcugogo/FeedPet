//
//  PageControllerBaseController.swift
//  FeedPet
//
//  Created by HwangGisu on 2017. 12. 22..
//  Copyright © 2017년 HwangGisu. All rights reserved.
//

import UIKit

class PageControllerBaseController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //테스트 위한 로그아웃 호출
        DataCenter.shared.singOut()
        if !DataCenter.shared.requestIsLogin(){
            print("로그인 안됫을때")
            DispatchQueue.main.async {
                self.showLoginViewController()
            }
        }
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
    
    // LoginView로 이동
    func showLoginViewController(){
        let nextViewContorller = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.present(nextViewContorller, animated: true, completion: nil)
    }

}
