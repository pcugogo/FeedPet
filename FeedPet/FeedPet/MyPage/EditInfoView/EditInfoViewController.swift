//
//  EditInfoViewController.swift
//  FeedPet2
//
//  Created by 샤인 on 2017. 12. 22..
//  Copyright © 2017년 Ios_Park. All rights reserved.
//

import UIKit
import Firebase

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
    
    //강아지/고양이 펫종류
    var petType = "functional_petkey_d"
    let dogType = "functional_petkey_d"
    let catType = "functional_petkey_c"
    //펫연령
    var petAge = 0
    let dogAgeAray: [String] = ["퍼피", "어덜트", "시니어"]
    let catAgeArray: [String] = ["주니어", "어덜트", "시니어"]
    var ageArray: [String] = []
    //펫 기호
    var petFunctionKey = [String]() //선택된 기능의 인덱스패스와 비교하여 선택된 기능키만 담아서 통신한다
    var petFunctionTotalKey = ["skin","allergy","joint","diet","indoor","immune","performance","urinary","all"]//초기값 강아지로 설정
    var petFunctionTotalKeyDic = ["skin":0,"allergy":1,"joint":2,"diet":3,"indoor":4,"immune":5,"performance":6,"urinary":7,"all":8]
    var loadPetFunctionKey = [String]() //유저가 체크했던 기존 키값 //기존전 화면에서 디폴트값을 넣는지 확인
    let dogFunctionKey = ["skin","allergy","joint","diet","indoor","immune","performance","urinary","all"]
    let catFunctionKey = ["skin","allergy","joint","diet","indoor","immune","hairball","urinary","all"]
    
    let dogFunctionalArray: [String] = ["피부","알러지","관절","다이어트","인도어","장&면역","퍼포먼스","비뇨기","전체"]
    let catFunctionalArray: [String] = ["피부","알러지","관절","다이어트","인도어","장&면역","헤어볼","비뇨기","전체"]
    var functionalArray: [String] = []
    
    var functionalKeyIndex:[Int] = []
    var functionalIndexPath: [IndexPath] = [] //선택된 펫기호 인덱스패스
    
    var dataIsLoaded = true
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
                
                petType = dogType
                petFunctionTotalKey = dogFunctionKey
                petAge = 0
                print(petType)
                print(petFunctionTotalKey)
                ageArray = dogAgeAray
                functionalArray = dogFunctionalArray
            }else{
                dogBtnImgView.image = #imageLiteral(resourceName: "dogDisable")
                catBtnImgView.image = #imageLiteral(resourceName: "catAble")
                dogTextLb.textColor = UIColor(red: 181/255, green: 181/255, blue: 181/255, alpha: 1.0)
                catTextLb.textColor = UIColor(red: 229/255, green: 170/255, blue: 54/255, alpha: 1.0)
                
                petType = catType
                petFunctionTotalKey = catFunctionKey
                petAge = 0
                print(petType)
                print(petFunctionTotalKey)
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
        
        nickNameTextField.delegate = self
        petAgeCollectionView.delegate = self
        petAgeCollectionView.dataSource = self
        petFunctionalCollectionView.delegate = self
        petFunctionalCollectionView.dataSource = self
        petFunctionalCollectionView.allowsMultipleSelection = true
        
        nickDuplicateBtnOut.layer.masksToBounds = true
        nickDuplicateBtnOut.layer.cornerRadius = 5
        emailLb.text = MyPageDataCenter.shared.userEmail
        nickNameTextField.text = MyPageDataCenter.shared.userNicName
        petAge = MyPageDataCenter.shared.petAge
        petType = MyPageDataCenter.shared.petType
        loadPetFunctionKey = MyPageDataCenter.shared.loadPetFunctionKey
        for loadKey in loadPetFunctionKey{
            if let funcLoadKey  = petFunctionTotalKeyDic[loadKey]{
                functionalKeyIndex.append(funcLoadKey)
            }
            print("초기 loadKey",functionalKeyIndex)
        }
        print("---뷰 디드로드 - functionlInedxPath 값: ", functionalIndexPath)
        // 최초 선택은 디폴트가 강아지로되어있다.
        ageArray = dogAgeAray
        functionalArray = dogFunctionalArray
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) { //화면에 보여지고 나서 호출이 된다 //뷰가 나타났다
        super.viewWillAppear(true)
        dataIsLoaded = false
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
        
        if nickNameTextField.text?.isEmpty == false{
            petFunctionKey = []
            for i in functionalIndexPath{
                print(i)
                petFunctionKey.append(petFunctionTotalKey[i[1]])
                print(petFunctionKey)
            }
            print(petType,"type")
            print(petAge,"age")
            print(petFunctionKey,"petFunctionKey")
            //싱글옵저브이다 마이페이지데이터센터에 각각 유저정보값을 업데이트해줘야된다
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            FireBaseData.shared.refUserInfoReturn.child(MyPageDataCenter.shared.testUUID).child("user_pet_funtional").removeValue()//펑셔널이 어레이로 되있어서 값이 바뀌지않고 계속 추가되기떄문에 지운다음에 추가해준다

            FireBaseData.shared.refUserInfoReturn.child(MyPageDataCenter.shared.testUUID).updateChildValues(["user_nic":nickNameTextField.text])
            FireBaseData.shared.refUserInfoReturn.child(MyPageDataCenter.shared.testUUID).updateChildValues(["user_pet":petType])

            FireBaseData.shared.refUserInfoReturn.child(MyPageDataCenter.shared.testUUID).updateChildValues(["user_pet_age":petAge])
            FireBaseData.shared.refUserInfoReturn.child(MyPageDataCenter.shared.testUUID).updateChildValues(["user_pet_funtional":petFunctionKey])
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }else{
            let nickNameNilAlert = UIAlertController(title: "", message: "닉네임을 입력해주세요", preferredStyle: .alert)
            let okBtn = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            nickNameNilAlert.addAction(okBtn)
            self.present(nickNameNilAlert, animated: true, completion: nil)
        }
    }
    @IBAction func nickDuplicateBtnAction(_ sender: UIButton) {
       
    }
    
    @IBAction func petSlectBtnTouched(_ sender: UIButton) {

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
            let ageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ageCell", for: indexPath) as! EditInfoViewAgeCollectionViewCell
            ageCell.ageLable.text = ageArray[indexPath.item]
            ageCell.petSelectInt = petBtnTag
            // 최초의 초기값은 선택 상태로
            if dataIsLoaded == true{
                if indexPath.item == petAge {
                    ageCell.isSelected = true
                    collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredVertically)
                    
                }
            }else{
                if indexPath.item == 0 {
                    ageCell.isSelected = true
                    collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredVertically)
                    
                }
            }
          
            return ageCell
        }else {
            let funcionalCell = collectionView.dequeueReusableCell(withReuseIdentifier: "functionalCell", for: indexPath) as! EditInfoViewPetFunctionCollectionViewCell
            
            funcionalCell.functionalLabel.text = functionalArray[indexPath.item]
            funcionalCell.petSelectInt = petBtnTag
            
            if dataIsLoaded == true {

                
                
                
                for selectIndex in functionalKeyIndex {
                    if indexPath.row == selectIndex{
                        funcionalCell.isSelected = true
                        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredVertically)
                        if functionalIndexPath.contains(indexPath) == true{
                            functionalIndexPath.remove(at: indexPath.row)
                        }else{
                            functionalIndexPath.append(indexPath)
                        }
                        print("초기 functionalIndexPath",functionalIndexPath)
                    }
                }
                
            }else{
                funcionalCell.isSelected = true
                collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredVertically)
            }
           
            return funcionalCell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == petFunctionalCollectionView {
            // 전체 선택 클릭시 -  모든 선택값을 선택
            if indexPath.item == collectionView.numberOfItems(inSection: 0)-1 {
                // 확장한 코드
                
                
                functionalIndexPath = collectionView.selectAll(animated: true)
                print(functionalIndexPath)
                
                
            }else{
                print(indexPath.item,"itemmmmm")
                if functionalIndexPath.contains(indexPath){
                    let indexInt = functionalIndexPath.index(of: indexPath)
                    
                    functionalIndexPath.remove(at: indexInt!)
                    print("------기능성 선택한 값이 존재할경우 didSelect 인덱스패스------: ",functionalIndexPath)
                }else{
                    functionalIndexPath.append(indexPath)
                    print("------didSelect 인덱스패스------: ",functionalIndexPath)
                }
                
                let pathtest = IndexPath(item: collectionView.numberOfItems(inSection: 0)-1, section: 0)
                if functionalIndexPath.count == 8{
                    //                    let indexInt = functionalIndexPath.index(of: pathtest)
                    collectionView.selectItem(at: pathtest, animated: true, scrollPosition: .centeredVertically)
                    functionalIndexPath.append(pathtest)
                    
                }
                
            }
            if functionalIndexPath.count == 8{
            }
        }else{
            petAge = indexPath.row
            print("petAge Pick",petAge)
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
                print("------기능성 didDeselect 인덱스패스------: ",functionalIndexPath)
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
}

extension EditInfoViewController:UITextFieldDelegate{
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}

