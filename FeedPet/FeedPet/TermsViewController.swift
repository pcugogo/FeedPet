//
//  TermsViewController.swift
//  FeedPet
//
//  Created by HwangGisu on 2018. 2. 9..
//  Copyright © 2018년 HwangGisu. All rights reserved.
//

import UIKit

class TermsViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var termsWebView: UIWebView!
    @IBOutlet weak var lodingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var lodingIndicatorBackGroundView: UIView!
    var termURL = "http://feedpet.co.kr/termsofservicetermsofuse/"
    override func viewDidLoad() {
        super.viewDidLoad()
        termsWebView.delegate = self
        if let url = URL(string: termURL){
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            termsWebView.loadRequest(URLRequest(url: url))
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
        }
    
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    func webViewDidStartLoad(_ webView: UIWebView) {
        lodingIndicator.startAnimating()
        lodingIndicatorBackGroundView.isHidden = false
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        lodingIndicator.stopAnimating()
        lodingIndicator.isHidden = true
        lodingIndicatorBackGroundView.isHidden = true
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        let errorAlert = UIAlertController(title: "", message: "네트워크가 원활하지 않습니다", preferredStyle: .alert)
        let okBtn = UIAlertAction(title: "OK", style: .cancel) { (_) in
            self.navigationController?.popViewController(animated: true)
        }
        errorAlert.addAction(okBtn)
        self.present(errorAlert, animated: true, completion: nil)
    }

}
