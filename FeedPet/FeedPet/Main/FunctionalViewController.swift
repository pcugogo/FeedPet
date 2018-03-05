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
    var functionalIndexPath: [IndexPath] = [] {
        didSet{
            DispatchQueue.global(qos: .userInteractive).async {
                
                self.functionalChangeToString()
            }
        }
    }
    
    var functionalKeyString: [String] = []
    // 델리게이트 패턴을 사용하기 위해 FunctionalKeySend 프로토콜 타입의 변수 선언
    var sendFunctionalDelegate: FunctionalProtocol?
    var filterDelegate: FilterProtocol?
    
    @IBOutlet weak var functionalCollectionView: UICollectionView!
    @IBOutlet weak var filterMenuView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        functionalCollectionView.delegate = self
        functionalCollectionView.dataSource = self
        functionalDataLoad()
        functionalCollectionView.allowsMultipleSelection = true
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func filterBtnTouched(_ sender: UIButton){
        let filterView: FilterViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FilterView") as! FilterViewController
        filterView.filterDelegate = self
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
    func functionalFeedDataLoad(functional: String, currentPet: String){
        
    }
    
    // MARK: Indexpath로 이루어지는 값을 해당 인덱스패스와 일치하는 기능성 키값 String 변환 함수
    func functionalChangeToString() {
//        if functionalIndexPath.count  == 9 {
//            self.functionalKeyString = ["all"]
//        }else{
//            self.functionalKeyString = functionalIndexPath.map({ (indexpath) -> String in
//                functionalData[indexpath.item]["functionalKey"] ?? "all"
//            })
//        }
        self.functionalKeyString = functionalIndexPath.map({ (indexpath) -> String in
            functionalData[indexpath.item]["functionalKey"]!
        })
        print(self.functionalKeyString)
        self.sendFunctionalDelegate?.functionalKeySend(keyArr: self.functionalKeyString)
        
            
        
        
        print("기능성키 변환 결과값:", self.functionalKeyString)
    }
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
//        functionalIndexPath.append(indexPath)
        return functionCell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(functionalData[indexPath.row]["functionalKey"])
        // 전체 선택 클릭시 -  모든 선택값을 선택
        if indexPath.item == collectionView.numberOfItems(inSection: 0)-1 {
            // 확장한 코드
            
            functionalIndexPath = collectionView.selectAll(animated: true)
            
            
     
            //                functionalIndexPath.append(indexPath)
            print(functionalIndexPath)
            // 초기 구현함수
            //                for item in 0..<collectionView.numberOfItems(inSection: 0) {
            //                    collectionView.selectItem(at: IndexPath(row: item, section: 0), animated: false, scrollPosition: .centeredVertically)
            //            }
            
        }else{
            if functionalIndexPath.contains(indexPath){
                let indexInt = functionalIndexPath.index(of: indexPath)
                print("기능성 선택한 값이 존재할경우 String:/",indexInt)
                functionalIndexPath.remove(at: indexInt!)
                print("------기능성 선택한 값이 존재할경우 slect 인덱스패스------: ",functionalIndexPath)
            }
            else{
                functionalIndexPath.append(indexPath)
                print("------기능성 선택한 값이 존재하지 않을경우 slect 인덱스패스------: ",functionalIndexPath)
            }
            
            let pathtest = IndexPath(item: collectionView.numberOfItems(inSection: 0)-1, section: 0)
            print("PATHTEST://",pathtest)
            if functionalIndexPath.count == 8{
                let indexInt = functionalIndexPath.index(of: pathtest)
                collectionView.selectItem(at: pathtest, animated: true, scrollPosition: .centeredVertically)
                
                // 8개가되면 실제로 all이라는 키값은 할당하지 않고 UI만 표시해준다.
//                functionalIndexPath.append(pathtest)
//                functionalIndexPath = [pathtest]
                
            }
            
        }

    }
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    // didDeselectItemAt - 지정한 패스의 항목의 선택이 해제 된 것을 위양에 통지합니다
    // collectionView:didDeselectItemAtIndexPath: 다른 item을 Select하면서 원래 선택된 item이 Deselect 됩니다.
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        
        if indexPath.item == collectionView.numberOfItems(inSection: 0)-1 {
            functionalIndexPath = []
            collectionView.deselectAll(animated: true)
        }else{
            collectionView.deselectItem(at: IndexPath(item:  collectionView.numberOfItems(inSection: 0)-1, section: 0), animated: true)
            
            // 전체 선택인지 확인을 위한 인덱스 패스 [0,8]
            let pathtest = IndexPath(item: collectionView.numberOfItems(inSection: 0)-1, section: 0)
            print(pathtest)
            if functionalIndexPath.contains(pathtest){
                let indexInt = functionalIndexPath.index(of: pathtest)
                functionalIndexPath.remove(at: indexInt!)
            }
        }
        if functionalIndexPath.contains(indexPath){
            let indexInt = functionalIndexPath.index(of: indexPath)
            print("기능성 didDeslect String:/",indexInt)
            functionalIndexPath.remove(at: indexInt!)
            print("------기능성 didDeslect 인덱스패스------: ",functionalIndexPath)
        }
        
    }
}
// FilterViewController와 관계를 가지는 FunctionalViewController에 데이터를 넘겨주기위한 확장
extension FunctionalViewController: FilterProtocol{
    func selectFilterData(filterData: FilterData, selectState: Bool) {
        self.sendFunctionalDelegate?.filterDataSend(filterData: filterData, selectState: selectState)
    }
    
    
}

protocol FunctionalProtocol {
    func functionalKeySend(keyArr: [String])
    func filterDataSend(filterData: FilterData, selectState: Bool)
}
