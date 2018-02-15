//
//  FeedSearchResultViewController.swift
//  FeedPet
//
//  Created by HwangGisu on 2018. 1. 29..
//  Copyright © 2018년 HwangGisu. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON

class FeedSearchResultViewController: UIViewController {

    var searchText = ""
    var totalData = [FeedInfo]()
    var searchFeedData = [FeedInfo]()
    var resultFeedData = [FeedInfo]()
    weak var delegate: SelectedCellProtocol?
    @IBOutlet weak var resultTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultTableView.delegate = self
        resultTableView.dataSource = self
        dataLoad()
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
    func dataLoad(){
        let currentKey: String = DataCenter.shared.currentPetKey
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let referenceT = Database.database().reference().child("feed_info").child("feed_petkey_c").queryOrdered(byChild: "feed_name")
        referenceT.observeSingleEvent(of: .value, with: { (dataSnap) in
            guard let dataSnapValue = dataSnap.value else {return}
            let searchFeedData = JSON(dataSnapValue)
            let result = FeedInfoList(feedsJson: searchFeedData)
            print("----totalData result----- ",result)
            self.totalData = result.feed
            DispatchQueue.main.async {
                print("----totalData: ----- ",self.totalData)
                self.resultTableView.reloadData()
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
            }
        }) { (error) in
            print(error)
        }
        
        // Filter the results using a predicate based on the filter string.
//        /let filterPredicate = NSPredicate(format: "self contains[c] %@", argumentArray: [searchText])
//        visibleResults = questionTitleData.filter { filterPredicate.evaluate(with: $0) }
        
        
    }
}
extension FeedSearchResultViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        guard let text = searchBar.text, !text.isEmpty else {return}
        print(text)
    }
   
}
extension FeedSearchResultViewController: UISearchControllerDelegate {}

extension FeedSearchResultViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("요걸로 검색됨 \(searchText)")
        
        searchFeedData = totalData.filter {$0.feedName.contains(searchText)||$0.feedBrand.contains(searchText)}
        self.resultTableView.reloadData()
        
//        let searchDataSource = totalData.filter { predicate.evaluate(with: $0) }
//        print("------검색 한 결과:-----", searchDataSource)

        //이게 빈칸이면, 저장됐던 검색어가 뜬다
//        let reference = Database.database().reference().child("feed_info").child("feed_petkey_c").queryOrdered(byChild: "feed_name").queryStarting(atValue: searchText).queryEnding(atValue: "\(searchText)\u{f8ff}")
//
//        reference.observe(.value, with: { (snap) in
////            if snap.hasChildren(){
////                print(snap.value)
////                print(snap.childrenCount)
////
////            }else{
////                print("no-data")
////            }
//            guard let dataSnapValue = snap.value else {return}
//            let searchFeedData = JSON(dataSnapValue)
//            let result = FeedInfoList(feedsJson: searchFeedData)
//            print("----SearchResult----- ",result)
//            self.resultFeedData = result.feed
//            DispatchQueue.main.async {
//                print("----resultFeedData: ----- ",self.resultFeedData)
//                self.resultTableView.reloadData()
//            }
//
//
//        }) { (error) in
//            print(error)
//        }
        
    }
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        print("gjgjgjgj")
    }
    func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
        print("클릭")
    }
    
}

extension FeedSearchResultViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("----searchFeedData count: ------",searchFeedData.count)
        return searchFeedData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedSearchResultCell", for: indexPath)
        cell.textLabel?.text = searchFeedData[indexPath.row].feedName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(searchFeedData[indexPath.row].feedKey,"/",searchFeedData[indexPath.row].feedName,"/",searchFeedData[indexPath.row].feedBrand)
        let selectFeedKey = searchFeedData[indexPath.row].feedKey
        let feedDetailView = self.storyboard?.instantiateViewController(withIdentifier: "FeedDetailView") as! FeedDetailViewController
        feedDetailView.feedDetailInfo = searchFeedData[indexPath.row]
        DataCenter.shared.feedDetailIngredientDataLoad(feedKey: searchFeedData[indexPath.row].feedKey) { (feedDetailIngredientData) in
            print(feedDetailIngredientData)
            feedDetailView.ingredientData = feedDetailIngredientData
            DispatchQueue.main.async {
                 self.delegate?.didSelectedCell(view: feedDetailView)
            }
        }
//       delegate?.didSelectedCell(view: feedDetailView)
        
        
//        present(feedDetailView, animated: false, completion: nil)
//        self.navigationController?.pushViewController(feedDetailView, animated: true)
    }
    
    
}

//SearchBar 검색결과 선택시 navigation push 하기 위한 프로토콜
protocol SelectedCellProtocol: class {
    // 선택시 사료 상세 정보를 담은 뷰를 파라미터로 준다.
    func didSelectedCell(view: FeedDetailViewController)
}


