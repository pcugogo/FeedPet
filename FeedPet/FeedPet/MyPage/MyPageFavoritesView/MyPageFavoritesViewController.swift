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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if MyPageDataCenter.shared.favorites.isEmpty{
            tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        }else{
            tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if MyPageDataCenter.shared.favorites.isEmpty{
            return ""
        }else{
            return "총 \(MyPageDataCenter.shared.favorites.count)개 상품"
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if MyPageDataCenter.shared.favorites.isEmpty{
            return 1
            
        }else{
            
            return MyPageDataCenter.shared.favorites.count
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if MyPageDataCenter.shared.favorites.isEmpty{
            let favoritesEmptyCell = tableView.dequeueReusableCell(withIdentifier: "FavoritesEmptyCell", for: indexPath)
            
            return favoritesEmptyCell
        }else{
            let favorites = MyPageDataCenter.shared.favorites[indexPath.row]
            
            let myPageFeedContentsCell = tableView.dequeueReusableCell(withIdentifier: "MyPageFeedContentsCell", for: indexPath) as! MyPageFeedContentsCell
            
            myPageFeedContentsCell.delegate = self
            
            myPageFeedContentsCell.likeBtnOut.tag = indexPath.row
            
            myPageFeedContentsCell.configureCell(favorites: favorites)
            
            return myPageFeedContentsCell
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func alertController() {
        let cancelLikeAlert:UIAlertController = UIAlertController(title: "", message: "좋아요를 취소 하시겠습니까?", preferredStyle: .alert)
        
        let okBtn:UIAlertAction = UIAlertAction(title: "네", style: .default){ (action) in
            
            if let index = MyPageDataCenter.shared.myPageFeedContentsCellLikeBtnTagValue {
                print("index",index)
                print("MyPageDataCenter.shared.feedKeys",MyPageDataCenter.shared.favoritesFeedKeys)
                
                let removeFeedKey = MyPageDataCenter.shared.favoritesFeedKeys[index]
                print("removeFeedKey",removeFeedKey)
                MyPageDataCenter.shared.favoritesFeedKeys.remove(at: index)
                MyPageDataCenter.shared.favorites.remove(at: index)
                self.tableView.reloadData()
                FireBaseData.shared.refFavoritesReturn.child(MyPageDataCenter.shared.testUUID).child(removeFeedKey).removeValue() //remove시에 지운 값이 있던 자리가 닐로 되있는건지 아예 없어진건지 아직 모르겠다

//                FireBaseData.shared.fireBaseFavoritesDataLoad() 서버에 있는 데이터를 불러오는 메서드인데
//                MyPageDataCenter.shared.favorites.remove(at: index)이런식으로 최신화를 해줘서 데이터를 불러오지않아도 최신화가 되있다
                
                print("LikeBtnCancelDidData",MyPageDataCenter.shared.favorites)
                
            }
            
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
