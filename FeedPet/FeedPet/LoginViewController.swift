//
//  LoginViewController.swift
//  FeedPet
//
//  Created by HwangGisu on 2017. 12. 22..
//  Copyright © 2017년 HwangGisu. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKLoginKit
import AVFoundation

class LoginViewController: UIViewController{

    // 로그인 영상 옵저버프로퍼티
    var reference: DatabaseReference!
    
    public var videoURL: NSURL? {
        didSet {
            setupVideoBackground()
        }
    }
    // 구글 로그인 버튼(UIView) 아웃렛
    @IBOutlet weak var googleSignInButton: GIDSignInButton!
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        GIDSignIn.sharedInstance().uiDelegate = self
            
        
        // background AV
//        self.setupVideoBackground()
        videoURL = Bundle.main.url(forResource: "loginVideo", withExtension: "mov")! as NSURL
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: IBAction
    @IBAction func googleSingInButtonTouched(_ sender: UIButton){
        GIDSignIn.sharedInstance().signIn()
        GIDSignIn.sharedInstance().delegate=self
        GIDSignIn.sharedInstance().uiDelegate=self
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func setupVideoBackground() {
        var theURL = NSURL()
        if let url = videoURL {
            
            // 쉐이드
            //            let shade = UIView(frame: self.view.frame)
            //            shade.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
            //            view.addSubview(shade)
            //            view.sendSubview(toBack: shade)
            //
            theURL = url
            
            var avPlayer = AVPlayer()
            avPlayer = AVPlayer(url: theURL as URL)
            let avPlayerLayer = AVPlayerLayer(player: avPlayer)
            avPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
            avPlayer.volume = 0
            avPlayer.actionAtItemEnd = AVPlayerActionAtItemEnd.none
            
            avPlayerLayer.frame = view.layer.bounds
            
            // 영상을 사용할 화면 뷰 생성
            let layer = UIView(frame: self.view.frame)
            view.backgroundColor = UIColor.clear
            view.layer.insertSublayer(avPlayerLayer, at: 0)
            view.addSubview(layer)
            view.sendSubview(toBack: layer)
            
            // NotificationCenter에 Noti 등록 -  Noti 해제부분 구현 예정
            NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: avPlayer.currentItem)
            
            avPlayer.play()
        }
        
    }
    
    // AVPlayer 영상이 끝낱을 경우 호출
    
    func playerItemDidReachEnd(notification: NSNotification) {
        if let avItem = notification.object as? AVPlayerItem {
            avItem.seek(to: kCMTimeZero, completionHandler: { (result) in
                
            })
        }
    }
}
extension LoginViewController: GIDSignInDelegate, GIDSignInUIDelegate{
    // MARK: GIDSignInDelegate Method
    // Google SignIn 로그인 수행 후 호출
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        print("LoginViewController SignIn Button")
        if let error = error {
            print(error.localizedDescription)
            return
        }
        print("User signed into google")
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        // Auth 에 사용자 등록 및 Database에 데이터 저장
        Auth.auth().signIn(with: credential) {[unowned self] (user, error) in
            print("User Signed Into Firebase")
            self.reference = Database.database().reference()
            guard let googleUser = user else{return}
            print("## 구글 uid 확인: ", googleUser.uid)
            self.reference.child("user_profiles").child(googleUser.uid).observeSingleEvent(of: .value, with: { (dataSnapshot) in
                
                let snapshot = dataSnapshot.value as? [String:Any]
                print(snapshot)
                if(snapshot == nil)
                {
                    
                    var userData: [String:Any] = [:]
                    userData.updateValue(googleUser.displayName, forKey: "name")
                    userData.updateValue(googleUser.email, forKey: "email")
                    self.reference.child("user_profiles").child(googleUser.uid).setValue(userData)
                    
                    UserDefaults.standard.set(true, forKey: "loginState")
                    print(UserDefaults.standard.bool(forKey: "loginState"))
                    
                    
                }
                
            })
        }
    }
    
    
    
    
    // MARK: GIDSignInUIDelegate Method
    //사용자가 시작할 때 시작된 UIActivityIndicatorView애니메이션 중지
    //로그인 버튼을 누릅니다.
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        print("구글 로그인 버튼 클릭")
        if let error = error {
            // ...
            return
        }
        
        
    }
    //사용자에게 Google과 로그인하라는 메시지를 표시하는 뷰
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        print("구글 로그인 버튼 메시지")
    }
    //"SignintheGooglewithGoogle"보기를 해제합니다.
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        print("구글 로그인 버튼 창 닫기")
    }
    
}
