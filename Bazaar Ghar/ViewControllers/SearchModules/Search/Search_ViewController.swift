//
// Search_ViewController.swift
// Bazaar Ghar
//
// Created by Umair ALi on 06/09/2023.
//
import UIKit
import Combine
class Search_ViewController: UIViewController {
  @IBOutlet weak var containerview: UIView!
  @IBOutlet weak var backBtn: UIButton!
  @IBOutlet weak var search_btn: UIButton!
  @IBOutlet weak var crossBtn: UIButton!
  @IBOutlet weak var search_txtfield: UITextField!
  @IBOutlet weak var segmentedControl: ScrollableSegmentedControl!
  var cancellable = [AnyCancellable]()
  var searchText: String?
  var facetSearchVc: FacetSearchVc?
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if let facetSearchVc = segue.destination as? FacetSearchVc {
        self.facetSearchVc = facetSearchVc
      }
    }
  var currentVC: UIViewController? {
    didSet {
      if let oldVC = oldValue {
        remove( asChildViewController: oldVC )
      }
      if let newVC = currentVC {
        add( asChildViewController: newVC )
      }
    }
  }
  private lazy var ProductSearch_VCs: FacetSearchVc = {
//    var vc = ProductSearch_VC.getVC(.main)
//
//    return vc
    var vc = FacetSearchVc.getVC(.searchStoryBoard)
    return vc
  }()
  private lazy var StoreSearchVCs: StoreSearchVC = {
    var vc = StoreSearchVC.getVC(.searchStoryBoard)
    return vc
  }()
  private lazy var VediosSearch_VCs: VediosSearch_VC = {
    var vc = VediosSearch_VC.getVC(.videoStoryBoard)
    return vc
  }()
  var index = 0
  override func viewDidLoad() {
    super.viewDidLoad()
      if searchText?.count ?? 0 > 0 {
        crossBtn.isHidden = false
       }else {
         crossBtn.isHidden = true
       }

    search_txtfield.text = searchText
    self.setupSegments(self.segmentedControl)
    search_txtfield.addTarget(self, action: #selector(enterPressed), for: .editingDidEndOnExit)
    search_txtfield.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    crossBtn.addTarget(self, action: #selector(crossBtnTapped(_:)), for: .touchUpInside)
    applyCombineSearch()
      search_txtfield.returnKeyType = .search
      search_txtfield.translatesAutoresizingMaskIntoConstraints = false
      search_txtfield.delegate = self
  }
  override func viewWillAppear(_ animated: Bool) {
//    if((self.tabBarController?.tabBar.isHidden) != nil){
//      appDelegate.isbutton = true
//    }else{
//      appDelegate.isbutton = false
//    }
//    NotificationCenter.default.post(name: Notification.Name("ishideen"), object: nil)
    self.LanguageRender()
  }
  func LanguageRender() {
    search_btn.setTitle("search".pLocalized(lang: LanguageManager.language), for: .normal)
    if LanguageManager.language == "ar"{
      backBtn.setImage(UIImage(systemName: "arrow.right"), for: .normal)
      }else{
        backBtn.setImage(UIImage(systemName: "arrow.left"), for: .normal)
      }
      search_txtfield.placeholder = "search".pLocalized(lang: LanguageManager.language)
  }
  @objc func crossBtnTapped(_ sender: UIButton) {
    search_txtfield.text = ""
    crossBtn.isHidden = true
    switch (sender as AnyObject).tag{
    case 0:
        ProductSearch_VCs.searchText = search_txtfield.text
        ProductSearch_VCs.page = 1

//      ProductSearch_VCs.performSearch(with: search_txtfield.text ?? "",page: 1, faceby: "")
      showController(0, ProductSearch_VCs)
    case 1:
      StoreSearchVCs.searchText = search_txtfield.text
      StoreSearchVCs.isNavBar = true
      showController(1, StoreSearchVCs)
    case 2:
      VediosSearch_VCs.searchText = search_txtfield.text
      showController(1, VediosSearch_VCs)
    default:
      currentVC = ProductSearch_VCs
  }
 }
  @objc func enterPressed(){
    search_txtfield.resignFirstResponder()
  }
  @objc func textFieldDidChange(_ textField: UITextField) {
      // This method is called when the text field's text changes
      if let text = textField.text {
       if text.count > 0 {
         crossBtn.isHidden = false
        }else {
          crossBtn.isHidden = true
          self.searchBtnTapped((self.search_btn))
        }
      }
    }
  func applyCombineSearch() {
    let publisher = NotificationCenter.default.publisher(for: UISearchTextField.textDidChangeNotification, object: self.search_txtfield)
   publisher
    .map {
     ($0.object as! UITextField).text
   }
   .debounce(for: .milliseconds(2200), scheduler: RunLoop.main)
   .sink(receiveValue: { (value) in
    DispatchQueue.global(qos: .userInteractive).async { [weak self] in
     DispatchQueue.main.async {
       if(self?.search_txtfield.text?.count == 0){
       }else{
         self?.searchBtnTapped((self?.search_btn)!)
       }
     }
    }
   })
   .store(in: &cancellable)
  }
  @IBAction func searchBtnTapped(_ sender: UIButton) {
//    search_txtfield.resignFirstResponder()
    switch (sender as AnyObject).tag {
    case 0:
//      Prood.searchText = search_txtfield.text
        ProductSearch_VCs.searchText = search_txtfield.text
        ProductSearch_VCs.page = 1

//      ProductSearch_VCs.performSearch(with: search_txtfield.text ?? "*",page: 1, faceby: "")
      showController(0, ProductSearch_VCs)
    case 1:
      StoreSearchVCs.searchText = search_txtfield.text
      StoreSearchVCs.isNavBar = true
      showController(1, StoreSearchVCs)
    case 2:
      VediosSearch_VCs.searchText = search_txtfield.text
      showController(1, VediosSearch_VCs)
    default:
      currentVC = ProductSearch_VCs
  }
//    search_txtfield.text = ""
  }
  @IBAction func bacbtn(_ sender: Any) {
//    appDelegate.isbutton = false
//  NotificationCenter.default.post(name: Notification.Name("ishideen"), object: nil)
//    DispatchQueue.main.async {
//      self.navigationController?.popToRootViewController(animated: true)
//    }
      navigationController?.popViewController(animated: false)
  }
  //MARK: - Setup Scrollable Segmented Control
  fileprivate func setupSegments(_ segmentedControl:ScrollableSegmentedControl){
    segmentedControl.segmentStyle = .textOnly
//    segmentedControl.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 17, weight: .light)], for: .normal)
    let selectedColor = UIColor(named: "headercolor") // This line creates a UIColor instance from the hex value
    segmentedControl.setTitleTextAttributes([.foregroundColor: selectedColor ?? ""], for: .selected)
    let normalAttributes: [NSAttributedString.Key: Any] = [
      .foregroundColor: UIColor.black,
      .font: UIFont.boldSystemFont(ofSize: UIFont.systemFontSize) // Adjust font size as needed
    ]
    // Apply the attributes to the segmented control
    segmentedControl.setTitleTextAttributes(normalAttributes, for: .normal)
    segmentedControl.insertSegment(withTitle: "products".pLocalized(lang: LanguageManager.language), at: 0)
    segmentedControl.insertSegment(withTitle: "stores".pLocalized(lang: LanguageManager.language), at: 1)
      segmentedControl.insertSegment(withTitle: "videos".pLocalized(lang: LanguageManager.language), at: 2)
    segmentedControl.underlineSelected = true
    segmentedControl.tintColor = UIColor(named: "headercolor")
    segmentedControl.segmentContentColor = .unselectedSegment
    segmentedControl.selectedSegmentContentColor = .black
    segmentedControl.backgroundColor = UIColor.white
    segmentedControl.fixedSegmentWidth = true
    segmentedControl.selectedSegmentIndex = index
  }
  func showController(_ index:Int,_ viewController:UIViewController){
    switch index{
    case 0:
      currentVC = viewController
    case 1:
      currentVC = viewController
    case 2:
      currentVC = viewController
    default:
      currentVC = viewController
    }
  }
  private func remove( asChildViewController viewController: UIViewController ) {
    viewController.willMove( toParent: nil )
    viewController.view.removeFromSuperview()
    viewController.removeFromParent()
  }
  private func add( asChildViewController viewController: UIViewController ) {
    addChild( viewController )
    containerview.addSubview( viewController.view )
    viewController.view.frame = containerview.bounds
    viewController.view.autoresizingMask = [ .flexibleWidth, .flexibleHeight ]
    viewController.didMove( toParent: self )
  }
  @IBAction func SegmentControlValueChanged(_ sender: ScrollableSegmentedControl) {
    search_btn.tag = sender.selectedSegmentIndex
    crossBtn.tag = sender.selectedSegmentIndex
    switch sender.selectedSegmentIndex {
    case 0:
        ProductSearch_VCs.searchText = search_txtfield.text ?? ""
        ProductSearch_VCs.page = 1
//      ProductSearch_VCs.performSearch(with: search_txtfield.text ?? "",page: 1, faceby: "")
      showController(0, ProductSearch_VCs)
    case 1:
      StoreSearchVCs.searchText = search_txtfield.text
      StoreSearchVCs.isMarket = false
      StoreSearchVCs.isNavBar = true
      showController(1, StoreSearchVCs)
    case 2:
      VediosSearch_VCs.searchText = search_txtfield.text
      showController(1, VediosSearch_VCs)
    default:
      currentVC = ProductSearch_VCs
    }
  }
}

extension Search_ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Dismiss the keyboard
        textField.resignFirstResponder()
        
        self.searchBtnTapped((self.search_btn))
        
        return true
    }
}
