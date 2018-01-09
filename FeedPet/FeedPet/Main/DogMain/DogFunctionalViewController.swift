//
//  DogFunctionalViewController.swift
//  FeedPet
//
//  Created by HwangGisu on 2018. 1. 9..
//  Copyright © 2018년 HwangGisu. All rights reserved.
//

import UIKit

class DogFunctionalViewController: UIViewController {

    @IBOutlet weak var functionalColectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        functionalColectionView.dataSource = self
        functionalColectionView.delegate = self
        
//        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
////        layout.sectionInset = UIEdgeInsets(top: 20, left: 2, bottom: 10, right: 2)
//        layout.minimumInteritemSpacing = 5
//        layout.minimumLineSpacing = 5
//        functionalColectionView.collectionViewLayout = layout
        // Do any additional setup after loading the view.
    }
//    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        guard let flowLayout = functionalColectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
//            return
//        }
//        flowLayout.invalidateLayout()
//    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        functionalColectionView.collectionViewLayout.invalidateLayout()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
}

extension DogFunctionalViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 9
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let functinalCell = collectionView.dequeueReusableCell(withReuseIdentifier: "functionalCell", for: indexPath) as! FunctionalCollectionViewCell
        
        
        return functinalCell
    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        return CGSize(width: self.functionalColectionView.frame.width / 2.8, height: self.functionalColectionView.frame.height / 3)
//
//    }
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//        
//        let theWidth = (self.functionalColectionView.frame.width - (15*3))/2    // it will generate 2 column
//        let theHeight = (self.functionalColectionView.frame.height - (10*2))/3   // it will generate 3 Row
//        
//        
//        
//        return CGSize(width: theWidth ,height: theHeight)
//    }
}
