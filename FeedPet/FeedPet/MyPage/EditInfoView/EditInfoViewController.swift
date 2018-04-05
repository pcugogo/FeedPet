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
    
    @IBOutlet weak var nickNameDuplicateTextLb: UILabel!
    //강아지/고양이 펫종류
    var petType = "feed_petkey_d"
    let dogType = "feed_petkey_d"
    let catType = "feed_petkey_c"
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
    
    var dataIsLoaded = false
    
    var nickNameDuplicate = false
    
    // 선택 반려동물 태그값 체크를 위한 옵저버 프로퍼티
    var petBtnTag: Int = 0 {
//        didSet{
//            petAgeCollectionView.reloadData()
//            petFunctionalCollectionView.reloadData()
//            if petBtnTag == 0{
//                dogBtnImgView.image = #imageLiteral(resourceName: "dogAble")
//                catBtnImgView.image = #imageLiteral(resourceName: "catDisable")
//                dogTextLb.textColor = UIColor(red: 27/255, green: 169/255, blue: 142/255, alpha: 1.0)
//                catTextLb.textColor = UIColor(red: 181/255, green: 181/255, blue: 181/255, alpha: 1.0)
//
//                petType = dogType
//                petFunctionTotalKey = dogFunctionKey
//                petAge = 0
//                print(petType)
//                print(petFunctionTotalKey)
//                ageArray = dogAgeAray
//                functionalArray = dogFunctionalArray
//            }else{
//                dogBtnImgView.image = #imageLiteral(resourceName: "dogDisable")
//                catBtnImgView.image = #imageLiteral(resourceName: "catAble")
//                dogTextLb.textColor = UIColor(red: 181/255, green: 181/255, blue: 181/255, alpha: 1.0)
//                catTextLb.textColor = UIColor(red: 229/255, green: 170/255, blue: 54/255, alpha: 1.0)
//
//                petType = catType
//                petFunctionTotalKey = catFunctionKey
//                petAge = 0
//                print(petType)
//                print(petFunctionTotalKey)
//                ageArray = catAgeArray
//                functionalArray = catFunctionalArray
//            }
//
//        }
        didSet{
            
            if petBtnTag == 0{
                dogBtnImgView.image = #imageLiteral(resourceName: "dogAbleImg")
                catBtnImgView.image = #imageLiteral(resourceName: "catDisableImg")
                
                ageArray = dogAgeAray
                //                functionalArray = dogFunctionalArray
                functionalDicArray = dogDicArray
                petType = "feed_petkey_d"
//                userPet = "feed_petkey_d"
            }else{
                dogBtnImgView.image = #imageLiteral(resourceName: "dogDisableImg")
                catBtnImgView.image = #imageLiteral(resourceName: "catAbleImg")
                ageArray = catAgeArray
                //                functionalArray = catFunctionalArray
                functionalDicArray = dogDicArray
                petType = "feed_petkey_c"
//                userPet = "feed_petkey_c"
            }
            
            if petType == userPet {
                isSamePet = true
                functionalIndexPath = tempfunctionalIndexPath
            }else{
                isSamePet = false
                functionalIndexPath = []
            }
            userPetInfoLoad()
            petAgeCollectionView.reloadData()
            petFunctionalCollectionView.reloadData()
        }

    }
    var userData: User?
    var userPet: String = "feed_petkey_d"
    var userFunctionalIndexPath: [IndexPath] = []
    var dogDicArray: [[String:String]] = [["key":"skin","text":"피부"],["key":"allergy","text":"알러지"],["key":"joint","text":"관절"],["key":"diet","text":"다이어트"],["key":"indoor","text":"인도어"],
                                          ["key":"immune","text":"장&면역"],["key":"performance","text":"퍼포먼스"],["key":"urinary","text":"비뇨기"],["key":"all","text":"전체"]]
    var catDicArray: [[String:String]] = [["key":"skin","text":"피부"],["key":"allergy","text":"알러지"],["key":"joint","text":"관절"],["key":"diet","text":"다이어트"],["key":"indoor","text":"인도어"],
                                          ["key":"immune","text":"장&면역"],["key":"hairball","text":"헤어볼"],["key":"urinary","text":"비뇨기"],["key":"all","text":"전체"]]
    var userInfo: User = User()
    var functionalDicArray: [[String:String]] = [[:]]
    var isSamePet: Bool = false
    var tempfunctionalIndexPath: [IndexPath] = []
    var userPetAgeIndexPath: IndexPath = IndexPath(item: 0, section: 0)
    
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
        
        guard let userInfo = userData else {return}
        self.userInfo = userInfo
        emailLb.text = userInfo.userEmail
        nickNameTextField.text = userInfo.userNickname
        petAge = userInfo.userPetAge
        userPet = userInfo.userPet
        
        loadPetFunctionKey = MyPageDataCenter.shared.loadPetFunctionKey
        for loadKey in loadPetFunctionKey{
            if let funcLoadKey  = petFunctionTotalKeyDic[loadKey]{
                functionalKeyIndex.append(funcLoadKey)
            }
            print("초기 loadKey",functionalKeyIndex)
        }
        
//        for indexRow in userInfo.userPetFunctionalIndexPathRow {
//            userFunctionalIndexPath.append(IndexPath(row: indexRow, section: 0))
//        }
//        print("조회해온 유저정보의 기능성 인덱스 패스://", userFunctionalIndexPath)
//        //                        self.userSelectFunctionalIndexPath = userFunctionalIndexPath
//        //                        self.functionalCollectionView.reloadData()
//
//        self.functionalIndexPath = userFunctionalIndexPath
//
//        for indexpath in self.functionalIndexPath{
//            self.petFunctionalCollectionView.selectItem(at: indexpath, animated: true, scrollPosition: .centeredVertically)
//        }
//
//        if userInfo.userPet == petType {
//            userPetAgeIndexPath = IndexPath(item: userInfo.userPetAge, section: 0)
//            self.petAgeCollectionView.selectItem(at: userPetAgeIndexPath, animated: true, scrollPosition: .centeredHorizontally)
//            // 만약 위에 코드처럼 UserDefault에 저장할경우 통신이 불필요하다.
//            // 사용자 정보는 최초 가입혹은 수정시에만 변경되므로 통신사용을 하지 않을지 고민이된다.
//            var userFunctionalIndexPath: [IndexPath] = []
//            print(userInfo)
//            for indexRow in userInfo.userPetFunctionalIndexPathRow {
//                userFunctionalIndexPath.append(IndexPath(row: indexRow, section: 0))
//            }
//            print("조회해온 유저정보의 기능성 인덱스 패스://", userFunctionalIndexPath)
//            //                        self.userSelectFunctionalIndexPath = userFunctionalIndexPath
//            //                        self.functionalCollectionView.reloadData()
//            self.tempfunctionalIndexPath = userFunctionalIndexPath
//            self.functionalIndexPath = userFunctionalIndexPath
////
//            for indexpath in self.functionalIndexPath{
//                self.petFunctionalCollectionView.selectItem(at: indexpath, animated: true, scrollPosition: .centeredVertically)
//            }
//
//            isSamePet = true
//
//        }
        userPetInfoLoad()
        print("---뷰 디드로드 - functionlInedxPath 값: ", functionalIndexPath)
        // 최초 선택은 디폴트가 강아지로되어있다.
//        ageArray = dogAgeAray
//        functionalArray = dogFunctionalArray
        // 최초 선택은 디폴트가 강아지로되어있다.
        ageArray = dogAgeAray
        //        functionalArray = dogFunctionalArray
        functionalDicArray = dogDicArray
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
        guard let useruid = Auth.auth().currentUser?.uid else {return}
        if nickNameTextField.text?.isEmpty == false && nickNameDuplicate == true{
            var petFunctionalIndexPathRow: [Int] = []
            petFunctionKey = []
            for i in functionalIndexPath{
                print(i)
                petFunctionKey.append(petFunctionTotalKey[i[1]])
                petFunctionalIndexPathRow.append(i.row)
                print(petFunctionKey)
            }
            print(petType,"type")
            print(petAge,"age")
            print(petFunctionKey,"petFunctionKey")
            print("기능성 인덱스패스 로우://", petFunctionalIndexPathRow)
            //싱글옵저브이다 마이페이지데이터센터에 각각 유저정보값을 업데이트해줘야된다
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            FireBaseData.shared.refUserInfoReturn.child(useruid).child("user_pet_functional").removeValue()//펑셔널이 어레이로 되있어서 값이 바뀌지않고 계속 추가되기떄문에 지운다음에 추가해준다
            
            
            if let nickName = nickNameTextField.text{
                FireBaseData.shared.refUserInfoReturn.child(useruid).updateChildValues(["user_nic":nickName])
            }
            
            FireBaseData.shared.refUserInfoReturn.child(useruid).updateChildValues(["user_pet":petType])
            
            FireBaseData.shared.refUserInfoReturn.child(useruid).updateChildValues(["user_pet_age":petAge])
            FireBaseData.shared.refUserInfoReturn.child(useruid).updateChildValues(["user_pet_functional":petFunctionKey])
            FireBaseData.shared.refUserInfoReturn.child(useruid).updateChildValues(["user_pet_functional_indexpath_row":petFunctionalIndexPathRow])
//            guard let userInfo = UserDefaults.standard.value(forKey: "loginUserData") as? [String:Any] else {return}
//
//            var userData: [String:Any] = userInfo
//
//
//            userData.updateValue(petType, forKey: "user_pet")
//            userData.updateValue(petAge, forKey: "user_petage")
//            userData.updateValue(petFunctionKey, forKey: "user_pet_functional")
//            userData.updateValue(petFunctionalIndexPathRow, forKey: "user_pet_functional_indexpath_row")
//            print("회원최동데이터://",userData)
            
            var userDatas = DataCenter.shared.userInfo
            userDatas.userPet = petType
            userDatas.userPetAge = petAge
            userDatas.userPetFunctional = petFunctionKey
            userDatas.userPetFunctionalIndexPathRow = petFunctionalIndexPathRow
            print(userDatas)
//            UserDefaults.standard.set(userData, forKey: "loginUserData")
            DataCenter.shared.userInfo = userDatas
            DataCenter.shared.userDataUpdate = true
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            let nickNameNilAlert = UIAlertController(title: "", message: "저장되었습니다", preferredStyle: .alert)
            let okBtn = UIAlertAction(title: "OK", style: .default, handler: { (_) in
                self.navigationController?.popViewController(animated: true)
            })
            nickNameNilAlert.addAction(okBtn)
            self.present(nickNameNilAlert, animated: true, completion: nil)
            
        }else{
            
            let nickNameNilAlert = UIAlertController(title: "", message: "닉네임 중복확인을 해주세요", preferredStyle: .alert)
            let okBtn = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            nickNameNilAlert.addAction(okBtn)
            self.present(nickNameNilAlert, animated: true, completion: nil)
            
        }
    }
    @IBAction func nickDuplicateBtnAction(_ sender: UIButton) {
        if let nickName = nickNameTextField.text {
            FireBaseData.shared.nicNameDoubleChek(nickName: nickName, completion: { (isDuplicate) in
                if isDuplicate {
                    
                    let duplicateAlert:UIAlertController = UIAlertController(title: "", message: "이미 사용중인 닉네임입니다", preferredStyle: .alert)
                    let okBtn = UIAlertAction(title: "OK", style: .default, handler: { (_) in
                        self.nickNameDuplicate = false
                        self.nickNameDuplicateTextLb.isHidden = false
                    })
                    
                    duplicateAlert.addAction(okBtn)
                    self.present(duplicateAlert, animated: true, completion: nil)
                }else{
                    self.view.endEditing(true)
                    let possibleAlert:UIAlertController = UIAlertController(title: "", message: "사용 가능한 닉네임입니다", preferredStyle: .alert)
                    let okBtn = UIAlertAction(title: "OK", style: .default, handler: { (_) in
                        self.nickNameDuplicate = true
                        self.nickNameDuplicateTextLb.isHidden = true
                        
                    })
                    
                    possibleAlert.addAction(okBtn)
                    self.present(possibleAlert, animated: true, completion: nil)
                }
            })
        }else{
            let nickNameNilAlert = UIAlertController(title: "", message: "닉네임을 입력해주세요", preferredStyle: .alert)
            let okBtn = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            nickNameNilAlert.addAction(okBtn)
            self.present(nickNameNilAlert, animated: true, completion: nil)
        }
    }
    
    @IBAction func petSlectBtnTouched(_ sender: UIButton) {
        
        print(sender.tag)
        petBtnTag = sender.tag
    }
 
    func userPetInfoLoad(){
        if userInfo.userPet == petType {
            userPetAgeIndexPath = IndexPath(item: userInfo.userPetAge, section: 0)
            self.petAgeCollectionView.selectItem(at: userPetAgeIndexPath, animated: true, scrollPosition: .centeredHorizontally)
            // 만약 위에 코드처럼 UserDefault에 저장할경우 통신이 불필요하다.
            // 사용자 정보는 최초 가입혹은 수정시에만 변경되므로 통신사용을 하지 않을지 고민이된다.
            var userFunctionalIndexPath: [IndexPath] = []
            
            for indexRow in userInfo.userPetFunctionalIndexPathRow {
                userFunctionalIndexPath.append(IndexPath(row: indexRow, section: 0))
            }
            print("조회해온 유저정보의 기능성 인덱스 패스://", userFunctionalIndexPath)
            //                        self.userSelectFunctionalIndexPath = userFunctionalIndexPath
            //                        self.functionalCollectionView.reloadData()
            self.tempfunctionalIndexPath = userFunctionalIndexPath
            self.functionalIndexPath = userFunctionalIndexPath
            //
            for indexpath in self.functionalIndexPath{
                self.petFunctionalCollectionView.selectItem(at: indexpath, animated: true, scrollPosition: .centeredVertically)
            }
            
            isSamePet = true
            
        }
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
            if isSamePet == true{
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
            
            //            funcionalCell.functionalLabel.text = functionalArray[indexPath.item]
            funcionalCell.functionalLabel.text = functionalDicArray[indexPath.item]["text"]
            funcionalCell.petSelectInt = petBtnTag
            if isSamePet {
                
                functionalIndexPath = tempfunctionalIndexPath
                
                if functionalIndexPath.contains(indexPath) {
                    funcionalCell.isSelected = true
                    collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredVertically)

                }
            }else{
                funcionalCell.isSelected = true
                
                functionalIndexPath.append(indexPath)
                collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredVertically)
                
            }
            
            print("그래서 인덱스패스는://", functionalIndexPath, "/갯수는://",functionalIndexPath.count)
//            funcionalCell.isSelected = true
//            functionalIndexPath.append(indexPath)
//            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredVertically)
            
            ///
//            funcionalCell.functionalLabel.text = functionalArray[indexPath.item]
//            funcionalCell.petSelectInt = petBtnTag
//
//            if dataIsLoaded == true {
//
//
//
//
//                for selectIndex in functionalKeyIndex {
//                    if indexPath.row == selectIndex{
//                        funcionalCell.isSelected = true
//                        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredVertically)
//                        if functionalIndexPath.contains(indexPath) == true{
//                            functionalIndexPath.remove(at: indexPath.row)
//                        }else{
//                            functionalIndexPath.append(indexPath)
//                        }
//                        print("초기 functionalIndexPath",functionalIndexPath)
//                    }
//                }
//
//            }else{
//                funcionalCell.isSelected = true
//                collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredVertically)
//            }
//
            return funcionalCell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == petFunctionalCollectionView {
            // 전체 선택 클릭시 -  모든 선택값을 선택
            if indexPath.item == collectionView.numberOfItems(inSection: 0)-1 {
                // 확장한 코드
                
                functionalIndexPath = collectionView.selectAll(animated: true)
                //                functionalIndexPath.append(indexPath)
                print(functionalIndexPath)
            }else{
                
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
            // ageIndexPath Array에 값이 존재하지 않을경우 append
            //            if !ageIndexPath.contains(indexPath){
            //                ageIndexPath.append(indexPath)
            //
            //            }
            //
            
            petAge = indexPath.row
            print("petAge Pick",petAge)
        }
//        if collectionView == petFunctionalCollectionView {
//            // 전체 선택 클릭시 -  모든 선택값을 선택
//            if indexPath.item == collectionView.numberOfItems(inSection: 0)-1 {
//                // 확장한 코드
//
//
//                functionalIndexPath = collectionView.selectAll(animated: true)
//                print(functionalIndexPath)
//
//
//            }else{
//                print(indexPath.item,"itemmmmm")
//                if functionalIndexPath.contains(indexPath){
//                    let indexInt = functionalIndexPath.index(of: indexPath)
//
//                    functionalIndexPath.remove(at: indexInt!)
//                    print("------기능성 선택한 값이 존재할경우 didSelect 인덱스패스------: ",functionalIndexPath)
//                }else{
//                    functionalIndexPath.append(indexPath)
//                    print("------didSelect 인덱스패스------: ",functionalIndexPath)
//                }
//
//                let pathtest = IndexPath(item: collectionView.numberOfItems(inSection: 0)-1, section: 0)
//                if functionalIndexPath.count == 8{
//                    //                    let indexInt = functionalIndexPath.index(of: pathtest)
//                    collectionView.selectItem(at: pathtest, animated: true, scrollPosition: .centeredVertically)
//                    functionalIndexPath.append(pathtest)
//
//                }
//
//            }
//            if functionalIndexPath.count == 8{
//            }
//        }else{
//            petAge = indexPath.row
//            print("petAge Pick",petAge)
//        }
//
        
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
        
//        if collectionView == petFunctionalCollectionView {
//
//            if indexPath.item == collectionView.numberOfItems(inSection: 0)-1 {
//                functionalIndexPath = []
//                collectionView.deselectAll(animated: true)
//            }else{
//                collectionView.deselectItem(at: IndexPath(item:  collectionView.numberOfItems(inSection: 0)-1, section: 0), animated: true)
//
//
//                let pathtest = IndexPath(item: collectionView.numberOfItems(inSection: 0)-1, section: 0)
//                if functionalIndexPath.contains(pathtest){
//                    let indexInt = functionalIndexPath.index(of: pathtest)
//                    functionalIndexPath.remove(at: indexInt!)
//                }
//            }
//            if functionalIndexPath.contains(indexPath){
//                let indexInt = functionalIndexPath.index(of: indexPath)
//
//                functionalIndexPath.remove(at: indexInt!)
//                print("------기능성 didDeselect 인덱스패스------: ",functionalIndexPath)
//            }
//        }
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
