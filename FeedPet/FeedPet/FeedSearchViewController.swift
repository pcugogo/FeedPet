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
    var searchController : UISearchController!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bar = UISearchBar(frame: CGRect(x: 0, y: 20, width: UIScreen.main.bounds.width, height: 44))
//        bar.searchBarStyle = .minimal
//        let bar = UISearchBar.init()
//        bar.layer.borderColor = UIColor.cyan.cgColor
//        bar.layer.borderWidth = 1
        bar.delegate = self
        bar.layer.cornerRadius = 5.0
        bar.clipsToBounds = true
        bar.searchBarStyle = .default
        
        
        bar.placeholder = "상품명이나 브랜드명을 검색해 주세요."
        
       
        self.navigationItem.titleView = bar
        
//        self.setSearchControl()

        

 
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

    private func setSearchControl() {
        
//        searchViewController.searchResultsUpdater = self
        searchViewController.obscuresBackgroundDuringPresentation = false
//        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.prefersLargeTitles = true
        searchViewController.searchBar.sizeToFit()
        searchViewController.hidesNavigationBarDuringPresentation = true
        // 검색중 기본 내용들이 흐리게 표시되게 해주는 녀석.
        searchViewController.dimsBackgroundDuringPresentation = false
        searchViewController.searchBar.searchBarStyle = UISearchBarStyle.default
        
        // Place Holder 설정
        let mutableString = NSMutableAttributedString(string: " 여행을 검색하세요! ")
//        mutableString.addAttribute(NSAttributedStringKey.foregroundColor,
//                                   value: UIColor.colorConcept,
//                                   range: NSRange(location: 0,
//                                                  length: 4))
        
        searchViewController.accessibilityAttributedHint = mutableString
        // SearchBar PlaceHolder
//        let searchTextField: UITextField? = searchViewController.searchBar.value(forKey: "searchField") as? UITextField
//        searchTextField?.attributedPlaceholder = mutableString
        
        // cancel button Color 변경
        searchViewController.searchBar.tintColor = UIColor.init(hexString: "#FF6600")
        searchViewController.searchBar.barTintColor = UIColor.white
        
    }
}
extension FeedSearchViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let resultCell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath)
        
        return resultCell
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
        print("요걸로 검색됨 \(searchText)")
        //이게 빈칸이면, 저장됐던 검색어가 뜬다
        let reference = Database.database().reference().child("feed_info").child("feed_petkey_c").queryOrdered(byChild: "feed_name").queryStarting(atValue: searchText).queryEnding(atValue: "\(searchText)\u{f8ff}")
        
        reference.observe(.value, with: { (snap) in
            if snap.hasChildren(){
                print(snap.value)
                print(snap.childrenCount)
            }else{
                    print("no-data")
            }
        }) { (error) in
            print(error)
        }
    
    }
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        print("gjgjgjgj")
    }
        
}
