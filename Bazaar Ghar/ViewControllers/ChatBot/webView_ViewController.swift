//
//  webView_ViewController.swift
//  Bazaar Ghar
//
//  Created by Developer on 30/11/2023.
//

import UIKit
import WebKit

class webView_ViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var webView: WKWebView!

     override func viewDidLoad() {
         super.viewDidLoad()

         // Load UseChat widget script
         if let url = URL(string: "https://js.usechat.ai/widget/e0f9545a-2002-4268-a5e3-9d422afcbf60.js") {
             let request = URLRequest(url: url)
             webView.load(request)
         }
         openChat()
         // Create a button to open the chat
     

         // Layout constraints
         

       
     }
    
    @IBAction func crossBtnTapped(_ sender: UIButton) {
        self.dismissViewController(sender)
    }
    
     @objc func openChat() {
         // Open the chat link in Safari or in your WKWebView
         if let url = URL(string: "https://app.usechat.ai/widget/e0f9545a-2002-4268-a5e3-9d422afcbf60") {
                let request = URLRequest(url: url)
                webView.load(request)
            }
     }
 }
