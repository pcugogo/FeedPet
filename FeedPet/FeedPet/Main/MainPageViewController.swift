//
//  MainPageViewController.swift
//  FeedPet
//
//  Created by HwangGisu on 2018. 1. 9..
//  Copyright © 2018년 HwangGisu. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SwiftyJSON
import Firebase
import Kingfisher

class MainPageViewController: UIViewController,IndicatorInfoProvider {

    var indicatorTitle: String = ""{
        didSet{
            
            currentPetCheck()
        }
    }
    
    var delegate: LoadingIndicatorProtocol?
    
//    var feedData: [FeedInfo] = []
    var testReference: DatabaseReference = Database.database().reference()
    var ref: DatabaseReference = Database.database().reference()
    
    
    
    // 페이지네이션 데이터 변수
    var feedPagenationData = [FeedInfo]()
    // 사료키값을 담을 데이터
    var feedInfoStartKey: String!
    
    var feedAllData = [FeedInfo]() {
        didSet{
            // 사용자의 선택 반려동물과 현재 선택된 반려동물이 같을경우에는 노티
            print("피드올포://", DataCenter.shared.userInfo)
//            guard let loginUser = UserDefaults.standard.value(forKey: "loginUserData") as? User else {return}
//            if loginUser.userPet == currentPet {
            if DataCenter.shared.userInfo.userPet == currentPet {
            
                NotificationCenter.default.post(name: .feedAllDataNoti, object: nil, userInfo: nil)
            }else{
//                feedDataCountLoad()
                feedAllDataPagination(functionalKey: [])
//                NotificationCenter.default.post(name: .userPetTest, object: nil, userInfo: nil)
            }
        }
    }
    var feedInfoKey: String!
    // 기능성 선택에 따른 총 데이터
    var feedFunctionalFilteringData = [FeedInfo]()
    
    // 필터에서 선택한 값에 따른 총 데이터
    var feedFilterFilteringData = [FeedInfo]()
    // 필터에 값이 있는지 판단을 위한 변수 - 초기에는 필터 선택값이 없음
    // 모든 기능성 및 필터 데이터 적용된 토탈데이터
    var feedFilteringTotalData = [FeedInfo]()
    
    // 즐겨찾기 정보
    var feedBookMarkData: [String] = []
//    {
//        didSet{
//            self.feedInfoTableView.reloadData()
//        }
//    }

    var filterSelectFlag: Bool = false {
        didSet{
            print(filterSelectFlag)
            print(feedFilterFilteringData.count)
            print(feedFunctionalFilteringData.count)
//            if currentPet == DataCenter.shared.currentPetKey{
//
//            }
//            print(indicatorTitle,"//", currentPet,"//",DataCenter.shared.currentPetKey )
            if filterSelectFlag {
                feedFilteringTotalData = feedFilterFilteringData
            }else{
                feedFilteringTotalData = feedFunctionalFilteringData
            }
            DispatchQueue.main.async {
                self.feedListCountLabel.text = self.feedFilteringTotalData.count.description
                self.feedInfoTableView.reloadData()
//                self.feedInfoTableView.setContentOffset(.zero, animated: true)
                // 데이터 리도드후 최상위로 스크롤 이동을 위해 구현
//                let topIndex = IndexPath(row: 0, section: 0)
//                self.feedInfoTableView.scrollToRow(at: topIndex, at: .top, animated: false)
            }
        }
    }
    var filterItemDataInfo: FilterData?
    
    var filteringDataInfo = [FeedInfo]()
    var feedFilteringPaginationData = [FeedInfo]()
    var currentPageCount: Int = 0
    
    var currentPet = String()
    
    var dataLoadFlag: Bool = false {
        didSet{
            if dataLoadFlag {
                
            }
        }
    }
    
    var userUID = String()
    var feedBookMarkDic: [String:Bool] = [:]
    
    
    var loadingOnView: UIView?
    var loadinIndicatorViewController = LoadingIndicatorViewController()
    
    @IBOutlet weak var functionalContainerView: UIView!
    @IBOutlet weak var feedInfoTableView: UITableView!
    @IBOutlet weak var feedListCountLabel: UILabel!
    
    /*******************************************/
    //MARK:-        LifeCycle                  //
    /*******************************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feedInfoTableView.dataSource = self
        feedInfoTableView.delegate = self
        print(self.navigationController?.topViewController)
        print(self.parent?.navigationController)
        print(indicatorTitle)

        //        기존 테이블 전체 데이터 호출
        feedDataCountLoad()
        
        // 페이지네이션 데이터 - 최초 가입시 선택한 기능성에
//        feedDataHandlePagination()
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        userUID = uid
        
        
//        loadinIndicatorViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoadingIndicatorViewController") as! LoadingIndicatorViewController
        
        
        
//        ref.database.reference()
//        scrollDelegate = self
//        self.navigationController?.isNavigationBarHidden = true
        // Do any additional setup after loading the view.
//        DataCenter.shared.fromNib(toViewController: self)
//        DataCenter.shared.showActivityIndicatory(uiView: (self.parent?.view)! ,animating: true)
//        NotificationCenter.default.addObserver(self, selector: #selector(self.userDataUpdate(notification:)), name: .userDataUpdateNoti, object: nil)
          
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        feedDataCountLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.currentPetCheck()
//        print("강아지://",feedAllData.count)
        
        // 사용자의 정보 수정시 변경된 정보 있을경우 화면이동및 데이터 조회를 위한 분기처리
        if DataCenter.shared.userDataUpdate && DataCenter.shared.userUpdateCount < 3 {
            self.feedDataCountLoad()
//            self.viewDidLoad()
            
//            loadinIndicatorViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoadingIndicatorViewController") as! LoadingIndicatorViewController
            
        }
        // 데이터센터에 userUdpateCount라는 변수를 선언하여 뷰디드로드시 호출되는 feedDataCountLoad()
        // 카운트가 3이됬을 경우 userDataUpdate값과 count값을 초기화
        if  DataCenter.shared.userDataUpdate && DataCenter.shared.userUpdateCount > 2 {
//            DataCenter.shared.userDataUpdate = false
//            DataCenter.shared.userUpdateCount = 0
        }
        
        DispatchQueue.main.async {
            self.feedMoreInformationLoad()

            self.feedInfoTableView.reloadData()
        }
        //        if DataCenter.shared.userUpdateCount > 3{
//             DataCenter.shared.userUpdateCount = 0
//        }
//         feedDataCountLoad()
//        self.navigationController?.isNavigationBarHidden = true
//        setupAnimationForNavigationBar(caseOfFunction: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        self.navigationController?.isNavigationBarHidden = false
//        setupAnimationForNavigationBar(caseOfFunction: false)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "FuncitonalEmbeddedSegue") {
            // Container 뷰의 세그 ID값을 할당하여 데이터 전달 및 델리게이트 패턴 적용
            let functionalView = segue.destination as! FunctionalViewController
            functionalView.functionalData = DataCenter.shared.functionalSettingData(currentPet: currentPet)
            functionalView.sendFunctionalDelegate = self
            
            functionalView.withMainPageView = self
            
            // Now you have a pointer to the child view controller.
            // You can save the reference to it, or pass data to it.
            
        }
        
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    /*******************************************/
    //MARK:-     IndicatorInfoProvider         //
    /*******************************************/
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        var indicator = IndicatorInfo(title: nil, image: nil)
        if indicatorTitle == "멍" {
            indicator.title = "멍"
            indicator.image = #imageLiteral(resourceName: "dogAbleImg")
            
        }
        else{
            indicator.title = "냥"
            indicator.image = #imageLiteral(resourceName: "catAbleImg")
            
        }
        return indicator
        
    }
    
    /*******************************************/
    //MARK:-           Data 호출                //
    /*******************************************/
    // MARK: 전체 데이터 카운트 호출
    func feedDataCountLoad(){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
//        delegate?.loadingDisplay()
        
        
        
//        guard let loginUserData = UserDefaults.standard.value(forKey: "loginUserData") as? User else {return}
        
        // 사용자 반려동물이 고양이일 경우 강아지데이터 호출시에는 로딩뷰 호출하지 않는다.
        // 이 외의 경우호출
//        if currentPet == "feed_petkey_d" && DataCenter.shared.userInfo.userPet == "feed_petkey_c"{
//            if let loadingview = DataCenter.shared.loadingView {
//                delegate?.loadingRemoveDisplay(spinerView: loadingview)
////                delegate?.loadingIndicatorDisplay()
//            }
//        }else{
//            if let loadingview = DataCenter.shared.loadingView {
//                delegate?.loadingRemoveDisplay(spinerView: loadingview)
//                delegate?.loadingIndicatorDisplay()
//            }else{
//                delegate?.loadingIndicatorDisplay()
//            }
//        }
        if let loadingview = DataCenter.shared.loadingView {
            delegate?.loadingRemoveDisplay(spinerView: loadingview)
            delegate?.loadingIndicatorDisplay()
        }else{
             delegate?.loadingIndicatorDisplay()
        }
//        let indi = DataCenter.shared.displsyLoadingIndicator(onView: self.view)
        print("@@선택 반려동물://",currentPet)
        testReference.child("feed_info").child(currentPet).observeSingleEvent(of: .value, with: { (dataSnap) in
            print("@@데이터수://",dataSnap.childrenCount)
            guard let feedInfoListJson = dataSnap.value else {return}
            let feedJson = JSON(feedInfoListJson)
            var feedData = [FeedInfo]()
            if dataSnap.childrenCount > 0 {
                for feed in feedJson{
                    
                    let feedOne = FeedInfo(feedJsonData: feed)
//                    self.feedPagenationData.insert(feedOne, at: self.feedPagenationData.count)
                    feedData.append(feedOne)
                    
                }
                switch DataCenter.shared.sortingState{
                case .grade:
                    self.feedAllData = feedData.sorted(by: { (feedOne, feedTwo) -> Bool in
                        return feedOne.feedGrade < feedTwo.feedGrade
                    })
                    
                case .mouth:
                    self.feedAllData = feedData.sorted(by: { (feedOne, feedTwo) -> Bool in
                        return feedOne.feedMouth < feedTwo.feedMouth
                    })
                    
                }
//                self.feedAllData = feedData
//                self.delegate?.loadingRemoveDisplay()

//                self.feedMoreInformationLoad()
                
//                guard let uid = Auth.auth().currentUser?.uid  else {return}
//
//                Database.database().reference().child("user_info").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
//                    print(snapshot)
//                    if let userInfoSnapshot = snapshot.value as? [String:Any]{
//
//                        let userInfo = User(userInfoData: userInfoSnapshot)
//                        print("조회한 유저데이터2://,",userInfo)
//                        var userFunctionalIndexPath: [IndexPath] = []
//                        for indexRow in userInfo.userPetFunctionalIndexPathRow {
//                            userFunctionalIndexPath.append(IndexPath(row: indexRow, section: 0))
//                        }
//                        print("조회해온 유저정보의 기능성 인덱스 패스://", userFunctionalIndexPath)
//                        //                        self.userSelectFunctionalIndexPath = userFunctionalIndexPath
//                        //                        self.functionalCollectionView.reloadData()
//
//                        self.feedAllDataPagination(functionalKey: userInfo.userPetFunctional)
//                        self.feedInfoTableView.reloadData()
//                    }
//
//                })
//                DispatchQueue.main.async {
//
//                    // 필터링 테스트
//                    self.feedAllDataPagination(functionalKey: [])
//                    self.feedInfoTableView.reloadData()
                
//                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
////                    DataCenter.shared.removeSpinner(spinner: indi)
//
//                }
                
                
            }
            print(DataCenter.shared.mainPageLoadCount)
            DataCenter.shared.mainPageLoadCount += 1
            print(DataCenter.shared.mainPageLoadCount)
            print(self.feedInfoStartKey)
            print(self.feedPagenationData)
            
            // 리로드 되는 카운트 증가를 위해 분기처리-사용자가 수정했을경우
            if DataCenter.shared.userDataUpdate {
                // 카운트증가
                DataCenter.shared.userUpdateCount += 1
            }
            print("호요요요요://", DataCenter.shared.userDataUpdate, "//",DataCenter.shared.userUpdateCount)
            DispatchQueue.main.async {
                
                
                
//                self.feedListCountLabel.text = dataSnap.childrenCount.description
//                DataCenter.shared.nibRemove(toViewController: self)
//                self.delegate?.loadingRemoveDisplay()
//                let lodingView = DataCenter.shared.loadingOnView
//                self.delegate?.loadingRemoveDisplay(spinerView: lodingView)
//                self.delegate?.loadingIndicatorRemovView()
//                self.delegate?.loadingRemove()
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            
        }) { (error) in
            print(error)
        }
        
    }
    func selectFilterItem(filterItemData: FilterData, selectState: Bool){
        print(self.indicatorTitle)
        print("필터 값존재 여부://",selectState)
        let functionalKey =  [1,2]
        // 최초 페이지네이션 키 값이 nil일 경우
        var filterData = [FeedInfo]()
        var filteringData = [FeedInfo]()
        var isDataEmpty: Bool = false
//        var temporaryFeedInfoData: [FeedInfo] = []
        print(feedFilteringTotalData.count)
        feedFilterFilteringData = feedFunctionalFilteringData
        
        self.filterItemDataInfo = filterItemData
        filteringDataInfo = []
        print("필터에서 선택한 키값://",filterItemData)
//        guard let grade = filterItemData.grade else{ return }
        if let gradeData = filterItemData.grade {
            
//            let data = feedFilterFilteringData.filter({ (feedOne) -> Bool in
//
//               return gradeData.contains(where: { (grade) -> Bool in
//                if feedOne.feedGrade == grade{
//                    filteringData.append(feedOne)
//                }
//                    return feedOne.feedGrade == grade
//                })
//            })
//
//
//            print("필터정렬한데이터 등급://",filteringData,"//카운트://",filteringData.count)
//            filteringData = data
            if filteringDataInfo.isEmpty && !isDataEmpty {
                for grade in gradeData {
                    // 2. 전체 사료정보중 사료하나의 값을 할당
                    for feedOne in feedFilterFilteringData{
                        // 3. 이 키값이 전체데이터의 사료정보중 하나의 사료정보 기능성키에 존재하는지 판단
                        // 4. FilterData에 중복 데이터 제거하기위한 값 ==> 중복데이터가 있을수 없기에 변경하고 코드중복 함수로 관리 할 예정
                        let duplicationCheck = filterData.contains(where: { (feedInfo) -> Bool in
                            return feedInfo.feedKey == feedOne.feedKey
                        })
                        
                        if !duplicationCheck && feedOne.feedGrade == grade{
                            filterData.append(feedOne)
                        }

                    }
                }
                filteringDataInfo = filterData
                
            }else{
                var temporaryFeedInfoData: [FeedInfo] = []
                for grade in gradeData {
                    
                    // 2. 전체 사료정보중 사료하나의 값을 할당
                    for feedOne in filteringDataInfo{
                        // 3. 이 키값이 전체데이터의 사료정보중 하나의 사료정보 기능성키에 존재하는지 판단
                        // 4. FilterData에 중복 데이터 제거하기위한 값
                        let duplicationCheck = temporaryFeedInfoData.contains(where: { (feedInfo) -> Bool in
                            return feedInfo.feedKey == feedOne.feedKey
                        })
                        
                        if temporaryFeedInfoData.count < 1 && feedOne.feedGrade == grade{
                            //존재한다면 해당 사료의 값을 확인해보자.
                            // 테스트 이유=> ex) ["immune","joint"] 배열에 값이 여러개를 가진 사료를 처리하기위함
                            print("존재하는 사료 정보 확인1:", feedOne.feedGrade)
                            temporaryFeedInfoData.append(feedOne)
                            
                        }else if !duplicationCheck && feedOne.feedGrade == grade {
                            print("존재하는 사료 정보 확인2:", feedOne.feedGrade)
                            temporaryFeedInfoData.append(feedOne)
                        }
                        
                        
                    }
                }
                if temporaryFeedInfoData.isEmpty {
                    isDataEmpty = true
                }
                filteringDataInfo = temporaryFeedInfoData
            }
            
//            }else {
//                if gradeData.count > 1{
//                    for grade in gradeData {
//
//                        // 2. 전체 사료정보중 사료하나의 값을 할당
//                        for feedOne in feedFilterFilteringData{
//                            // 3. 이 키값이 전체데이터의 사료정보중 하나의 사료정보 기능성키에 존재하는지 판단
//                            // 4. FilterData에 중복 데이터 제거하기위한 값
//                            let duplicationCheck = filterData.contains(where: { (feedInfo) -> Bool in
//                                return feedInfo.feedKey == feedOne.feedKey
//                            })
//
//                            if filterData.count < 1 && feedOne.feedGrade == grade{
//                                //존재한다면 해당 사료의 값을 확인해보자.
//                                // 테스트 이유=> ex) ["immune","joint"] 배열에 값이 여러개를 가진 사료를 처리하기위함
//                                print("존재하는 사료 정보 확인1:", feedOne.feedGrade)
//                                filterData.append(feedOne)
//
//                            }else if !duplicationCheck && feedOne.feedGrade == grade {
//                                print("존재하는 사료 정보 확인2:", feedOne.feedGrade)
//                                filterData.append(feedOne)
//                            }
//
//
//                        }
//                    }
//
//                }else{
//
//                    for grade in gradeData {
//
//                        // 2. 전체 사료정보중 사료하나의 값을 할당
//                        for feedOne in filteringDataInfo{
//                            // 3. 이 키값이 전체데이터의 사료정보중 하나의 사료정보 기능성키에 존재하는지 판단
//                            // 4. FilterData에 중복 데이터 제거하기위한 값
//                            let duplicationCheck = filterData.contains(where: { (feedInfo) -> Bool in
//                                return feedInfo.feedKey == feedOne.feedKey
//                            })
//
//                            if filterData.count < 1 && feedOne.feedGrade == grade{
//                                //존재한다면 해당 사료의 값을 확인해보자.
//                                // 테스트 이유=> ex) ["immune","joint"] 배열에 값이 여러개를 가진 사료를 처리하기위함
//                                print("존재하는 사료 정보 확인1:", feedOne.feedGrade)
//                                filterData.append(feedOne)
//
//                            }else if !duplicationCheck && feedOne.feedGrade == grade {
//                                print("존재하는 사료 정보 확인2:", feedOne.feedGrade)
//                                filterData.append(feedOne)
//                            }
//
//
//                        }
//                    }
//                }
//
//
//            }
            
            print("filteringDataInfo 등급://",filteringDataInfo,"//카운트://",filteringDataInfo.count)
        }
        
        
        
        if let ageData = filterItemData.age {
            if filteringDataInfo.isEmpty && !isDataEmpty {
                for age in ageData {
                    
                    // 2. 전체 사료정보중 사료하나의 값을 할당
                    for feedOne in feedFilterFilteringData{
                        // 3. 이 키값이 전체데이터의 사료정보중 하나의 사료정보 기능성키에 존재하는지 판단
                        // 4. FilterData에 중복 데이터 제거하기위한 값
                        
                        let duplicationCheck = filterData.contains(where: { (feedInfo) -> Bool in
                            return feedInfo.feedKey == feedOne.feedKey
                        })
                        
                        if !duplicationCheck && feedOne.feedAge == age {
                            print("존재하는 사료 정보 확인2:", feedOne.feedAge)
                            filterData.append(feedOne)
                        }
                        
                        
                    }
                    
                    //                let a = self.feedFilteringData.filter{$0.feedGrade == grade}
                }
                filteringDataInfo = filterData

            }else {
                print("연령대 선택 기존에 값 잇지롱://", filteringDataInfo)
                
                var temporaryFeedInfoData: [FeedInfo] = []
                for age in ageData {
                    
                    // 2. 전체 사료정보중 사료하나의 값을 할당
                    for feedOne in filteringDataInfo{
                        // 3. 이 키값이 전체데이터의 사료정보중 하나의 사료정보 기능성키에 존재하는지 판단
                        // 4. FilterData에 중복 데이터 제거하기위한 값
                        let duplicationCheck = temporaryFeedInfoData.contains(where: { (feedInfo) -> Bool in
                            return feedInfo.feedKey == feedOne.feedKey
                        })
                        
                        if !duplicationCheck && feedOne.feedAge == age {
                            print("존재하는 사료 정보 확인2:", feedOne.feedAge)
                            temporaryFeedInfoData.append(feedOne)
                        }
                        
                        
                    }
                }
//                if ageData.count > 1{
//                    for age in ageData {
//
//                        // 2. 전체 사료정보중 사료하나의 값을 할당
//                        for feedOne in feedFilterFilteringData{
//                            // 3. 이 키값이 전체데이터의 사료정보중 하나의 사료정보 기능성키에 존재하는지 판단
//                            // 4. FilterData에 중복 데이터 제거하기위한 값
//                            let duplicationCheck = filterData.contains(where: { (feedInfo) -> Bool in
//                                return feedInfo.feedKey == feedOne.feedKey
//                            })
//
//                            if filterData.count < 1 && feedOne.feedAge == age{
//                                //존재한다면 해당 사료의 값을 확인해보자.
//                                // 테스트 이유=> ex) ["immune","joint"] 배열에 값이 여러개를 가진 사료를 처리하기위함
//                                print("존재하는 사료 정보 확인1:", feedOne.feedAge)
//                                filterData.append(feedOne)
//
//                            }else if !duplicationCheck && feedOne.feedAge == age {
//                                print("존재하는 사료 정보 확인2:", feedOne.feedAge)
//                                filterData.append(feedOne)
//                            }
//
//
//                        }
//                    }
//
//                }else{
//
//                    for age in ageData {
//
//                        // 2. 전체 사료정보중 사료하나의 값을 할당
//                        for feedOne in filteringDataInfo{
//                            // 3. 이 키값이 전체데이터의 사료정보중 하나의 사료정보 기능성키에 존재하는지 판단
//                            // 4. FilterData에 중복 데이터 제거하기위한 값
//                            let duplicationCheck = filterData.contains(where: { (feedInfo) -> Bool in
//                                return feedInfo.feedKey == feedOne.feedKey
//                            })
//
//                            if filterData.count < 1 && feedOne.feedAge == age{
//                                //존재한다면 해당 사료의 값을 확인해보자.
//                                // 테스트 이유=> ex) ["immune","joint"] 배열에 값이 여러개를 가진 사료를 처리하기위함
//                                print("존재하는 사료 정보 확인1:", feedOne.feedAge)
//                                filterData.append(feedOne)
//
//                            }else if !duplicationCheck && feedOne.feedAge == age {
//                                print("존재하는 사료 정보 확인2:", feedOne.feedAge)
//                                filterData.append(feedOne)
//                            }
//
//
//                        }
//                    }
//                }
                
                
                filteringDataInfo = temporaryFeedInfoData
            }
            if filteringDataInfo.isEmpty {
                isDataEmpty = true
            }
            print("filterData 연령대1://",filterData,"//연랭대 1카운트://",filterData.count)
            print("filterData 연령대2://",filteringDataInfo,"//연령대 2카운트://",filteringDataInfo.count)
            
        }
        
        // 주원료
        if let ingredientData = filterItemData.ingredient {
//            let data = feedFilterFilteringData.filter({ (feedOne) -> Bool in
//                return ingredientData.contains(where: { (ingredient) -> Bool in
//                    return feedOne.feedIngredient == ingredient
//                })
//            })
//            print("필터정렬한데이터 주원료://",data,"//카운트://",data.count)
//            feedFilterFilteringData = data
            print("선택 주원료 정보들://",ingredientData)
            if filteringDataInfo.isEmpty && !isDataEmpty{
                for ingrdient in ingredientData {
                    // 2. 전체 사료정보중 사료하나의 값을 할당
                    for feedOne in feedFilterFilteringData{
                        // 3. 이 키값이 전체데이터의 사료정보중 하나의 사료정보 기능성키에 존재하는지 판단
                        // 4. FilterData에 중복 데이터 제거하기위한 값
                        let duplicationCheck = filterData.contains(where: { (feedInfo) -> Bool in
                            return feedInfo.feedKey == feedOne.feedKey
                        })
                        
                        if !duplicationCheck && feedOne.feedIngredient == ingrdient {
                            print("존재하는 사료 정보 확인2:", feedOne.feedIngredient)
                            filterData.append(feedOne)
                        }
                        
                        
                    }
                }
                print(filterData)
                filteringDataInfo = filterData
            }else{
                
                var temporaryFeedInfoData: [FeedInfo] = []
                for ingrdient in ingredientData {
                    
                    // 2. 전체 사료정보중 사료하나의 값을 할당
                    for feedOne in filteringDataInfo{
                        // 3. 이 키값이 전체데이터의 사료정보중 하나의 사료정보 기능성키에 존재하는지 판단
                        // 4. FilterData에 중복 데이터 제거하기위한 값
                        let duplicationCheck = temporaryFeedInfoData.contains(where: { (feedInfo) -> Bool in
                            return feedInfo.feedKey == feedOne.feedKey
                        })
                        
                        if !duplicationCheck && feedOne.feedIngredient == ingrdient {
                            print("존재하는 사료 정보 확인2:", feedOne.feedIngredient)
                            temporaryFeedInfoData.append(feedOne)
                        }
                        
                        
                        
                    }
                }
                if temporaryFeedInfoData.isEmpty {
                    isDataEmpty = true
                }
                filteringDataInfo = temporaryFeedInfoData
                print("filterData temporaryFeedInfoData://",temporaryFeedInfoData,"//temporaryFeedInfoData 1카운트://",temporaryFeedInfoData.count)
            }
            print("filterData temporaryFeedInfoData2://",filteringDataInfo,"//temporaryFeedInfoData 2카운트://",filteringDataInfo.count)
        }
        
        
        

        // 브랜드
        if let brandData = filterItemData.brand {
//            let data = feedFilterFilteringData.filter({ (feedOne) -> Bool in
//                return brandData.contains(where: { (brand) -> Bool in
//                    return feedOne.feedBrand == brand
//                })
//            })
//            print("필터정렬한데이터 브랜드://",data,"//카운트://",data.count)
//            feedFilterFilteringData = data

                if filteringDataInfo.isEmpty && !isDataEmpty{
                    for brand in brandData {
                        // 2. 전체 사료정보중 사료하나의 값을 할당
                        for feedOne in feedFilterFilteringData{
                            // 3. 이 키값이 전체데이터의 사료정보중 하나의 사료정보 기능성키에 존재하는지 판단
                            // 4. FilterData에 중복 데이터 제거하기위한 값
                            let duplicationCheck = filterData.contains(where: { (feedInfo) -> Bool in
                                return feedInfo.feedKey == feedOne.feedKey
                            })
                            
                            if !duplicationCheck && feedOne.feedBrand == brand {
                                print("존재하는 사료 정보 확인2:", feedOne.feedIngredient)
                                filterData.append(feedOne)
                            }
                            
                            
                        }
                    }
                    filteringDataInfo = filterData
                }else{
                    
                    var temporaryFeedInfoData: [FeedInfo] = []
                    for brand in brandData {
                        
                        // 2. 전체 사료정보중 사료하나의 값을 할당
                        for feedOne in filteringDataInfo{
                            // 3. 이 키값이 전체데이터의 사료정보중 하나의 사료정보 기능성키에 존재하는지 판단
                            // 4. FilterData에 중복 데이터 제거하기위한 값
                            let duplicationCheck = temporaryFeedInfoData.contains(where: { (feedInfo) -> Bool in
                                return feedInfo.feedKey == feedOne.feedKey
                            })
                            
                            if !duplicationCheck && feedOne.feedBrand == brand {
                                print("존재하는 사료 정보 확인2:", feedOne.feedBrand)
                                temporaryFeedInfoData.append(feedOne)
                            }
                            
                            
                        }
                    }
                    if temporaryFeedInfoData.isEmpty {
                        isDataEmpty =  true
                    }
                    print("선택 주원료 정보들 분기카운트://",temporaryFeedInfoData.count,"//",temporaryFeedInfoData)
                    filteringDataInfo = temporaryFeedInfoData
                }
                
            
        }
        
        // 그레인프리
        if let grainFreeData = filterItemData.grinfreeFlag {
//            let data = feedFilterFilteringData.filter({ (feedOne) -> Bool in
//                return feedOne.grainfreeFlag == grainFreeData
//            })
//            print("필터정렬한데이터 그래인프리://",data,"//카운트://",data.count)
//            feedFilterFilteringData = data
            
            if filteringDataInfo.isEmpty && !isDataEmpty{
                for feedOne in feedFilterFilteringData{
                    let duplicationCheck = filterData.contains(where: { (feedInfo) -> Bool in
                        return feedInfo.feedKey == feedOne.feedKey
                    })
                    if !duplicationCheck && feedOne.grainfreeFlag == grainFreeData {
                        filterData.append(feedOne)
                    }
                
                }
                print(filterData)
                filteringDataInfo = filterData
            }else{
                var temporaryFeedInfoData: [FeedInfo] = []
                for feedOne in filteringDataInfo{
                    let duplicationCheck = temporaryFeedInfoData.contains(where: { (feedInfo) -> Bool in
                        return feedInfo.feedKey == feedOne.feedKey
                    })
                    if !duplicationCheck && feedOne.grainfreeFlag == grainFreeData {
                        temporaryFeedInfoData.append(feedOne)
                    }
                }
                if temporaryFeedInfoData.isEmpty {
                    isDataEmpty =  true
                }
                
                filteringDataInfo = temporaryFeedInfoData
            }
            
        }
    
        // 유기농/오가닉
        if let organicData = filterItemData.organicFlag {
            if filteringDataInfo.isEmpty && !isDataEmpty {
                for feedOne in feedFilterFilteringData{
                    let duplicationCheck = filterData.contains(where: { (feedInfo) -> Bool in
                        return feedInfo.feedKey == feedOne.feedKey
                    })
                    if !duplicationCheck && feedOne.organicFlag == organicData {
                        filterData.append(feedOne)
                    }
                    
                }
                print(filterData)
                filteringDataInfo = filterData
            }else{
                var temporaryFeedInfoData: [FeedInfo] = []
                for feedOne in filteringDataInfo{
                    let duplicationCheck = temporaryFeedInfoData.contains(where: { (feedInfo) -> Bool in
                        return feedInfo.feedKey == feedOne.feedKey
                    })
                    if !duplicationCheck && feedOne.organicFlag == organicData {
                        temporaryFeedInfoData.append(feedOne)
                    }
                }
                if temporaryFeedInfoData.isEmpty {
                    isDataEmpty = true
                }
                filteringDataInfo = temporaryFeedInfoData
            }
        }
        
        // LID
        if let lidData = filterItemData.lidFlag {
            if filteringDataInfo.isEmpty && !isDataEmpty {
                for feedOne in feedFilterFilteringData{
                    let duplicationCheck = filterData.contains(where: { (feedInfo) -> Bool in
                        return feedInfo.feedKey == feedOne.feedKey
                    })
                    if !duplicationCheck && feedOne.lidFlag == lidData {
                        filterData.append(feedOne)
                    }
                    
                }
                print(filterData)
                filteringDataInfo = filterData
            }else{
                var temporaryFeedInfoData: [FeedInfo] = []
                for feedOne in filteringDataInfo{
                    let duplicationCheck = temporaryFeedInfoData.contains(where: { (feedInfo) -> Bool in
                        return feedInfo.feedKey == feedOne.feedKey
                    })
                    if !duplicationCheck && feedOne.lidFlag == lidData {
                        temporaryFeedInfoData.append(feedOne)
                    }
                }
                if temporaryFeedInfoData.isEmpty {
                    isDataEmpty = true
                }
                filteringDataInfo = temporaryFeedInfoData
            }
        }
        
        // 대형견/묘
        if let bitPetData = filterItemData.bigPetFlag {
            if filteringDataInfo.isEmpty && !isDataEmpty {
                for feedOne in feedFilterFilteringData{
                    let duplicationCheck = filterData.contains(where: { (feedInfo) -> Bool in
                        return feedInfo.feedKey == feedOne.feedKey
                    })
                    if !duplicationCheck && feedOne.bigFlag == bitPetData {
                        filterData.append(feedOne)
                    }
                    
                }
                
                print(filterData)
                filteringDataInfo = filterData
            }else{
                var temporaryFeedInfoData: [FeedInfo] = []
                for feedOne in filteringDataInfo{
                    let duplicationCheck = temporaryFeedInfoData.contains(where: { (feedInfo) -> Bool in
                        return feedInfo.feedKey == feedOne.feedKey
                    })
                    if !duplicationCheck && feedOne.bigFlag == bitPetData {
                        temporaryFeedInfoData.append(feedOne)
                    }
                }
                if temporaryFeedInfoData.isEmpty {
                    isDataEmpty = true
                }
                filteringDataInfo = temporaryFeedInfoData
            }
        }
        
        
//        feedFilterFilteringData = filterData
        print(filteringDataInfo)
        feedFilterFilteringData = filteringDataInfo
        self.filterSelectFlag = selectState
        print("필터에서 선택완료한 필터링된 총 데이터://",feedFilterFilteringData,"//총카운트://",feedFilterFilteringData.count)
        print(self.feedFilteringTotalData.count.description)
        
        
        
    }
    
    
    func feedAllDataPagination(functionalKey: [String]){
//        delegate?.loadingDisplay()
        /*
        if let pageControllBaseViewCon = self.parent {
            
//            if let view = self.loadingOnView {
//                self.loadingOnView = nil
//                DataCenter.shared.removeSpinner(spinner: view)
//            }else{
//                // 본인이 선택한 반려동물의 경우에서 addSubview가 두번된다...
//                    self.loadingOnView = DataCenter.shared.displsyLoadingIndicator(onView: pageControllBaseViewCon.view)
//
//
//            }
            
            if !self.loadinIndicatorViewController.loadingState {
//                pageControllBaseViewCon.present(loadinIndicatorViewController, animated: false, completion: nil)
                self.loadinIndicatorViewController.loadingState = true
                pageControllBaseViewCon.present(loadinIndicatorViewController, animated: true, completion: {
//                    self.loadinIndicatorViewController.loadingState = true
                })
                
            }else{
                loadinIndicatorViewController.loadingViewDismiss()

            }
            
            

        }else{
           
        }
        
        */
        
//        DataCenter.shared.loadingOnViewDisplay(onView: <#T##UIView#>)
        
        // 사용자 반려동물이 고양이일 경우 강아지데이터 호출시에는 로딩뷰 호출하지 않는다.
        // 이 외의 경우호출
//        if currentPet == "feed_petkey_d" && DataCenter.shared.userInfo.userPet == "feed_petkey_c"{
////            if let loadingview = DataCenter.shared.loadingView {
////                delegate?.loadingRemoveDisplay(spinerView: loadingview)
////                //                delegate?.loadingIndicatorDisplay()
////            }
//        }else{
//            if let pageControllBaseViewCon = self.parent {
//                loadinView = DataCenter.shared.displsyLoadingIndicator(onView: pageControllBaseViewCon.view)
//            }else{
//
//            }
////            if let loadingview = DataCenter.shared.loadingView {
////                delegate?.loadingRemoveDisplay(spinerView: loadingview)
//////                delegate?.loadingIndicatorDisplay()
////            }else{
////                delegate?.loadingIndicatorDisplay()
////            }
//
//        }//        delegate?.loadingIndicatorDisplay()
//
        
        // 로딩인디케이터 뷰 값이 존재하면
//        if let loadingView = self.loadingOnView {
//            self.loadingOnView = nil
//            DataCenter.shared.removeSpinner(spinner: loadingView)
//
//
////            delegate?.loadingRemoveDisplay(spinerView: loadingview)
////            delegate?.loadingIndicatorDisplay()
////            delegate?.loadingRemoveToDisplay(spinerView: loadingview)
//        }else{
//            if let pageControllBaseViewCon = self.parent {
//                if pageControllBaseViewCon.view.subviews.count < 5{
//                    self.loadingOnView = DataCenter.shared.displsyLoadingIndicator(onView: pageControllBaseViewCon.view)
//                }
//
//            }else{
//                self.loadingOnView = nil
//            }
////            delegate?.loadingIndicatorDisplay()
//        }
//        guard let pageControlBaseViewCon = self.parent else {return}
//        let loadingView = DataCenter.shared.displsyLoadingIndicator(onView: pageControlBaseViewCon.view)
        
        // 최초 페이지네이션 키 값이 nil일 경우
        var filterData = [FeedInfo]()
        self.feedMoreInformationLoad()
        print(indicatorTitle)
        print("선택한 키값에 맞는 사료정보이때 키값://",functionalKey)
        
        if functionalKey.count != 0{
            // 1. 먼저 기능성 키값에 String 값을 할당
            for key in functionalKey {
                // key => [String] 배열에 하나의 값
                // 2. 전체 사료정보중 사료하나의 값을 할당
                for feedOne in feedAllData{
                    // 3. 이 키값이 전체데이터의 사료정보중 하나의 사료정보 기능성키에 존재하는지 판단
                    // 4. FilterData에 중복 데이터 제거하기위한 값
                    let duplicationCheck = filterData.contains(where: { (feedInfo) -> Bool in
                        return feedInfo.feedKey == feedOne.feedKey
                    })
                    
                    if filterData.count < 1 && feedOne.feedFunctional.contains(key){
                        //존재한다면 해당 사료의 값을 확인해보자.
                        // 테스트 이유=> ex) ["immune","joint"] 배열에 값이 여러개를 가진 사료를 처리하기위함
                        print("존재하는 사료 정보 확인1:", feedOne.feedKey)
                        filterData.append(feedOne)
                        
                    }else if !duplicationCheck && feedOne.feedFunctional.contains(key) {
                        print("존재하는 사료 정보 확인2:", feedOne.feedKey)
                        filterData.append(feedOne)
                    }
                    
                }
            }
            switch DataCenter.shared.sortingState{
            case .grade:
                feedFunctionalFilteringData = filterData.sorted(by: { (feedOne, feedTwo) -> Bool in
                    return feedOne.feedGrade < feedTwo.feedGrade
                })
                
            case .mouth:
                feedFunctionalFilteringData = filterData.sorted(by: { (feedOne, feedTwo) -> Bool in
                    return feedOne.feedMouth < feedTwo.feedMouth
                })
                
            }
//            feedFunctionalFilteringData = filterData.sorted(by: { (feedOne, feedTwo) -> Bool in
//                return feedOne.feedName < feedTwo.feedName
//            })
            
        }else{
            feedFunctionalFilteringData = feedAllData
        }
        feedFilteringTotalData = feedFunctionalFilteringData
        
        if let filterItem = filterItemDataInfo {
            self.selectFilterItem(filterItemData: filterItem, selectState: filterSelectFlag)
            
        }else{
            DispatchQueue.main.async {
                self.feedListCountLabel.text = self.feedFunctionalFilteringData.count.description
                print("리로드하는 데이터의 타이틀://",self.indicatorTitle)
               
//                self.delegate?.loadingRemoveDisplay()
                print(DataCenter.shared.currentPetKey)
//                DataCenter.shared.loadingOnViewRemove(onView: self.loadingOnView)
//                DataCenter.shared.removeSpinner(spinner: loadinView)
                
                
                
                
                if let loadingView = self.loadingOnView {
//                    self.loadingOnView = nil
//                    DataCenter.shared.removeSpinner(spinner: loadingView)


                    //            delegate?.loadingRemoveDisplay(spinerView: loadingview)
                    //            delegate?.loadingIndicatorDisplay()
                    //            delegate?.loadingRemoveToDisplay(spinerView: loadingview)
                }else{

                    //            if let pageControllBaseViewCon = self.parent {
                    //                self.loadingOnView = DataCenter.shared.displsyLoadingIndicator(onView: pageControllBaseViewCon.view)
                    //            }
                    //            delegate?.loadingIndicatorDisplay()
                }
//                self.loadinIndicatorViewController.loadingViewDismiss()
//                print(self.loadinIndicatorViewController.loadingState)
//                self.delegate?.loadingRemove()
                
                self.feedInfoTableView.reloadData()
            }
        }
        
//        DataCenter.shared.removeSpinner(spinner: loadingView)
//        if let loadingview = DataCenter.shared.loadingView {
//            print(loadingview)
//            delegate?.loadingRemoveDisplay(spinerView: loadingview)
// 
//        }
        
        
        print("정렬기능성://",feedFunctionalFilteringData,"//카운트:",feedFunctionalFilteringData.count)
        
        
        
        
//        print("필터데이터://",filterData,"/카운트:", filterData.count)
//        let reference = Database.database().reference().child("feed_info").child(currentPet).queryOrdered(byChild: "feed_functional").queryEqual(toValue: "immune")
//        reference.observeSingleEvent(of: .value, with: { (data) in
//            print("퉤스트://",data.value)
//        }, withCancel: nil)
        if currentPageCount == 0 {
            for index in 0...10 {
//                feedFilteringPaginationData.append(feedFilteringData[index])
            }
        }else{
            
        }
    }
    
    // MARK: 사료 정보 페이징 처리를 위한 함수
    func feedDataHandlePagination(){
        print("---현재 반려동물----",currentPet)
        // 현재 고양이 데이터만 존재하므로 curretnPet 부분을 "feed_petkey_c"로 임시 작업
        let reference = Database.database().reference().child("feed_info").child(currentPet).queryOrderedByKey()
        if feedInfoStartKey == nil{
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            reference.queryLimited(toFirst: 10).observeSingleEvent(of: .value, with: { (dataSnap) in
                guard let children = dataSnap.children.allObjects.last as? DataSnapshot else {return}
                guard let feedInfoListJson = dataSnap.value else {return}
                let feedJson = JSON(feedInfoListJson)
                
                if dataSnap.childrenCount > 0 {
                    for feed in feedJson{
                        print(feed.0)
                        let feedOne = FeedInfo(feedJsonData: feed)
                        self.feedPagenationData.append(feedOne)
                    }
                    self.feedInfoStartKey = children.key
                    DispatchQueue.main.async {
                        
                        self.feedInfoTableView.reloadData()
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    }
                    print(self.feedInfoStartKey)
                    print(self.feedPagenationData)
                }
            })
        }else {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            reference.queryStarting(atValue: self.feedInfoStartKey).queryLimited(toFirst: 5).observeSingleEvent(of: .value, with: { (dataSnap) in
                guard let children = dataSnap.children.allObjects.last as? DataSnapshot else {return}
                print(children.key)
                guard let feedInfoListJson = dataSnap.value else {return}
                let feedJson = JSON(feedInfoListJson)
                if dataSnap.childrenCount > 0 {
                    for feed in feedJson{

                        if feed.0 != self.feedInfoStartKey {
                            let feedOne = FeedInfo(feedJsonData: feed)
                            self.feedPagenationData.insert(feedOne, at: self.feedPagenationData.count)
                        }
                        
                    }
                    self.feedInfoStartKey = children.key
                    DispatchQueue.main.async {
                        self.feedInfoTableView.reloadData()
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    }
                    print(self.feedInfoStartKey)
                    print(self.feedPagenationData)
                }
            })
        }
//        feedMoreInformationLoad()
        
//        ref.child("feed_info").child(currentPet).queryOrderedByKey().queryLimited(toLast: 10).observeSingleEvent(of: .value, with: { (dataSnap) in
//
//            if dataSnap.childrenCount > 0{
//                for child in dataSnap.children.allObjects as! [DataSnapshot]{
//                    let item = child.value as! (String, JSON)
//                    let feedInfo = FeedInfo(feedJsonData: item)
//                    self.feedPagenationData.insert(feedInfo, at: 0)
//                }
//
//            }
//        }) { (error) in
//            print(error)
//        }
    }
    /*******************************************/
    //MARK:-         Class Method              //
    /*******************************************/
    // MARK: 현재 반려동물 체크 메서드
    func currentPetCheck(){
        if indicatorTitle == "멍" {
            currentPet = "feed_petkey_d"
            DataCenter.shared.currentPetKey = currentPet
        }else{
            currentPet = "feed_petkey_c"
            DataCenter.shared.currentPetKey = currentPet
        }
//        self.feedInfoTableView.reloadData()
    }
    
//    func setupAnimationForNavigationBar(caseOfFunction: Bool) {
//        if caseOfFunction == true {
//            UIView.animate(withDuration: 0.5) {
//                self.navigationController?.navigationBar.transform = CGAffineTransform(translationX: 0, y: -200)
//            }
//        } else {
//            UIView.animate(withDuration: 0.5, animations: {
//                self.navigationController?.navigationBar.transform = CGAffineTransform.identity
//            })
//        }
//
//    }
    
    func moreData() {
        for index in 0...5{
            
        }
    }
    
    func feedMoreInformationLoad(){
        DispatchQueue.main.async {
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
//        if let loadingview = DataCenter.shared.loadingView {
//            //            delegate?.loadingRemoveDisplay(spinerView: loadingview)
//            //            delegate?.loadingIndicatorDisplay()
//            delegate?.loadingRemoveDisplay(spinerView: loadingview)
//        }else{
//            delegate?.loadingIndicatorDisplay()
//        }
//       delegate?.loadingIndicatorDisplay()
        Database.database().reference().child("my_favorite").child(userUID).observeSingleEvent(of: .value, with: { (dataSnap) in
            var isBookMark: Bool = false
            print("즐겨찾기 data://",dataSnap.value)
            
            if let bookMakrValue = dataSnap.children.allObjects as? [DataSnapshot] {
                var bookMarkData: [String] = []
                for child in bookMakrValue {
                    guard let feedKey = child.childSnapshot(forPath: "feed_key").value as? String else {return}
                    bookMarkData.append(feedKey)
                }
                print("내즐찾정보:///", bookMarkData)
                self.feedBookMarkData = bookMarkData
            }
            
             UIApplication.shared.isNetworkActivityIndicatorVisible = false
//            if let loadingview = DataCenter.shared.loadingView {
//                self.delegate?.loadingRemoveDisplay(spinerView: loadingview)
//
//            }
//               self.delegate?.loadingRemoveDisplay()
            if let loadingview = DataCenter.shared.loadingView {
                self.delegate?.loadingRemoveDisplay(spinerView: loadingview)
                
            }
            self.feedInfoTableView.reloadData()
        }) { (error) in
            print("----bookMakrError://",error.localizedDescription)
        }
    }
    func bookMarkSet(isBookMark: Bool, feedKey: String){
        print("넘어온 즐겨찾기 값//", isBookMark," 사료키값://", feedKey)
        let bookMarkRef = Database.database().reference().child("my_favorite").child(userUID)
        // 최초등록
        if isBookMark {
            // 즐겨찾기 추가
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            var bookMarkData: [String:Any] = [:]
            bookMarkData.updateValue(feedKey, forKey: "feed_key")
            
            
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ko")
            formatter.dateFormat = "yyyy.MM.dd HH:mm"
            let currentDataString = formatter.string(from: Date())
            print("날짜2://, ", currentDataString)
            bookMarkData.updateValue(currentDataString, forKey: "favorites_date")
            bookMarkRef.childByAutoId().setValue(bookMarkData)
            print("즐겨찾기 데이터://", bookMarkData)
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            
        }
        else{ // 기존에 데이터 존재시 삭제
            bookMarkRef.observeSingleEvent(of: .value, with: { (dataSnap) in
                guard let childrenValue = dataSnap.children.allObjects as? [DataSnapshot] else{return}
                for bookMark in childrenValue{
                    if bookMark.childSnapshot(forPath: "feed_key").value as? String == feedKey{
                        print("즐겨찾기존지하는 키://",bookMark.key)
                        bookMarkRef.child(bookMark.key).removeValue()
                    }
                }
            })
        }
        DispatchQueue.main.async {
            self.feedMoreInformationLoad()
            self.feedInfoTableView.reloadData()
        }
        
        
    }
   
        
    @objc func userDataUpdate(notification: Notification){
       self.viewDidLoad()
    }
}
extension MainPageViewController: UITableViewDelegate, UITableViewDataSource{
    /*************************************************/
    //MARK:-  TableViewDelegate, TableViewDataSource //
    /*************************************************/
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return feedFilteringTotalData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let feedCell = tableView.dequeueReusableCell(withIdentifier: "FeedMainInfoCell", for: indexPath) as! FeedMainInfoTableViewCell
        print(self.feedFilteringTotalData[indexPath.row].feedBrand)
        feedCell.feedBrandLabel.text = self.feedFilteringTotalData[indexPath.row].feedBrand
        feedCell.feedNameLabel.text = self.feedFilteringTotalData[indexPath.row].feedName
        
        // 셀의 이벤트후 메인뷰컨트롤러에서 행동을 하기위한 델리게이트 선언
        feedCell.delegate = self
        
        feedCell.feedKey = self.feedFilteringTotalData[indexPath.row].feedKey
        let gradeInt: Int = self.feedFilteringTotalData[indexPath.row].feedGrade
//        let gradeText: String = FeedGrade.init(rawValue: gradeInt)?.gardeText() ?? "no-data"
//        feedCell.feedGradeLabel.text = gradeText

        // Enum을 통해 해당 셀의 레이블의 값 할당 과 텍스트 컬러 변경 => 좋은방법일지 생각해보고 좋지않다면 함수로 분리하여 호출하자
        FeedGrade.init(rawValue: gradeInt)?.gradeText(label: feedCell.feedGradeLabel)

        // Enum을 통한 입소문 이미지 할당 위에 코드와 동일 한 구조
        FeedMouthGrade.init(rawValue: self.feedFilteringTotalData[indexPath.row].feedMouth)?.mouthImgSetting(mouthImgView: feedCell.feedMouthImgView)

        // 포장방식 분기처리
        if self.feedFilteringTotalData[indexPath.row].feedPackageFlag {
            feedCell.feedPackageLabel.text = "소분포장"
        }else{
            feedCell.feedPackageLabel.text = "전체포장"
        }
        feedCell.feedIngredientLabel.text = self.feedFilteringTotalData[indexPath.row].feedIngredient


        if let urlStr = self.feedFilteringTotalData[indexPath.row].feedImg.first, let url = URL(string: urlStr){

            feedCell.feedImgView.kf.setImage(with: url)
//            DispatchQueue.main.async {
//
//            }

        }

        let ref = Database.database().reference()
        
        ref.child("feed_review").child(feedFilteringTotalData[indexPath.row].feedKey).observeSingleEvent(of: .value, with: { (dataSnap) in
            // 1. 리뷰의 갯수가 필요하
//            print(feedDataInfo.feedKey)
            guard let data = dataSnap.value else {return}
            
            let oneReviewData = FeedReview(feedReviewJSON: JSON(data), feedKey: dataSnap.key)
            feedCell.reviewData = oneReviewData
            print("리뷰하나의정보://",oneReviewData)
//            feedCell.feedReviewCount.text = dataSnap.childSnapshot(forPath: "review_info").childrenCount.description
//            print("사료\(self.feedFilteringTotalData[indexPath.row].feedKey)별점://",dataSnap.value)
//            let reviewRatingScore = oneReviewData.reviewRating ?? 0
//            guard let reviewRating = dataSnap.childSnapshot(forPath: "review_rating").value as? Int else {return}
            
//            print(reviewRating)
            // Enum을 사용하여 default 경우 제외
            

            // 2. 선택한 사료에 대한 자식데이터 분기
//            if dataSnap.childrenCount > 0 {
//                guard let reviewData = dataSnap.value else {return}
//                let reviewDataJSON = JSON(reviewData)
//                print(reviewDataJSON)
//                print(dataSnap.childSnapshot(forPath: "review_info").childrenCount)
//                DispatchQueue.main.async {
//
//                    feedCell.feedReviewCount.text = dataSnap.childSnapshot(forPath: "review_info").childrenCount.description
//                    guard let reviewRating = dataSnap.childSnapshot(forPath: "review_rating").value as? Int else {return}
//                    print(reviewRating)
//                    // Enum을 사용하여 default 경우 제외
//                    switch reviewRating {
//                    case 1:
//                        feedCell.firstStarImg.image = #imageLiteral(resourceName: "selectStar")
//                        feedCell.secontdStarImg.image = #imageLiteral(resourceName: "normalStar")
//                        feedCell.thirdStarImg.image = #imageLiteral(resourceName: "normalStar")
//                        feedCell.fourthStarImg.image = #imageLiteral(resourceName: "normalStar")
//                        feedCell.fifthStarImg.image = #imageLiteral(resourceName: "normalStar")
//                    case 2:
//                        feedCell.firstStarImg.image = #imageLiteral(resourceName: "selectStar")
//                        feedCell.secontdStarImg.image = #imageLiteral(resourceName: "selectStar")
//                        feedCell.thirdStarImg.image = #imageLiteral(resourceName: "normalStar")
//                        feedCell.fourthStarImg.image = #imageLiteral(resourceName: "normalStar")
//                        feedCell.fifthStarImg.image = #imageLiteral(resourceName: "normalStar")
//                    case 3:
//                        feedCell.firstStarImg.image = #imageLiteral(resourceName: "selectStar")
//                        feedCell.secontdStarImg.image = #imageLiteral(resourceName: "selectStar")
//                        feedCell.thirdStarImg.image = #imageLiteral(resourceName: "selectStar")
//                        feedCell.fourthStarImg.image = #imageLiteral(resourceName: "normalStar")
//                        feedCell.fifthStarImg.image = #imageLiteral(resourceName: "normalStar")
//                    case 4:
//                        feedCell.firstStarImg.image = #imageLiteral(resourceName: "selectStar")
//                        feedCell.secontdStarImg.image = #imageLiteral(resourceName: "selectStar")
//                        feedCell.thirdStarImg.image = #imageLiteral(resourceName: "selectStar")
//                        feedCell.fourthStarImg.image = #imageLiteral(resourceName: "selectStar")
//                        feedCell.fifthStarImg.image = #imageLiteral(resourceName: "normalStar")
//                    case 5:
//                        feedCell.firstStarImg.image = #imageLiteral(resourceName: "selectStar")
//                        feedCell.secontdStarImg.image = #imageLiteral(resourceName: "selectStar")
//                        feedCell.thirdStarImg.image = #imageLiteral(resourceName: "selectStar")
//                        feedCell.fourthStarImg.image = #imageLiteral(resourceName: "selectStar")
//                        feedCell.fifthStarImg.image = #imageLiteral(resourceName: "selectStar")
//                    default:
//                        feedCell.firstStarImg.image = #imageLiteral(resourceName: "normalStar")
//                        feedCell.secontdStarImg.image = #imageLiteral(resourceName: "normalStar")
//                        feedCell.thirdStarImg.image = #imageLiteral(resourceName: "normalStar")
//                        feedCell.fourthStarImg.image = #imageLiteral(resourceName: "normalStar")
//                        feedCell.fifthStarImg.image = #imageLiteral(resourceName: "normalStar")
//                    }
//
//                }
//            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
    
       
        if feedBookMarkData.contains(self.feedFilteringTotalData[indexPath.row].feedKey) {
//            feedCell.bookMarkBtn.setBackgroundImage(#imageLiteral(resourceName: "bookMarkAble"), for: .normal)
            feedCell.isBookMark = true
        }else{
//            feedCell.bookMarkBtn.setBackgroundImage(#imageLiteral(resourceName: "bookMarkDisable"), for: .normal)
            feedCell.isBookMark = false
        }
       self.feedBookMarkDic.updateValue(feedCell.isBookMark, forKey: self.feedFilteringTotalData[indexPath.row].feedKey)
        ref.child("my_favorite").child(userUID).child(self.feedFilteringTotalData[indexPath.row].feedKey).observeSingleEvent(of: .value, with: { (dataSnap) in
            var isBookMark: Bool = false
            print("즐겨찾기 data://",dataSnap.value)
//            if dataSnap.hasChildren() {
//                feedCell.bookMarkBtn.setBackgroundImage(#imageLiteral(resourceName: "bookMarkAble"), for: .normal)
//            }else{
//                feedCell.bookMarkBtn.setBackgroundImage(#imageLiteral(resourceName: "bookMarkDisable"), for: .normal)
//            }
//
//            if let bookMakrValue = dataSnap.children.allObjects as? [DataSnapshot] {
//
//                for child in bookMakrValue {
//                    if self.feedFilteringTotalData[indexPath.row].feedKey == child.childSnapshot(forPath: "feed_key").value as? String {
//                        print("이때 북마크://", child)
////                        feedCell.bookMarkBtn.setBackgroundImage(#imageLiteral(resourceName: "bookMarkAble"), for: .normal)
//                                                feedCell.isBookMark = true
//                    }else{
//                        feedCell.bookMarkBtn.setBackgroundImage(#imageLiteral(resourceName: "bookMarkDisable"), for: .normal)
//                                                feedCell.isBookMark = false
//                    }
//
//                }
//
//            }
//            print("북마크://",bookMakrValue)

//            if dataSnap.hasChildren() {
//                feedCell.bookMarkBtn.setBackgroundImage(#imageLiteral(resourceName: "bookMarkAble"), for: .normal)
//                isBookMark = true
//            }else{
//                feedCell.bookMarkBtn.setBackgroundImage(#imageLiteral(resourceName: "bookMarkDisable"), for: .normal)
//            }
//            // 내 즐겨찾기 정보 상태 전달을위해 feedBookMarkDic 정보에 값 저장
//            self.feedBookMarkDic.updateValue(isBookMark, forKey: self.feedFilteringTotalData[indexPath.row].feedKey)

        }) { (error) in
            print("----bookMakrError://",error.localizedDescription)
        }

//        feedCell.feedData = self.feedFilteringTotalData[indexPath.row]
        
        return feedCell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        let feedDetailData: FeedInfo = feedFilteringTotalData[indexPath.row]
        print("----select FeedData ----",feedDetailData)
        let feedDetailView: FeedDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "FeedDetailView") as! FeedDetailViewController
        feedDetailView.delegate = self
        feedDetailView.feedDetailInfo = feedDetailData
        
        feedDetailView.isBookMark = feedBookMarkDic[feedFilteringTotalData[indexPath.row].feedKey] ?? false
        
        
        delegate?.loadingIndicatorDisplay()
        DataCenter.shared.feedDetailIngredientDataLoad(feedKey: feedDetailData.feedKey) { (feedDetailIngredientData) in
            print(feedDetailIngredientData)
            feedDetailView.ingredientData = feedDetailIngredientData
            
//            feedDetailView.navigationItem.title = feedDetailData.feedName
            feedDetailView.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            DispatchQueue.main.async {
                
                self.parent?.navigationController?.pushViewController(feedDetailView, animated: true)
                self.delegate?.loadingRemoveDisplay()
            }
        }
        
//        Database.database().reference().child("feed_review").child(feedFilteringTotalData[indexPath.row].feedKey).observeSingleEvent(of: .value, with: { (dataSnap) in
//            // 1. 리뷰의 갯수가 필요하
//            //            print(feedDataInfo.feedKey)
//            guard let data = dataSnap.value else {return}
//
//            let oneReviewData = FeedReview(feedReviewJSON: JSON(data), feedKey: dataSnap.key)
//            feedDetailView.reviewInfo = oneReviewData
//            print("리뷰하나의정보://",oneReviewData)
//            feedDetailView.navigationItem.title = feedDetailData.feedName
//            feedDetailView.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
//
////            print(feedDetailView.navigationItem.backBarButtonItem)
//            DispatchQueue.main.async {
//
//
//                self.parent?.navigationController?.pushViewController(feedDetailView, animated: true)
//                self.delegate?.loadingRemoveDisplay()
//            }
//        }) { (error) in
//            print(error.localizedDescription)
//        }
//
//
        
        
//        self.parent?.navigationController?.pushViewController(feedDeatilView, animated: true)

//        self.parent?.navigationController?.pushViewController(feedDeatilView, animated: true)
//        self.present(feedDeatilView, animated: true, completion: nil)
    }
    
    // 테이블뷰 페이지네이션
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == feedPagenationData.count - 1 {
            // 데이터 호출
//            feedDataHandlePagination()
            
            currentPageCount = indexPath.row
        }
        
    }
    
    
    // 스크롤 뷰가 끝나는 시점 델리게이트 메서드
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        let currentOffset = scrollView.contentOffset.y
        print("-- CurrentOffSet --- " , currentOffset)
        print("-- scrollView.contentSize.height --- " , scrollView.contentSize.height)
        print("-- scrollView.frame.height --- " , scrollView.frame.height)
        
        let maxOffSet = scrollView.contentSize.height - scrollView.frame.height
        print("-- maxOffSet --- " , maxOffSet)
        
        print(maxOffSet - currentOffset)
        // 수정필요
        if maxOffSet - currentOffset <= 600 {
//            self.feedDataHandlePagination()
        }
        
    }
}

extension MainPageViewController: FunctionalProtocol{
    func filterDataSend(filterData: FilterData, selectState: Bool) {
        selectFilterItem(filterItemData: filterData, selectState: selectState)
    }
    
    func functionalKeySend(keyArr: [String]) {
        print(keyArr)
        
        print("22222테스트중:///",indicatorTitle,"//", currentPet,"//",DataCenter.shared.currentPetKey,"/",keyArr ,"------")
        //로그인하나 사용자의 반려동물 자식뷰로 이동후 선택한 기능성 인덱스 값 선택시 호출이 될대
        //현재 선택된 반려동물의 값에 따라 호출 값 분기처리
        
        
        
        if currentPet == DataCenter.shared.currentPetKey {
            feedAllDataPagination(functionalKey: keyArr)
        }else{
//            feedAllDataPagination(functionalKey: [])
        }
    }

    
    
}
extension MainPageViewController: FeedMainInfoCellProtocol{
    func sendBookMarkValue(isBookMark: Bool, feedKey: String) {
        print("넘어온 즐겨찾기 값//", isBookMark," 사료키값://", feedKey)
        let bookMarkRef = Database.database().reference().child("my_favorite").child(userUID)
        // 최초등록
        if isBookMark {
            // 즐겨찾기 추가
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            var bookMarkData: [String:Any] = [:]
            bookMarkData.updateValue(feedKey, forKey: "feed_key")
            //            let date = Date()
            //            let calendar = Calendar.current
            //            let components = calendar.dateComponents([.year, .month, .day], from: date)
            //
            //            let year =  components.year
            //            let month = components.month
            //            let day = components.day
            //
            //            print("날짜1://, ", "\(year).\(d)")
            //            print(month)
            //            print(day)
            
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ko")
            formatter.dateFormat = "yyyy.MM.dd HH:mm"
            let currentDataString = formatter.string(from: Date())
            print("날짜2://, ", currentDataString)
            bookMarkData.updateValue(currentDataString, forKey: "favorites_date")
            bookMarkRef.childByAutoId().setValue(bookMarkData)
            print("즐겨찾기 데이터://", bookMarkData)
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            DispatchQueue.main.async {
                self.feedMoreInformationLoad()
                //                self.feedInfoTableView.reloadData()
            }
            
        }
        else{ // 기존에 데이터 존재시 삭제
            bookMarkRef.observeSingleEvent(of: .value, with: { (dataSnap) in
                guard let childrenValue = dataSnap.children.allObjects as? [DataSnapshot] else{return}
                for bookMark in childrenValue{
                    if bookMark.childSnapshot(forPath: "feed_key").value as? String == feedKey{
                        print("즐겨찾기존지하는 키://",bookMark.key)
                        bookMarkRef.child(bookMark.key).removeValue()
                    }
                }
                DispatchQueue.main.async {
                    self.feedMoreInformationLoad()
                    //                    self.feedInfoTableView.reloadData()
                }
            })
        }
        
        
        /*
         if isBookMark{
         UIApplication.shared.isNetworkActivityIndicatorVisible = true
         var bookMarkData: [String:Any] = [:]
         bookMarkData.updateValue(feedKey, forKey: "feed_key")
         //            let date = Date()
         //            let calendar = Calendar.current
         //            let components = calendar.dateComponents([.year, .month, .day], from: date)
         //
         //            let year =  components.year
         //            let month = components.month
         //            let day = components.day
         //
         //            print("날짜1://, ", "\(year).\(d)")
         //            print(month)
         //            print(day)
         
         let formatter = DateFormatter()
         formatter.locale = Locale(identifier: "ko")
         formatter.dateFormat = "yyyy.MM.dd HH:mm"
         let currentDataString = formatter.string(from: Date())
         print("날짜2://, ", currentDataString)
         bookMarkData.updateValue(currentDataString, forKey: "favorites_date")
         bookMarkRef.setValue(bookMarkData)
         print("즐겨찾기 데이터://", bookMarkData)
         UIApplication.shared.isNetworkActivityIndicatorVisible = false
         //            self.feedInfoTableView.reloadData()
         }else{
         let cancelLikeAlert:UIAlertController = UIAlertController(title: "", message: "좋아요를 취소 하시겠습니까?", preferredStyle: .alert)
         
         let okBtn:UIAlertAction = UIAlertAction(title: "네", style: .default){ (action) in
         
         UIApplication.shared.isNetworkActivityIndicatorVisible = true
         FireBaseData.shared.refFavoritesReturn.child(self.userUID).childByAutoId().child(feedKey).removeValue()
         UIApplication.shared.isNetworkActivityIndicatorVisible = false
         self.feedInfoTableView.reloadData()
         
         }
         let noBtn:UIAlertAction = UIAlertAction(title: "아니오", style: .cancel, handler: nil)
         
         cancelLikeAlert.addAction(okBtn)
         cancelLikeAlert.addAction(noBtn)
         
         self.present(cancelLikeAlert, animated: true, completion: nil)
         }
         */
    }
    
    
    
    
    
    
    
    
}
enum FeedGrade: Int{
    case ratingOrganic = 0
    case ratingHolistic = 1
    case ratingSuperPremium = 2
    case ratingPremium = 3
    case ratingGroceryBrand = 4
    case ratingNo = 5
    
    func gradeText(label: UILabel){
        switch self {
        case .ratingOrganic:
            label.textColor = UIColor.init(hexString: "338FCB")
            label.text = "오가닉"
        case .ratingHolistic:
            label.textColor = UIColor.init(hexString: "2EA55E")
            label.text = "홀리스틱"
        case .ratingSuperPremium:
            label.textColor = UIColor.init(hexString: "FFE200")
            label.text = "슈퍼프리미엄"
        case .ratingPremium:
            label.textColor = UIColor.init(hexString: "F39800")
            label.text = "프리미엄"
        case .ratingGroceryBrand:
            label.textColor = UIColor.init(hexString: "C30D23")
            label.text = "마트용"
        case .ratingNo:
            label.textColor = UIColor.init(hexString: "bebebe")
            label.text = "측정불가"
        }
        //case .ratingOrganic:
        //label.textColor = UIColor.init(hexString: "")
        //label.text = "오가닉"
        //return "오가닉"
        //case .ratingHolistic:
        //return "홀리스틱"
        //case .ratingSuperPremium:
        //return "슈퍼프리미엄"
        //case .ratingPremium:
        //return "프리미엄"
        //case .ratingGroceryBrand:
        //return "마트용"
        //default:
        //return "측정 불가"
        //}

    
    }
}


// 현재는 테스트로 작성
// 입소문 부분 이부분은 에셋이미지 명을 변경하여 구현가능 찬욱이와 상의후 제거 할수있음
enum FeedMouth: String{
    case Good = "mouth_g"
    case Soso = "mouth_s"
    case Bad = "mouth_b"

    
    func mouthImgSetting(mouthImgView: UIImageView!){
        switch self {
        case .Good:
            mouthImgView.image = #imageLiteral(resourceName: "good")
        case .Soso:
            mouthImgView.image = #imageLiteral(resourceName: "soso")
        case .Bad:
            mouthImgView.image = #imageLiteral(resourceName: "bad")
        
        }
        
    }
}

enum FeedMouthGrade: Int{
    case Good = 0
    case Soso = 1
    case Bad = 2
    
    
    func mouthImgSetting(mouthImgView: UIImageView!){
        switch self {
        case .Good:
            mouthImgView.image = #imageLiteral(resourceName: "good")
        case .Soso:
            mouthImgView.image = #imageLiteral(resourceName: "soso")
        case .Bad:
            mouthImgView.image = #imageLiteral(resourceName: "bad")
            
        }
        
    }
}


// SwiftyGif 활용한 인데케이터 사용을 위한 프로토콜
protocol LoadingIndicatorProtocol {
    func loadingIndicatorDisplay()
    func loadingRemoveDisplay()
    func loadingRemoveDisplay(spinerView: UIView?)
    func loadingRemoveToDisplay(spinerView: UIView?)
    
    func loadingIndicatorSubView()
    func loadingIndicatorRemovView()
    
    // 다시
    func loadingDisplay()
    func loadingRemove()
}


