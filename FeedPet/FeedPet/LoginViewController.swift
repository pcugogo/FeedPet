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
    
    var spiner: UIView?
    
    
    var reference: DatabaseReference!
    // 로그인 영상 옵저버프로퍼티
    //    public var videoURL: NSURL? {
    //        didSet {
    //            setupVideoBackground()
    //        }
    //    }
    // 로그인 영상이 보일 뷰
    @IBOutlet weak var videoView: UIView!
    var introPlayer: AVPlayer?
    
    // 구글 로그인 버튼(UIView) 아웃렛
    @IBOutlet weak var googleSignInButton: GIDSignInButton!
    
    @IBOutlet weak var videoBackgroundView: UIView!
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // 영상 옵저버 프로퍼티 등록
        NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: .UIApplicationDidBecomeActive, object: nil)
        //        DataCenter.shared.singOut()
        //        self.navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view.
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        
        // #삭제예정 : 로그인화면 이동 테스트를 위한 코드 - 삭제 예정
        //        UserDefaults.standard.setValue(nil, forKey: "localGoogleUid")
        
        // background AV
        //        self.setupVideoBackground()
        //        videoURL = Bundle.main.url(forResource: "loginVideo", withExtension: "mov")! as NSURL
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if introPlayer == nil {
            videoView.contentMode = .scaleAspectFill
            playVideo()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        self.navigationController?.navigationBar.isHidden = true
        // 뷰가 나타날때 지울 spiner 옵셔널 체크를 통해 값이 있을경우에 지워준다.
        guard let spinerView = spiner else{return}
        DataCenter.shared.removeSpinner(spinner: spinerView)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        introPlayer?.play()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        introPlayer?.pause()
        // 옵저버 등록 해제
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIApplicationDidBecomeActive, object: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.default
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func appDidBecomeActive() {
        introPlayer?.play()
    }
    
    func playVideo() {
        UIApplication.shared.statusBarView?.backgroundColor = .clear
        let path = Bundle.main.path(forResource: "login_video360", ofType: "mov")
        let url  = NSURL.fileURL(withPath: path!)
        introPlayer = AVPlayer(url: url)
        if let introPlayer = introPlayer {
            introPlayer.allowsExternalPlayback = false
            let introPlayerLayer = AVPlayerLayer(player: introPlayer)
            
            introPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoView.layer.addSublayer(introPlayerLayer)
            introPlayerLayer.frame = self.view.bounds
            introPlayer.rate = 2
            NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying(notification:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: introPlayer.currentItem)
        }
    }
    
    @objc func playerDidFinishPlaying(notification: NSNotification) {
        if let playerItem = notification.object as? AVPlayerItem {
            playerItem.seek(to: kCMTimeZero)
        }
        if let introPlayer = introPlayer {
            introPlayer.play()
        }
    }
    
    // MARK: IBAction
    @IBAction func googleSingInButtonTouched(_ sender: UIButton){
        
        GIDSignIn.sharedInstance().signIn()
        
        
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
                self.socialLogin(credential: credential, social: "facebook")
                //                Auth.auth().signIn(with: credential) { (user, error) in
                //
                //
                //                    guard let faceBookUser = user else{return}
                //                    print("## 페이스북 uid 확인: ", faceBookUser.uid)
                //                    UserDefaults.standard.setValue(faceBookUser.uid, forKey: "userUID")
                //
                //                    // UserDefault에 "localFaceBookUid" 의 값이 존재 하지 않을 경우(최초로그인)->추가회원가입화면이동
                //                    if UserDefaults.standard.string(forKey: "localFaceBookUid") == nil {
                //                        // UserDefault에 로그인한 user.uid 정보를 "localFaceBookUid" 키 값에 할당 --> #테스트를 위해 주석처리#
                //                        //                UserDefaults.standard.setValue(faceBookUser.uid, forKey: "localFaceBookUid")
                //
                //                        //
                //                        //                        guard let displayName = faceBookUser.displayName else {return}
                //                        //                        guard let email = faceBookUser.email else {return}
                //                        //
                //                        //                        var userData: [String:Any] = [:]
                //                        //                        userData.updateValue(displayName, forKey: "user_name")
                //                        //                        userData.updateValue(email, forKey: "user_email")
                //                        //                        print(userData)
                //                        //                        let addUserInfromationView = self.storyboard?.instantiateViewController(withIdentifier: "AddUserInformationViewController") as! AddUserInformationViewController
                //                        //                        addUserInfromationView.user = userData
                //                        //
                //                        self.reference.child("user_info").child(faceBookUser.uid).observeSingleEvent(of: .value, with: { (dataSnapshot) in
                //
                //                            let snapshot = dataSnapshot.value as? [String:Any]
                //                            print(snapshot)
                //
                //                            // 기존에 DataSnapShot이 값이 없을 경우(nil일경우)
                //                            if(snapshot == nil)
                //                            {
                //                                guard let displayName = faceBookUser.displayName else {return}
                //                                guard let email = faceBookUser.email else {return}
                //
                //                                var userData: [String:Any] = [:]
                //                                userData.updateValue(displayName, forKey: "user_name")
                //                                userData.updateValue(email, forKey: "user_email")
                //                                // 아직 확실한 로그인 상태가 아니므로 데이터를 넒겨준다.
                //                                //                        self.reference.child("user_profiles").child(googleUser.uid).setValue(userData)
                //
                //                                // 수정될수있음 구글아이디로 로그인한지 알기 위한 값으로 사용할예정
                //                                //                        UserDefaults.standard.set(true, forKey: "loginState")
                //                                print(UserDefaults.standard.bool(forKey: "loginState"))
                //
                //                                // 테스트를 위해 추가 추후 삭제될수도잇음
                //                                DataCenter.shared.loginUserData = userData
                //
                //                                let addUserInfromationView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddUserInformationViewController") as! AddUserInformationViewController
                //                                addUserInfromationView.user = userData
                //                                addUserInfromationView.delegateToViewController = self
                //
                //                                let addUserInfoNaviController = UINavigationController(rootViewController: addUserInfromationView)
                //                                addUserInfoNaviController.navigationBar.isTranslucent = false
                //
                //                                self.present(addUserInfoNaviController, animated: true, completion: nil)
                //
                //                            }else{
                //                                //                        self.dismiss(animated: true, completion: nil)
                //                                let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
                //                                let mainHome = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PageControllerBase")
                //                                let navi = UINavigationController(rootViewController: mainHome)
                //                                navi.navigationBar.isTranslucent = false
                //                                appDelegate.window?.rootViewController? = navi
                //
                //                            }
                //
                //                        })
                //
                //                    }else{
                //
                //                    }
                //
                //                    //                    if let error = error {
                //                    //                        print(error)
                //                    //                    }
                //                }
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
    
    //    func setupVideoBackground() {
    //        // 로그인 영상부분의 상태바 부분의 색깔을 여기서만 바꿔준다
    //        UIApplication.shared.statusBarView?.backgroundColor = .clear
    //
    //        var theURL = NSURL()
    //        if let url = videoURL {
    //
    //            // 쉐이드
    //            //            let shade = UIView(frame: self.view.frame)
    //            //            shade.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    //            //            view.addSubview(shade)
    //            //            view.sendSubview(toBack: shade)
    //            //
    //            theURL = url
    //
    //            var avPlayer = AVPlayer()
    //            avPlayer = AVPlayer(url: theURL as URL)
    //            let avPlayerLayer = AVPlayerLayer(player: avPlayer)
    //            avPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
    //            avPlayer.volume = 0
    //            avPlayer.actionAtItemEnd = AVPlayerActionAtItemEnd.none
    //
    //            avPlayerLayer.frame = self.view.frame
    //
    //            //                .autoLayoutAnchor(top: videoBackgroundView.topAnchor,
    //            //                                  left: videoBackgroundView.leftAnchor,
    //            //                                  right: videoBackgroundView.rightAnchor,
    //            //                                  bottom: videoBackgroundView.bottomAnchor,
    //            //                                  topConstant: 0,
    //            //                                  leftConstant: 0,
    //            //                                  rigthConstant: 0,
    //            //                                  bottomConstant: 0,
    //            //                                  width: 0,
    //            //                                  height: 0,
    //            //                                  centerX: nil,
    //            //                                  centerY: nil)
    //            // 영상을 사용할 화면 뷰 생성
    //            let layer = UIView(frame: self.view.frame)
    //            self.view.backgroundColor = UIColor.clear
    //            self.view.layer.insertSublayer(avPlayerLayer, at: 0)
    //
    //            self.view.addSubview(layer)
    //            self.view.sendSubview(toBack: layer)
    //
    //            // NotificationCenter에 Noti 등록 -  Noti 해제부분 구현 예정
    //            NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: avPlayer.currentItem)
    //            DispatchQueue.main.async {
    //
    //                avPlayer.play()
    //            }
    //        }
    //
    //    }
    //
    //    // AVPlayer 영상이 끝낱을 경우 호출
    //
    //    func playerItemDidReachEnd(notification: NSNotification) {
    //        if let avItem = notification.object as? AVPlayerItem {
    //            avItem.seek(to: kCMTimeZero, completionHandler: { (result) in
    //
    //            })
    //        }
    //    }
    
    func socialLogin(credential: AuthCredential, social: String){
        // Auth 에 사용자 등록 및 Database에 데이터 저장- 데이터베이스 저장은 추가 정보 입력후 저장되도록
        Auth.auth().signIn(with: credential) {[unowned self] (user, error) in
            
            print("User Signed Into Firebase")
            self.reference = Database.database().reference()
            guard let loginUser = user else{return}
            print("## 로그인 uid 확인: ", loginUser.uid)
            UserDefaults.standard.setValue(loginUser.uid, forKey: "userUID")
            UserDefaults.standard.setValue(social, forKey: "loginSocial")
            // 최초 로그인시에만 Firebase데이터에 저장
            // 그렇지않을 경우 Firebase데이터에 저장하지 않고 Auth에만 등록
            
            
            
            // UserDefault에 로그인한 user.uid 정보를 "localGoogleUid" 키 값에 할당 --> #테스트를 위해 주석처리#
            //                UserDefaults.standard.setValue(googleUser.uid, forKey: "localGoogleUid")
            
            // 최초 로그인인지 아닌지만 확인하고 최초이든 아니든 로그인시에 현재 로그인한 소셜 정보를 저장해줘야한다.
            self.reference.child("user_info").child(loginUser.uid).observeSingleEvent(of: .value, with: { (dataSnapshot) in
                
                let snapshot = dataSnapshot.value as? [String:Any]
                print(snapshot)
                
                // 기존에 DataSnapShot이 값이 없을 경우(nil일경우)
                if(snapshot == nil)
                {
                    guard let displayName = loginUser.displayName else {return}
                    guard let email = loginUser.email else {return}
                    
                    var userData: [String:Any] = [:]
                    userData.updateValue(displayName, forKey: "user_name")
                    userData.updateValue(email, forKey: "user_email")
                    // 아직 확실한 로그인 상태가 아니므로 데이터를 넒겨준다.
                    //                        self.reference.child("user_profiles").child(googleUser.uid).setValue(userData)
                    
                    // 수정될수있음 구글아이디로 로그인한지 알기 위한 값으로 사용할예정
                    //                        UserDefaults.standard.set(true, forKey: "loginState")
                    print(UserDefaults.standard.bool(forKey: "loginState"))
                    
                    // 테스트를 위해 추가 추후 삭제될수도잇음
                    DataCenter.shared.loginUserData = userData
                    
                    let addUserInfromationView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddUserInformationViewController") as! AddUserInformationViewController
                    addUserInfromationView.user = userData
                    addUserInfromationView.delegate = self
                    addUserInfromationView.delegateToViewController = self
                    
                    let addUserInfoNaviController = UINavigationController(rootViewController: addUserInfromationView)
                    addUserInfoNaviController.navigationBar.isTranslucent = false
                    
                    self.present(addUserInfoNaviController, animated: true, completion: nil)
                    
                }else{
                    //                        self.dismiss(animated: true, completion: nil)
                    
                    let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
                    print("현재 루트뷰컨://",appDelegate.window?.rootViewController)
                    let mainHome = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PageControllerBase")
                    let navi = UINavigationController(rootViewController: mainHome)
                    
                    appDelegate.window?.rootViewController? = navi
                    
                }
//                Database.database().reference().child("user_info").child(loginUser.uid).observeSingleEvent(of: .value, with: { (snapshot) in
//                    print(snapshot)
//                    if let userInfoSnapshot = snapshot.value as? [String:Any]{
//                        
//                        let userInfo = User(userInfoData: userInfoSnapshot)
//                        print("조회한 유저데이터2://,",userInfo)
//                        var userFunctionalIndexPath: [IndexPath] = []
//                        for indexRow in userInfo.userPetFunctionalIndexPathRow {
//                            userFunctionalIndexPath.append(IndexPath(row: indexRow, section: 0))
//                        }
//                        print("조회해온 유저정보의 기능성 인덱스 패스://", userFunctionalIndexPath)
////                        self.userSelectFunctionalIndexPath = userFunctionalIndexPath
////                        self.functionalCollectionView.reloadData()
//                        
//                    }

//                })
            })
            
            //                guard let displayName = googleUser.displayName else {return}
            //                guard let email = googleUser.email else {return}
            //
            //                var userData: [String:Any] = [:]
            //                userData.updateValue(displayName, forKey: "name")
            //                userData.updateValue(email, forKey: "email")
            //
            //                // 테스트를 위해 추가 추후 삭제될수도잇음
            //                DataCenter.shared.loginUserData = userData
            //
            //                let addUserInfromationView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddUserInformationViewController") as! AddUserInformationViewController
            //                addUserInfromationView.user = userData
            //                addUserInfromationView.delegateToViewController = self
            //
            //                let addUserInfoNaviController = UINavigationController(rootViewController: addUserInfromationView)
            //                addUserInfoNaviController.navigationBar.isTranslucent = false
            //
            //                self.present(addUserInfoNaviController, animated: true, completion: nil)
            //
            //
            
            //                self.performSegue(withIdentifier: "AddUserInformationViewController", sender: nil)
            
            
            
        }
    }
}
extension LoginViewController: GIDSignInDelegate, GIDSignInUIDelegate{
    // MARK: GIDSignInDelegate Method
    // Google SignIn 로그인 수행 후 호출
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        print("구글 로그인 LoginViewController SignIn Custom Button")
        if let error = error {
            print(error.localizedDescription)
            return
        }
        print("User signed into google 2")
        
        guard let authentication = user.authentication else { return }
        spiner = DataCenter.shared.displsyLoadingIndicator(onView: self.view)
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        print(credential)
        
        // AddUserInfo뷰 이동전에 딜레이 부분을 위해 체크를 해주는데 메인큐에서 할경우 AddUserInfo뷰에서 사용할필요가있다.
        //        if let _ = spiner {
        //            spiner = DataCenter.shared.displsyLoadingIndicator(onView: self.view)
        //
        //        }
        
        // Auth 에 사용자 등록 및 Database에 데이터 저장- 데이터베이스 저장은 추가 정보 입력후 저장되도록
        Auth.auth().signIn(with: credential) {[unowned self] (user, error) in
            
            print("User Signed Into Firebase")
            self.reference = Database.database().reference()
            guard let googleUser = user else{return}
            print("## 구글 uid 확인: ", googleUser.uid)
            UserDefaults.standard.setValue(googleUser.uid, forKey: "userUID")
            
            // 최초 로그인시에만 Firebase데이터에 저장
            // 그렇지않을 경우 Firebase데이터에 저장하지 않고 Auth에만 등록
            
            // UserDefault에 "localGoogleUid" 의 값이 존재 하지 않을 경우(최초로그인)->추가회원가입화면이동
            if UserDefaults.standard.bool(forKey: "localGoogleUID") {
                
            }
            if UserDefaults.standard.string(forKey: "localGoogleUid") == nil {
                // UserDefault에 로그인한 user.uid 정보를 "localGoogleUid" 키 값에 할당 --> #테스트를 위해 주석처리#
                //                UserDefaults.standard.setValue(googleUser.uid, forKey: "localGoogleUid")
                
                
                self.reference.child("user_info").child(googleUser.uid).observeSingleEvent(of: .value, with: { (dataSnapshot) in
                    
                    let snapshot = dataSnapshot.value as? [String:Any]
                    print(snapshot)
                    
                    // 기존에 DataSnapShot이 값이 없을 경우(nil일경우)
                    if(snapshot == nil)
                    {
                        guard let displayName = googleUser.displayName else {return}
                        guard let email = googleUser.email else {return}
                        
                        var userData: [String:Any] = [:]
                        userData.updateValue(displayName, forKey: "user_name")
                        userData.updateValue(email, forKey: "user_email")
                        // 아직 확실한 로그인 상태가 아니므로 데이터를 넒겨준다.
                        //                        self.reference.child("user_profiles").child(googleUser.uid).setValue(userData)
                        
                        // 수정될수있음 구글아이디로 로그인한지 알기 위한 값으로 사용할예정
                        //                        UserDefaults.standard.set(true, forKey: "loginState")
                        print(UserDefaults.standard.bool(forKey: "loginState"))
                        
                        // 테스트를 위해 추가 추후 삭제될수도잇음
                        DataCenter.shared.loginUserData = userData
                        
                        let addUserInfromationView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddUserInformationViewController") as! AddUserInformationViewController
                        addUserInfromationView.user = userData
                        addUserInfromationView.delegate = self
                        addUserInfromationView.delegateToViewController = self
                        
                        let addUserInfoNaviController = UINavigationController(rootViewController: addUserInfromationView)
                        addUserInfoNaviController.navigationBar.isTranslucent = false
                        
                        self.present(addUserInfoNaviController, animated: true, completion: nil)
                        
                    }else{
                        //                        self.dismiss(animated: true, completion: nil)
                        let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
                        let mainHome = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PageControllerBase")
                        let navi = UINavigationController(rootViewController: mainHome)
                        
                        appDelegate.window?.rootViewController? = navi
                        
                    }
                    guard let spinerView = self.spiner else {return}
                    print(spinerView)
                })
                
                //                guard let displayName = googleUser.displayName else {return}
                //                guard let email = googleUser.email else {return}
                //
                //                var userData: [String:Any] = [:]
                //                userData.updateValue(displayName, forKey: "name")
                //                userData.updateValue(email, forKey: "email")
                //
                //                // 테스트를 위해 추가 추후 삭제될수도잇음
                //                DataCenter.shared.loginUserData = userData
                //
                //                let addUserInfromationView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddUserInformationViewController") as! AddUserInformationViewController
                //                addUserInfromationView.user = userData
                //                addUserInfromationView.delegateToViewController = self
                //
                //                let addUserInfoNaviController = UINavigationController(rootViewController: addUserInfromationView)
                //                addUserInfoNaviController.navigationBar.isTranslucent = false
                //
                //                self.present(addUserInfoNaviController, animated: true, completion: nil)
                //
                //
                
                //                self.performSegue(withIdentifier: "AddUserInformationViewController", sender: nil)
                
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
            
            return
        }
//                spiner = DataCenter.shared.displsyLoadingIndicator(onView: self.view)
        
    }
    //사용자에게 Google과 로그인하라는 메시지를 표시하는 뷰
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        print("구글 로그인 버튼 메시지")
        
        
    }
    //"SignintheGooglewithGoogle"보기를 해제합니다.
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        print("구글 로그인 버튼 창 닫기")
                guard let spinerView = spiner else {return}
                print(spinerView)
    }
    
}

extension LoginViewController: ViewDismissProtocol {
    func currentViewDismiss() {
        print("여기는 로그인뷰컨")
        let page = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PageControllerBase") as! PageControllerBaseController
        let nextNavi = UINavigationController(rootViewController: page)
        let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        //        guard let spinerView = spiner else {return}
        //        print(spinerView)
        
        // 루트뷰를 가지 않기 위해 처리
        appDelegate.window?.rootViewController = nextNavi
        //        self.dismiss(animated: false, completion: nil)
        
    }
    
    
}
