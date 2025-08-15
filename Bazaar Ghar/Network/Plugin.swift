//
//  Services.swift
//  RGB
//
//  Created by usamaghalzai on 15/11/2021.
//  Copyright © 2021 usamaghalzai. All rights reserved.
//

import Foundation
import Moya
import JGProgressHUD

struct Plugin{
    static let networkPlugin = NetworkActivityPlugin.init(networkActivityClosure: { (changeType, targetType) in
        switch (changeType){
        case .began:
          UIApplication.startActivityIndicator()
            
          
            
            
            break
        case .ended:
            UIApplication.stopActivityIndicator()
            break
        }
    })
    
    static let authPlugin = AccessTokenPlugin(tokenClosure: {_ in 
        if let user = AppDefault.currentUser as CurrentUser? {
            return AppDefault.accessToken
        }else{
            return AppDefault.accessToken
        }
    })
}

extension UIApplication{
    static var hud = JGProgressHUD(style: .dark)
    class func startActivityIndicator(with message: String? = "") {
        DispatchQueue.main.async {
            let hud = JGProgressHUD(style: .dark)
            hud.tag = 9999
            hud.textLabel.text = message
            if let view = self.shared.keyWindow {
                hud.show(in: view)
            }
        }
    }
    
    class func stopActivityIndicator(){
        DispatchQueue.main.async {
            if let hud = self.shared.keyWindow?.viewWithTag(9999) as? JGProgressHUD {
                hud.dismiss()
                hud.removeFromSuperview()
            }
        }
    }
    class func showPercentageIndicator(_ percentage:Float) {
        DispatchQueue.main.async {
            UIApplication.hud.indicatorView = JGProgressHUDPieIndicatorView()
            UIApplication.hud.progress = percentage
            UIApplication.hud.tag = 999
            if let topView = UIApplication.topViewController()?.view,
               topView.subviews.contains(where: { return $0 == UIApplication.hud.hudView}) == false {
                UIApplication.hud.show(in: topView)
            }
        }
    }
    class func stopPercentageIndicator(){
        DispatchQueue.main.async {
            UIApplication.hud.dismiss()
//            if let hud = self.shared.keyWindow?.viewWithTag(999) as? JGProgressHUD {
//                hud.dismiss()
//                hud.removeFromSuperview()
//            }
        }
    }
}

