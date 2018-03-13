//
//  TermsViewController.swift
//  FeedPet
//
//  Created by HwangGisu on 2018. 2. 9..
//  Copyright © 2018년 HwangGisu. All rights reserved.
//

import UIKit

class TermsViewController: UIViewController {

    @IBOutlet weak var termsWebView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        termsWebView.loadRequest(URLRequest(url: URL(string: "http://feedpet.co.kr/termsofservicetermsofuse/")!))
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
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

}
