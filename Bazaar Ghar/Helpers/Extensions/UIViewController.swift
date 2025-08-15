//
//  UIViewController.swift

import UIKit
import var CommonCrypto.CC_SHA512_DIGEST_LENGTH
import var CommonCrypto.CC_SHA256_DIGEST_LENGTH
import func CommonCrypto.CC_SHA512
import func CommonCrypto.CC_SHA256
import typealias CommonCrypto.CC_LONG

extension UIViewController {
    
    static var storyboardIdentifier: String {
        return String( describing: self )
    }
    func customizeNavigationBarAppearance(backgroundColor: UIColor, foregroundColor: UIColor) {
        navigationController?.navigationBar.tintColor = foregroundColor
        navigationController?.navigationBar.backgroundColor = backgroundColor
        navigationController?.navigationBar.barTintColor = backgroundColor
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.titleTextAttributes = [ .foregroundColor: foregroundColor]
        navigationController?.navigationBar.isTranslucent = true
      if #available(iOS 13.0, *) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = backgroundColor
        appearance.shadowColor = backgroundColor
        appearance.titleTextAttributes = [.foregroundColor: foregroundColor]
        appearance.shadowImage = UIImage()
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
      }

      navigationController?.setNeedsStatusBarAppearanceUpdate()
    }
    
    static func instantiate() -> UIViewController {
        return UIStoryboard.main.instantiateViewController( withIdentifier: self.storyboardIdentifier )
    }
    
    func rbga2argb(hexString: String) -> String {
        var cString = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if cString.hasPrefix("#") { cString.removeFirst() }
        
        if cString.count == 6 {
            cString = "ff\(cString)"
        }
        
        return String(format: "#%@", cString)
    }
    
    public func sha256(value: String) -> String {
        let data = value.data(using: .utf8) ?? Data()
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA256($0.baseAddress, CC_LONG(data.count), &digest)
        }
        return digest.map({ String(format: "%02hhx", $0) }).joined(separator: "")
    }
    
    func sha512(value: String) -> String {
        let data = value.data(using: .utf8) ?? Data()
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA512_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA512($0.baseAddress, CC_LONG(data.count), &digest)
        }
        return digest.map({ String(format: "%02hhx", $0) }).joined(separator: "")
    }
    
   
    
}


extension NSObject {
    class var identifierr: String {
        return String(describing: self)
    }
}

extension Notification.Name {
    static let updateColorNotification = Notification.Name("updateColorNotification")
    static let favColorNotification = Notification.Name("favColorNotification")
    
}
//MARK:- ======== ViewController Identifiers ========
extension UIViewController {
    
    static func getVC(_ storyBoard: Boards) -> Self {
        
        func instanceFromNib<T: UIViewController>(_ storyBoard: Boards) -> T {
            guard let vc = controller(storyBoard: storyBoard, controller: T.identifierr) as? T else {
                fatalError("'\(storyBoard.rawValue)' : '\(T.identifierr)' is Not exist")
            }
            return vc
        }
        return instanceFromNib(storyBoard)
    }
   
    
    static func controller(storyBoard: Boards, controller: String) -> UIViewController {
        let storyBoard = storyBoard.stortBoard
        let vc = storyBoard.instantiateViewController(withIdentifier: controller)
        return vc
    }
}
extension UIViewController {
    @IBAction func dismissViewController(_ sender:UIButton){
        UIApplication.topViewController()?.dismiss(animated: true, completion: nil)
    }
    @IBAction func popViewController(_ sender:UIButton){
        UIApplication.topViewController()?.navigationController?.popViewController(animated: true)
    }
}
