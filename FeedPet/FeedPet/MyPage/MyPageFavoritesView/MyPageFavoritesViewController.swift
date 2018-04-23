//
//  MyPageFavoritesViewController.swift
//  FeedPet
//
//  Created by ChanWook Park on 2018. 1. 15..
//  Copyright © 2018년 HwangGisu. All rights reserved.
//

import UIKit
import Firebase

class MyPageFavoritesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,MyPageFeedContentsCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var userUID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let useruid = Auth.auth().currentUser?.uid else {return}
        self.userUID = useruid
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
//        if MyPageDataCenter.shared.favorites.isEmpty{
//            tableView.isHidden = true
//        }else{
//            tableView.isHidden = false
//        }
//
//        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if MyPageDataCenter.shared.favorites.isEmpty{
//            return ""
//        }else{
//            return "총 \(MyPageDataCenter.shared.favoritesCount)개 상품"
//        }
//        tableView.headerView(forSection: section)?.textLabel?.font = UIFont(name: "GodoM", size: 15)
        return "총 \(MyPageDataCenter.shared.favoritesCount)개 상품"
        
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = UIFont(name: "GodoM", size: 15)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(MyPageDataCenter.shared.favorites.count)
        if MyPageDataCenter.shared.favorites.isEmpty{
            self.tableView.isHidden = true
            return 0
            
        }else{
            self.tableView.isHidden = false
            return MyPageDataCenter.shared.favorites.count
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        
            
        let myPageFeedContentsCell = tableView.dequeueReusableCell(withIdentifier: "MyPageFeedContentsCell", for: indexPath) as! MyPageFeedContentsCell
            
        
        if !MyPageDataCenter.shared.favorites.isEmpty{
            myPageFeedContentsCell.delegate = self
            
            myPageFeedContentsCell.likeBtnOut.tag = indexPath.row
            
            let favorites = MyPageDataCenter.shared.favorites[indexPath.row] //reviews가 옵셔널이 아니므로 옵셔널 바인딩 안된다
            print("==",favorites)
            myPageFeedContentsCell.configureCell(favorites: favorites)
        }
        
            return myPageFeedContentsCell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(MyPageDataCenter.shared.favorites[indexPath.row])
        let selectFeedKey = MyPageDataCenter.shared.favorites[indexPath.row].feedKeyReturn
        let feedDetailView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FeedDetailView") as! FeedDetailViewController
        
        let feedDetailInfo = FeedInfo(myBookMarkData: MyPageDataCenter.shared.favorites[indexPath.row])
        feedDetailView.feedDetailInfo = feedDetailInfo
            
        
        
//        feedDetailView.feedDetailInfo = searchFeedData[indexPath.row]
        
        feedDetailView.delegate = self
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        Database.database().reference().child("my_favorite").child(self.userUID).queryOrdered(byChild: "feed_key").queryEqual(toValue: feedDetailInfo.feedKey).observeSingleEvent(of: .value, with: { (dataSnap) in
            
            print(dataSnap.value)
            var isBookMark: Bool = false
            if dataSnap.hasChildren() {
                isBookMark = true
                
            }
//            self.feedBookMarkDic.updateValue(isBookMark, forKey: self.searchFeedData[indexPath.row].feedKey)
            feedDetailView.isBookMark = isBookMark//self.feedBookMarkDic[self.searchFeedData[indexPath.row].feedKey] ?? false
            DataCenter.shared.feedDetailIngredientDataLoad(feedKey: feedDetailInfo.feedKey) { (feedDetailIngredientData) in
                print(feedDetailIngredientData)
                feedDetailView.ingredientData = feedDetailIngredientData
                //                feedDetailView.feedBookMarkLoadData(userUID: self.userUID, feedKey: self.searchFeedData[indexPath.row].feedKey)
                //            DispatchQueue.main.async {
                //self.delegate?.didSelectedCell(view: feedDetailView)
                //            print(self.navigationController)
                
                //            }
                //            self.navigationController?.pushViewController(feedDetailView, animated: true)
                
                
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    self.navigationController?.pushViewController(feedDetailView, animated: true)
                    
                    //                self.navigationController?.pushViewController(feedDetailView, animated: true)
                    
                    //                self.delegate?.loadingRemoveDisplay()
                }
            }
        })
        
        
        
        //        feedDetailView.isBookMark = self.feedBookMarkDic[self.searchFeedData[indexPath.row].feedKey] ?? false
        //    Database.database().reference().child("my_favorite").child(self.userUID).childByAutoId().child(self.searchFeedData[indexPath.row].feedKey).observeSingleEvent(of: .value, with: { (dataSnap) in
        //            var isBookMark: Bool = false
        //            if dataSnap.hasChildren() {
        //                isBookMark = true
        //
        //            }
        //            self.feedBookMarkDic.updateValue(isBookMark, forKey: self.searchFeedData[indexPath.row].feedKey)
        //            feedDetailView.isBookMark = self.feedBookMarkDic[self.searchFeedData[indexPath.row].feedKey] ?? false
        //        })
        
        /*
        DataCenter.shared.feedDetailIngredientDataLoad(feedKey: searchFeedData[indexPath.row].feedKey) { (feedDetailIngredientData) in
            print(feedDetailIngredientData)
            feedDetailView.ingredientData = feedDetailIngredientData
            feedDetailView.feedBookMarkLoadData(userUID: self.userUID, feedKey: self.searchFeedData[indexPath.row].feedKey)
            //            DispatchQueue.main.async {
            //self.delegate?.didSelectedCell(view: feedDetailView)
            //            print(self.navigationController)
            
            //            }
            //            self.navigationController?.pushViewController(feedDetailView, animated: true)
            
            
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(feedDetailView, animated: true)
                
                //                self.navigationController?.pushViewController(feedDetailView, animated: true)
                
                //                self.delegate?.loadingRemoveDisplay()
            }
        }
        */
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func alertController() {
        let cancelLikeAlert:UIAlertController = UIAlertController(title: "", message: "좋아요를 취소 하시겠습니까?", preferredStyle: .alert)
        
        let okBtn:UIAlertAction = UIAlertAction(title: "네", style: .default){ (action) in
            
            if let index = MyPageDataCenter.shared.myPageFeedContentsCellLikeBtnTagValue {
                print("index",index)

                let removeFavoriteKey = MyPageDataCenter.shared.favorites[index]
               UIApplication.shared.isNetworkActivityIndicatorVisible = true
                guard let useruid = Auth.auth().currentUser?.uid else {return}
                FireBaseData.shared.refFavoritesReturn.child(useruid).child(removeFavoriteKey.favoriteKeyReturn).removeValue()
                
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                print(MyPageDataCenter.shared.favorites,"/",MyPageDataCenter.shared.favoritesCount)
                MyPageDataCenter.shared.favorites.remove(at: index)
                MyPageDataCenter.shared.favoritesCount -= 1
                print(MyPageDataCenter.shared.favorites,"/",MyPageDataCenter.shared.favoritesCount)
                
                
                print("LikeBtnCancelDidData",MyPageDataCenter.shared.favorites)
                
            }
            if MyPageDataCenter.shared.myReviewKeyDatas.isEmpty == true{
                self.tableView.isHidden = true
            }else{
                self.tableView.isHidden = false
            }
            self.tableView.reloadData()
            
        }
        let noBtn:UIAlertAction = UIAlertAction(title: "아니오", style: .cancel, handler: nil)
        
        cancelLikeAlert.addAction(okBtn)
        cancelLikeAlert.addAction(noBtn)
        
        self.present(cancelLikeAlert, animated: true, completion: nil)
    }
    

    
    @IBAction func backBtnAction(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
extension MyPageFavoritesViewController: FeedMainInfoCellProtocol{
    func sendBookMarkValue(isBookMark: Bool, feedKey: String) {
        print("넘어온 즐겨찾기 값//", isBookMark," 사료키값://", feedKey)
        let bookMarkRef = Database.database().reference().child("my_favorite").child(userUID)
        // 최초등록
        if isBookMark {
            // 즐겨찾기 추가
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            var bookMarkData: [String:Any] = [:]
            bookMarkData.updateValue(feedKey, forKey: "feed_key")
            
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ko")
            formatter.dateFormat = "yyyy.MM.dd HH:mm"
            let currentDataString = formatter.string(from: Date())
            print("날짜2://, ", currentDataString)
            bookMarkData.updateValue(currentDataString, forKey: "favorites_date")
            bookMarkRef.childByAutoId().setValue(bookMarkData)
            print("즐겨찾기 데이터://", bookMarkData)
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            DispatchQueue.main.async {
                //노티혹은 델리게이트를 사용해야할것같다.
                //                self.feedMoreInformationLoad()
                //                self.feedInfoTableView.reloadData()
            }
            
        }
        else{ // 기존에 데이터 존재시 삭제
            bookMarkRef.observeSingleEvent(of: .value, with: { (dataSnap) in
                guard let childrenValue = dataSnap.children.allObjects as? [DataSnapshot] else{return}
                for bookMark in childrenValue{
                    if bookMark.childSnapshot(forPath: "feed_key").value as? String == feedKey{
                        print("즐겨찾기존지하는 키://",bookMark.key)
                        bookMarkRef.child(bookMark.key).removeValue()
                    }
                }
                DispatchQueue.main.async {
                    //                    self.feedMoreInformationLoad()
                    //                    self.feedInfoTableView.reloadData()
                }
            })
        }
    }
    
    
}
