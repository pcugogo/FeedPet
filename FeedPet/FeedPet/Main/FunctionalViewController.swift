//
//  FunctionalViewController.swift
//  FeedPet
//
//  Created by HwangGisu on 2018. 1. 9..
//  Copyright © 2018년 HwangGisu. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON

class FunctionalViewController: UIViewController {
    
    
    
    var functionalData = [[String:String]]()
    var functionalList = [Functional]()
    
    @IBOutlet weak var functionalCollectionView: UICollectionView!
    @IBOutlet weak var filterMenuView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        functionalCollectionView.delegate = self
        functionalCollectionView.dataSource = self
        functionalDataLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func filterBtnTouched(_ sender: UIButton){
        let filterView: FilterViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FilterView") as! FilterViewController
        
        self.present(filterView, animated: true, completion: nil)
        
    }
    
    func functionalDataLoad(){
        let reference = Database.database().reference().child("feed_functional").child("functional_petkey_c")
        reference.observeSingleEvent(of: .value, with: { (dataSnap) in
            print(dataSnap.value)
            guard let data = dataSnap.value else {return}
            let json = JSON(data)
            var functionListData = FunctionalList.init(functionJson: json)
            print(functionListData)
        }) { (error) in
            
        }
    }
    
//    func tableViewScroll() {
//        filterMenuView.frame.offsetBy(dx: self.view.layer.frame.maxX, dy: 0)
//    }
//    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        super.viewWillTransition(to: size, with: coordinator)
//        collectionViewSizeChanged = true
//    }
//
//
//    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//
//        if collectionViewSizeChanged {
//            functionalCollectionView.collectionViewLayout.invalidateLayout()
//        }
//    }
//
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//
//        if collectionViewSizeChanged {
//            collectionViewSizeChanged = false
//            functionalCollectionView.performBatchUpdates({}, completion: nil)
//        }
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension FunctionalViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat = collectionView.frame.size.height/3 - 10
        let width: CGFloat = collectionView.frame.size.width/3 - 10

        // 디바이스가 패드일경우
//        if traitCollection.userInterfaceIdiom == .pad {
//            width = collectionView.frame.size.width/3 - 10
//        }

        return CGSize(width: width, height: height)
    }
}
extension FunctionalViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return functionalData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let functionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FunctionalCell", for: indexPath) as! FunctionalCollectionViewCell
        functionCell.functionalImag.image = UIImage(named: functionalData[indexPath.item]["functionalImg"]!)
        
        functionCell.functionalLabel.text = functionalData[indexPath.item]["functional"]
        
        return functionCell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(functionalData[indexPath.row]["functionalKey"])
    }
    
    func functionalFeedDataLoad(functional: String, currentPet: String){
        
    }
}

