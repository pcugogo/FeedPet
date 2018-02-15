//
//  AddPetInformationViewController.swift
//  FeedPet
//
//  Created by HwangGisu on 2017. 12. 28..
//  Copyright © 2017년 HwangGisu. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON

class AddPetInformationViewController: UIViewController {

    
    @IBOutlet weak var petAgeCollectionView: UICollectionView!
    @IBOutlet weak var petFunctionalCollectionView: UICollectionView!
    @IBOutlet weak var dogBtnOutlet: UIButton!
    @IBOutlet weak var catBtnOutlet: UIButton!
    
    var dogAgeAray: [String] = ["퍼피", "어덜트", "시니어"]
    var catAgeArray: [String] = ["주니어", "어덜트", "시니어"]
    
    var ageArray: [String] = []
    var ageIntValue: Int = 1
    var dogFunctionalArray: [String] = ["피부","알러지","관절","다이어트","인도어","장&면역","퍼포먼스","비뇨기","전체"]
    var catFunctionalArray: [String] = ["피부","알러지","관절","다이어트","인도어","장&면역","헤어볼","비뇨기","전체"]
    var dogDicArray: [[String:String]] = [["key":"skin","text":"피부"],["key":"allergy","text":"알러지"],["key":"joint","text":"관절"],["key":"diet","text":"다이어트"],["key":"indoor","text":"인도어"],
                                          ["key":"immune","text":"장&면역"],["key":"performance","text":"퍼포먼스"],["key":"urinary","text":"비뇨기"],["key":"all","text":"전체"]]
    var functionalArray: [String] = []
    var functionalDicArray: [[String:String]] = [[:]]
    
    
    var ageIndexPath: IndexPath = IndexPath()
    var functionalIndexPath: [IndexPath] = []
    
    var userData: [String:Any] = [:]
    var petKey: String = "functional_petkey_d"
    var userPet: String = "feed_petkey_d"
    // 선택 반려동물 태그값 체크를 위한 옵저버 프로퍼티
    var petBtnTag: Int = 0 {
        didSet{
            
            if petBtnTag == 0{
                dogBtnOutlet.setImage(#imageLiteral(resourceName: "dogAble"), for: .normal)
                catBtnOutlet.setImage(#imageLiteral(resourceName: "catDisable"), for: .normal)
                ageArray = dogAgeAray
//                functionalArray = dogFunctionalArray
                functionalDicArray = dogDicArray
                petKey = "functional_petkey_d"
                userPet = "feed_petkey_d"
            }else{
                dogBtnOutlet.setImage(#imageLiteral(resourceName: "dogDisable"), for: .normal)
                catBtnOutlet.setImage(#imageLiteral(resourceName: "catAble"), for: .normal)
                ageArray = catAgeArray
//                functionalArray = catFunctionalArray
                functionalDicArray = dogDicArray
                petKey = "functional_petkey_c"
                userPet = "feed_petkey_c"
            }
            functionalKeyLoad()
            petAgeCollectionView.reloadData()
            petFunctionalCollectionView.reloadData()
        }
    }
    
    var delegate: ViewDismissProtocol?
    
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
        
        
        print("---뷰 디드로드 - functionlInedxPath 값: ", functionalIndexPath)
        print(userData)
        // 최초 선택은 디폴트가 강아지로되어있다.
        ageArray = dogAgeAray
//        functionalArray = dogFunctionalArray
        functionalDicArray = dogDicArray
        // Do any additional setup after loading the view.
        
        functionalKeyLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // ########################################
    // MARK: IBAction Method
    // ########################################
    
    @IBAction func petSlectBtnTouched(_ sender: UIButton) {
//        if sender.tag == petState.Dog.rawValue {
//        }
//        petBtnTag = sender.tag
        print(sender.tag)

        petBtnTag = sender.tag
    }
    
    
    @IBAction func doneBtnTouched(_ sender: UIBarButtonItem){
        var functionalKeyArr: [String] = []
        
        if !functionalIndexPath.isEmpty {
            if functionalIndexPath.count == 9 {
                functionalKeyArr.append("all")
                print(functionalKeyArr)
            }else{
                for functionIndexpath in functionalIndexPath {
                    guard let functionKey = functionalDicArray[functionIndexpath.item]["key"] as? String else {return}
                    functionalKeyArr.append(functionKey)
                    
                }
                print(functionalKeyArr)
                
                //            functionalKeyArr = functionalIndexPath.map { (indexpath) -> String in
                //                self.functionalDicArray[indexpath.item]["key"] as? String ?? "all"
                //            }
                //            print(functionalKeyArr)
            }
            userData.updateValue(userPet, forKey: "user_pet")
            userData.updateValue(ageIntValue, forKey: "user_petage")
            userData.updateValue(functionalKeyArr, forKey: "user_pet_functional")
            print("회원최동데이터://",userData)
            print( UserDefaults.standard.string(forKey: "userUID"))
            
//            guard let userUID = UserDefaults.standard.string(forKey: "userUID") else {return}
            guard let userUID =  Auth.auth().currentUser?.uid else {return}
            print(userUID)
           
            // 파이어베이스 사용자 정보 값 저장
            let ref = Database.database().reference().child("user_info").child(userUID)
            ref.setValue(userData)
            DispatchQueue.main.async {
                self.dismiss(animated: true) {
                    
                    self.delegate?.currentViewDismiss()
                }
            }
           
            
        }else{
//            let pathTest = IndexPath(item: 8, section: 0)
//            petFunctionalCollectionView.selectItem(at: pathTest, animated: true, scrollPosition: .centeredVertically)
//            functionalIndexPath.append(pathTest)
//            functionalIndexPath = petFunctionalCollectionView.selectAll(animated: true)
            print(functionalIndexPath)
            let alert = UIAlertController(title: nil, message: "기능성은 한가지 이상 선택해주세요.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
        
        
        
        
    }
    func functionalKeyLoad(){
        let ref = Database.database().reference()
        // 0209변경예정- petKey 값 파베데이터에서 모두 "feed_petkey_d" 형태로 변경할예정
        ref.child("feed_functional").child(petKey).observeSingleEvent(of: .value, with: { (dataSnap) in
            guard let data = dataSnap.value else {return}
            print(data)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
}

// ########################################
// MARK: Extension -                
// ########################################
extension AddPetInformationViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat = collectionView.cellForItem(at: indexPath)?.frame.size.height ?? 30.0
        print(collectionView.bottomAnchor)
        let width: CGFloat = collectionView.frame.size.width/3 - 10
        
        return CGSize(width: width, height: height)
        
    }
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
            
//            funcionalCell.functionalLabel.text = functionalArray[indexPath.item]
            funcionalCell.functionalLabel.text = functionalDicArray[indexPath.item]["text"]
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
                    print(indexInt)
                    functionalIndexPath.remove(at: indexInt!)
                    print("------기능성 선택한 값이 존재할경우 slect 인덱스패스------: ",functionalIndexPath,"---/")
                }
                else{
                    functionalIndexPath.append(indexPath)
                    print("------기능성 선택한 값이 존재하지 않을경우 slect 인덱스패스------: ",functionalIndexPath,"--/")
                }
                
                let pathtest = IndexPath(item: collectionView.numberOfItems(inSection: 0)-1, section: 0)
                if functionalIndexPath.count == 8{
                    let indexInt = functionalIndexPath.index(of: pathtest)
                    collectionView.selectItem(at: pathtest, animated: true, scrollPosition: .centeredVertically)
                    functionalIndexPath.append(pathtest)
                    print("무슨경우더라?/",functionalIndexPath)
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
            ageIntValue = indexPath.item+1
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
                print(indexInt)
                functionalIndexPath.remove(at: indexInt!)
                print("------기능성 didDeslect 인덱스패스------: ",functionalIndexPath,"/")
            }
        }
    }
    

    

    
}
// UICollectionView 확장
extension UICollectionView {
    
    // 모든 셀 선택 => 기능성 키값에서 "all"부분이 =>모든데이터 포함으로 변경에 따라 return 부분에 -1을 해주었다.
    // all이라는 부분은 실제로 데이터로는 들어가지않고 UI로만 표시해준다.
    func selectAll(animated: Bool) -> [IndexPath]{
        var inpathArr: [IndexPath] = []
        (0..<numberOfSections).flatMap { (section) -> [IndexPath]? in
            return (0..<numberOfItems(inSection: section)-1).flatMap({ (item) -> IndexPath? in
                return IndexPath(item: item, section: section)
                
            })
            }.flatMap { $0 }.forEach { (indexPath) in
                selectItem(at: indexPath, animated: true, scrollPosition: [])
                inpathArr.append(indexPath)
        }
        
        
        return inpathArr
    }
    
    // 모든 셀 선택 해제
    func deselectAll(animated: Bool) {
        indexPathsForSelectedItems?.forEach({ (indexPath) in
            deselectItem(at: indexPath, animated: animated)
        })
    }
  
    
    
}

protocol ViewDismissProtocol {
    func currentViewDismiss()
}
