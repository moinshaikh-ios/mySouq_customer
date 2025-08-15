//
//  AddAddressViewController.swift
//  Bazaar Ghar
//
//  Created by Developer on 21/09/2023.
//

import UIKit

class AddAddressViewController: UIViewController {
 
    @IBOutlet weak var arealabeltext: UILabel!
    @IBOutlet weak var provinceLabele: UILabel!
    @IBOutlet weak var cityView: UIView!
    @IBOutlet weak var cityTblV: UITableView!
    @IBOutlet weak var countryTblV: UITableView!
    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var countryView: UIView!
    @IBOutlet weak var countryTableView: UIView!
    @IBOutlet weak var pakistanRadioImg: UIImageView!
    @IBOutlet weak var internationalRadioImg: UIImageView!
    @IBOutlet weak var homeBtn: UIButton!
    @IBOutlet weak var officeBtn: UIButton!
    @IBOutlet weak var mobileNumberTF: UITextField!
    @IBOutlet weak var address1TF: UITextField!
    @IBOutlet weak var address2TF: UITextField!
    @IBOutlet weak var zipCodeTF: UITextField!
    @IBOutlet weak var fullnameTF: UITextField!
    @IBOutlet weak var myStackView: UIStackView!
    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var countryImg: UILabel!
    @IBOutlet weak var countryLbl: UILabel!
    @IBOutlet weak var cityViewPakistan: UIView!
    @IBOutlet weak var cityViewInternational: UIView!
    @IBOutlet weak var backgroundHandleView: UIView!
    @IBOutlet weak var cityTF: UITextField!
    @IBOutlet weak var fullnameValidationImg: UIImageView!
    @IBOutlet weak var mobileNumberValidationImg: UIImageView!
    @IBOutlet weak var cityValidationView: UIView!
    @IBOutlet weak var addressValidationImg: UIImageView!
    @IBOutlet weak var address2ValidationImg: UIImageView!
    @IBOutlet weak var zipCodeValidationImg: UIImageView!
    @IBOutlet weak var cityValidationImg: UIImageView!
    @IBOutlet weak var mobileNumerHeadingLbl: UILabel!
    @IBOutlet weak var mobileNumerCodeLbl: UILabel!
    @IBOutlet weak var scrollHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollHeightinnerview: NSLayoutConstraint!
    @IBOutlet weak var arealbl: UILabel!
    @IBOutlet weak var citlbl: UILabel!
    @IBOutlet weak var provincelbl: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var addNewAddressi18: UILabel!
    @IBOutlet weak var pakistani18: UILabel!
    @IBOutlet weak var internationali18: UILabel!
    @IBOutlet weak var receiverFullNamei18: UILabel!
    @IBOutlet weak var whatsappNumberi18: UILabel!
    @IBOutlet weak var cityi18: UILabel!
    @IBOutlet weak var countryi18: UILabel!
    @IBOutlet weak var countryNamei18: UILabel!
    @IBOutlet weak var selectCityi18: UILabel!
    @IBOutlet weak var addressi18: UILabel!
    @IBOutlet weak var zipcodei18: UILabel!
    @IBOutlet weak var saveAddressBtn: UIButton!
    @IBOutlet weak var selectCountry18n: UILabel!
    @IBOutlet weak var provinceView: UIView!
    @IBOutlet weak var AreaView: UIView!
    @IBOutlet weak var ProvincePullDownButton: UIButton!
    @IBOutlet weak var CityPullDownButton: UIButton!
    @IBOutlet weak var AreaPullDownButton: UIButton!


    

    var city: [CitiesResponse] = []
    var defaultAddress : DefaultAddress?
    var cityName = ""
    var cityCode = ""
    var fullname = ""
    var phone = ""
    var address = ""
    var addressLine_2 = ""
    var zipCode = ""
    var cityy = ""
    var addressID = ""
    var country = ""
    
    var addressType = "home"
    var localType = "local"
    
    var isComeChange = Bool()
    var isComeOrder = Bool()
   

    var countriesName: [String] = []
    var countriesFlag: [String] = []
    var setProvince = ""

    var province:ProvinceDataModel? {
        didSet {
            let actions = province?.provinces?.enumerated().map { (index, province) in
                UIAction(title: province.province ?? "", handler: { _ in
                            print("\(province.province ?? "") selected at index \(index)")
                            self.cities = self.province?.provinces?[index].cities ?? []
                    self.setProvince = province.province ?? ""
                              self.provincelbl.text = province.province
                        })
                    }
                     ProvincePullDownButton.menu = UIMenu(children: actions!)
                     ProvincePullDownButton.showsMenuAsPrimaryAction = true
        }
    }
    var cities:[City]? {
        didSet {
            let actions = cities?.enumerated().map { (index, city) in
                UIAction(title: city.city ?? "", handler: { _ in
                            print("\(city.city ?? "") selected at index \(index)")
//                            self.cities = self.province?.provinces?[index].cities ?? []
                             self.areas = city.areas
                             self.citlbl.text = city.city
                        })
                    }
                     CityPullDownButton.menu = UIMenu(children: actions!)
                     CityPullDownButton.showsMenuAsPrimaryAction = true
        }
    }
    var areas:[String]? {
        didSet {
            let actions = areas?.enumerated().map { (index, area) in
                UIAction(title: area, handler: { _ in
                            print("\(area) selected at index \(index)")
                           self.arealbl.text = area
                        })
                    }
                    AreaPullDownButton.menu = UIMenu(children: actions!)
                    AreaPullDownButton.showsMenuAsPrimaryAction = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        mobileNumberTF.delegate = self
        address1TF.delegate = self
            address2TF.delegate = self
           zipCodeTF.delegate = self
           fullnameTF.delegate = self
        cityTblV.delegate = self
        cityTblV.dataSource = self
        countryTblV.delegate = self	
        countryTblV.dataSource = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        myStackView.addGestureRecognizer(tap)
        
        fullnameTF.text = fullname
        mobileNumberTF.text = phone
        address1TF.text = address
        address2TF.text = addressLine_2
        zipCodeTF.text = zipCode
        if cityy == "" {
//            cityLbl.text = "Select City"
		}
        if country == "" {
            countryLbl.text = "Saudi Arabia"
        }else {
            countryLbl.text = country
        }
       
        if localType == "local" {
//            scrollHeight.constant  = 650
         
            countryView.isHidden = true
            pakistanRadioImg.image = UIImage(named: "selectedRadioBlue")
            internationalRadioImg.image = UIImage(named: "radioBlue")
            cityViewPakistan.isHidden = false
            cityViewInternational.isHidden = true
            if cityy == "" {
//                cityLbl.text = "Select City"
            }else {
//                cityLbl.text = cityy
            }
            mobileNumerHeadingLbl.text = "mobilenmber".pLocalized(lang: LanguageManager.language) // whatsappnmber
//            mobileNumerCodeLbl.text = "+92"
            mobileNumerCodeLbl.text = "+966"
        }else {
            scrollHeight.constant = 750
           
            countryView.isHidden = false
            pakistanRadioImg.image = UIImage(named: "radioBlue")
            internationalRadioImg.image = UIImage(named: "selectedRadioBlue")
            cityViewPakistan.isHidden = true
            cityViewInternational.isHidden = false
            cityTF.text = cityy
            mobileNumerHeadingLbl.text = "whatsappnmber".pLocalized(lang: LanguageManager.language) // whatsappnmber
            mobileNumerCodeLbl.text = "+355"
        }
        
        
       
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        LanguageRender()
        getcities()
        getprovince(countryCode: "SA", language: "en", checkCache: false)
        for code in NSLocale.isoCountryCodes {
            let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
            let name = NSLocale(localeIdentifier: "en_UK").displayName(forKey: NSLocale.Key.identifier, value: id) ?? "Country not found for code: \(code)"
            countriesName.append(name)
        }
        
        let isoCodes = Locale.isoRegionCodes
        for isoCode in isoCodes {
            print(countryFlag(isoCode))
            countriesFlag.append(countryFlag(isoCode))
        }
        countryImg.font = UIFont.systemFont(ofSize: 30.0)
        countryImg.text = countryFlag("PK")
        
        if(isComeChange) {
            if let countryCode = countryCode(for: country, countryNames: countriesName, countryCodes: countriesFlag) {
                print("Country code for Canada: \(countryCode)")
                countryImg.text = countryCode
            } else {
               
            }
        }

    }
    
    
    func LanguageRender() {
        arealbl.text = "area".pLocalized(lang: LanguageManager.language)
        mobileNumberTF.placeholder = "entermobilenumber".pLocalized(lang: LanguageManager.language)
        provincelbl.text = "province".pLocalized(lang: LanguageManager.language)
        arealabeltext.text = "area".pLocalized(lang: LanguageManager.language)
        citlbl.text =  "selectcity".pLocalized(lang: LanguageManager.language)
        if LanguageManager.language == "ar"{
            zipCodeTF.placeholder = "الرمز البريدي"
            address1TF.placeholder  = "العنوان سطر 1"
            address2TF.placeholder  = "العنوان سطر2"
            provinceLabele.text  = "مقاطعة"
            fullnameTF.placeholder = "جون أكل"
            backBtn.setImage(UIImage(systemName: "arrow.right"), for: .normal)
            receiverFullNamei18.text = "الاسم الكامل للمستلم"
           }else{
               address1TF.placeholder  = "Address Line 1"
               address2TF.placeholder = "Address Line 2"
               zipCodeTF.placeholder = "Zip Code"
               provinceLabele.text  = "Province"
               receiverFullNamei18.text = "Receiver Full name"
               fullnameTF.placeholder = "John Jeo"
               backBtn.setImage(UIImage(systemName: "arrow.left"), for: .normal)
           }
        addNewAddressi18.text = "addnewaddress".pLocalized(lang: LanguageManager.language)
        pakistani18.text = "saudi".pLocalized(lang: LanguageManager.language)
        internationali18.text = "international".pLocalized(lang: LanguageManager.language)
        receiverFullNamei18.text = "receiverfullname".pLocalized(lang: LanguageManager.language)
        cityi18.text = "city".pLocalized(lang: LanguageManager.language)
        addressi18.text = "address".pLocalized(lang: LanguageManager.language)
        zipcodei18.text = "zipcode".pLocalized(lang: LanguageManager.language)
        homeBtn.setTitle("home".pLocalized(lang: LanguageManager.language), for: .normal)
        officeBtn.setTitle("office".pLocalized(lang: LanguageManager.language), for: .normal)
        saveAddressBtn.setTitle("saveaddress".pLocalized(lang: LanguageManager.language), for: .normal)
        countryi18.text = "country".pLocalized(lang: LanguageManager.language)
        selectCountry18n.text = "selectacountry".pLocalized(lang: LanguageManager.language)

    }
    
    func validate() -> Bool {
        if citlbl.text == "" {
            view.makeToast("city is required")
            return false
        }
        else {
            cityValidationImg.isHidden = true
        }
        if arealbl.text == "" {
            view.makeToast("area is required")
            return false
        }else {
            cityValidationImg.isHidden = true
        }
        if fullnameTF.text == "" {
//            fullnameValidationImg.isHidden = false
            view.makeToast("fullName is required")

            return false
        }else{
            fullnameValidationImg.isHidden = true
        }
        if mobileNumberTF.text == "" {
//            mobileNumberValidationImg.isHidden = false
            view.makeToast("Mobile Numer is required")

            return false
        }else{
            mobileNumberValidationImg.isHidden = true
        }
       
        if mobileNumberTF.text?.count ?? 0 <= 8{
//            mobileNumberValidationImg.isHidden = false
            view.makeToast("Mobile Number must be at least 9 digits long")

            return false
        }else {
            mobileNumberValidationImg.isHidden = true
        }
        if localType == "local" {
//            if cityLbl.text == "Select City" || cityLbl.text == "" {
//                Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(hideView), userInfo: nil, repeats: false)
//                view.makeToast("City Name Required")
//
////                cityValidationView.isHidden = false
//                return false
//            }else {
//                cityValidationView.isHidden = true
//            }
        }else {
            if cityTF.text == "Select City" || cityTF.text == "" {
//                cityValidationImg.isHidden = false
                view.makeToast("City Name Required")
                return false
            }else {
                cityValidationImg.isHidden = true
            }
        }

        if address1TF.text == ""{
//            addressValidationImg.isHidden = false
            view.makeToast("Address Required")
            return false
        }else {
            addressValidationImg.isHidden = true
        }
        if address1TF.text?.count ?? 0 <= 9{
//            addressValidationImg.isHidden = false
            view.makeToast("Adress length must be greater than 10 character")
            return false
        }else {
            addressValidationImg.isHidden = true
        }
//        if address2TF.text == ""{
////            addressValidationImg.isHidden = false
//            view.makeToast("Address Line 2 Required")
//            return false
//        }else {
//            addressValidationImg.isHidden = true
//        }
//        if address2TF.text?.count ?? 0 <= 9{
////            address2ValidationImg.isHidden = false
//            view.makeToast("Adress length must be greater than 10 character")
//            return false
//        }else {
//            address2ValidationImg.isHidden = true
//        }
        if zipCodeTF.text == "" {
//            zipCodeValidationImg.isHidden = false
            view.makeToast("zip code required")

            return false
        }else {
            zipCodeValidationImg.isHidden = true
        }
        if zipCodeTF.text?.count ?? 0 <= 4{
//            zipCodeValidationImg.isHidden = false
            view.makeToast("zip code/ postal code must be five character")
            return false
        }else {
            zipCodeValidationImg.isHidden = true
        }
        
        return true
    }
    
    @objc func hideView() {
        cityValidationView.isHidden = true
    }
    
    func countryCode(for countryName: String, countryNames: [String], countryCodes: [String]) -> String? {
        // Ensure both arrays have the same count
        guard countryNames.count == countryCodes.count else {
            print("Mismatched arrays - country names and country codes.")
            return nil
        }
        
        // Iterate through the country names array and find the index of the specified country name
        if let index = countryNames.firstIndex(of: countryName) {
            // Use the index to retrieve the corresponding country code from the country codes array
            return countryCodes[index]
        } else {
            print("Country not found.")
            return nil
        }
    }
    
    func countryFlag(_ countryCode: String) -> String {
        let flagBase = UnicodeScalar("🇦").value - UnicodeScalar("A").value
                let flag = countryCode
            .uppercased()
            .unicodeScalars
            .compactMap({ UnicodeScalar(flagBase + $0.value)?.description })
            .joined()
            
        return flag
    }
    
    private func getcities(){
        APIServices.citiesResponse(){[weak self] data in
            switch data{
            case .success(let res):
                    self?.city = res
                
                self?.cityTblV.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    private func addAddress(fullname:String,phone:String,province:String,city:String,city_code:String,address:String,addressType:String,localType:String,zipCode:String,addressLine_2:String,country:String,area:String){
        APIServices.addAddress(fullname: fullname, phone: phone, province: province, city: city, city_code: city_code, address: address, addressType: addressType, localType: localType, zipCode: zipCode, addressLine_2: addressLine_2, country: country, area: area){[weak self] data in
            switch data{
            case .success(let res):
                    self?.defaultAddress = res
                self?.defaultAdress(addressId: res.id ?? "", cartId: AppDefault.cartId ?? "")
            case .failure(let error):
                print(error)
                self?.view.makeToast(error)
            }
        }
    }
    
    private func updateAddress(addressId:String,fullname:String,phone:String,province:String,city:String,city_code:String,address:String,addressType:String,localType:String,zipCode:String,addressLine_2:String,country:String){
        APIServices.updateAddress(addressId:addressId,fullname: fullname, phone: phone, province: province, city: city, city_code: city_code, address: address, addressType: addressType, localType: localType, zipCode: zipCode, addressLine_2: addressLine_2, country: country){[weak self] data in
            switch data{
            case .success(let res):
                if self?.isComeOrder == true{
                    self?.defaultAddress = res
                }
            self?.defaultAdress(addressId: res.id ?? "", cartId: AppDefault.cartId ?? "")
            case .failure(let error):
                print(error)
                self?.view.makeToast(error)
            }
        }
    }
    
    private func defaultAdress(addressId:String,cartId:String){
        APIServices.defaultAdrress(addressId: addressId, cartId: cartId, completion: {[weak self] data in
            switch data{
            case .success(let res):
               //
                AppDefault.currentUser?.defaultAddress = self?.defaultAddress
                self?.navigationController?.popViewController(animated: true)
                if(res == "OK"){
                    self?.view.makeToast("Set Default Address Successfully")
                }else{
                    self?.view.makeToast(res)
                }
                
             case .failure(let error):
                print(error)
                self?.view.makeToast(error)
            }
        })
    }
    
    private func getprovince(countryCode:String,language:String,checkCache:Bool){
        APIServices.getprovince(countryCode: countryCode, language: language, checkCache: checkCache, completion: {[weak self] data in
            switch data{
            case .success(let res):
               //
             
                self?.province = res
                
             case .failure(let error):
                print(error)
                self?.view.makeToast(error)
            }
        })
    }

    
    
    
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        cityView.isHidden = true

    }
    
    @IBAction func countryCrossbtntapped(_ sender: Any) {
        countryTableView.isHidden = true
        backgroundHandleView.isHidden = true

    }
    @IBAction func countryBtnTapped(_ sender: Any) {
        countryTableView.isHidden = false
        backgroundHandleView.isHidden = false
        backgroundHandleView.backgroundColor = UIColor.black
        backgroundHandleView.isOpaque = false
        backgroundHandleView.alpha = 0.5

    }
    @IBAction func pakistanBtnTapped(_ sender: Any) {
        countryView.isHidden = true
        pakistanRadioImg.image = UIImage(named: "selectedRadioBlue")
        internationalRadioImg.image = UIImage(named: "radioBlue")
        localType = "local"
        cityViewPakistan.isHidden = false
        cityViewInternational.isHidden = true
        provinceView.isHidden = false
        AreaView.isHidden = false
            scrollHeight.constant  = 800
         
            countryView.isHidden = true
            pakistanRadioImg.image = UIImage(named: "selectedRadioBlue")
            internationalRadioImg.image = UIImage(named: "radioBlue")
            cityViewPakistan.isHidden = false
            cityViewInternational.isHidden = true
            if cityy == "" {
//                cityLbl.text = "selctcity".pLocalized(lang: LanguageManager.language)
            }else {
//                cityLbl.text = cityy
            }
            mobileNumerHeadingLbl.text = "mobilenmber".pLocalized(lang: LanguageManager.language) // whatsappnmber
//            mobileNumerCodeLbl.text = "+92"
            mobileNumerCodeLbl.text = "+966"
     
    }
    
    func keyboardDown (){
        
        mobileNumberTF.resignFirstResponder()
        address1TF.resignFirstResponder()
            address2TF.resignFirstResponder()
           zipCodeTF.resignFirstResponder()
           fullnameTF.resignFirstResponder()

    }
    @IBAction func internationalBtnTapped(_ sender: Any) {
        countryView.isHidden = false
        pakistanRadioImg.image = UIImage(named: "radioBlue")
        internationalRadioImg.image = UIImage(named: "selectedRadioBlue")
        localType = "international"
        cityViewPakistan.isHidden = true
        cityViewInternational.isHidden = false
        provinceView.isHidden = true
        AreaView.isHidden = true
            scrollHeight.constant = 750
           
            countryView.isHidden = false
            pakistanRadioImg.image = UIImage(named: "radioBlue")
            internationalRadioImg.image = UIImage(named: "selectedRadioBlue")
            cityViewPakistan.isHidden = true
            cityViewInternational.isHidden = false
            cityTF.text = cityy
            mobileNumerHeadingLbl.text = "whatsappnmber".pLocalized(lang: LanguageManager.language) // whatsappnmber
            mobileNumerCodeLbl.text = "+355"
        
    }
    
    @IBAction func homeBtnTapped(_ sender: Any) {
        homeBtn.borderColor = primaryColor
        officeBtn.borderColor = UIColor.systemGray2
        addressType = "home"

    }
    
    @IBAction func officeBtnTapped(_ sender: Any) {
        homeBtn.borderColor = UIColor.systemGray2
        officeBtn.borderColor = primaryColor
        addressType = "office"

    }
 
    @IBAction func saveAddressBtnTapped(_ sender: Any) {
        keyboardDown()
        if(validate()) {
            if(isComeChange) {
                 
                updateAddress(addressId: addressID,fullname: fullnameTF.text ?? "", phone: "\(mobileNumberTF.text ?? "")", province:setProvince , city: citlbl.text ?? "" , city_code: "+966", address: address1TF.text ?? "", addressType: addressType, localType: localType, zipCode: zipCodeTF.text ?? "", addressLine_2: address2TF.text ?? "", country: countryLbl.text ?? "")
                
            }else {
                
                addAddress(fullname: fullnameTF.text ?? "", phone: "+966\(mobileNumberTF.text ?? "")", province:setProvince, city: citlbl.text ?? "" , city_code: "+966", address: address1TF.text ?? "", addressType: addressType, localType: localType, zipCode: zipCodeTF.text ?? "", addressLine_2: address2TF.text ?? "", country: countryLbl.text ?? "",area: arealbl.text ?? "")
                    
                
            }

        } else {}
    }
}

extension AddAddressViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == countryTblV {
            return countriesName.count
        }else {
//            return dropDownData.count
             return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == countryTblV {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CountryTableViewCell", for: indexPath) as! CountryTableViewCell
            cell.countryImgLbl.font = UIFont.systemFont(ofSize: 40.0)

            cell.countryImgLbl.text = countriesFlag[indexPath.row]
            cell.countryNameLbl.text = countriesName[indexPath.row]
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CityTableViewCell", for: indexPath) as! CityTableViewCell
//            let data = dropDownData[indexPath.row]
//            cell.textLabel?.text = data

            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == countryTblV {
            let selectedCountry = countriesFlag[indexPath.row]
            let selectedCountryName = countriesName[indexPath.row]
            countryImg.text = selectedCountry
            countryLbl.text = selectedCountryName
            countryTableView.isHidden = true
            backgroundHandleView.isHidden = true

        }else {
//            let selectedValue = dropDownData[indexPath.row]
//            cityName = selectedValue
//            cityLbl.text = selectedValue
//            cityy = selectedValue
//            cityCode = selectedValue
//            cityView.isHidden = true
        }
    }
    
 
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
    
}

extension AddAddressViewController: UITextFieldDelegate {
  
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                    replacementString string: String) -> Bool {
        if textField == zipCodeTF {
            let currentString: NSString = textField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= 6
        }else if textField == mobileNumberTF{
            let currentString: NSString = textField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= 10
        }else {
            let currentString: NSString = textField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= 128
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == cityTF {
            cityy = cityTF.text ?? ""
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // ✅ This hides the keyboard
        return true
    }
}



