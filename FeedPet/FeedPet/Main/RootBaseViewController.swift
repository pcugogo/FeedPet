//
//  RootBaseViewController.swift
//  FeedPet
//
//  Created by HwangGisu on 2018. 2. 8..
//  Copyright © 2018년 HwangGisu. All rights reserved.
//

import UIKit
import Firebase
import SwiftyGif
class RootBaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // 로그인 테스트를 위한 코드 삭제예정
//        DataCenter.shared.socialLogOut()
//        DataCenter.shared.socialLogOut { (result) in
//            print(result)
//        }
        
//        let loadingIndicator: UIImageView = {
//            let imgView = UIImageView()
//            let gifManager = SwiftyGifManager(memoryLimit:30)
//            let gif = UIImage(gifName: "loading_img@3.gif")
//            imgView.setGifImage(gif, manager: gifManager)
//            imgView.contentMode = .scaleAspectFit
//            imgView.clipsToBounds = true
//            return imgView
//        }()
//
//        let gifManager = SwiftyGifManager(memoryLimit:30)
//        let gif = UIImage(gifName: "loading_img@3x2.gif")
//        loadingIndicator.setGifImage(gif, manager: gifManager)
//        DispatchQueue.main.async {
//            //            spinner.addSubview(loadingIndicator)
//
//
//            self.view.addSubview(loadingIndicator)
//            loadingIndicator.autoLayoutAnchor(top: nil,
//                                              left: nil,
//                                              right: nil,
//                                              bottom: nil,
//                                              topConstant: 0,
//                                              leftConstant: 0,
//                                              rigthConstant: 0,
//                                              bottomConstant: 0,
//                                              width: self.view.layer.frame.width * 0.22,
//                                              height: self.view.layer.frame.width * 0.22,
//                                              centerX: self.view.centerXAnchor,
//                                              centerY: self.view.centerYAnchor)
//
//        }
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 로그인여부 판단 호출메서드
//        loginStateToMoveViewController()
    }
    //뷰가 화면에 표시되면 노출된다.
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("ggggggg")
//        // 로그인여부 판단 호출메서드
        loginStateToMoveViewController()
    }
    //뷰의 bound가 변경되면 뷰는 하위 뷰의 레이아웃을 변경해야 하는데, 그 작업이 이루어지기 직전에 호출
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("viewlayout")
//        loginStateToMoveViewController(isLogin: true)
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

    
    func loginStateToMoveViewController(){
        if DataCenter.shared.requestIsLogin(){
            let page = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PageControllerBase") as! PageControllerBaseController
            let nextNavi = UINavigationController(rootViewController: page)
            nextNavi.navigationBar.isTranslucent = false
            //self.present(nextNavi, animated: false, completion: nil)
            guard let loginUserId = Auth.auth().currentUser?.uid else { return }
            print("NOW USERID://", loginUserId)
                Database.database().reference().child("user_info").child(loginUserId).observeSingleEvent(of: .value, with: { (dataSnap) in
                if let userInfoSnapshot = dataSnap.value as? [String:Any]{
                    
                    let userInfo = User(userInfoData: userInfoSnapshot)
                    print("조회한 유저데이터 로그인뷰://,",userInfo)
                    DataCenter.shared.userInfo = userInfo
//                    UserDefaults.standard.set(userInfo, forKey: "loginUserData")
                    //                            var userFunctionalIndexPath: [IndexPath] = []
                    //                            for indexRow in userInfo.userPetFunctionalIndexPathRow {
                    //                                userFunctionalIndexPath.append(IndexPath(row: indexRow, section: 0))
                    //                            }
                    //                            print("조회해온 유저정보의 기능성 인덱스 패스://", userFunctionalIndexPath)
                    //                        self.userSelectFunctionalIndexPath = userFunctionalIndexPath
                    //                        self.functionalCollectionView.reloadData()
                    //                                appDelegate.window?.rootViewController? = navi
                    //                                appDelegate.window!.makeKeyAndVisible()
                    
                    let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
//                    appDelegate.window?.rootViewController = nextNavi
                    self.present(nextNavi, animated: false, completion: nil)
                }
            }, withCancel: { (error) in
                print(error)
            })

           
        }else{
            let LoginViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//            let page = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PageControllerBase") as! PageControllerBaseController
//            let nextNavi = UINavigationController(rootViewController: page)
//            nextNavi.navigationBar.isTranslucent = false
            self.present(LoginViewController, animated: true, completion: nil)
//            self.present(LoginViewController, animated: true, completion: {
//                let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
//                appDelegate.window?.rootViewController = nextNavi
//            })
//            let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
//            appDelegate.window?.rootViewController = nextNavi
//            appDelegate.window?.rootViewController?.transition(from: self, to: nextNavi, duration: 0.3, options: .beginFromCurrentState, animations: {
//
//            }, completion: { (finish) in
//
//            })
           
        }
        
//        if isLogin {
//            let page = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PageControllerBase") as! PageControllerBaseController
//            let nextNavi = UINavigationController(rootViewController: page)
//            nextNavi.navigationBar.isTranslucent = false
//            self.present(nextNavi, animated: false, completion: nil)
//        }else{
//            let LoginViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//
//            self.present(LoginViewController, animated: true, completion: nil)
//        }
    }
    
}
