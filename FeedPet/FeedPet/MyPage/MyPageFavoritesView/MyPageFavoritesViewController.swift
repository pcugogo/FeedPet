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
  
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if MyPageDataCenter.shared.favorites.isEmpty{
            tableView.isHidden = true
        }else{
            tableView.isHidden = false
        }
        
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if MyPageDataCenter.shared.favorites.isEmpty{
            return ""
        }else{
            return "총 \(MyPageDataCenter.shared.favoritesCount)개 상품"
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
       
        
            
            let myPageFeedContentsCell = tableView.dequeueReusableCell(withIdentifier: "MyPageFeedContentsCell", for: indexPath) as! MyPageFeedContentsCell
            
            myPageFeedContentsCell.delegate = self
            
            myPageFeedContentsCell.likeBtnOut.tag = indexPath.row
            
        
        
        if MyPageDataCenter.shared.favorites.isEmpty == false{
            let favorites = MyPageDataCenter.shared.favorites[indexPath.row] //reviews가 옵셔널이 아니므로 옵셔널 바인딩 안된다
            myPageFeedContentsCell.configureCell(favorites: favorites)
        }
        
            return myPageFeedContentsCell
        
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
                MyPageDataCenter.shared.favoritesCount -= 1 //좋아요가 하나 취소 되면서 get해온 즐겨찾기 카운트 데이터에 - 1을 한다 데이터를 지운뒤 최신화된 카운트를 겟해올 수도 있지만 데이터 통신이 느려 메인뷰의 즐겨찾기 갯수가 업데이트 되지 않을수도 있고 꼭 필요하지않은 상황에서 자주 통신을 하는 것도 바람직하지않다고 생각이 들어 이렇게 작업하였다
                self.tableView.reloadData()
                FireBaseData.shared.refFavoritesReturn.child(MyPageDataCenter.shared.testUUID).child(removeFeedKey).removeValue() //remove시에 지운 값이 있던 자리가 닐로 되있는건지 아예 없어진건지 아직 모르겠다
                
              
                
                print("LikeBtnCancelDidData",MyPageDataCenter.shared.favorites)
                
            }
            if MyPageDataCenter.shared.myReviewKeyDatas.isEmpty == true{
                self.tableView.isHidden = true
            }else{
                self.tableView.isHidden = false
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
