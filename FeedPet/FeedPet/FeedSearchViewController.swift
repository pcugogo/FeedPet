//
//  FeedSearchViewController.swift
//  FeedPet
//
//  Created by HwangGisu on 2018. 1. 27..
//  Copyright © 2018년 HwangGisu. All rights reserved.
//

import UIKit

class FeedSearchViewController: UIViewController {
    
    
    private lazy var searchViewController = UISearchController(searchResultsController: nil)
    override func viewDidLoad() {
        super.viewDidLoad()
        let bar = UISearchBar.init()
//        bar.layer.borderColor = UIColor.cyan.cgColor
//        bar.layer.borderWidth = 1
        bar.layer.cornerRadius = 5.0
        
        bar.clipsToBounds = true
        bar.searchBarStyle = .default
        bar.placeholder = "상품명이나 브랜드명을 검색해 주세요."
//        self.navigationItem.titleView = bar
//        self.setSearchControl()
        
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "상품명이나 브랜드명을 검색해 주세요."
        searchController.searchBar.searchBarStyle = .default
        
        let frame = CGRect(x: 0, y: 0, width: 300, height: 30)
        let titleView = UIView(frame: frame)
        searchController.searchBar.backgroundImage = UIImage()
        searchController.searchBar.frame = frame
        titleView.addSubview(searchController.searchBar)
        self.navigationItem.titleView = titleView
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

extension FeedSearchViewController: UISearchBarDelegate {
    
}
