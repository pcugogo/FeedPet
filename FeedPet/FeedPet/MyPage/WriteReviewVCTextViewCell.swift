//
//  WriteReviewVCTextViewCell.swift
//  FeedPet
//
//  Created by 샤인 on 2018. 1. 10..
//  Copyright © 2018년 HwangGisu. All rights reserved.
//

import UIKit

//protocol WriteReviewVCTextViewCellDelegate {
//    func WriteReviewVCendEditing()
//}

class WriteReviewVCTextViewCell: UITableViewCell,UITextViewDelegate {
    
//    var delegate:WriteReviewVCTextViewCellDelegate?
  
    let textViewPlaceHolderText = "사용하신 상품의 리뷰를 남겨주세요:)"
    
    var ratingNumberOfStars = 5 //서버에 넘겨질 평점 초기 별 갯수 5개
    
    @IBOutlet weak var firstStarBtnOut: UIButton!
    @IBOutlet weak var secondStarBtnOut: UIButton!
    @IBOutlet weak var thirdStarBtnOut:UIButton!
    @IBOutlet weak var fourthStarBtnOut:UIButton!
    @IBOutlet weak var fifthStarBtnOut:UIButton!
    
    
    @IBOutlet weak var writeReviewContentsTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
//        createToolbar(textView: writeReviewContentsTextView)
//
//        writeReviewContentsTextView.delegate = self
//
//        if writeReviewContentsTextView.text == ""{
//            writeReviewContentsTextView.text = textViewPlaceHolderText
//            writeReviewContentsTextView.textColor = UIColor.lightGray
//        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    
    @IBAction func starBtnAction(_ sender: UIButton) {
     
    }
    
    
    
    
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        if writeReviewContentsTextView.text == textViewPlaceHolderText{
//            writeReviewContentsTextView.text = ""
//            writeReviewContentsTextView.textColor = .black
//        }
//
//    }
//
//    func textViewDidEndEditing(_ textView: UITextView) {
//        if writeReviewContentsTextView.text == ""{
//            writeReviewContentsTextView.text = textViewPlaceHolderText
//            writeReviewContentsTextView.textColor = UIColor.lightGray
//        }
//
//    }
//    func createToolbar(textView : UITextView) { //텍스트 뷰 키보드 위에 올라갈 툴바
//        let toolbar = UIToolbar()
//        toolbar.barStyle = UIBarStyle.default
//        toolbar.sizeToFit()
//
//        let flexsibleSpace: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
//        let complateBtn = UIBarButtonItem(title: "완료", style: UIBarButtonItemStyle.plain, target: self, action: #selector(WriteReviewVCTextViewCell.complateBtnAction))
//
//        toolbar.items = [flexsibleSpace,complateBtn]
//        textView.inputAccessoryView = toolbar
//    }
    
//    func endEditingTrue(){
//        delegate?.WriteReviewVCendEditing()
//    }
//
//    func complateBtnAction() {
//        endEditingTrue()
//    }
    
    
    
    
}
