//
//  FilterViewController.swift
//  FeedPet
//
//  Created by HwangGisu on 2018. 1. 14..
//  Copyright © 2018년 HwangGisu. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {
    
    @IBOutlet weak var filterMenuTableView: UITableView!
    var dogBrand: [FilterMenuInner] = [FilterMenuInner(cellType: "Detail",
                                                       checkState: false,
                                                       gradeImg: nil,
                                                       textLabel: "네츄럴코어",
                                                       filterValue: "네츄럴코어"),
                                       FilterMenuInner(cellType: "Detail",
                                                       checkState: false,
                                                       gradeImg: nil,
                                                       textLabel: "로얄캐닌",
                                                       filterValue: "로얄캐닌"),
                                       FilterMenuInner(cellType: "Detail",
                                                       checkState: false,
                                                       gradeImg: nil,
                                                       textLabel: "ANF",
                                                       filterValue: "ANF"),
                                       FilterMenuInner(cellType: "Detail",
                                                       checkState: false,
                                                       gradeImg: nil,
                                                       textLabel: "풀무원",
                                                       filterValue: "풀무원"),
                                       FilterMenuInner(cellType: "Detail",
                                                       checkState: false,
                                                       gradeImg: nil,
                                                       textLabel: "뉴트리나",
                                                       filterValue: "뉴트리나"),
                                       FilterMenuInner(cellType: "Detail",
                                                       checkState: false,
                                                       gradeImg: nil,
                                                       textLabel: "도비",
                                                       filterValue: "도비"),
                                       FilterMenuInner(cellType: "Detail",
                                                       checkState: false,
                                                       gradeImg: nil,
                                                       textLabel: "NOW",
                                                       filterValue: "NOW"),
                                       FilterMenuInner(cellType: "Detail",
                                                       checkState: false,
                                                       gradeImg: nil,
                                                       textLabel: "이즈칸",
                                                       filterValue: "이즈칸"),
                                       FilterMenuInner(cellType: "Detail",
                                                       checkState: false,
                                                       gradeImg: nil,
                                                       textLabel: "도그랑",
                                                       filterValue: "도그랑"),
                                       FilterMenuInner(cellType: "Detail",
                                                       checkState: false,
                                                       gradeImg: nil,
                                                       textLabel: "시저",
                                                       filterValue: "시저"),
                                       FilterMenuInner(cellType: "Detail",
                                                       checkState: false,
                                                       gradeImg: nil,
                                                       textLabel: "건강백서",
                                                       filterValue: "건강백서"),
                                       FilterMenuInner(cellType: "Detail",
                                                       checkState: false,
                                                       gradeImg: nil,
                                                       textLabel: "하루애",
                                                       filterValue: "하루애"),
                                       FilterMenuInner(cellType: "Detail",
                                                       checkState: false,
                                                       gradeImg: nil,
                                                       textLabel: "알포",
                                                       filterValue: "알포"),
                                       FilterMenuInner(cellType: "Detail",
                                                       checkState: false,
                                                       gradeImg: nil,
                                                       textLabel: "내추럴발란스",
                                                       filterValue: "내추럴발란스"),
                                       FilterMenuInner(cellType: "Detail",
                                                       checkState: false,
                                                       gradeImg: nil,
                                                       textLabel: "퓨리나",
                                                       filterValue: "퓨리나"),
                                       FilterMenuInner(cellType: "Detail",
                                                       checkState: false,
                                                       gradeImg: nil,
                                                       textLabel: "오가다이어트",
                                                       filterValue: "오가다이어트"),
                                       FilterMenuInner(cellType: "Detail",
                                                       checkState: false,
                                                       gradeImg: nil,
                                                       textLabel: "닥터도비",
                                                       filterValue: "닥터도비"),
                                       FilterMenuInner(cellType: "Detail",
                                                       checkState: false,
                                                       gradeImg: nil,
                                                       textLabel: "대한사료",
                                                       filterValue: "대한사료")]
    var catBrand: [FilterMenuInner] = [FilterMenuInner(cellType: "Detail",
                                                       checkState: false,
                                                       gradeImg: nil,
                                                       textLabel: "로얄캐닌",
                                                       filterValue: "로얄캐닌"),
                                       FilterMenuInner(cellType: "Detail",
                                                       checkState: false,
                                                       gradeImg: nil,
                                                       textLabel: "프로베스트",
                                                       filterValue: "프로베스트"),
                                       FilterMenuInner(cellType: "Detail",
                                                       checkState: false,
                                                       gradeImg: nil,
                                                       textLabel: "캐츠랑",
                                                       filterValue: "캐츠랑"),
                                       FilterMenuInner(cellType: "Detail",
                                                       checkState: false,
                                                       gradeImg: nil,
                                                       textLabel: "뉴트리나",
                                                       filterValue: "뉴트리나"),
                                       FilterMenuInner(cellType: "Detail",
                                                       checkState: false,
                                                       gradeImg: nil,
                                                       textLabel: "이즈칸",
                                                       filterValue: "이즈칸"),
                                       FilterMenuInner(cellType: "Detail",
                                                       checkState: false,
                                                       gradeImg: nil,
                                                       textLabel: "퓨리나",
                                                       filterValue: "퓨리나"),
                                       FilterMenuInner(cellType: "Detail",
                                                       checkState: false,
                                                       gradeImg: nil,
                                                       textLabel: "뉴트로",
                                                       filterValue: "뉴트로"),
                                       FilterMenuInner(cellType: "Detail",
                                                       checkState: false,
                                                       gradeImg: nil,
                                                       textLabel: "프리미엄엣지",
                                                       filterValue: "프리미엄엣지"),
                                       FilterMenuInner(cellType: "Detail",
                                                       checkState: false,
                                                       gradeImg: nil,
                                                       textLabel: "내츄럴초이스",
                                                       filterValue: "내츄럴초이스"),
                                       FilterMenuInner(cellType: "Detail",
                                                       checkState: false,
                                                       gradeImg: nil,
                                                       textLabel: "슈슈",
                                                       filterValue: "슈슈"),
                                       FilterMenuInner(cellType: "Detail",
                                                       checkState: false,
                                                       gradeImg: nil,
                                                       textLabel: "ANF",
                                                       filterValue: "ANF"),
                                       FilterMenuInner(cellType: "Detail",
                                                       checkState: false,
                                                       gradeImg: nil,
                                                       textLabel: "리얼오가닉",
                                                       filterValue: "리얼오가닉"),
                                       FilterMenuInner(cellType: "Detail",
                                                       checkState: false,
                                                       gradeImg: nil,
                                                       textLabel: "치킨수프",
                                                       filterValue: "치킨수프"),
                                       FilterMenuInner(cellType: "Detail",
                                                       checkState: false,
                                                       gradeImg: nil,
                                                       textLabel: "네츄럴코어",
                                                       filterValue: "네츄럴코어"),
                                       FilterMenuInner(cellType: "Detail",
                                                       checkState: false,
                                                       gradeImg: nil,
                                                       textLabel: "커클랜드",
                                                       filterValue: "커클랜드"),
                                       FilterMenuInner(cellType: "Detail",
                                                       checkState: false,
                                                       gradeImg: nil,
                                                       textLabel: "사나벨",
                                                       filterValue: "사나벨")]
    var dogIngredient: [FilterMenuInner] = [FilterMenuInner(cellType: "Detail",
                                                            checkState: false,
                                                            gradeImg: nil,
                                                            textLabel: "고구마",
                                                            filterValue: "고구마"),
                                            FilterMenuInner(cellType: "Detail",
                                                            checkState: false,
                                                            gradeImg: nil,
                                                            textLabel: "곡물",
                                                            filterValue: "곡물"),
                                            FilterMenuInner(cellType: "Detail",
                                                            checkState: false,
                                                            gradeImg: nil,
                                                            textLabel: "과일/야채",
                                                            filterValue: "과일/야채"),
                                            FilterMenuInner(cellType: "Detail",
                                                            checkState: false,
                                                            gradeImg: nil,
                                                            textLabel: "닭",
                                                            filterValue: "닭"),
                                            FilterMenuInner(cellType: "Detail",
                                                            checkState: false,
                                                            gradeImg: nil,
                                                            textLabel: "밤",
                                                            filterValue: "밤"),
                                            FilterMenuInner(cellType: "Detail",
                                                            checkState: false,
                                                            gradeImg: nil,
                                                            textLabel: "생선",
                                                            filterValue: "생선"),
                                            FilterMenuInner(cellType: "Detail",
                                                            checkState: false,
                                                            gradeImg: nil,
                                                            textLabel: "소",
                                                            filterValue: "소"),
                                            FilterMenuInner(cellType: "Detail",
                                                            checkState: false,
                                                            gradeImg: nil,
                                                            textLabel: "양",
                                                            filterValue: "양"),
                                            FilterMenuInner(cellType: "Detail",
                                                            checkState: false,
                                                            gradeImg: nil,
                                                            textLabel: "연어",
                                                            filterValue: "연어"),
                                            FilterMenuInner(cellType: "Detail",
                                                            checkState: false,
                                                            gradeImg: nil,
                                                            textLabel: "오리",
                                                            filterValue: "오리"),
                                            FilterMenuInner(cellType: "Detail",
                                                            checkState: false,
                                                            gradeImg: nil,
                                                            textLabel: "칠면조",
                                                            filterValue: "칠면조"),
                                            FilterMenuInner(cellType: "Detail",
                                                            checkState: false,
                                                            gradeImg: nil,
                                                            textLabel: "캥거루",
                                                            filterValue: "캥거루")]
    var catIngredient: [FilterMenuInner] = [FilterMenuInner(cellType: "Detail",
                                                            checkState: false,
                                                            gradeImg: nil,
                                                            textLabel: "고등어",
                                                            filterValue: "고등어"),
                                            FilterMenuInner(cellType: "Detail",
                                                            checkState: false,
                                                            gradeImg: nil,
                                                            textLabel: "곡물",
                                                            filterValue: "곡물"),
                                            FilterMenuInner(cellType: "Detail",
                                                            checkState: false,
                                                            gradeImg: nil,
                                                            textLabel: "꿩",
                                                            filterValue: "꿩"),
                                            FilterMenuInner(cellType: "Detail",
                                                            checkState: false,
                                                            gradeImg: nil,
                                                            textLabel: "닭",
                                                            filterValue: "닭"),
                                            FilterMenuInner(cellType: "Detail",
                                                            checkState: false,
                                                            gradeImg: nil,
                                                            textLabel: "돼지",
                                                            filterValue: "돼지"),
                                            FilterMenuInner(cellType: "Detail",
                                                            checkState: false,
                                                            gradeImg: nil,
                                                            textLabel: "사슴",
                                                            filterValue: "사슴"),
                                            FilterMenuInner(cellType: "Detail",
                                                            checkState: false,
                                                            gradeImg: nil,
                                                            textLabel: "생선",
                                                            filterValue: "생선"),
                                            FilterMenuInner(cellType: "Detail",
                                                            checkState: false,
                                                            gradeImg: nil,
                                                            textLabel: "소",
                                                            filterValue: "소"),
                                            FilterMenuInner(cellType: "Detail",
                                                            checkState: false,
                                                            gradeImg: nil,
                                                            textLabel: "송어",
                                                            filterValue: "송어"),
                                            FilterMenuInner(cellType: "Detail",
                                                            checkState: false,
                                                            gradeImg: nil,
                                                            textLabel: "양",
                                                            filterValue: "양"),
                                            FilterMenuInner(cellType: "Detail",
                                                            checkState: false,
                                                            gradeImg: nil,
                                                            textLabel: "연어",
                                                            filterValue: "연어"),
                                            FilterMenuInner(cellType: "Detail",
                                                            checkState: false,
                                                            gradeImg: nil,
                                                            textLabel: "오리",
                                                            filterValue: "오리"),
                                            FilterMenuInner(cellType: "Detail",
                                                            checkState: false,
                                                            gradeImg: nil,
                                                            textLabel: "정어리",
                                                            filterValue: "정어리"),
                                            FilterMenuInner(cellType: "Detail",
                                                            checkState: false,
                                                            gradeImg: nil,
                                                            textLabel: "참치",
                                                            filterValue: "참치"),
                                            FilterMenuInner(cellType: "Detail",
                                                            checkState: false,
                                                            gradeImg: nil,
                                                            textLabel: "청어",
                                                            filterValue: "청어"),
                                            FilterMenuInner(cellType: "Detail",
                                                            checkState: false,
                                                            gradeImg: nil,
                                                            textLabel: "칠면조",
                                                            filterValue: "칠면조"),
                                            FilterMenuInner(cellType: "Detail",
                                                            checkState: false,
                                                            gradeImg: nil,
                                                            textLabel: "타조",
                                                            filterValue: "타조"),
                                            FilterMenuInner(cellType: "Detail",
                                                            checkState: false,
                                                            gradeImg: nil,
                                                            textLabel: "토끼",
                                                            filterValue: "토끼"),]
    var testFilterMenuSection = [
                FilterMenuSections(menu: "등급",
                                   filterMenuKind: [
                                                    FilterMenuInner(cellType: "GradeDetail",
                                                                    checkState: false,
                                                                    gradeImg: "ratingOrganic",
                                                                    textLabel: "유기농",
                                                                    filterValue: 0),
                                                    FilterMenuInner(cellType: "GradeDetail",
                                                                    checkState: false,
                                                                    gradeImg: "ratingHolistic",
                                                                    textLabel: "홀리스틱",
                                                                    filterValue: 1),
                                                    FilterMenuInner(cellType: "GradeDetail",
                                                                    checkState: false,
                                                                    gradeImg: "ratingSuperPremium",
                                                                    textLabel: "슈퍼프리미엄",
                                                                    filterValue: 2),
                                                    FilterMenuInner(cellType: "GradeDetail",
                                                                    checkState: false,
                                                                    gradeImg: "ratingPremium",
                                                                    textLabel: "프리미엄",
                                                                    filterValue: 3),
                                                    FilterMenuInner(cellType: "GradeDetail",
                                                                    checkState: false,
                                                                    gradeImg: "ratingGroceryBrand",
                                                                    textLabel: "마트용",
                                                                    filterValue: 4)
                                                    ],
                                   expanded: false),
                FilterMenuSections(menu: "연령대",
                                   filterMenuKind: [
                                    FilterMenuInner(cellType: "Detail",
                                                    checkState: false,
                                                    gradeImg: nil,
                                                    textLabel: "전연령",
                                                    filterValue: 0),
                                    FilterMenuInner(cellType: "Detail",
                                                    checkState: false,
                                                    gradeImg: nil,
                                                    textLabel: "퍼피/키튼",
                                                    filterValue: 1),
                                    FilterMenuInner(cellType: "Detail",
                                                    checkState: false,
                                                    gradeImg: nil,
                                                    textLabel: "어덜트",
                                                    filterValue: 2),
                                    FilterMenuInner(cellType: "Detail",
                                                    checkState: false,
                                                    gradeImg: nil,
                                                    textLabel: "시니어",
                                                    filterValue: 3)
                                    ],
                                   expanded: false),
                FilterMenuSections(menu: "주원료",
                                   filterMenuKind: [
                                    FilterMenuInner(cellType: "Detail",
                                                    checkState: false,
                                                    gradeImg: nil,
                                                    textLabel: "닭",
                                                    filterValue: "닭"),
                                    FilterMenuInner(cellType: "Detail",
                                                    checkState: false,
                                                    gradeImg: nil,
                                                    textLabel: "소",
                                                    filterValue: "소"),
                                    FilterMenuInner(cellType: "Detail",
                                                    checkState: false,
                                                    gradeImg: nil,
                                                    textLabel: "오리",
                                                    filterValue: "오리")
                    ],
                                   expanded: false),
                // 중량은 일단빼둬야할것 같다. 사료정보에는 2,4,10형태의 값으로 존재하기에
//                FilterMenuSections(menu: "중량",
//                                   filterMenuKind: [
//                                    FilterMenuInner(cellType: "Detail",
//                                                    checkState: false,
//                                                    gradeImg: nil,
//                                                    textLabel: "1kg이하"),
//                                    FilterMenuInner(cellType: "Detail",
//                                                    checkState: false,
//                                                    gradeImg: nil,
//                                                    textLabel: "1kg~2kg이하"),
//                                    FilterMenuInner(cellType: "Detail",
//                                                    checkState: false,
//                                                    gradeImg: nil,
//                                                    textLabel: "2kg~5kg이하"),
//                                    FilterMenuInner(cellType: "Detail",
//                                                    checkState: false,
//                                                    gradeImg: nil,
//                                                    textLabel: "5kg~10kg이하"),
//                                    FilterMenuInner(cellType: "Detail",
//                                                    checkState: false,
//                                                    gradeImg: nil,
//                                                    textLabel: "10kg~15kg이하"),
//                                    FilterMenuInner(cellType: "Detail",
//                                                    checkState: false,
//                                                    gradeImg: nil,
//                                                    textLabel: "15kg이상")
//                    ],
//                                   expanded: false),
                FilterMenuSections(menu: "브랜드",
                                   filterMenuKind: [
                                    FilterMenuInner(cellType: "Detail",
                                                    checkState: false,
                                                    gradeImg: nil,
                                                    textLabel: "로얄캐닌",
                                                    filterValue: "로얄캐닌"),
                                    FilterMenuInner(cellType: "Detail",
                                                    checkState: false,
                                                    gradeImg: nil,
                                                    textLabel: "캣츠랑",
                                                    filterValue: "캣츠랑"),
                                    FilterMenuInner(cellType: "Detail",
                                                    checkState: false,
                                                    gradeImg: nil,
                                                    textLabel: "ANF",
                                                    filterValue: "ANF")
                    ],
                                   expanded: false),
                FilterMenuSections(menu: "그래인프리 여부",
                                   filterMenuKind: [
                                    FilterMenuInner(cellType: "Detail",
                                                    checkState: false,
                                                    gradeImg: nil,
                                                    textLabel: "그래인프리",
                                                    filterValue: "그래인프리")
                                    
                                    ],
                                   expanded: false),
                FilterMenuSections(menu: "유기농/오가닉 여부",
                                   filterMenuKind: [
                                    FilterMenuInner(cellType: "Detail",
                                                    checkState: false,
                                                    gradeImg: nil,
                                                    textLabel: "유기농/오가닉",
                                                    filterValue: "유기농/오가닉")
                                    
                    ],
                                   expanded: false),
                FilterMenuSections(menu: "LID 여부",
                                   filterMenuKind: [
                                    FilterMenuInner(cellType: "Detail",
                                                    checkState: false,
                                                    gradeImg: nil,
                                                    textLabel: "LID",
                                                    filterValue: "LID")
                                    
                    ],
                                   expanded: false),
                FilterMenuSections(menu: "대형견/묘 여부",
                                   filterMenuKind: [
                                    FilterMenuInner(cellType: "Detail",
                                                    checkState: false,
                                                    gradeImg: nil,
                                                    textLabel: "대형견/묘",
                                                    filterValue: "대형견/묘")
                                    
                    ],
                                   expanded: false)
                            
        ]
    
    var feedGradeIndexPath: [IndexPath] = [] {
        didSet{
//            DispatchQueue.global(qos: .userInteractive).async {
                DataCenter.shared.filterGrade = self.feedGradeIndexPath
                self.functionalChangeToString()
//            }
        }
    }
    var filterIndexPath: [IndexPath] = [] {
        didSet{
             DataCenter.shared.filterIndexPathArr = self.filterIndexPath
        }
    }
    
    var filterDataLoadFlag: Bool = false
    
    var filterIndexPathDicArr: [Int:[IndexPath]] = [:] {
        didSet{
            
            if curretPetKey == "feed_petkey_d" {
                DataCenter.shared.filterDogIndexPathDicArr = filterIndexPathDicArr
//                if filterIndexPathDicArr.isEmpty {
//                    DataCenter.shared.filterDogIndexPathDicArr = [:]
//                    filterMenuTableView.reloadData()
//                }
            }else{
                DataCenter.shared.filterCatIndexPathDicArr = filterIndexPathDicArr
//                if filterIndexPathDicArr.isEmpty {
//                    DataCenter.shared.filterCatIndexPathDicArr = [:]
//                    filterMenuTableView.reloadData()
//                }
            }
//            DataCenter.shared.filterIndexPathDicArr = filterIndexPathDicArr
            self.filterDataChangeToValue()
        }
    }
    var filterDelegate: FilterProtocol?
    
    var feedIngredientIndexPath : [IndexPath] = []
    var feedGrainfreeFlag: Bool = false
    var feedOrganicFlag: Bool = false
    var feedLidFlag: Bool = false
    var big_flag: Bool = false
    var curretPetKey: String = "feed_petkey_d"
    var feedGradeKeyString: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
//        filterMenuTableView.delegate = self
//        filterMenuTableView.dataSource = self
        self.curretPetKey = DataCenter.shared.currentPetKey
        let filterMenuNib = UINib(nibName: "FilterMenuHeaderView", bundle: nil)
        filterMenuTableView.register(filterMenuNib, forHeaderFooterViewReuseIdentifier: "filterMenuHeaderView")
        filterMenuTableView.allowsMultipleSelection = true
        var temporaryMenuSecion: [FilterMenuSections] = testFilterMenuSection
        for index in 0..<temporaryMenuSecion.count{
            if temporaryMenuSecion[index].menu == "브랜드"{
                if curretPetKey == "feed_petkey_d"{
                    temporaryMenuSecion[index].filterMenuKind = dogBrand
                }else{
                    temporaryMenuSecion[index].filterMenuKind = catBrand
                }
            }
            if temporaryMenuSecion[index].menu == "주원료"{
                if curretPetKey == "feed_petkey_d"{
                    temporaryMenuSecion[index].filterMenuKind = dogIngredient
                }else{
                    temporaryMenuSecion[index].filterMenuKind = catIngredient
                }
            }
        }
        testFilterMenuSection = temporaryMenuSecion
        
        // Do any additional setup after loading the view.
        
        
        //초기 인덱스패스를 가진 배열형태로 구현하였던 부분
//        print(DataCenter.shared.filterIndexPathArr)
//        if !DataCenter.shared.filterIndexPathArr.isEmpty{
//            guard let indexPath = DataCenter.shared.filterIndexPathArr.first else {return}
//            let header = filterMenuTableView.dequeueReusableHeaderFooterView(withIdentifier: "filterMenuHeaderView") as! FilterMenuHeaderView
//            self.toggleSection(header: header, section: indexPath.section)
//            for indexPath in DataCenter.shared.filterIndexPathArr{
//                filterIndexPath.append(indexPath)
//                filterMenuTableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
//            }
//
//        }
        // 초기에 인덱스패스를 가진 배열형태에서 해당 섹션값을 키값으로 갖고 벨류에 인덱스패스 배열을 할당한 구조
        print(DataCenter.shared.filterIndexPathDicArr)
        print(DataCenter.shared.currentPetKey)
//        if !DataCenter.shared.filterIndexPathDicArr.isEmpty {
//            print(DataCenter.shared.filterIndexPathDicArr.count)
//            var indexPathArr: [IndexPath] = []
//            for dicIndexPath in DataCenter.shared.filterIndexPathDicArr{
//                print(dicIndexPath)
//                var indexPathArr: [IndexPath] = []
//                let header = filterMenuTableView.dequeueReusableHeaderFooterView(withIdentifier: "filterMenuHeaderView") as! FilterMenuHeaderView
//                self.toggleSection(header: header, section: dicIndexPath.key)
//                for indexPath in dicIndexPath.value{
////                    filterIndexPath.append(indexPath)
//                    indexPathArr.append(indexPath)
//                    filterIndexPathDicArr.updateValue(indexPathArr, forKey: dicIndexPath.key)
//                    filterMenuTableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
//                }
//            }
//            print(filterIndexPathDicArr)
//        }
        // 현재의 선택된 반려동물이 강아지일경우 강아지의 필터 인덱스패스 값을 가지고 필터뷰 데이터및 애니메이션 적용
        if curretPetKey == "feed_petkey_d" && !DataCenter.shared.filterDogIndexPathDicArr.isEmpty{
            
            for dicIndexPath in DataCenter.shared.filterDogIndexPathDicArr{
                print(dicIndexPath)
                var indexPathArr: [IndexPath] = []
                let header = filterMenuTableView.dequeueReusableHeaderFooterView(withIdentifier: "filterMenuHeaderView") as! FilterMenuHeaderView
                self.toggleSection(header: header, section: dicIndexPath.key)
                for indexPath in dicIndexPath.value{
                    //                    filterIndexPath.append(indexPath)
                    indexPathArr.append(indexPath)
                    filterIndexPathDicArr.updateValue(indexPathArr, forKey: dicIndexPath.key)
                    filterMenuTableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
                }
            }
            print(filterIndexPathDicArr)
        }
        
        // 현재의 선택된 반려동물이 고양이일경우 고양이의 필터 인덱스패스 값을 가지고 필터뷰 데이터및 애니메이션 적용
        if curretPetKey == "feed_petkey_c" && !DataCenter.shared.filterCatIndexPathDicArr.isEmpty{
            for dicIndexPath in DataCenter.shared.filterCatIndexPathDicArr{
                print(dicIndexPath)
                var indexPathArr: [IndexPath] = []
                let header = filterMenuTableView.dequeueReusableHeaderFooterView(withIdentifier: "filterMenuHeaderView") as! FilterMenuHeaderView
                self.toggleSection(header: header, section: dicIndexPath.key)
                for indexPath in dicIndexPath.value{
                    //                    filterIndexPath.append(indexPath)
                    indexPathArr.append(indexPath)
                    filterIndexPathDicArr.updateValue(indexPathArr, forKey: dicIndexPath.key)
                    filterMenuTableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
                }
            }
            print(filterIndexPathDicArr)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func initBtnTouched(_ sender: UIButton){
        filterDataLoadFlag = true
        filterIndexPathDicArr.removeAll()
        filterMenuTableView.reloadData()
    }
    @IBAction func tapGesture(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true) {
            
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
    
    // MARK: Indexpath로 이루어지는 값을 해당 인덱스패스와 일치하는 기능성 키값 String 변환 함수
    func functionalChangeToString() {
        //        if functionalIndexPath.count  == 9 {
        //            self.functionalKeyString = ["all"]
        //        }else{
        //            self.functionalKeyString = functionalIndexPath.map({ (indexpath) -> String in
        //                functionalData[indexpath.item]["functionalKey"] ?? "all"
        //            })
        //        }
//        self.feedGradeKeyString = feedGradeIndexPath.map({ (indexpath) -> String in
//            testFilterMenuSection[indexpath.section].filterMenuKind[indexpath.row].filterValue
//        })
        
//        self.sendFunctionalDelegate?.functionalKeySend(keyArr: self.functionalKeyString)
        
        
        
        
        print("등급선택 변환 결과값:", self.feedGradeKeyString)
    }
    
    func selectIndexPathArr(indexPathArr: [IndexPath]){
        
    }
    func filterDataChangeToValue(){
        let data: FilterData = FilterData.init(filterDic: filterIndexPathDicArr, filterinMenuSection: testFilterMenuSection)
        print(filterIndexPathDicArr.count,"//", filterIndexPathDicArr.isEmpty)
        var filterSelectFlag = false
        if !filterIndexPathDicArr.isEmpty {
            filterSelectFlag = true
        }else{
//            filterSelectFlag = false
        }
        print(filterDataLoadFlag)
        if filterDataLoadFlag {
            
            filterDelegate?.selectFilterData(filterData: data, selectState: filterSelectFlag)
        }
//        self.dismiss(animated: true) {
//
//        }
    }

}
extension FilterViewController: UITableViewDataSource, UITableViewDelegate, FilterMenuExpendableHeaderViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return testFilterMenuSection.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return testFilterMenuSection[section].filterMenuKind.count
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if testFilterMenuSection[indexPath.section].expanded {
            return 44
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let header = FilterMenuHeaderView()
//        header.customInint(title: testFilterMenuSection[section].menu, section: section, delegate: self)
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "filterMenuHeaderView") as! FilterMenuHeaderView
        print(testFilterMenuSection[section].menu)
        header.customInint(title: testFilterMenuSection[section].menu, section: section, delegate: self)
        if testFilterMenuSection[section].expanded {
            header.expendedImg.image = #imageLiteral(resourceName: "foldBtn")
        }else{
            header.expendedImg.image = #imageLiteral(resourceName: "unfoldBtn")
        }
        return header
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if testFilterMenuSection[indexPath.section].filterMenuKind[indexPath.row].cellType == "GradeDetail"{
            
            let gradeDetailCell = tableView.dequeueReusableCell(withIdentifier: "FilterDetailGradeTableViewCell", for: indexPath) as! FilterDetailGradeTableViewCell
            let graerImgString = testFilterMenuSection[indexPath.section].filterMenuKind[indexPath.row].gradeImg ?? "dogDisable"
            gradeDetailCell.gradeImgView.image = UIImage(imageLiteralResourceName: graerImgString)
            gradeDetailCell.detailGradeLabel.text = testFilterMenuSection[indexPath.section].filterMenuKind[indexPath.row].textLabel
            
            
            return gradeDetailCell
            
        }else{
            let detailCell = tableView.dequeueReusableCell(withIdentifier: "FilterDetailTableViewCell", for: indexPath) as! FilterDetailTableViewCell
            detailCell.detailLabel.text = testFilterMenuSection[indexPath.section].filterMenuKind[indexPath.row].textLabel
            // 기존에 선택한 필터 값이 있을 경우 메뉴헤더뷰 클릭시 메뉴의 reloadSection을 함으로써 기존값들이 선택되지않아 분기처리
            if let selectIndexPathArr = filterIndexPathDicArr[indexPath.section] {
                for path in selectIndexPathArr{
                    if path == indexPath {
                        tableView.selectRow(at: path, animated: true, scrollPosition: .none)
                    }
                }
            }
//            tableView.selectRow(at: filterIndexPathDicArr[indexPath.sec], animated: true, scrollPosition: .none)
           
            return detailCell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // nil 아닐 경우
        filterDataLoadFlag = true
        if var filterIndexPathKey = filterIndexPathDicArr[indexPath.section] {
            
            if filterIndexPathKey.contains(indexPath) {
                let indexInt = filterIndexPathKey.index(of: indexPath)
                print("기능성 선택한 값이 존재할경우 String:/",indexInt!)
                filterIndexPathKey.remove(at: indexInt!)
            }else{
                print(indexPath)
                filterIndexPathKey.append(indexPath)
                
            }
            filterIndexPathDicArr.updateValue(filterIndexPathKey, forKey: indexPath.section)
            
            print("------filterIndexPathDicArr값이 nil일경우 값 할당 및 제거후------: ",filterIndexPathDicArr)

        }
        else{
            filterIndexPathDicArr.updateValue([indexPath], forKey: indexPath.section)
            print("------filterIndexPathDicArr nil 일경우 slect 인덱스패스값생성후------: ",filterIndexPathDicArr)
        }
        
        
//        guard var testIndexPaht = test[indexPath.section] else {return}
//        if testIndexPaht.contains(indexPath){
//            let indexInt = testIndexPaht.index(of: indexPath)
//            print("기능성 선택한 값이 존재할경우 String:/",indexInt)
//            testIndexPaht.remove(at: indexInt!)
//            print("------기능성 선택한 값이 존재할경우 slect 인덱스패스------: ",feedGradeIndexPath)
//        }
//        else{
//            testIndexPaht.append(indexPath)
//            print("------기능성 선택한 값이 존재하지 않을경우 slect 인덱스패스------: ",feedGradeIndexPath)
//        }
        /*
        if filterIndexPath.contains(indexPath){
            let indexInt = filterIndexPath.index(of: indexPath)
            print("기능성 선택한 값이 존재할경우 String:/",indexInt)
            filterIndexPath.remove(at: indexInt!)
            print("------기능성 선택한 값이 존재할경우 slect 인덱스패스------: ",filterIndexPath)
        }
        else{
            filterIndexPath.append(indexPath)
            print("------기능성 선택한 값이 존재하지 않을경우 slect 인덱스패스------: ",filterIndexPath)
        }
        */
//        DataCenter.shared.filterIndexPathDicArr = filterIndexPathDicArr
        DataCenter.shared.filterIndexPathArr = filterIndexPath
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        filterDataLoadFlag = true
        if var filterIndexPathArr = filterIndexPathDicArr[indexPath.section] {
            if filterIndexPathArr.contains(indexPath) {
                let indexInt = filterIndexPathArr.index(of: indexPath)
                print("기능성 선택한 값이 존재할경우 String:/",indexInt)
                filterIndexPathArr.remove(at: indexInt!)
                print(filterIndexPathArr.isEmpty)
                if filterIndexPathArr.isEmpty {
                    filterIndexPathDicArr.removeValue(forKey: indexPath.section)
                    print(filterIndexPathDicArr)
                }else{
                    filterIndexPathDicArr.updateValue(filterIndexPathArr, forKey: indexPath.section)
                }
            }
//            현재까지 이 경우가 없다고 판단됨
//            else{
//                print(indexPath)
//                filterIndexPathArr.append(indexPath)
//
//            }
            //filterIndexPathDicArr.removeValue(forKey: indexPath.section)
            
            
            print("------filterIndexPathDicArr nil 일경우 slect 인덱스패스값생성후------: ",filterIndexPathDicArr)
            
        }
        /*
        if filterIndexPath.contains(indexPath){
            let indexInt = filterIndexPath.index(of: indexPath)
            print("기능성 didDeslect String:/",indexInt)
            filterIndexPath.remove(at: indexInt!)
            print("------기능성 didDeslect 인덱스패스------: ",filterIndexPath)
        }
         */
    }
    
    // MARK: -메뉴헤더 접고 펼치기위한 함수
    func toggleSection(header: FilterMenuHeaderView, section: Int) {
        
        testFilterMenuSection[section].expanded = !testFilterMenuSection[section].expanded
        
        filterMenuTableView.beginUpdates()
//        for i in 0 ..< testFilterMenuSection[section].filterMenuKind.count {
//            filterMenuTableView.reloadRows(at: [IndexPath(row: i, section: section)], with: .automatic)
//        }
 
        // 헤더메뉴클릭값에 따라 변화되는정보를 리로드(이미지포함)
        filterMenuTableView.reloadSections([section], with: .automatic)

        filterMenuTableView.endUpdates()
        
        
    
    }
    
    func selectFilterItem(){
        self.dismiss(animated: true) {
            
        }
    }
    
    
}

protocol FilterProtocol {
    func selectFilterData(filterData: FilterData, selectState: Bool)
}
