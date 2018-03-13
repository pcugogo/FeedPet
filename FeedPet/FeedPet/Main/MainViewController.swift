//
//  MainViewController.swift
//  FeedPet
//
//  Created by HwangGisu on 2017. 12. 22..
//  Copyright © 2017년 HwangGisu. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        var isLogin = false
        print("view didload")
        
    
//        if isLogin {
//            let page = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PageControllerBase") as! PageControllerBaseController
//            let navi = UINavigationController(rootViewController: page)
//            print(self.navigationController)
//            self.present(navi, animated: true, completion: nil)
//        }else{
//            let LoginViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//            self.present(LoginViewController, animated: false, completion: {
//
//            })
//        }

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewdidappear")
//        moveLoginController()
//        let page = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PageControllerBase") as! PageControllerBaseController
//        let nextNavi = UINavigationController(rootViewController: page)
//
//
//
//        self.present(nextNavi, animated: true, completion: nil)
        
//        self.present(navi, animated: true, completion: nil)
        
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //moveLoginController()
        print("viewdid layousubviews")
        movePageBaseController()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    


    func movePageBaseController(){
        let page = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PageControllerBase") as! PageControllerBaseController
        let nextNavi = UINavigationController(rootViewController: page)
        
        
        
        self.present(nextNavi, animated: true, completion: nil)
    }
    
    func moveLoginController(){
        let LoginViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
    
         self.present(LoginViewController, animated: true, completion: nil)
        
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
