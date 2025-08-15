//
//  DashboardViewController.swift
//  Bazaar Ghar
//
//  Created by Developer on 11/06/2024.
//

import UIKit

class DashboardViewController: UIViewController {

    
    @IBOutlet weak var headerBackgroudView: UIView!
    @IBOutlet weak var bottomBarCollectionView: UICollectionView!
    @IBOutlet weak var containerView: UIView!

    
    let images: [UIImage] = [
        UIImage(named: "Home")!,
        UIImage(named: "discount")!,
        UIImage(named: "discount")!,
        UIImage(named: "profile")!,
        UIImage(named: "hamburger")!
    ]
    
    let Selectedimages: [UIImage] = [
        UIImage(named: "SelectHome")!,
        UIImage(named: "discount")!,
        UIImage(named: "discount")!,
        UIImage(named: "selectProfile")!,
        UIImage(named: "hamburger")!
    ]
    let namearray = ["Home","Offers","","Profile","menu"]
    var selectedIndexPath: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectedIndexPath = 0
        // Do any additional setup after loading the view.
        headerBackgroudView.backgroundColor = UIColor(named: "headercolor")
        self.embedviewController(Indexpath: self.selectedIndexPath ?? 0)
        
    }
    

    func embed(_ child: UIViewController, in container: UIView) {
           // Remove previously added child view controllers
           for childVC in children {
               childVC.willMove(toParent: nil)
               childVC.view.removeFromSuperview()
               childVC.removeFromParent()
           }
           
           // Add the new child view controller
           addChild(child)
           container.addSubview(child.view)
           child.view.frame = container.bounds
           child.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
           child.didMove(toParent: self)
       }
    
    
    func embedviewController(Indexpath: Int){
        selectedIndexPath = Indexpath
        if(Indexpath == 0){
            
            ViewEmbedder.embed(
                withIdentifier: "HomeController", // Storyboard ID
                parent: self,
                container: self.containerView){ vc in
                // do things when embed complete
            }
        }
        if(Indexpath == 3){
            
            ViewEmbedder.embed(
                withIdentifier: "ProfileViewController", // Storyboard ID
                parent: self,
                container: self.containerView){ vc in
                // do things when embed complete
            }
        }
        self.bottomBarCollectionView.reloadData()
    }
    
    

}

extension DashboardViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
     
        return namearray.count //self.CategoriesResponsedata.count
    
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BottomBarCollectionViewCell", for: indexPath) as! BottomBarCollectionViewCell
        cell.topline.backgroundColor = primaryColor

        cell.lbl.text = namearray[indexPath.row]
     
        
        if selectedIndexPath == indexPath.row {
            cell.lbl.textColor = primaryColor
            cell.image.image = Selectedimages[indexPath.row]
            cell.topline.isHidden = false
        }else{
            cell.lbl.textColor = UIColor(hex: "#989898")
            cell.image.image = images[indexPath.row]
            cell.topline.isHidden = true
            if indexPath.row == 2 {
                cell.image.isHidden = true
                cell.lbl.isHidden = true
                cell.topline.isHidden = true
            }
        }
     
        
            return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {

        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
   
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      
            return CGSize(width: collectionView.frame.width/5-10, height: collectionView.frame.height)

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
          return  UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
       
       

   
        self.embedviewController(Indexpath: indexPath.row)
             
            }
        
           
       
    
}




extension UIColor {
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else {
            return nil
        }

        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

@IBDesignable class CustomButton: UIButton {

    @IBInspectable var spacing: CGFloat = 8.0 {
        didSet {
            updateInsets()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        contentHorizontalAlignment = .left
        semanticContentAttribute = .forceRightToLeft
        updateInsets()
    }

    private func updateInsets() {
        imageEdgeInsets = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: -spacing)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: -spacing, bottom: 0, right: spacing)
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
    }
}
class ViewEmbedder {

class func embed(
    parent:UIViewController,
    container:UIView,
    child:UIViewController,
    previous:UIViewController?){

    if let previous = previous {
        removeFromParent(vc: previous)
    }
    child.willMove(toParent: parent)
    parent.addChild(child)
    container.addSubview(child.view)
    child.didMove(toParent: parent)
    let w = container.frame.size.width;
    let h = container.frame.size.height;
    child.view.frame = CGRect(x: 0, y: 0, width: w, height: h)
}

class func removeFromParent(vc:UIViewController){
    vc.willMove(toParent: nil)
    vc.view.removeFromSuperview()
    vc.removeFromParent()
}

class func embed(withIdentifier id:String, parent:UIViewController, container:UIView, completion:((UIViewController)->Void)? = nil){
    let vc = parent.storyboard!.instantiateViewController(withIdentifier: id)
    embed(
        parent: parent,
        container: container,
        child: vc,
        previous: parent.children.first
    )
    completion?(vc)
}

}
