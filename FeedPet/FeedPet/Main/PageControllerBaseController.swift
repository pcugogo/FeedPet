//
//  PageControllerBaseController.swift
//  FeedPet
//
//  Created by HwangGisu on 2017. 12. 22..
//  Copyright © 2017년 HwangGisu. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Firebase

class PageControllerBaseController: BaseButtonBarPagerTabStripViewController<MainMenuIconCollectionViewCell> {
    
    let redColor = UIColor(red: 221/255.0, green: 0/255.0, blue: 19/255.0, alpha: 1.0)
    let unselectedIconColor = UIColor(red: 73/255.0, green: 8/255.0, blue: 10/255.0, alpha: 1.0)
    var searchController: UISearchController!
    // 아이콘 선택 변화시 체크를 위한 옵저버 프로퍼티
    var indicatorTitle: String = ""{
        didSet{
            currentPetCheck()
        }
    }
    var curretPetKey = String()
    var spinerView = UIView()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        buttonBarItemSpec = ButtonBarItemSpec.nibFile(nibName: "MainMenuIconCollectionViewCell", bundle: Bundle(for: MainMenuIconCollectionViewCell.self), width: { _ in
            return 55.0
        })
        
        
        
    }
    
    override func viewDidLoad() {
//        let backgroundView = UIView(frame: self.view.frame)
//        backgroundView.backgroundColor = UIColor.init(hexString: "#FF6600")
//        self.view.addSubview(backgroundView)
        
        
            
//            let LoginViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            //            let navigation = UINavigationController(rootViewController: LoginViewController)
            
            //            self.present(LoginViewController, animated: true, completion: nil)
            //            self.navigationController?.pushViewController(LoginViewController, animated: true)
        
            
//            self.navigationController?.present(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainTest") as! MainViewController, animated: false, completion: {
//                
//            })
            
           
        
        
        
        //
        //        if !DataCenter.shared.requestIsLogin(){
        //            let LoginViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController")
        //            //            let navigation = UINavigationController(rootViewController: LoginViewController)
        //
        //            //            self.present(LoginViewController, animated: true, completion: nil)
        //            //            self.navigationController?.pushViewController(LoginViewController, animated: true)
        //            self.navigationController?.present(LoginViewController, animated: false, completion: {
        //
        //
//            })
//
//        }
        // change selected bar color
//        settings.style.buttonBarBackgroundColor = UIColor(red: 255/255.0, green: 102/255.0, blue: 0/255.0, alpha: 1.0)
//        settings.style.buttonBarItemBackgroundColor = .clear
        
        // 셀렉트 바 색
//        settings.style.selectedBarBackgroundColor = UIColor(red: 234/255.0, green: 234/255.0, blue: 234/255.0, alpha: 1.0)
      
            
       
        // 하단의 셀레트 바 높이
        settings.style.selectedBarHeight = 0.0
//        settings.style.buttonBarMinimumLineSpacing = 0
//        settings.style.buttonBarItemTitleColor = .black
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        
//        settings.style.buttonBarLeftContentInset = 0
//        settings.style.buttonBarRightContentInset = 0
//
        // Icon 선택 변화시 이루어질 클로져
       changeCurrentIndexProgressive = { [weak self] (oldCell: MainMenuIconCollectionViewCell?, newCell: MainMenuIconCollectionViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
//            oldCell?.menuIconImg.tintColor = self?.unselectedIconColor
//
//            newCell?.menuIconImg.tintColor = .white
            
            if oldCell?.title == "멍" {
                oldCell?.menuIconImg.image = #imageLiteral(resourceName: "dogDisableImg")
                newCell?.menuIconImg.image = #imageLiteral(resourceName: "catAbleImg")
                self?.indicatorTitle = "냥"
            }else{
                oldCell?.menuIconImg.image = #imageLiteral(resourceName: "catDisableImg")
                newCell?.menuIconImg.image = #imageLiteral(resourceName: "dogAbleImg")
                self?.indicatorTitle = "멍"
            }
        }
        super.viewDidLoad()
        
        // XLPagerTabStrip의 탭바 설정입니다.
        // [주의!] 스토리보드의 설정들은 먹히지 않습니다.
//        let mySelectedColor = UIColor.blue
//        let myBackgroundColor = UIColor.init(hexString: "#FF6600")
//        buttonBarView.selectedBar.backgroundColor = mySelectedColor
//        buttonBarView.backgroundColor = myBackgroundColor
//        settings.style.buttonBarItemBackgroundColor = myBackgroundColor
        
        //테스트 위한 로그아웃 호출
        
//        navigationController?.navigationBar.shadowImage = UIImage()
//        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        // 로그인 여부 체크 - 비로그인시 로그인화면으로 이동
//        if !DataCenter.shared.requestIsLogin(){
//            print("로그인 안됫을때")
//            DispatchQueue.main.async {
//                self.showLoginViewController()
//            }
//        }
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//                self.navigationController?.isNavigationBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//                self.navigationController?.isNavigationBarHidden = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - PagerTabStripDataSource
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
//        let child_1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DogMainViewController") as! DogMainViewController
        
//        let child_2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CatMainViewController") as! CatMainViewController
        let child_1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainPageViewController") as! MainPageViewController
        child_1.indicatorTitle = "멍"
        child_1.delegate = self
        
        let child_2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainPageViewController") as! MainPageViewController
        child_2.indicatorTitle = "냥"
        child_2.delegate = self
        
        return [child_1, child_2]
    }
    
    override func configure(cell: MainMenuIconCollectionViewCell, for indicatorInfo: IndicatorInfo) {
        cell.menuIconImg.image = indicatorInfo.image?.withRenderingMode(.alwaysTemplate)
//        cell.menuIconLabel.text = indicatorInfo.title
        
        cell.title = indicatorInfo.title!
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func mypageShow(_ sender: UIBarButtonItem){
        let nextViewController = UIStoryboard.init(name: "MyPage", bundle: nil).instantiateViewController(withIdentifier: "MyPageViewController") as! MyPageViewController
        
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    @IBAction func feedSearchBtnTouched(_ sender: UIButton) {
        let nextViewContorller = self.storyboard?.instantiateViewController(withIdentifier: "FeedSearchViewController") as! FeedSearchViewController
        let searchNavigationController = UINavigationController(rootViewController: nextViewContorller)
        searchNavigationController.navigationBar.isTranslucent = false
//        self.present(nextViewContorller, animated: true, completion: nil)
        self.navigationController?.present(searchNavigationController, animated: true, completion: nil)
//        self.navigationController?.pushViewController(nextViewContorller, animated: true)
        
        
        /*
        UIBarButtonItem.appearance(whenContainedInInstancesOf:[UISearchBar.self]).tintColor = UIColor(red: 255, green: 0, blue: 0, alpha: 1)
        
        // 검색 결과를 보여줄 FeedSearchResultViewController 할당
        let searchResultsViewController = storyboard!.instantiateViewController(withIdentifier: "FeedSearchResultView") as! FeedSearchResultViewController
        // 결과 화면 뷰에 델리게이트를 현재의 뷰가 사용하기 위해 델리게이트 구현
        searchResultsViewController.delegate = self
        
        searchController = UISearchController(searchResultsController: searchResultsViewController)
        //        searchController.searchResultsUpdater = searchResultsController
        searchController.hidesNavigationBarDuringPresentation = false
        //        searchResultsController.isSearchBarClicked = true
        
        searchController.searchResultsUpdater = searchResultsViewController
        searchController.dimsBackgroundDuringPresentation = true
        searchController.searchBar.barTintColor = UIColor.init(hexString: "#FF6600")
        searchController.searchBar.isTranslucent = false
        
        print(DataCenter.shared.currentPetKey)
        if DataCenter.shared.currentPetKey == "feed_petkey_d"{
            searchController.searchBar.placeholder = "강아지사료 상품명이나 브랜드명을 검색해주세요."
        }else{
            searchController.searchBar.placeholder = "고양이사료 상품명이나 브랜드명을 검색해주세요."
        }
//        self.definesPresentationContext = true
        searchController.searchBar.delegate = searchResultsViewController
        searchController.searchBar.searchFieldBackgroundPositionAdjustment = UIOffset(horizontal: 0, vertical: 2)
        searchController.searchBar.layer.borderWidth = 0
        
        
//        searchController.obscuresBackgroundDuringPresentation = false
        //        navigationItem.searchController = searchController
        searchController.isActive = true
        
        // SearchBar 내부 Textfiled fontsize 조정
        let textFieldInsideUISearchBar =  searchController.searchBar.value(forKey: "searchField") as? UITextField
        let placeholderLabel = textFieldInsideUISearchBar?.value(forKey: "placeholderLabel") as? UILabel
        placeholderLabel?.font = UIFont.systemFont(ofSize: 12.0)
        
        present(searchController, animated: true, completion: nil)
//        self.navigationController?.present(searchController, animated: true, completion: nil)
        
        self.searchController.delegate = self
 
 */
        /*
        UIBarButtonItem.appearance(whenContainedInInstancesOf:[UISearchBar.self]).tintColor = UIColor.white
        
        // 검색 결과를 보여줄 FeedSearchResultViewController 할당
        let searchResultsViewController = storyboard!.instantiateViewController(withIdentifier: "FeedSearchResultView") as! FeedSearchResultViewController
        // 결과 화면 뷰에 델리게이트를 현재의 뷰가 사용하기 위해 델리게이트 구현
        searchResultsViewController.delegate = self
        
        // 검색하기위한 컨트롤러 할당 및 셋팅
        searchController = UISearchController(searchResultsController: searchResultsViewController)
        searchController.searchResultsUpdater = searchResultsViewController
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = true
        searchController.searchBar.barTintColor = UIColor.init(hexString: "#FF6600")
        searchController.searchBar.isTranslucent = false
        print(DataCenter.shared.currentPetKey)
        if DataCenter.shared.currentPetKey == "feed_petkey_d"{
            searchController.searchBar.placeholder = "강아지사료 상품명이나 브랜드명을 검색해주세요."
        }else{
            searchController.searchBar.placeholder = "고양이사료 상품명이나 브랜드명을 검색해주세요."
        }
        self.definesPresentationContext = true
        //        self.searchController.delegate = searchResultsViewController
        searchController.searchBar.delegate = searchResultsViewController
        searchController.searchBar.searchFieldBackgroundPositionAdjustment = UIOffset(horizontal: 0, vertical: 2)
        searchController.searchBar.layer.borderWidth = 0
        
        
        searchController.obscuresBackgroundDuringPresentation = false
//        navigationItem.searchController = searchController
        searchController.isActive = true
        
        // SearchBar 내부 Textfiled fontsize 조정
        let textFieldInsideUISearchBar =  searchController.searchBar.value(forKey: "searchField") as? UITextField
        let placeholderLabel = textFieldInsideUISearchBar?.value(forKey: "placeholderLabel") as? UILabel
        placeholderLabel?.font = UIFont.systemFont(ofSize: 12.0)
        // 구현한  SearchController를 화면에 띄어주기위해 present 호출
        present(searchController, animated: true, completion: nil)
        self.searchController.delegate = self
        */
        
    }
   
    // LoginView로 이동
    func showLoginViewController(){
        let nextViewContorller = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//        self.present(nextViewContorller, animated: true, completion: nil)
        self.navigationController?.pushViewController(nextViewContorller, animated: true)
    }
    /*******************************************/
    //MARK:-         Class Method              //
    /*******************************************/
    // MARK: 현재 반려동물 체크 메서드
    func currentPetCheck(){
        if indicatorTitle == "멍" {
            curretPetKey = "feed_petkey_d"
            DataCenter.shared.currentPetKey = curretPetKey
        }else{
            curretPetKey = "feed_petkey_c"
            DataCenter.shared.currentPetKey = curretPetKey
        }
        
    }
}

extension PageControllerBaseController: UISearchControllerDelegate{
    // 검색 컨트롤러가 자동으로 닫힐 때 호출
    @nonobjc func willDismissSearchController(_ searchController: UISearchController) {
        print("검색 컨트롤러 자동닫힘")
    }


}
extension PageControllerBaseController: SelectedCellProtocol{
    func didSelectedCell(view: FeedDetailViewController) {
        self.navigationController?.pushViewController(view, animated: true)
    }
}

extension PageControllerBaseController: LoadingIndicatorProtocol{
    
    func loadingIndicatorDisplay() {
        spinerView = DataCenter.shared.displsyLoadingIndicator(onView: self.view)
    }
    
    func loadingRemoveDisplay() {
        DataCenter.shared.removeSpinner(spinner: spinerView)
    }
    
    
}
