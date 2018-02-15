//
//  TermsOfUseViewController.swift
//  FeedPet
//
//  Created by 샤인 on 2017. 12. 27..
//  Copyright © 2017년 HwangGisu. All rights reserved.
//

import UIKit

class TermsOfUseViewController: UIViewController,UIWebViewDelegate {
   var spinerView = UIView()
    @IBOutlet weak var termsOfUseLinkWebView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        termsOfUseLinkWebView.delegate = self
        spinerView = DataCenter.shared.displsyLoadingIndicator(onView: self.view)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        if let termsOfUseUrl = URL(string: "http://feedpet.co.kr/termsofservicetermsofuse/"){
        termsOfUseLinkWebView.loadRequest(URLRequest(url: termsOfUseUrl))
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        DataCenter.shared.removeSpinner(spinner: spinerView)
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        let errorAlert = UIAlertController(title: "", message: "네트워크가 원활하지 않습니다", preferredStyle: .alert)
        let okBtn = UIAlertAction(title: "OK", style: .cancel) { (_) in
            self.navigationController?.popViewController(animated: true)
        }
        errorAlert.addAction(okBtn)
        self.present(errorAlert, animated: true, completion: nil)
    }
    
    @IBAction func backBtnAction(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
