//
//  WebViewController.swift
//  todo
//
//  Created by 中村太一 on 2018/10/20.
//  Copyright © 2018 中村太一. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    

    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let myURL = URL(string: "https://www.google.com/")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
    
    @IBAction func didTouchCloseButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
