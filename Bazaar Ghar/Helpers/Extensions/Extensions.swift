//
//  Extensions.swift
//  RGB
//
//  Created by invision75 on 03/11/2021.
//

import UIKit
extension UIApplication {

    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
  
}
extension String {
    var isValidPassword:Bool {
        let passwordRegex = "^" +
        "(?=.*[0-9])" +         //at least 1 digit
        "(?=.*[a-z])" +         //at least 1 lower case letter
        "(?=.*[A-Z])" +         //at least 1 upper case letter
        "(?=.*[a-zA-Z])" +      //any letter
        "(?=.*[@#$%^&+=!])" +    //at least 1 special character
        "(?=\\S+$)" +           //no white spaces
        ".{8,}" +               //at least 8 characters
        "$"
        return self.range(of: passwordRegex, options: .regularExpression) != nil ? true : false
    }
    
    func remainingDaysFromCurrentDate() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        formatter.date(from: self)
        
    }
    func applyPatternOnNumbers(pattern: String, replacementCharacter: Character) -> String {
        var pureNumber = self.replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression)
        for index in 0 ..< pattern.count {
            guard index < pureNumber.count else { return pureNumber }
            let stringIndex = String.Index(utf16Offset: index, in: pattern)
            let patternCharacter = pattern[stringIndex]
            guard patternCharacter != replacementCharacter else { continue }
            pureNumber.insert(patternCharacter, at: stringIndex)
        }
        return pureNumber
    }
    /// mask example: `+X (XXX) XXX-XXXX`
    func format(with mask: String) -> String {
        let numbers = self.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex // numbers iterator
        
        // iterate over the mask characters until the iterator of numbers ends
        for ch in mask where index < numbers.endIndex {
            if ch == "X" {
                // mask requires a number in this place, so take the next one
                result.append(numbers[index])
                
                // move numbers iterator to the next index
                index = numbers.index(after: index)
                
            } else {
                result.append(ch) // just append a mask character
            }
        }
        return result
    }
}

extension UIViewController{
    func popController(){
        self.navigationController?.popViewController(animated: true)
    }
    func PushController(vc:UIViewController){
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func PresentController(vc:UIViewController){
        self.present(vc, animated: true)
    }
    
}
extension Bool {
    var intValue: Int {
        return self ? 1 : 0
    }
}
extension Int {
    func decToHexString() -> String {
        //        let result = decToHexStringFormat()
        let result = createString(radix: 16)
        return result
    }
    fileprivate  func createString(radix: Int) -> String {
            return String(self, radix: radix, uppercase: true)
        }
}
extension String {
    var boolValue: Bool {
        return (self as NSString).boolValue
    }}
extension Data {
    struct HexEncodingOptions: OptionSet {
        let rawValue: Int
        static let upperCase = HexEncodingOptions(rawValue: 1 << 0)
    }

    func hexEncodedString(options: HexEncodingOptions = []) -> String {
        let format = options.contains(.upperCase) ? "%02hhX" : "%02hhx"
        return self.map { String(format: format, $0) }.joined()
    }
    var checksum: Int {
        return self.map { Int($0) }.reduce(0, +) & 0xff
    }
}
extension CALayer {
    public func configureGradientBackground(_ colors:CGColor...){
        
        let gradient = CAGradientLayer()
        let maxWidth = max(self.bounds.size.height,self.bounds.size.width)
        let squareFrame = CGRect(origin: self.bounds.origin, size: CGSize(width: maxWidth, height: maxWidth))
        gradient.frame = squareFrame
        gradient.colors = colors
        self.insertSublayer(gradient, at: 0)
    }
}

extension UIView{
    func makeRounded() {
        
         self.layer.masksToBounds = true
         self.layer.cornerRadius = self.frame.height / 2
         self.clipsToBounds = true
         
         self.layer.shadowColor = UIColor.black.cgColor
         self.layer.shadowOpacity = 1
         self.layer.shadowOffset = .zero
         self.layer.shadowRadius = 2
    }
    
    func addShadow(){
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = 0.3
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 0.0
    }
    func addBottomShadow() {
        layer.masksToBounds = false
        layer.shadowRadius = 4
        layer.shadowOpacity = 1
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 0 , height: 2)
        layer.shadowPath = UIBezierPath(rect: CGRect(x: 0,                                                  y: bounds.maxY - layer.shadowRadius,                                                  width: bounds.width,                                                  height: layer.shadowRadius)).cgPath
        
    }
    func fadeIn()  {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.alpha = 1
        }, completion: nil)
    }
    func fadeout()  {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.alpha = 0.0
        }, completion: nil)
    }
    func round(corners: UIRectCorner, cornerRadius: Double) {
        
        let size = CGSize(width: cornerRadius, height: cornerRadius)
        let bezierPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: size)
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = self.bounds
        shapeLayer.path = bezierPath.cgPath
        self.layer.mask = shapeLayer
    }
}
extension UIFont {
  public enum fontType: String {
    case regular = ""
    case kFontBlackItalic = "Montserrat-BlackItalic"
    case kFontExtraBoldItalic = "Montserrat-ExtraBoldItalic"
    case kFontBoldItalic = "Montserrat-BoldItalic"
    case kFontSemiBoldItalic = "Montserrat-SemiBoldItalic"
    case kFontMediumItalic = "Montserrat-MediumItalic"
    case kFontItalic = "Montserrat-Italic"
    case kFontLightItalic = "Montserrat-LightItalic"
    case kFontBlack = "Bruna-Bold"
    case kFontExtraLightItalic = "Montserrat-ExtraLightItalic"
    case kFontThinItalic = "Montserrat-ThinItalic"
    case kFontExtraBold = "Montserrat-ExtraBold"
    case kFontBold = "Montserrat-Bold"
    case kFontSemiBold = "Montserrat-SemiBold"
    case kFontMedium = "Montserrat-Medium"
    case kFontRegular = "Montserrat-Regular"
    case kFontLight = "Montserrat-Light"
    case kFontExtraLight = "Montserrat-ExtraLight"
    case kFontThin = "Montserrat-Thin"
}
    
static func setFont(_ type: fontType = .regular, size: CGFloat = UIFont.systemFontSize) -> UIFont? {
    return UIFont(name: type.rawValue, size: size)
    }
 }
   
extension Double{
    func roundTo(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
    func toCelsius(degree: Double) -> Double {
        return degree - 273.15
    }

    func toFahrenheit(degree: Double) -> Double {
        return (degree - 273.15) * 1.8 + 32.0
    }
    func toInt() -> Int? {
        if self >= Double(Int.min) && self < Double(Int.max) {
            return Int(self)
        } else {
            return nil
        }
    }
}
extension Double {
  /// Rounds the double to decimal places value
  func pRoundTo(places:Int) -> Double {
    let divisor = pow(10.0, Double(places))
    return (self * divisor).rounded() / divisor
  }
  //MARK:- Format number
  func prettyNumberFormat(_ currencySymbol:String = "$")->String? {
    let formatter = NumberFormatter()
    formatter.minimumFractionDigits = 0
    formatter.numberStyle = .currency
    formatter.currencySymbol = currencySymbol
    formatter.allowsFloats = true
    formatter.alwaysShowsDecimalSeparator = true
    formatter.currencyGroupingSeparator = ","
    formatter.currencyDecimalSeparator = ""
    return formatter.string(from: NSNumber(value: self))
  }
}
extension Float {
  /// Rounds the double to decimal places value
  func pRoundTo(places:Int) -> Float {
    let divisor = pow(10.0, Double(places))
      return Float((Double(self) * divisor).rounded() / divisor)
  }
  //MARK:- Format number
  func prettyNumberFormat(_ currencySymbol:String = "$")->String? {
    let formatter = NumberFormatter()
    formatter.minimumFractionDigits = 0
    formatter.numberStyle = .currency
    formatter.currencySymbol = currencySymbol
    formatter.allowsFloats = true
    formatter.alwaysShowsDecimalSeparator = true
    formatter.currencyGroupingSeparator = ","
    formatter.currencyDecimalSeparator = ""
    return formatter.string(from: NSNumber(value: self))
  }
}
extension Double {
  private static var pNumberFormatter: NumberFormatter = {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    return numberFormatter
  }()
  var pDelimiter: String {
    return Double.pNumberFormatter.string(from: NSNumber(value: self)) ?? ""
  }
}
extension CGFloat {
    func toCelsius(degree: CGFloat) -> CGFloat {
        return degree - 273.15
    }

    func toFahrenheit(degree: CGFloat) -> CGFloat {
        return (degree - 273.15) * 1.8 + 32.0
    }
}
extension UIImage {
    public class func gifImageWithName(_ name: String) -> UIImage? {
          guard let bundleURL = Bundle.main
              .url(forResource: name, withExtension: "gif") else {
                  print("SwiftGif: This image named \"\(name)\" does not exist")
                  return nil
          }
          guard let imageData = try? Data(contentsOf: bundleURL) else {
              print("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
              return nil
          }
          
          return gifImageWithData(imageData)
      }
    public class func gifImageWithData(_ data: Data) -> UIImage? {
            guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
                print("image doesn't exist")
                return nil
            }
            
            return UIImage.animatedImageWithSource(source)
        }
    class func animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
          let count = CGImageSourceGetCount(source)
          var images = [CGImage]()
          var delays = [Int]()
          
          for i in 0..<count {
              if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                  images.append(image)
              }
              
              let delaySeconds = UIImage.delayForImageAtIndex(Int(i),
                  source: source)
              delays.append(Int(delaySeconds * 450.0)) // Seconds to ms  //1000.0
          }
          
          let duration: Int = {
              var sum = 0
              
              for val: Int in delays {
                  sum += val
              }
              
              return sum
          }()
          
          let gcd = gcdForArray(delays)
          var frames = [UIImage]()
          
          var frame: UIImage
          var frameCount: Int
          for i in 0..<count {
              frame = UIImage(cgImage: images[Int(i)])
              frameCount = Int(delays[Int(i)] / gcd)
              
              for _ in 0..<frameCount {
                  frames.append(frame)
              }
          }
          
          let animation = UIImage.animatedImage(with: frames,
              duration: Double(duration) / 1000.0)
          
          return animation
      }
    class func delayForImageAtIndex(_ index: Int, source: CGImageSource!) -> Double {
           var delay = 0.1
           
           let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
           let gifProperties: CFDictionary = unsafeBitCast(
               CFDictionaryGetValue(cfProperties,
                   Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()),
               to: CFDictionary.self)
           
           var delayObject: AnyObject = unsafeBitCast(
               CFDictionaryGetValue(gifProperties,
                   Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
               to: AnyObject.self)
           if delayObject.doubleValue == 0 {
               delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                   Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
           }
           
           delay = delayObject as! Double
           
           if delay < 0.1 {
               delay = 0.1
           }
           
           return delay
       }
       
       class func gcdForPair(_ a: Int?, _ b: Int?) -> Int {
           var a = a
           var b = b
           if b == nil || a == nil {
               if b != nil {
                   return b!
               } else if a != nil {
                   return a!
               } else {
                   return 0
               }
           }
           
         
           
           var rest: Int
           while true {
               rest = a! % b!
               
               if rest == 0 {
                   return b!
               } else {
                   a = b
                   b = rest
               }
           }
       }
       
       class func gcdForArray(_ array: Array<Int>) -> Int {
           if array.isEmpty {
               return 1
           }
           
           var gcd = array[0]
           
           for val in array {
               gcd = UIImage.gcdForPair(val, gcd)
           }
           
           return gcd
       }
    class func colorForNavBar(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        //    Or if you need a thinner border :
        //    let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 0.5)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
}

extension UINavigationController {
    func pushViewController(viewController: UIViewController, animated: Bool, completion: @escaping () -> Void) {
        pushViewController(viewController, animated: animated)
        
        if animated, let coordinator = transitionCoordinator {
            coordinator.animate(alongsideTransition: nil) { _ in
                completion()
            }
        } else {
            completion()
        }
    }
    
    func popViewController(animated: Bool, completion: @escaping () -> Void) {
        popViewController(animated: animated)
        
        if animated, let coordinator = transitionCoordinator {
            coordinator.animate(alongsideTransition: nil) { _ in
                completion()
            }
        } else {
            completion()
        }
    }
}

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}

extension Date {
    var currentTimeStamp:String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        let time = formatter.string(from: self)
        return time
    }
    func getFormattedDate(format: String) -> String {
         let dateformat = DateFormatter()
         dateformat.dateFormat = format
         return dateformat.string(from: self)
     }
    func adding(minutes: Int) -> Date {
        return Calendar.current.date(byAdding: .minute, value: minutes, to: self)!
    }
    

}


extension NSMutableAttributedString {

    func setBoldText(textForAttribute: String, withColor color: UIColor, withFontSize size: Int) {
        let range: NSRange = self.mutableString.range(of: textForAttribute, options: .caseInsensitive)
        
        self.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: CGFloat(size), weight: .bold), range: range)

    }

}
extension UIApplication {
  var pStatusBarView: UIView? {
    if responds(to: Selector(("statusBar"))) {
      return value(forKey: "statusBar") as? UIView
    }
    return nil
  }
  class func pTopViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) ->
    UIViewController! {
      if let navigationController = controller as? UINavigationController {
        return pTopViewController(controller: navigationController.visibleViewController)
      }
      if let tabController = controller as? UITabBarController {
        if let selected = tabController.selectedViewController {
          return pTopViewController(controller: selected)
        }
      }
      if let presented = controller?.presentedViewController {
        return pTopViewController(controller: presented)
      }
      return controller
  }
  class func pTopViewControllerOptional(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) ->
    UIViewController? {
      if let navigationController = controller as? UINavigationController {
        return pTopViewController(controller: navigationController.visibleViewController)
      }
      if let tabController = controller as? UITabBarController {
        if let selected = tabController.selectedViewController {
          return pTopViewController(controller: selected)
        }
      }
      if let presented = controller?.presentedViewController {
        return pTopViewController(controller: presented)
      }
      return controller ?? nil
  }
}

extension String {


  func getURL() -> String? {
    let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
    let matches = detector.matches(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count))
    for match in matches {
      guard let range = Range(match.range, in: self) else { continue }
      let url = self[range]
      print(url)
      return String(url)
    }
    return nil
  }
  func pLocalized(lang: String = LanguageManager.language) ->String {
    let path = Bundle.main.path(forResource: lang, ofType: "lproj")
    let bundle = Bundle(path: path!)
    return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
  }
  func pLocalizedEn(lang: String) ->String {
    let path = Bundle.main.path(forResource: lang, ofType: "lproj")
    let bundle = Bundle(path: path!)
    return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
  }
  func pUtcToLocalDateTime() -> String? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd H:mm:ss.S"
    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    if let date = dateFormatter.date(from: self) {
      dateFormatter.timeZone = TimeZone.current
      dateFormatter.dateFormat = "yyyy-MM-dd H:mm:ss.S"
      return dateFormatter.string(from: date)
    }
    return nil
  }
 
  func pChangeFormat(from:String = "yyyy-MM-dd'T'HH:mm:ss.SSSZ",to:String)->String {
    let formatter = DateFormatter()
    formatter.dateFormat = from //"yyyy-MM-dd HH:mm:ss"
    let date = formatter.date(from: self)
    formatter.dateFormat = to
    //formatter.dateStyle = .full
    formatter.locale  = Locale(identifier:LanguageManager.language)
    if let convertedDate = date{
      if to == "dd MMM yyyy" {
        if let d = formatter.string(from: convertedDate).split(separator: " ").first,
          let day = Int(d){
          // String(d)
          let numberFormatter = NumberFormatter()
          numberFormatter.numberStyle = .ordinal
          let ordinalDay = numberFormatter.string(from: NSNumber(value: day))
          return formatter.string(from: convertedDate).replacingOccurrences(of: String(d), with: ordinalDay ?? "")
        }
      }
      return formatter.string(from: convertedDate)
    }else{
      return self
    }
  }
  func pToDate(_ format:String = "yyyy-MM-dd'T'HH:mm:ss.SSSZ") -> Date? {
    let formatter = DateFormatter()
    formatter.dateFormat = format
    return formatter.date(from: self)
  }
  func pMakeFirebaseString()->String{
    let arrCharacterToReplace = [".","#","$","[","]"]
    var finalString = self
    for character in arrCharacterToReplace{
      finalString = finalString.replacingOccurrences(of: character, with: " ")
    }
    return finalString
  }
  func pCapitalizingFirstLetter() -> String {
    let first = String(self.prefix(1)).capitalized
    let other = String(self.dropFirst())
    return first + other
  }
  func pRemoveSpaces() -> String {
    let trimmedString = self.trimmingCharacters(in: .whitespaces)
    return trimmedString
  }
  mutating func capitalizeFirstLetter() {
    self = self.pCapitalizingFirstLetter()
  }
  func pSpaceToUnderscore() -> String {
    return self.replacingOccurrences(of: " ", with: "_")
  }
  func pUnderscoreToSpace() -> String {
    return self.replacingOccurrences(of: "_", with: " ")
  }
  func pIsValidEmail() -> Bool {
    // here, `try!` will always succeed because the pattern is valid
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailPred.evaluate(with: self)
  }
  func isValidEmail() -> Bool {
    // here, `try!` will always succeed because the pattern is valid
    let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
    return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
  }
  // vrify Valid PhoneNumber or Not
  func pStrikeThrough() -> NSAttributedString {
    let attributeString = NSMutableAttributedString(string: self)
    attributeString.addAttribute(
      NSAttributedString.Key.strikethroughStyle,
      value: NSUnderlineStyle.single.rawValue,
      range:NSMakeRange(0,attributeString.length))
    return attributeString
  }
  func pToKhamr() -> String {
    var text = self
    text = text.replacingOccurrences(of: "0", with: "0".pLocalized())
    text = text.replacingOccurrences(of: "1", with: "1".pLocalized())
    text = text.replacingOccurrences(of: "2", with: "2".pLocalized())
    text = text.replacingOccurrences(of: "3", with: "3".pLocalized())
    text = text.replacingOccurrences(of: "4", with: "4".pLocalized())
    text = text.replacingOccurrences(of: "5", with: "5".pLocalized())
    text = text.replacingOccurrences(of: "6", with: "6".pLocalized())
    text = text.replacingOccurrences(of: "7", with: "7".pLocalized())
    text = text.replacingOccurrences(of: "8", with: "8".pLocalized())
    text = text.replacingOccurrences(of: "9", with: "9".pLocalized())
    text = text.replacingOccurrences(of: ":", with: ":".pLocalized())
    text = text.replacingOccurrences(of: "AM", with: "AM".pLocalized())
    text = text.replacingOccurrences(of: "PM", with: "PM".pLocalized())
    text = text.replacingOccurrences(of: "st", with: "".pLocalized())
    //text = text.replacingOccurrences(of: "nd", with: "".pLocalized())
    text = text.replacingOccurrences(of: "th", with: "".pLocalized())
    return text
  }

   func convertHtmlToAttributedStringWithCSS(font: UIFont? , csscolor: String , lineheight: Int, csstextalign: String) -> NSAttributedString? {
    guard let font = font else {
      return convertHtmlToNSAttributedString
    }
    let modifiedString = "<style>body{font-family: '\(font.fontName)'; font-size:\(font.pointSize)px; color: \(csscolor); line-height: \(lineheight)px; text-align: \(csstextalign); }</style>\(self)";
    guard let data = modifiedString.data(using: .utf8) else {
      return nil
    }
    do {
      return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
    }
    catch {
      print(error)
      return nil
    }
  }
  public var convertHtmlToNSAttributedString: NSAttributedString? {
    guard let data = data(using: .utf8) else {
      return nil
    }
    do {
      return try NSAttributedString(data: data,options: [.documentType: NSAttributedString.DocumentType.html,.characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
    }
    catch {
      print(error.localizedDescription)
      return nil
    }
  }
}
