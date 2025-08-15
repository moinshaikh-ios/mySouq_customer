//
//  NoInternet_ViewController.swift
//  Bazaar Ghar
//
//  Created by Umair Ali on 01/08/2024.
//

import UIKit

class NoInternet_ViewController: UIViewController {
    @IBOutlet weak var headerview: UIView!
    @IBOutlet weak var gotosetting: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        headerview.backgroundColor = UIColor(named: "headercolor")
        let button = UIButton(type: .system)
          button.setTitle("Open Settings", for: .normal)
          
        gotosetting.addTarget(self, action: #selector(openWiFiSettings), for: .touchUpInside)
      
            
        // Do any additional setup after loading the view.
    }
    @objc func openWiFiSettings() {
         // Open the general settings
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
             }
         }
     }
    



