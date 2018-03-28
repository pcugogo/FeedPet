//
//  FeedSearchViewController.swift
//  FeedPet
//
//  Created by HwangGisu on 2018. 1. 27..
//  Copyright © 2018년 HwangGisu. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON

class FeedSearchViewController: UIViewController {
    @IBOutlet weak var searchResultTableView: UITableView!
//    let searchController = UISearchController(searchResultsController: nil)
    var searchViewController = UISearchController(searchResultsController: nil)
    var searchController = UISearchController(searchResultsController: nil)
    var searchBar: UISearchBar!
    
    var totalData = [FeedInfo]()
    var searchFeedData = [FeedInfo]()
    var resultFeedData = [FeedInfo]()
    var userUID: String = String()
    var feedBookMarkDic: [String:Bool] = [:]
    override func viewDidLoad() {
        super.viewDidLoad()
        searchResultTableView.dataSource = self
        searchResultTableView.delegate = self
        dataLoad()
        //setupSearchBar()
        setSearchControl()
        /*
        UIBarButtonItem.appearance(whenContainedInInstancesOf:[UISearchBar.self]).tintColor = UIColor.white
        
        // 검색 결과를 보여줄 FeedSearchResultViewController 할당
//        let searchResultsViewController = storyboard!.instantiateViewController(withIdentifier: "FeedSearchResultView") as! FeedSearchResultViewController
//        // 결과 화면 뷰에 델리게이트를 현재의 뷰가 사용하기 위해 델리게이트 구현
//        searchResultsViewController.delegate = self
        
        // 검색하기위한 컨트롤러 할당 및 셋팅
//        searchController = UISearchController(searchResultsController: searchResultsViewController)
        searchViewController.searchResultsUpdater = self
        searchViewController.hidesNavigationBarDuringPresentation = false
        searchViewController.dimsBackgroundDuringPresentation = true
        searchViewController.searchBar.barTintColor = UIColor.init(hexString: "#FF6600")
        searchViewController.searchBar.isTranslucent = false
        print(DataCenter.shared.currentPetKey)
//        if DataCenter.shared.currentPetKey == "feed_petkey_d"{
//            searchController.searchBar.placeholder = "강아지사료 상품명이나 브랜드명을 검색해주세요."
//        }else{
//            searchController.searchBar.placeholder = "고양이사료 상품명이나 브랜드명을 검색해주세요."
//        }
        self.definesPresentationContext = true
        //        self.searchController.delegate = searchResultsViewController
        searchViewController.searchBar.delegate = self
        searchViewController.searchBar.placeholder = "tet"
        searchViewController.searchBar.searchFieldBackgroundPositionAdjustment = UIOffset(horizontal: 0, vertical: 2)
        searchViewController.searchBar.layer.borderWidth = 0
        searchViewController.delegate = self
        
        searchViewController.obscuresBackgroundDuringPresentation = false
        //        navigationItem.searchController = searchController
        searchViewController.isActive = true
        
        // SearchBar 내부 Textfiled fontsize 조정
        let textFieldInsideUISearchBar =  searchViewController.searchBar.value(forKey: "searchField") as? UITextField
        let placeholderLabel = textFieldInsideUISearchBar?.value(forKey: "placeholderLabel") as? UILabel
        placeholderLabel?.font = UIFont.systemFont(ofSize: 12.0)
//        self.setSearchControl()

        */

 
        // 테스트 1
//        self.searchController = UISearchController(searchResultsController:  nil)
//        searchController.searchResultsUpdater = self
//        searchController.delegate = self
//        searchController.searchBar.delegate = self
//
//        // 검색시 서치바 부분을 숨김 여부에 대한 값
//        searchController.hidesNavigationBarDuringPresentation = false
//
//        // 검색 중 기본내용 흐리게 표시되는지 여부에 대한 값
//        searchController.dimsBackgroundDuringPresentation = false
//
//
//        searchController.searchBar.placeholder = "상품명이나 브랜드명을 검색해 주세요."
//        searchController.searchBar.searchBarStyle = .default
//
//        let frame = CGRect(x: 0, y: 0, width: 300, height: 30)
//        let titleView = UIView(frame: frame)
//
//        searchController.searchBar.frame = frame
//        titleView.addSubview(searchController.searchBar)
//        self.navigationItem.titleView = titleView
        
        
 
 
        
        
        
  /*
        let searchController = UISearchController(searchResultsController: nil)
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Candies"
        searchController.searchBar.delegate = self
        searchController.delegate = self
        navigationItem.searchController = searchController
//        navigationItem.titleView = searchViewController.searchBar
        definesPresentationContext = true
   
   */
        
        
        // Setup the Scope Bar
//        searchController.searchBar.scopeButtonTitles = ["All", "Chocolate", "Hard", "Other"]
//        searchController.searchBar.delegate = self
//        navigationItem.titleView = searchController.searchBar
//        self.searchDisplayController?.displaysSearchBarInNavigationBar = true
        // Setup the search footer
//        tableView.tableFooterView = searchFooter
        
        // Do any additional setup after loading the view.
        
          // 테스트 2
//        self.searchController = UISearchController(searchResultsController:  nil)
//
//        self.searchController.searchResultsUpdater = self
//        self.searchController.delegate = self
//        self.searchController.searchBar.delegate = self
//
//        self.searchController.hidesNavigationBarDuringPresentation = false
//        self.searchController.dimsBackgroundDuringPresentation = true
//
//        let frame = CGRect(x: 0, y: -10, width: 300, height: 30)
//        let titleview = UIView(frame: frame)
//        titleview.addSubview(searchController.searchBar)
//
//        searchController.searchBar.frame = frame
//
//        self.navigationItem.titleView = titleview//searchController.searchBar
//
//        self.definesPresentationContext = true
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
   
    @IBAction func cancelBtnTouched(_ sender: UIBarButtonItem){
        self.dismiss(animated: true, completion: nil)
    }
    func dataLoad(){
        let currentKey: String = DataCenter.shared.currentPetKey
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let referenceT = Database.database().reference().child("feed_info").child(currentKey).queryOrdered(byChild: "feed_name")
        referenceT.observeSingleEvent(of: .value, with: { (dataSnap) in
            guard let dataSnapValue = dataSnap.value else {return}
            let searchFeedData = JSON(dataSnapValue)
            let result = FeedInfoList(feedsJson: searchFeedData)
            print("----totalData result----- ",result)
            self.totalData = result.feed
            DispatchQueue.main.async {
                print("----totalData: ----- ",self.totalData)
                self.searchResultTableView.reloadData()
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
            }
        }) { (error) in
            print(error)
        }
        guard let uid = Auth.auth().currentUser?.uid else{ return }
        userUID = uid
        // Filter the results using a predicate based on the filter string.
        //        /let filterPredicate = NSPredicate(format: "self contains[c] %@", argumentArray: [searchText])
        //        visibleResults = questionTitleData.filter { filterPredicate.evaluate(with: $0) }
        
        
    }
    func setupSearchBar(){
        searchBar = UISearchBar()
        //        bar.searchBarStyle = .minimal
        //        let bar = UISearchBar.init()
        //        bar.layer.borderColor = UIColor.cyan.cgColor
        //        bar.layer.borderWidth = 1
        searchBar.delegate = self
        searchBar.layer.cornerRadius = 5.0
        searchBar.clipsToBounds = true
        searchBar.searchBarStyle = .default
        
        
        searchBar.placeholder = "상품명이나 브랜드명을 검색해 주세요."
        
        let textFieldInsideUISearchBar =  searchBar.value(forKey: "searchField") as? UITextField
        let placeholderLabel = textFieldInsideUISearchBar?.value(forKey: "placeholderLabel") as? UILabel
        placeholderLabel?.font = UIFont.systemFont(ofSize: 12.0)
        textFieldInsideUISearchBar?.font = UIFont.systemFont(ofSize: 12.0)
        
        
//        self.navigationController?.navigationItem.titleView = searchBar
        self.navigationItem.titleView = searchBar

    }
    private func setSearchControl() {
        // Setup the Search Controller
//        searchController.searchResultsUpdater = self
//        searchController.obscuresBackgroundDuringPresentation = false
//        searchController.searchBar.placeholder = "Search Candies"
//        navigationItem.searchController = searchController
//        definesPresentationContext = true
//
//        // Setup the Scope Bar
//        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
//        searchController.searchBar.barTintColor = UIColor.init(hexString: "#FF6600")
//        searchController.searchBar.layer.borderColor = UIColor.init(hexString: "#FF6600").cgColor
//        searchController.searchBar.layer.borderWidth = 1
        
    
        searchController.searchBar.delegate = self
        let customSearchBar = searchController.searchBar
        customSearchBar.tintColor = UIColor.white
        customSearchBar.barTintColor = UIColor.white
//        searchBar.layer.cornerRadius = 5.0
//        searchBar.clipsToBounds = true
//        searchBar.searchBarStyle = .default
        let textFieldInsideUISearchBar =  searchController.searchBar.value(forKey: "searchField") as? UITextField
        let placeholderLabel = textFieldInsideUISearchBar?.value(forKey: "placeholderLabel") as? UILabel
        placeholderLabel?.font = UIFont(name: "GodoM", size: 12)
//        placeholderLabel?.textColor = .orange
        textFieldInsideUISearchBar?.font = UIFont(name: "GodoM", size: 12)
//        let clearButton = textFieldInsideUISearchBar?.value(forKey: "clearButton") as? UIButton
//
//        clearButton?.tintColor = .white
        searchController.searchBar.barStyle = .default
        
        
        print(DataCenter.shared.currentPetKey)
        if DataCenter.shared.currentPetKey == "feed_petkey_d"{
            searchController.searchBar.placeholder = "강아지사료 상품명이나 브랜드명을 검색해주세요."
        }else{
            searchController.searchBar.placeholder = "고양이사료 상품명이나 브랜드명을 검색해주세요."
        }
        
        

    
        
        
       
        if #available(iOS 11.0, *) {
            searchController.searchBar.searchBarStyle = .minimal
            // searchFiled 부분의 배경색을 커스텀하기위한 코드
            if let textfield = searchController.searchBar.value(forKey: "searchField") as? UITextField {
                if let backgroundview = textfield.subviews.first {
                    
                    // Background color
                    backgroundview.backgroundColor = UIColor.white
                    
                    // Rounded corner
                    backgroundview.layer.cornerRadius = 10
                    backgroundview.clipsToBounds = true
                }
            }
            navigationItem.searchController = searchController
            //스크롤시 서치바를 표시할지 선택값. 기본값 true
            navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            // Fallback on earlier versions
//            searchController.searchBar.layer.borderColor = UIColor.init(hexString: "#FF6600").cgColor
//            searchController.searchBar.layer.borderWidth = 0
//            searchController.searchBar.tintColor =  UIColor.init(hexString: "#FF6600")
            searchController.searchBar.barTintColor =  UIColor.init(hexString: "#FF6600")
//            searchResultTableView.tableHeaderView?.backgroundColor = UIColor.init(hexString: "#FF6600")
//            searchResultTableView.tableHeaderView?.tintColor = UIColor.init(hexString: "#FF6600")
            searchResultTableView.tableHeaderView = searchController.searchBar
            
            
        }
        

        // Header 뷰에서 사용시
        //        searchResultTableView.tableHeaderView = customSearchBar
        


    }
    
}
extension FeedSearchViewController: UITableViewDelegate, UITableViewDataSource{
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(searchFeedData.count)
        return searchFeedData.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let resultCell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath)
        resultCell.textLabel?.font = UIFont(name: "GodoM", size:17)
        resultCell.textLabel?.text = searchFeedData[indexPath.row].feedName
        
        
        // 내 즐겨찾기 정보 상태 전달을위해 feedBookMarkDic 정보에 값 저장
        //            self.feedBookMarkDic.updateValue(isBookMark, forKey: self.feedFilteringTotalData[indexPath.row].feedKey)
    Database.database().reference().child("my_favorite").child(userUID).childByAutoId().child(searchFeedData[indexPath.row].feedKey).observeSingleEvent(of: .value, with: { (dataSnap) in
        var isBookMark: Bool = false
        if dataSnap.hasChildren() {
            isBookMark = true
        }
        self.feedBookMarkDic.updateValue(isBookMark, forKey: self.searchFeedData[indexPath.row].feedKey)
        })
        
        return resultCell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(searchFeedData[indexPath.row].feedKey,"/",searchFeedData[indexPath.row].feedName,"/",searchFeedData[indexPath.row].feedBrand)
        let selectFeedKey = searchFeedData[indexPath.row].feedKey
        let feedDetailView = self.storyboard?.instantiateViewController(withIdentifier: "FeedDetailView") as! FeedDetailViewController
        feedDetailView.feedDetailInfo = searchFeedData[indexPath.row]
        feedDetailView.isBookMark = feedBookMarkDic[searchFeedData[indexPath.row].feedKey] ?? false
        
        DataCenter.shared.feedDetailIngredientDataLoad(feedKey: searchFeedData[indexPath.row].feedKey) { (feedDetailIngredientData) in
            print(feedDetailIngredientData)
            feedDetailView.ingredientData = feedDetailIngredientData
//            DispatchQueue.main.async {
                //self.delegate?.didSelectedCell(view: feedDetailView)
//            print(self.navigationController)
            
//            }
            DispatchQueue.main.async {
                
                self.navigationController?.pushViewController(feedDetailView, animated: true)
                
                //                self.delegate?.loadingRemoveDisplay()
            }
        }
        
//        Database.database().reference().child("feed_review").child(searchFeedData[indexPath.row].feedKey).observeSingleEvent(of: .value, with: { (dataSnap) in
//            // 1. 리뷰의 갯수가 필요하
//            //            print(feedDataInfo.feedKey)
//            guard let data = dataSnap.value else {return}
//            
//            let oneReviewData = FeedReview(feedReviewJSON: JSON(data), feedKey: dataSnap.key)
//            feedDetailView.reviewInfo = oneReviewData
//            print("리뷰하나의정보://",oneReviewData)
//            
//            DispatchQueue.main.async {
//                
//                self.navigationController?.pushViewController(feedDetailView, animated: true)
//                
////                self.delegate?.loadingRemoveDisplay()
//            }
//        }) { (error) in
//            print(error.localizedDescription)
//        }
        //       delegate?.didSelectedCell(view: feedDetailView)
        
        
        //        present(feedDetailView, animated: false, completion: nil)
        //        self.navigationController?.pushViewController(feedDetailView, animated: true)
    }
    
}

extension FeedSearchViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        guard let text = searchBar.text, !text.isEmpty else {return}
        print(text)
    }
    
    
}


extension FeedSearchViewController: UISearchControllerDelegate {}

extension FeedSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        print("요걸로 검색됨 \(searchText)")
//        //이게 빈칸이면, 저장됐던 검색어가 뜬다
//        let reference = Database.database().reference().child("feed_info").child("feed_petkey_c").queryOrdered(byChild: "feed_name").queryStarting(atValue: searchText).queryEnding(atValue: "\(searchText)\u{f8ff}")
//
//        reference.observe(.value, with: { (snap) in
//            if snap.hasChildren(){
//                print(snap.value)
//                print(snap.childrenCount)
//            }else{
//                    print("no-data")
//            }
//        }) { (error) in
//            print(error)
//        }

        print("요걸로 검색됨 \(searchText)")
        
        searchFeedData = totalData.filter {$0.feedName.contains(searchText)||$0.feedBrand.contains(searchText)}
        print("써치://",searchFeedData,"//",totalData)
        self.searchResultTableView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        print("gjgjgjgj")
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchFeedData = []
        self.searchResultTableView.reloadData()
    }
        
}
