//
//  FunctionalViewController.swift
//  FeedPet
//
//  Created by HwangGisu on 2018. 1. 9..
//  Copyright © 2018년 HwangGisu. All rights reserved.
//

import UIKit

class FunctionalViewController: UIViewController {
    // 강아지일때-MainPageViewController에서 강아지,고야잉 구분하여데이터 할당예정
    var testData: [[String:String]] = [
                                    ["functional":"피부","functionalImg":"dogFunctional-Skin"],
                                    ["functional":"알러지","functionalImg": "dogFunctional-Allergy"],
                                    ["functional":"관절","functionalImg":"dogFunctional-Joint"],
                                    ["functional":"다이어트","functionalImg":"dogFunctional-Diet"],
                                    ["functional":"인도어","functionalImg":"dogFunctional-Indoor"],
                                    ["functional":"장&면역","functionalImg":"dogFunctional-Immune"]
    ]
    @IBOutlet weak var functionalCollectionView: UICollectionView!
    
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
