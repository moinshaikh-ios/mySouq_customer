//
//  UIStoryboard.swift


import UIKit
import Rswift
extension UIStoryboard {
    
    static var main: UIStoryboard {
        return UIStoryboard( name: "Main", bundle: Bundle.main )
    }
}
public protocol SeguePerformerType {
  func performSegue(withIdentifier identifier: String, sender: Any?)
}
extension UIViewController: SeguePerformerType {}

public extension SeguePerformerType {
  /**
   Initiates the segue with the specified identifier (R.segue.*) from the current view controller's storyboard file.
   - parameter identifier: The R.segue.* that identifies the triggered segue.
   - parameter sender: The object that you want to use to initiate the segue. This object is made available for informational purposes during the actual segue.
   - SeeAlso: Library for typed block based segues: [tomlokhorst/SegueManager](https://github.com/tomlokhorst/SegueManager)
   */
  func performSegue<Segue, Destination>(withIdentifier identifier: StoryboardSegueIdentifier<Segue, Self, Destination>, sender: Any?) {
    performSegue(withIdentifier: identifier.identifier, sender: sender)
  }
}

public extension StoryboardSegue where Source : UIViewController {
  /**
   Performs this segue on the source view controller
   - parameter sender: The object that you want to use to initiate the segue. This object is made available for informational purposes during the actual segue.
   */
  func performSegue(sender: Any? = nil) {
    source.performSegue(withIdentifier: identifier.identifier, sender: sender)
  }
}


public extension StoryboardResourceWithInitialControllerType {
  /**
   Instantiates and returns the initial view controller in the view controller graph.

   - returns: The initial view controller in the storyboard.
   */
  func instantiateInitialViewController() -> InitialController? {
    return UIStoryboard(resource: self).instantiateInitialViewController() as? InitialController
  }
}


protocol StoryboardSceneType {
    static var storyboardName: String { get }
}

extension StoryboardSceneType {
    static func storyboard() -> UIStoryboard {
        return UIStoryboard(name: self.storyboardName, bundle: nil)
    }
    
    static func initialViewController() -> UIViewController {
        guard let vc = storyboard().instantiateInitialViewController() else {
            fatalError("Failed to instantiate initialViewController for \(self.storyboardName)")
        }
        return vc
    }
}

extension StoryboardSceneType where Self: RawRepresentable, Self.RawValue == String {
    func viewController() -> UIViewController {
        return Self.storyboard().instantiateViewController(withIdentifier: self.rawValue)
    }
    static func viewController(identifier: Self) -> UIViewController {
        return identifier.viewController()
    }
    //Nitin
    func tabBarViewController() -> UITabBarController {
        guard let vc = Self.storyboard().instantiateViewController(withIdentifier: self.rawValue) as? UITabBarController else {  fatalError("MainTabBarViewController not found.") }
        return vc
    }
}

protocol StoryboardSegueType: RawRepresentable { }

extension UIViewController {
    func performSegue<S: StoryboardSegueType>(segue: S, sender: AnyObject? = nil) where S.RawValue == String {
        performSegue(withIdentifier: segue.rawValue, sender: sender)
    }
}
