//
//  WebView_Vc.swift
//  Bazaar Ghar
//
//  Created by Developer on 23/08/2024.
//

import UIKit
import WebKit

class WebView_Vc: UIViewController {
    
    lazy var webView: WKWebView = {
        let webView = WKWebView(frame: self.view.bounds)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return webView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add the webView to the view hierarchy
        self.view.addSubview(webView)
        
        // Optionally, load a default URL
        
    }
    
    func launchWebView(with urlString: String) {
        if let url = URL(string: urlString) {
            loadWebView(with: url)
        } else {
            print("Invalid URL")
        }
    }
    
    private func loadWebView(with url: URL) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
