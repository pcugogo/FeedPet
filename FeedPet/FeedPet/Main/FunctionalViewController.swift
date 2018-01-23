//
//  FunctionalViewController.swift
//  FeedPet
//
//  Created by HwangGisu on 2018. 1. 9..
//  Copyright © 2018년 HwangGisu. All rights reserved.
//

import UIKit

class FunctionalViewController: UIViewController {
    
    var delegate: TableViewScrollDelegate?
    
    // 강아지일때-MainPageViewController에서 강아지,고야잉 구분하여데이터 할당예정
    var testData: [[String:String]] = [
                                    ["functional":"피부","functionalImg":"dogFunctional-Skin"],
                                    ["functional":"알러지","functionalImg": "dogFunctional-Allergy"],
                                    ["functional":"관절","functionalImg":"dogFunctional-Joint"],
                                    ["functional":"다이어트","functionalImg":"dogFunctional-Diet"],
                                    ["functional":"인도어","functionalImg":"dogFunctional-Indoor"],
                                    ["functional":"장&면역","functionalImg":"dogFunctional-Immune"],
                                    ["functional":"퍼포먼스","functionalImg":"dogFunctional-Performance"],
                                    ["functional":"비뇨기","functionalImg":"dogFunctional-Urinary"],
                                    ["functional":"전체","functionalImg":"dogFunctional-All"]
    ]
    @IBOutlet weak var functionalCollectionView: UICollectionView!
    @IBOutlet weak var filterMenuView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        functionalCollectionView.delegate = self
        functionalCollectionView.dataSource = self
        
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
        return testData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let functionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FunctionalCell", for: indexPath) as! FunctionalCollectionViewCell
        functionCell.functionalImag.image = UIImage(named: testData[indexPath.item]["functionalImg"]!)
        
        functionCell.functionalLabel.text = testData[indexPath.item]["functional"]
        
        return functionCell
    }
    
    
}
protocol TableViewScrollDelegate {
    func tableViewScroll()
}
