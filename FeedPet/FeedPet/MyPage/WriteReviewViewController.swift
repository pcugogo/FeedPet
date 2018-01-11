//
//  WriteReviewViewController.swift
//  FeedPet
//
//  Created by 샤인 on 2018. 1. 10..
//  Copyright © 2018년 HwangGisu. All rights reserved.
//

import UIKit

class WriteReviewViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,WriteReviewVCTextViewCellDelegate {
    
    var writeReviewContentsTextReset = false
    //글을 작성 후 다시 리뷰작성 화면으로 들어왔을때 텍스트뷰를 초기화
    //전 화면에서 false로 초기화해줘야된다
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0{  // 펫이름/디테일 셀
            let writeReviewVCFeedImgCell = tableView.dequeueReusableCell(withIdentifier: "WriteReviewVCFeedImgCell", for: indexPath) as! WriteReviewVCFeedImgCell
            return writeReviewVCFeedImgCell
        }else{ //평점/평가 셀
            let writeReviewVCTextViewCell = tableView.dequeueReusableCell(withIdentifier: "WriteReviewVCTextViewCell", for: indexPath) as! WriteReviewVCTextViewCell
            
            writeReviewVCTextViewCell.delegate = self
            
            if writeReviewContentsTextReset == true {
                writeReviewVCTextViewCell.writeReviewContentsTextView.text = writeReviewVCTextViewCell.textViewPlaceHolderText
                
                writeReviewVCTextViewCell.writeReviewContentsTextView.textColor = UIColor.lightGray
                
            }
            
            return writeReviewVCTextViewCell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 100
        }else{
            return 430
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    @IBAction func backBtnAction(_ sender: UIBarButtonItem) {
        writeReviewContentsTextReset = true
        tableView.reloadData()
        print("뒤로")
    }
    
    @IBAction func saveBtnAction(_ sender: UIBarButtonItem) {
        DispatchQueue.main.async {
            
            let completedReview:UIAlertController = UIAlertController(title: "리뷰 등록 완료!", message: "소중한 리뷰 감사합니다:)", preferredStyle: .alert)
            
            let okBtn:UIAlertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            completedReview.addAction(okBtn)
            
            self.present(completedReview, animated: true, completion: nil)
        }
    }
    func WriteReviewVCendEditing() {
        self.view.endEditing(true)
    }
    
    
}
