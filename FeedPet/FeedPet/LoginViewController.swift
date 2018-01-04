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
    
    var dict : [String : Any]!
    
    
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
        self.navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view.
        GIDSignIn.sharedInstance().uiDelegate = self
        
        // #삭제예정 : 로그인화면 이동 테스트를 위한 코드 - 삭제 예정
        UserDefaults.standard.setValue(nil, forKey: "localGoogleUid")
        
        // background AV
        //        self.setupVideoBackground()
        videoURL = Bundle.main.url(forResource: "loginVideo", withExtension: "mov")! as NSURL
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        
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
    
    @IBAction func facebookSingInButtonTouched(sender: UIButton) {
        let fbLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                return
            }else if result?.isCancelled == true {
                print(result)
            }else{
                self.getFBUserData()
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                Auth.auth().signIn(with: credential) { (user, error) in
                    
                    
                    guard let faceBookUser = user else{return}
                    print("## 페이스북 uid 확인: ", faceBookUser.uid)
                    
                    //                    if let user = user {
                    //                        print(user)
                    //                        let uid = user.uid
                    //                        UserDefaults.standard.set(true, forKey: "isLogin")
                    //                        let parameter: [String:String] = ["email":self.dict["email"] as! String, "username":self.dict["name"] as! String]
                    //                        print(parameter)
                    //                        self.reference = Database.database().reference()
                    //                        let userDataRef = self.reference.child("user_profiles").child(user.uid)
                    //                        userDataRef.setValue(parameter)
                    //
                    //
                    //
                    //                    }
                    
                    // UserDefault에 "localFaceBookUid" 의 값이 존재 하지 않을 경우(최초로그인)->추가회원가입화면이동
                    if UserDefaults.standard.string(forKey: "localFaceBookUid") == nil {
                        // UserDefault에 로그인한 user.uid 정보를 "localFaceBookUid" 키 값에 할당 --> #테스트를 위해 주석처리#
                        //                UserDefaults.standard.setValue(faceBookUser.uid, forKey: "localFaceBookUid")
                        guard let displayName = faceBookUser.displayName else {return}
                        guard let email = faceBookUser.email else {return}
                        
                        var userData: [String:Any] = [:]
                        userData.updateValue(displayName, forKey: "name")
                        userData.updateValue(email, forKey: "email")
                        print(userData)
                        let addUserInfromationView = self.storyboard?.instantiateViewController(withIdentifier: "AddUserInformationViewController") as! AddUserInformationViewController
                        addUserInfromationView.user = userData
                        
                        self.navigationController?.navigationBar.isHidden = false
                        self.navigationController?.pushViewController(addUserInfromationView, animated: true)
                        //                self.present(addInfomationViewController, animated: true, completion: nil)
                        
                    }
                    
                    if let error = error {
                        print(error)
                    }
                }
            }
        }
    }
    
    func getFBUserData() {
        if((FBSDKAccessToken.current()) != nil) {
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email, gender,age_range"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    self.dict = result as! [String : Any]
                    print(self.dict)
                }
            })
        }
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
        print(credential)
        
        // Auth 에 사용자 등록 및 Database에 데이터 저장- 데이터베이스 저장은 추가 정보 입력후 저장되도록
        Auth.auth().signIn(with: credential) {[unowned self] (user, error) in
            print("User Signed Into Firebase")
            self.reference = Database.database().reference()
            guard let googleUser = user else{return}
            print("## 구글 uid 확인: ", googleUser.uid)
            
            // 최초 로그인시에만 Firebase데이터에 저장
            // 그렇지않을 경우 Firebase데이터에 저장하지 않고 Auth에만 등록
            
            // UserDefault에 "localGoogleUid" 의 값이 존재 하지 않을 경우(최초로그인)->추가회원가입화면이동
            if UserDefaults.standard.string(forKey: "localGoogleUid") == nil {
                // UserDefault에 로그인한 user.uid 정보를 "localGoogleUid" 키 값에 할당 --> #테스트를 위해 주석처리#
                //                UserDefaults.standard.setValue(googleUser.uid, forKey: "localGoogleUid")
                
                
                /* self.reference.child("user_profiles").child(googleUser.uid).observeSingleEvent(of: .value, with: { (dataSnapshot) in
                 
                 let snapshot = dataSnapshot.value as? [String:Any]
                 print(snapshot)
                 
                 // 기존에 DataSnapShot이 값이 없을 경우(nil일경우)
                 if(snapshot == nil)
                 {
                 guard let displayName = googleUser.displayName else {return}
                 guard let email = googleUser.email else {return}
                 
                 var userData: [String:Any] = [:]
                 userData.updateValue(displayName, forKey: "name")
                 userData.updateValue(email, forKey: "email")
                 self.reference.child("user_profiles").child(googleUser.uid).setValue(userData)
                 
                 UserDefaults.standard.set(true, forKey: "loginState")
                 print(UserDefaults.standard.bool(forKey: "loginState"))
                 
                 
                 }
                 
                 })
                 */
                guard let displayName = googleUser.displayName else {return}
                guard let email = googleUser.email else {return}
                
                var userData: [String:Any] = [:]
                userData.updateValue(displayName, forKey: "name")
                userData.updateValue(email, forKey: "email")
                
                let addUserInfromationView = self.storyboard?.instantiateViewController(withIdentifier: "AddUserInformationViewController") as! AddUserInformationViewController
                addUserInfromationView.user = userData
                
                self.navigationController?.navigationBar.isHidden = false
                self.navigationController?.pushViewController(addUserInfromationView, animated: true)
                //                self.present(addInfomationViewController, animated: true, completion: nil)
                
            }else{ // 기존에 로그인한 정보가 있을경우->메인페이지로 이동
                print("메인 뷰동동")
                self.dismiss(animated: true, completion: nil)
            }
            
            
            
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

