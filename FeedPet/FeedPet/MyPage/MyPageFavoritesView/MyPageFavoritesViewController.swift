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

                let removeFavoriteKey = MyPageDataCenter.shared.favorites[index]
               UIApplication.shared.isNetworkActivityIndicatorVisible = true
                guard let useruid = Auth.auth().currentUser?.uid else {return}
                FireBaseData.shared.refFavoritesReturn.child(useruid).child(removeFavoriteKey.favoriteKeyReturn).removeValue()
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                MyPageDataCenter.shared.favorites.remove(at: index)
                MyPageDataCenter.shared.favoritesCount -= 1
                self.tableView.reloadData()
              
                
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
