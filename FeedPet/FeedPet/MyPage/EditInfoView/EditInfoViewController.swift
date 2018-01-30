//
//  EditInfoViewController.swift
//  FeedPet2
//
//  Created by 샤인 on 2017. 12. 22..
//  Copyright © 2017년 Ios_Park. All rights reserved.
//

import UIKit

class EditInfoViewController: UIViewController {

    @IBOutlet weak var emailLb: UILabel!
    
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var nickDuplicateBtnOut: UIButton!
    @IBOutlet weak var petAgeCollectionView: UICollectionView!
    @IBOutlet weak var petFunctionalCollectionView: UICollectionView!
    
    @IBOutlet weak var dogBtnImgView: UIImageView!
    @IBOutlet weak var catBtnImgView: UIImageView!
    @IBOutlet weak var dogTextLb: UILabel!
    @IBOutlet weak var catTextLb: UILabel!
    
    
    var dogAgeAray: [String] = ["퍼피", "어덜트", "시니어"]
    var catAgeArray: [String] = ["주니어", "어덜트", "시니어"]
    
    var ageArray: [String] = []
    
    var dogFunctionalArray: [String] = ["피부","알러지","관절","다이어트","인도어","장&면역","퍼포먼스","비뇨기","전체"]
    var catFunctionalArray: [String] = ["피부","알러지","관절","다이어트","인도어","장&면역","헤어볼","비뇨기","전체"]
    var functionalArray: [String] = []
    
    
    var ageIndexPath: IndexPath = IndexPath()
    var functionalIndexPath: [IndexPath] = []
    
    // 선택 반려동물 태그값 체크를 위한 옵저버 프로퍼티
    var petBtnTag: Int = 0 {
        didSet{
            petAgeCollectionView.reloadData()
            petFunctionalCollectionView.reloadData()
            if petBtnTag == 0{
                dogBtnImgView.image = #imageLiteral(resourceName: "dogAble")
                catBtnImgView.image = #imageLiteral(resourceName: "catDisable")
                dogTextLb.textColor = UIColor(red: 27/255, green: 169/255, blue: 142/255, alpha: 1.0)
                catTextLb.textColor = UIColor(red: 181/255, green: 181/255, blue: 181/255, alpha: 1.0)
                
                ageArray = dogAgeAray
                functionalArray = dogFunctionalArray
            }else{
                dogBtnImgView.image = #imageLiteral(resourceName: "dogDisable")
                catBtnImgView.image = #imageLiteral(resourceName: "catAble")
                dogTextLb.textColor = UIColor(red: 181/255, green: 181/255, blue: 181/255, alpha: 1.0)
                catTextLb.textColor = UIColor(red: 229/255, green: 170/255, blue: 54/255, alpha: 1.0)
                
                ageArray = catAgeArray
                functionalArray = catFunctionalArray
            }
            
        }
    }
    
    // ########################################
    // MARK: View LifeCycle
    // ########################################
    override func viewDidLoad() {
        super.viewDidLoad()

        petAgeCollectionView.delegate = self
        petAgeCollectionView.dataSource = self
        petFunctionalCollectionView.delegate = self
        petFunctionalCollectionView.dataSource = self
        petFunctionalCollectionView.allowsMultipleSelection = true
        
        nickDuplicateBtnOut.layer.masksToBounds = true
        nickDuplicateBtnOut.layer.cornerRadius = 5
        
        print("---뷰 디드로드 - functionlInedxPath 값: ", functionalIndexPath)
        // 최초 선택은 디폴트가 강아지로되어있다.
        ageArray = dogAgeAray
        functionalArray = dogFunctionalArray
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // ########################################
    // MARK: IBAction Method
    // ########################################
   
    @IBAction func backBtnAction(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveBtnAction(_ sender: UIBarButtonItem) {
    }
    @IBAction func nickDuplicateBtnAction(_ sender: UIButton) {
    }
    
    @IBAction func petSlectBtnTouched(_ sender: UIButton) {
        //        if sender.tag == petState.Dog.rawValue {
        //        }
        //        petBtnTag = sender.tag
        print(sender.tag)
        
        petBtnTag = sender.tag
    }
    
}

// ########################################
// MARK: Extension -
// ########################################
extension EditInfoViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var itemCount = 0
        if collectionView == petAgeCollectionView {
            itemCount = 3
        }else {
            itemCount = 9
        }
        return itemCount
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == petAgeCollectionView {
            let ageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ageCell", for: indexPath) as! PetAgeCollectionViewCell
            ageCell.ageLable.text = ageArray[indexPath.item]
            ageCell.petSelectInt = petBtnTag
            // 최초의 초기값은 선택 상태로
            if indexPath.item == 0 {
                ageCell.isSelected = true
                collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredVertically)
                
            }
            
            return ageCell
        }else {
            let funcionalCell = collectionView.dequeueReusableCell(withReuseIdentifier: "functionalCell", for: indexPath) as! PetFunctionalCollectionViewCell
            
            funcionalCell.functionalLabel.text = functionalArray[indexPath.item]
            funcionalCell.petSelectInt = petBtnTag
            
            functionalIndexPath.append(indexPath)
            collectionView.selectAll(animated: true)
            
            
            //            for item in 0..<collectionView.numberOfItems(inSection: 0) {
            //                collectionView.selectItem(at: IndexPath(row: item, section: 0), animated: false, scrollPosition: .centeredVertically)
            //            }
            
            return funcionalCell
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //        let cell = collectionView.cellForItem(at: indexPath)!
        
        //        cell.contentView.backgroundColor =  UIColor.init(hexString: "#1ABC9C")
        if collectionView == petFunctionalCollectionView {
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
                  
                    functionalIndexPath.remove(at: indexInt!)
                    print("------기능성 선택한 값이 존재할경우 slect 인덱스패스------: ",functionalIndexPath)
                }
                else{
                    functionalIndexPath.append(indexPath)
                    print("------기능성 선택한 값이 존재하지 않을경우 slect 인덱스패스------: ",functionalIndexPath)
                }
                
                let pathtest = IndexPath(item: collectionView.numberOfItems(inSection: 0)-1, section: 0)
                if functionalIndexPath.count == 8{
                    let indexInt = functionalIndexPath.index(of: pathtest)
                    collectionView.selectItem(at: pathtest, animated: true, scrollPosition: .centeredVertically)
                    functionalIndexPath.append(pathtest)
                    
                }
                
            }
            if functionalIndexPath.count == 8{
                
            }
        }else{
            // ageIndexPath Array에 값이 존재하지 않을경우 append
            //            if !ageIndexPath.contains(indexPath){
            //                ageIndexPath.append(indexPath)
            //
            //            }
            //
            ageIndexPath = indexPath
            
        }
       
        
    }
    // didDeselectItemAt - 지정한 패스의 항목의 선택이 해제 된 것을 위양에 통지합니다
    // collectionView:didDeselectItemAtIndexPath: 다른 item을 Select하면서 원래 선택된 item이 Deselect 됩니다.
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == petFunctionalCollectionView {
            
            if indexPath.item == collectionView.numberOfItems(inSection: 0)-1 {
                functionalIndexPath = []
                collectionView.deselectAll(animated: true)
            }else{
                collectionView.deselectItem(at: IndexPath(item:  collectionView.numberOfItems(inSection: 0)-1, section: 0), animated: true)
                
                
                let pathtest = IndexPath(item: collectionView.numberOfItems(inSection: 0)-1, section: 0)
                if functionalIndexPath.contains(pathtest){
                    let indexInt = functionalIndexPath.index(of: pathtest)
                    functionalIndexPath.remove(at: indexInt!)
                }
            }
            if functionalIndexPath.contains(indexPath){
                let indexInt = functionalIndexPath.index(of: indexPath)
                
                functionalIndexPath.remove(at: indexInt!)
                print("------기능성 didDeslect 인덱스패스------: ",functionalIndexPath)
            }
        }
    }
    
    
    
    
    
}


