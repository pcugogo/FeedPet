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
    var sortingState: SortingState = DataCenter.shared.sortingState {
        didSet{
            
        }
    }
    // 사용자의 반려동물과 현재 cuurentPetkey값이 동일하지 않을때 사용할 기능성 인덱스패스 데이터
    var userDataLoad: Bool = false
    var userIndexPath: [IndexPath] = [] {
        willSet{
            
            print(userIndexPath)
        }
        didSet{
            print(userIndexPath)
//            if DataCenter.shared.userDataUpdate {
//
//            }else{
//
//                DispatchQueue.global(qos: .userInteractive).async {
//
//                    self.functionalChangeToString()
//
//                }
//            }
            
            self.functionalChangeToString()
            
            
            
        }
    }
    
    // 사용자의 반려동물과 현재 cuurentPetkey값이 동일할때 사용할 기능성 인덱스패스 데이터
    var functionalIndexPath: [IndexPath] = [] {

        didSet{
            
            DispatchQueue.global(qos: .userInteractive).async {
                
                self.functionalChangeToString()

            }
            
        }
    }
    
    // 실제 기능성의 String값을 담을 배열
    var functionalKeyString: [String] = []
    
    // 델리게이트 패턴을 사용하기 위해 FunctionalKeySend 프로토콜 타입의 변수 선언
    var sendFunctionalDelegate: FunctionalProtocol?
    var filterDelegate: FilterProtocol?
    var withMainPageView: MainPageViewController = MainPageViewController()
    
    @IBOutlet weak var functionalCollectionView: UICollectionView!
    @IBOutlet weak var filterMenuView: UIView!
    @IBOutlet weak var filterBtnOutlet: UIButton!
    @IBOutlet weak var sortingBtnOutlet: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        functionalCollectionView.allowsMultipleSelection = true
        sortingBtnOutlet.layer.cornerRadius = 10
        
        functionalCollectionView.delegate = self
        functionalCollectionView.dataSource = self
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.dataLoadSignal(notification:)), name: .feedAllDataNoti, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(self.test(notification:)), name: .userPetTest, object: nil)
        
//        functionalDataLoad()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        switch DataCenter.shared.sortingState {
//        case .grade:
//            self.sortingBtnOutlet.setBackgroundImage(#imageLiteral(resourceName: "feed_grade_sorting_btn"), for: .normal)
//        case .mouth:
//            self.sortingBtnOutlet.setBackgroundImage(#imageLiteral(resourceName: "mouth_grade_sorting_btn"), for: .normal)
//        }
        
// self.functionalCollectionView.reloadData()
//        let userInfo = DataCenter.shared.userInfo
//        print("조회한 유저데이터 datasignal://,",userInfo)
//        if userInfo.userPet != DataCenter.shared.currentPetKey {
//            functionalIndexPath = []
////           self.functionalCollectionView.reloadData()
//        }
        print(self.functionalIndexPath)
        print("메인에 기능 값보내기전 유저반려동물://",DataCenter.shared.userInfo.userPet ,"//현화면 반려동물://", DataCenter.shared.currentPetKey)
        if DataCenter.shared.userDataUpdate && DataCenter.shared.userUpdateCount < 3 {
            print(self.functionalIndexPath, self.userIndexPath)
            self.userIndexPath = []
            
//            self.functionalCollectionView.reloadData()
        }
        self.functionalCollectionView.reloadData()
//        self.functionalCollectionView.deselectAll(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    deinit {
        // 옵저버 등록 해제
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.feedAllDataNoti, object: nil)
        
    }
    @IBAction func dataSortingFilterBtnTouched(_ sender: UIButton){
        let actionSheet = UIAlertController(title: nil, message: "정렬", preferredStyle: .actionSheet)
//        let rankingAction = UIAlertAction(title: "랭킹순", style: .default) { (action) in
//
//        }
        let gradeAction = UIAlertAction(title: "등급순", style: .default) { (action) in
            DataCenter.shared.sortingState = .grade
            DispatchQueue.main.async {
                self.sortingBtnOutlet.setBackgroundImage(#imageLiteral(resourceName: "feed_grade_sorting_btn"), for: .normal)
            }
            self.functionalChangeToString()
        }
        let mouthAction = UIAlertAction(title: "입소문순", style: .default) { (action) in
            DataCenter.shared.sortingState = .mouth
            DispatchQueue.main.async {
                self.sortingBtnOutlet.setBackgroundImage(#imageLiteral(resourceName: "mouth_grade_sorting_btn"), for: .normal)
            }
            self.functionalChangeToString()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
//        actionSheet.addAction(rankingAction)
        actionSheet.addAction(gradeAction)
        actionSheet.addAction(mouthAction)
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet, animated: true, completion: nil)
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
        guard let uid = Auth.auth().currentUser?.uid else{return}
        Database.database().reference().child("user_info").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot)
            if let userInfoSnapshot = snapshot.value as? [String:Any]{
                
                let userInfo = User(userInfoData: userInfoSnapshot)
                print("조회한 유저데이터2://,",userInfo)
                var userFunctionalIndexPath: [IndexPath] = []
                if userInfo.userPet == currentPet {
                    for indexRow in userInfo.userPetFunctionalIndexPathRow {
                        userFunctionalIndexPath.append(IndexPath(row: indexRow, section: 0))
                    }
                }
                
                print("조회해온 유저정보의 기능성 인덱스 패스://", userFunctionalIndexPath)
                //                        self.userSelectFunctionalIndexPath = userFunctionalIndexPath
                //                        self.functionalCollectionView.reloadData()
                
//                self.feedAllDataPagination(functionalKey: userInfo.userPetFunctional)
//                self.feedInfoTableView.reloadData()
            }
            
        })
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
        var sendIndexPath:[IndexPath] = []
        print("메인에 기능 값보내기전 유저반려동물://",DataCenter.shared.userInfo.userPet ,"//현화면 반려동물://", DataCenter.shared.currentPetKey,"//", userIndexPath,"/", functionalIndexPath)
        if DataCenter.shared.userInfo.userPet != DataCenter.shared.currentPetKey {
            sendIndexPath = userIndexPath
        }else{
            sendIndexPath = functionalIndexPath
        }
        self.functionalKeyString = sendIndexPath.map({ (indexpath) -> String in
            functionalData[indexpath.item]["functionalKey"]!
        })
        
        print("현재 선택된 키://",DataCenter.shared.currentPetKey,"사용자 선택기://", DataCenter.shared.userInfo.userPet,"기능성 키 값들://",self.functionalKeyString)
        
        self.sendFunctionalDelegate?.functionalKeySend(keyArr: self.functionalKeyString)
//        self.functionalCollectionView.reloadData()
        
                
        
        print("기능성키 변환 결과값:", self.functionalKeyString)
    }
    
//    @objc func test(notification: Notification){
//        let userInfo = DataCenter.shared.userInfo
//        print("조회한 유저데이터 datasignal://,",userInfo)
////        self.userIndexPath = []
////        self.functionalCollectionView.reloadData()
//
////        if userInfo.userPet != DataCenter.shared.currentPetKey {
////            self.userIndexPath = []
////            self.functionalCollectionView.reloadData()
////        }
//    }
//
    
    // NotificationCenter 옵저버를 사용하여 MainPageViewController에서 선행되어야할 데이터 작업후 노티게시
    @objc func dataLoadSignal(notification: Notification){
        guard let mainview = self.parent as? MainPageViewController else {return}
        
        print(mainview.indicatorTitle)
        var key = "feed_petkey_d"
        if mainview.indicatorTitle == "멍" {
            key = "feed_petkey_d"
        }else{
            key = "feed_petkey_c"
        }
        
//        guard let uid = Auth.auth().currentUser?.uid else {return}
//        guard let userData = UserDefaults.standard.value(forKey: "loginUserData") as? [String:Any] else {return}
        let userInfo = DataCenter.shared.userInfo //User(userInfoData: userData)
        print("조회한 유저데이터 datasignal://,",userInfo)
        var userFunctionalIndexPath: [IndexPath] = []
        
        if userInfo.userPet == DataCenter.shared.currentPetKey {
            print("a1123")
            for indexRow in userInfo.userPetFunctionalIndexPathRow {
                userFunctionalIndexPath.append(IndexPath(row: indexRow, section: 0))
            }
//           ㅋprint(userFunctionalIndexPath)
//            for indexpath in userFunctionalIndexPath{
//                self.functionalCollectionView.selectItem(at: indexpath, animated: true, scrollPosition: .centeredVertically)
//            }
        
            
        }
        else{
            
            print("b1123")
            
            
        }
//        else{
//            userFunctionalIndexPath = []
//        }
        self.functionalIndexPath = userFunctionalIndexPath
        self.functionalCollectionView.reloadData()
//        self.userIndexPath = userFunctionalIndexPath
        
//        Database.database().reference().child("user_info").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
//            print(snapshot)
//            if let userInfoSnapshot = snapshot.value as? [String:Any]{
//
//                let userInfo = User(userInfoData: userInfoSnapshot)
//                print("조회한 유저데이터2://,",userInfo)
//                var userFunctionalIndexPath: [IndexPath] = []
//
//                if userInfo.userPet == DataCenter.shared.currentPetKey {
//                    for indexRow in userInfo.userPetFunctionalIndexPathRow {
//                        userFunctionalIndexPath.append(IndexPath(row: indexRow, section: 0))
//                    }
//                    DispatchQueue.main.async {
//
//                        for indexpath in userFunctionalIndexPath{
//                            self.functionalCollectionView.selectItem(at: indexpath, animated: true, scrollPosition: .centeredVertically)
//                        }
//                    }
//                }else{
//                    self.functionalCollectionView.deselectAll(animated: true)
//                }
//                self.functionalIndexPath = userFunctionalIndexPath
//                print("조회해온 유저정보의 기능성 인덱스 패스://", userFunctionalIndexPath)
//                //                        self.userSelectFunctionalIndexPath = userFunctionalIndexPath
//                //                        self.functionalCollectionView.reloadData()
//
//
//
//            }
//
//        })
        /*
        // 사용자 가입신 선택한 반려동물이 현재 팻키 값과 동일한지-- 문제발생
        print("가입할때 있던 유저정보://",UserDefaults.standard.value(forKey: "loginUserData"))
        guard let userInfo = UserDefaults.standard.value(forKey: "loginUserData") as? [String:Any] else {return}
        let userData = User(userInfoData: userInfo)
//        self.functionalIndexPath = []
//
        
        print("가입할때 있던 유저정보2://",userData)
        print("시그널 현재 화면에서 선택된 팻키://", DataCenter.shared.currentPetKey)
        if userData.userPet == DataCenter.shared.currentPetKey {
            // 만약 위에 코드처럼 UserDefault에 저장할경우 통신이 불필요하다.
            // 사용자 정보는 최초 가입혹은 수정시에만 변경되므로 통신사용을 하지 않을지 고민이된다.
            
            Database.database().reference().child("user_info").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                print(snapshot)
                if let userInfoSnapshot = snapshot.value as? [String:Any]{
                    
                    let userInfo = User(userInfoData: userInfoSnapshot)
                    print("조회한 유저데이터2://,",userInfo)
                    var userFunctionalIndexPath: [IndexPath] = []
                    for indexRow in userInfo.userPetFunctionalIndexPathRow {
                        userFunctionalIndexPath.append(IndexPath(row: indexRow, section: 0))
                    }
                    print("조회해온 유저정보의 기능성 인덱스 패스://", userFunctionalIndexPath)
                    //                        self.userSelectFunctionalIndexPath = userFunctionalIndexPath
                    //                        self.functionalCollectionView.reloadData()
                    
                    self.functionalIndexPath = userFunctionalIndexPath
                    
                    for indexpath in self.functionalIndexPath{
                        self.functionalCollectionView.selectItem(at: indexpath, animated: true, scrollPosition: .centeredVertically)
                    }
                    
                }
                
            })
        }else{
            self.functionalIndexPath = []
        }
         */
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
       
        let userInfo = DataCenter.shared.userInfo
        print("기능성에서 유저정보\(indexPath)://", userInfo.userPet,"//데이터센터 선택키://",DataCenter.shared.currentPetKey)
        
//        if functionalIndexPath.contains(indexPath) {
//            functionCell.isSelected = true
//            //            functionCell.functionalSelectInt = 1
//            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
//            //            functionalIndexPath.append(indexPath)
//        }else{
//            functionCell.isSelected = false
//            //            functionCell.functionalSelectInt = 0
//            collectionView.deselectItem(at: indexPath, animated: true)
//        }
        
        if userInfo.userPet == DataCenter.shared.currentPetKey {
            if functionalIndexPath.contains(indexPath) {
                functionCell.isSelected = true
                //            functionCell.functionalSelectInt = 1
                collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
                //            functionalIndexPath.append(indexPath)
            }else{
                functionCell.isSelected = false
                //            functionCell.functionalSelectInt = 0
                collectionView.deselectItem(at: indexPath, animated: true)
            }
        }else{
            if userIndexPath.contains(indexPath) {
                functionCell.isSelected = true
                collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
                
            }else{
                functionCell.isSelected = false
                //            functionCell.functionalSelectInt = 0
                collectionView.deselectItem(at: indexPath, animated: true)
            }

        }
 
        
//        if userInfo.userPet == DataCenter.shared.currentPetKey && functionalIndexPath.contains(indexPath) {
//            functionCell.isSelected = true
////            functionCell.functionalSelectInt = 1
//            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
////            functionalIndexPath.append(indexPath)
//        }else{
//            functionCell.isSelected = false
////            functionCell.functionalSelectInt = 0
//            collectionView.deselectItem(at: indexPath, animated: true)
//        }
        return functionCell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(functionalData[indexPath.row]["functionalKey"])
        userDataLoad = true
        // 전체 선택 클릭시 -  모든 선택값을 선택
        if indexPath.item == collectionView.numberOfItems(inSection: 0)-1 {
            // 확장한 코드
            if DataCenter.shared.userInfo.userPet != DataCenter.shared.currentPetKey {
                userIndexPath = collectionView.selectAll(animated: true)
            }else{

                functionalIndexPath = collectionView.selectAll(animated: true)
            }
            
//            functionalIndexPath = collectionView.selectAll(animated: true)
            
     
            //                functionalIndexPath.append(indexPath)
            print(functionalIndexPath)
            // 초기 구현함수
            //                for item in 0..<collectionView.numberOfItems(inSection: 0) {
            //                    collectionView.selectItem(at: IndexPath(row: item, section: 0), animated: false, scrollPosition: .centeredVertically)
            //            }
            
        }else{
//            if functionalIndexPath.contains(indexPath){
//                let indexInt = functionalIndexPath.index(of: indexPath)
//                print("기능성 선택한 값이 존재할경우 String:/",indexInt)
//                functionalIndexPath.remove(at: indexInt!)
//                print("------기능성 선택한 값이 존재할경우 slect 인덱스패스------: ",functionalIndexPath)
//            }
//            else{
//                functionalIndexPath.append(indexPath)
//                print("------기능성 선택한 값이 존재하지 않을경우 slect 인덱스패스------: ",functionalIndexPath)
//            }
//
//            let pathtest = IndexPath(item: collectionView.numberOfItems(inSection: 0)-1, section: 0)
//            print("PATHTEST://",pathtest)
//            if functionalIndexPath.count == 8{
//                let indexInt = functionalIndexPath.index(of: pathtest)
//                collectionView.selectItem(at: pathtest, animated: true, scrollPosition: .centeredVertically)
//
//                // 8개가되면 실제로 all이라는 키값은 할당하지 않고 UI만 표시해준다.
//                //                functionalIndexPath.append(pathtest)
//                //                functionalIndexPath = [pathtest]
//
//            }
            
            if DataCenter.shared.userInfo.userPet != DataCenter.shared.currentPetKey {
                if userIndexPath.contains(indexPath){
                    let indexInt = userIndexPath.index(of: indexPath)
                    print("기능성 선택한 값이 존재할경우 String:/",indexInt)
                    userIndexPath.remove(at: indexInt!)
                    print("------userIndexPath기능성 선택한 값이 존재할경우 slect 인덱스패스------: ",userIndexPath)
                }
                else{
                    userIndexPath.append(indexPath)
                    print("------userIndexPath기능성 선택한 값이 존재하지 않을경우 slect 인덱스패스------: ",userIndexPath)
                }
                
                let pathtest = IndexPath(item: collectionView.numberOfItems(inSection: 0)-1, section: 0)
                print("PATHTEST://",pathtest)
                if userIndexPath.count == 8{
                    let indexInt = userIndexPath.index(of: pathtest)
                    collectionView.selectItem(at: pathtest, animated: true, scrollPosition: .centeredVertically)
                    
                    // 8개가되면 실제로 all이라는 키값은 할당하지 않고 UI만 표시해준다.
                    //                functionalIndexPath.append(pathtest)
                    //                functionalIndexPath = [pathtest]
                    
                }
                
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

    }
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        
        
        return true
    }
    // didDeselectItemAt - 지정한 패스의 항목의 선택이 해제 된 것을 위양에 통지합니다
    // collectionView:didDeselectItemAtIndexPath: 다른 item을 Select하면서 원래 선택된 item이 Deselect 됩니다.
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        
        if indexPath.item == collectionView.numberOfItems(inSection: 0)-1 {
            
//            functionalIndexPath = []
            
            if DataCenter.shared.userInfo.userPet != DataCenter.shared.currentPetKey {
                userIndexPath = []
            }
            else{
                functionalIndexPath = []
            }
 
            collectionView.deselectAll(animated: true)
        }else{
            collectionView.deselectItem(at: IndexPath(item:  collectionView.numberOfItems(inSection: 0)-1, section: 0), animated: true)
            print(functionalIndexPath,"//",userIndexPath)
            // 전체 선택인지 확인을 위한 인덱스 패스 [0,8]
            let pathtest = IndexPath(item: collectionView.numberOfItems(inSection: 0)-1, section: 0)
            print(pathtest)
//            if functionalIndexPath.contains(pathtest){
//                let indexInt = functionalIndexPath.index(of: pathtest)
//                functionalIndexPath.remove(at: indexInt!)
//            }
//            if functionalIndexPath.contains(indexPath){
//                let indexInt = functionalIndexPath.index(of: indexPath)
//                print("기능성 didDeslect String:/",indexInt)
//                functionalIndexPath.remove(at: indexInt!)
//                print("------기능성 didDeslect 인덱스패스------: ",functionalIndexPath)
//            }
            
            if DataCenter.shared.userInfo.userPet != DataCenter.shared.currentPetKey {
                if userIndexPath.contains(pathtest){
                    let indexInt = userIndexPath.index(of: pathtest)
                    userIndexPath.remove(at: indexInt!)
                }
                if userIndexPath.contains(indexPath){
                    let indexInt = userIndexPath.index(of: indexPath)
                    print("userIndexPath기능성 didDeslect String:/",indexInt)
                    userIndexPath.remove(at: indexInt!)
                    print("------userIndexPath기능성 didDeslect 인덱스패스------: ",userIndexPath)
                }

            }else{
                if functionalIndexPath.contains(pathtest){
                    let indexInt = functionalIndexPath.index(of: pathtest)
                    functionalIndexPath.remove(at: indexInt!)
                }
                if functionalIndexPath.contains(indexPath){
                    let indexInt = functionalIndexPath.index(of: indexPath)
                    print("기능성 didDeslect String:/",indexInt)
                    functionalIndexPath.remove(at: indexInt!)
                    print("------기능성 didDeslect 인덱스패스------: ",functionalIndexPath)
                }
                
            }
 
        }
//        if functionalIndexPath.contains(indexPath){
//            let indexInt = functionalIndexPath.index(of: indexPath)
//            print("기능성 didDeslect String:/",indexInt)
//            functionalIndexPath.remove(at: indexInt!)
//            print("------기능성 didDeslect 인덱스패스------: ",functionalIndexPath)
//        }
        
    }
}
// FilterViewController와 관계를 가지는 FunctionalViewController에 데이터를 넘겨주기위한 확장
extension FunctionalViewController: FilterProtocol{
    func selectFilterData(filterData: FilterData, selectState: Bool) {
        self.sendFunctionalDelegate?.filterDataSend(filterData: filterData, selectState: selectState)
        if selectState{
            self.filterBtnOutlet.setBackgroundImage(#imageLiteral(resourceName: "filter_btn_check"), for: .normal)
        }else{
            self.filterBtnOutlet.setBackgroundImage(#imageLiteral(resourceName: "filterBtn"), for: .normal)
        }
    }
    
    
}
extension Notification.Name {
    static let feedAllDataNoti = Notification.Name("feedAllDataNoti")
    static let userPetTest = Notification.Name("userPetTest")
}
protocol FunctionalProtocol {
    func functionalKeySend(keyArr: [String])
    func filterDataSend(filterData: FilterData, selectState: Bool)
    
    
}


