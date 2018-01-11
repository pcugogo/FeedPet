//
//  AppDelegate.swift
//  FeedPet
//
//  Created by HwangGisu on 2017. 12. 21..
//  Copyright © 2017년 HwangGisu. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // 네비게이션 컨트롤러
        let navigationBarAppearance = UINavigationBar.appearance()

        navigationBarAppearance.barTintColor = UIColor.init(hexString: "#FF6600")
        navigationBarAppearance.tintColor = .white
        navigationBarAppearance.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]

        let _ = PageControllerBaseController(nibName: nil, bundle: nil)
        // Firebase 초기화 코드
        FirebaseApp.configure()
        
        // Google 소셜로그인-Firebase 연동 초기화 코드
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        //        GIDSignIn.sharedInstance().delegate = self
        
        // Facebook 소셜로그인-Firebase 연동 초기화 코드
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        // #삭제예정-로그인상태체크 위한코드
        /*
         DataCenter.shared.singOut()
         
         // 테스트 위해 주석처리 : 추가회원가입정보 뷰
         // 로그인 여부 판단
         // 비로그인시
         self.window = UIWindow(frame: UIScreen.main.bounds)
         let storyboard = UIStoryboard(name: "Main", bundle: nil)
         
         if !DataCenter.shared.requestIsLogin(){
         print("로그인 안됫을때")
         
         // 현재 디바이스의 스크린사이즈의 크기를 가져와서 윈도우 프레임 설졍
         
         let LoginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
         let navigationController = UINavigationController(rootViewController: LoginViewController)
         self.window?.rootViewController = navigationController
         }else{
         let pageController = storyboard.instantiateViewController(withIdentifier: "pageController")
         let navigationController = UINavigationController(rootViewController: pageController)
         
         self.window?.rootViewController = navigationController
         }
         self.window?.makeKeyAndVisible()
         */
        
        // Status bar 부분의 색변경을 위한 코드-UIApplication을 extension하여 코드 구현
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.init(hexString: "#FF6600")
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    // MARK: URL 지정 리소스 열기
    // 이 메소드는 GIDSignIn 인스턴스의 handleURL 메소드를 호출하며 이 메소드는 애플리케이션이 인증 절차가 끝나고 받는 URL를 적절히 처리합니다.
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let googleHandled = GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String, annotation: [:])
        let facebookHandled = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
        
        return googleHandled || facebookHandled
    }
    
    // MARK: ## GIDSignInDelegate 메서드
    // 로그인 프로세스 델리게이트 메서드-구글 로그인시 호출
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        print("Appdelegate SignIn Button")
    }
}
// 좋지 못한 코드인것 같다..좀더찾아보자.
extension UIApplication {
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}
