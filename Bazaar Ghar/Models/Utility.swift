//
//  Utility.swift
//  Bazaar Ghar
//
//  Created by Developer on 04/08/2023.
//

import Foundation
import UIKit
import Kingfisher
import ImageIO



class Utility {
   
    let countryCodesToPhoneCodes: [String: String] = [
        "AF": "+93", "AL": "+355", "DZ": "+213", "AD": "+376", "AO": "+244", "AI": "+1-264",
        "AG": "+1-268", "AR": "+54", "AM": "+374", "AW": "+297", "AU": "+61", "AT": "+43",
        "AZ": "+994", "BS": "+1-242", "BH": "+973", "BD": "+880", "BB": "+1-246", "BY": "+375",
        "BE": "+32", "BZ": "+501", "BJ": "+229", "BM": "+1-441", "BT": "+975", "BO": "+591",
        "BA": "+387", "BW": "+267", "BR": "+55", "IO": "+246", "VG": "+1-284", "BN": "+673",
        "BG": "+359", "BF": "+226", "BI": "+257", "KH": "+855", "CM": "+237", "CA": "+1",
        "CV": "+238", "KY": "+1-345", "CF": "+236", "TD": "+235", "CL": "+56", "CN": "+86",
        "CX": "+61", "CC": "+61", "CO": "+57", "KM": "+269", "CK": "+682", "CR": "+506",
        "HR": "+385", "CU": "+53", "CW": "+599", "CY": "+357", "CZ": "+420", "CD": "+243",
        "DK": "+45", "DJ": "+253", "DM": "+1-767", "DO": "+1-809", "TL": "+670", "EC": "+593",
        "EG": "+20", "SV": "+503", "GQ": "+240", "ER": "+291", "EE": "+372", "ET": "+251",
        "FK": "+500", "FO": "+298", "FJ": "+679", "FI": "+358", "FR": "+33", "GF": "+594",
        "PF": "+689", "GA": "+241", "GM": "+220", "GE": "+995", "DE": "+49", "GH": "+233",
        "GI": "+350", "GR": "+30", "GL": "+299", "GD": "+1-473", "GP": "+590", "GU": "+1-671",
        "GT": "+502", "GG": "+44-1481", "GN": "+224", "GW": "+245", "GY": "+592", "HT": "+509",
        "HN": "+504", "HK": "+852", "HU": "+36", "IS": "+354", "IN": "+91", "ID": "+62",
        "IR": "+98", "IQ": "+964", "IE": "+353", "IM": "+44-1624", "IL": "+972", "IT": "+39",
        "CI": "+225", "JM": "+1-876", "JP": "+81", "JE": "+44-1534", "JO": "+962", "KZ": "+7",
        "KE": "+254", "KI": "+686", "XK": "+383", "KW": "+965", "KG": "+996", "LA": "+856",
        "LV": "+371", "LB": "+961", "LS": "+266", "LR": "+231", "LY": "+218", "LI": "+423",
        "LT": "+370", "LU": "+352", "MO": "+853", "MK": "+389", "MG": "+261", "MW": "+265",
        "MY": "+60", "MV": "+960", "ML": "+223", "MT": "+356", "MH": "+692", "MQ": "+596",
        "MR": "+222", "MU": "+230", "YT": "+262", "MX": "+52", "FM": "+691", "MD": "+373",
        "MC": "+377", "MN": "+976", "ME": "+382", "MS": "+1-664", "MA": "+212", "MZ": "+258",
        "MM": "+95", "NA": "+264", "NR": "+674", "NP": "+977", "NL": "+31", "NC": "+687",
        "NZ": "+64", "NI": "+505", "NE": "+227", "NG": "+234", "NU": "+683", "NF": "+672",
        "KP": "+850", "MP": "+1-670", "NO": "+47", "OM": "+968", "PK": "+92", "PW": "+680",
        "PS": "+970", "PA": "+507", "PG": "+675", "PY": "+595", "PE": "+51", "PH": "+63",
        "PN": "+64", "PL": "+48", "PT": "+351", "PR": "+1-787", "QA": "+974", "CG": "+242",
        "RE": "+262", "RO": "+40", "RU": "+7", "RW": "+250", "BL": "+590", "SH": "+290",
        "KN": "+1-869", "LC": "+1-758", "MF": "+590", "PM": "+508", "VC": "+1-784",
        "WS": "+685", "SM": "+378", "ST": "+239", "SA": "+966", "SN": "+221", "RS": "+381",
        "SC": "+248", "SL": "+232", "SG": "+65", "SX": "+1-721", "SK": "+421", "SI": "+386",
        "SB": "+677", "SO": "+252", "ZA": "+27", "KR": "+82", "SS": "+211", "ES": "+34",
        "LK": "+94", "SD": "+249", "SR": "+597", "SJ": "+47", "SZ": "+268", "SE": "+46",
        "CH": "+41", "SY": "+963", "TW": "+886", "TJ": "+992", "TZ": "+255", "TH": "+66",
        "TG": "+228", "TK": "+690", "TO": "+676", "TT": "+1-868", "TN": "+216", "TR": "+90",
        "TM": "+993", "TC": "+1-649", "TV": "+688", "UG": "+256", "UA": "+380", "AE": "+971",
        "GB": "+44", "US": "+1", "UY": "+598", "UZ": "+998", "VU": "+678", "VA": "+379",
        "VE": "+58", "VN": "+84", "WF": "+681", "EH": "+212", "YE": "+967", "ZM": "+260",
        "ZW": "+263"
    ]
    
    let countryPhoneLengths: [String: Int] = [
        "AD": 9, "AE": 9, "AF": 9, "AG": 7, "AI": 7, "AL": 9, "AM": 8, "AO": 9, "AQ": 7, "AR": 10,
        "AS": 10, "AT": 11, "AU": 10, "AW": 7, "AX": 7, "AZ": 9, "BA": 8, "BB": 7, "BD": 10, "BE": 9,
        "BF": 8, "BG": 9, "BH": 8, "BI": 8, "BJ": 8, "BL": 10, "BM": 7, "BN": 8, "BO": 8, "BQ": 7,
        "BR": 11, "BS": 7, "BT": 8, "BV": 7, "BW": 9, "BY": 9, "BZ": 7, "CA": 10, "CC": 7, "CD": 9,
        "CF": 8, "CG": 9, "CH": 10, "CI": 8, "CK": 7, "CL": 9, "CM": 9, "CN": 11, "CO": 10, "CR": 8,
        "CU": 8, "CV": 7, "CW": 7, "CX": 7, "CY": 9, "CZ": 9, "DE": 10, "DJ": 8, "DK": 8, "DM": 7,
        "DO": 10, "DZ": 9, "EC": 10, "EE": 8, "EG": 10, "EH": 8, "ER": 8, "ES": 9, "ET": 9, "FI": 10,
        "FJ": 7, "FK": 7, "FM": 7, "FO": 6, "FR": 10, "GA": 9, "GB": 11, "GD": 7, "GE": 8, "GF": 10,
        "GG": 10, "GH": 9, "GI": 8, "GL": 7, "GM": 8, "GN": 8, "GP": 10, "GQ": 9, "GR": 10, "GS": 7,
        "GT": 8, "GU": 10, "GW": 8, "GY": 9, "HK": 8, "HM": 7, "HN": 8, "HR": 9, "HT": 8, "HU": 9,
        "ID": 11, "IE": 9, "IL": 9, "IM": 7, "IN": 10, "IO": 7, "IQ": 10, "IR": 10, "IS": 7, "IT": 10,
        "JE": 10, "JM": 7, "JO": 9, "JP": 11, "KE": 9, "KG": 9, "KH": 9, "KI": 7, "KM": 8, "KN": 7,
        "KP": 9, "KR": 10, "KW": 8, "KY": 7, "KZ": 10, "LA": 8, "LB": 8, "LC": 7, "LI": 8, "LK": 9,
        "LR": 8, "LS": 8, "LT": 8, "LU": 8, "LV": 8, "LY": 9, "MA": 10, "MC": 8, "MD": 8, "ME": 9,
        "MF": 10, "MG": 9, "MH": 7, "MK": 9, "ML": 8, "MM": 9, "MN": 8, "MO": 8, "MP": 10, "MQ": 10,
        "MR": 9, "MS": 7, "MT": 8, "MU": 8, "MV": 7, "MW": 9, "MX": 10, "MY": 10, "MZ": 9, "NA": 8,
        "NC": 7, "NE": 8, "NF": 7, "NG": 10, "NI": 8, "NL": 10, "NO": 8, "NP": 10, "NR": 7, "NU": 7,
        "NZ": 10, "OM": 8, "PA": 8, "PE": 9, "PF": 11, "PG": 9, "PH": 10, "PK": 10, "PL": 9, "PM": 7,
        "PN": 7, "PR": 10, "PS": 9, "PT": 9, "PW": 7, "PY": 9, "QA": 8, "RE": 10, "RO": 9, "RS": 9,
        "RU": 10, "RW": 9, "SA": 9, "SB": 7, "SC": 7, "SD": 9, "SE": 10, "SG": 8, "SH": 7, "SI": 9,
        "SJ": 7, "SK": 9, "SL": 8, "SM": 8, "SN": 9, "SO": 8, "SR": 7, "SS": 9, "ST": 8, "SV": 8,
        "SX": 8, "SY": 10, "SZ": 9, "TC": 7, "TD": 8, "TF": 7, "TG": 8, "TH": 9, "TJ": 9, "TK": 7,
        "TL": 8, "TM": 8, "TN": 8, "TO": 7, "TR": 10, "TT": 7, "TV": 7, "TW": 9, "TZ": 9, "UA": 10,
        "UG": 10, "UM": 7, "US": 10, "UY": 8, "UZ": 9, "VA": 8, "VC": 7, "VE": 11, "VG": 7, "VI": 10,
        "VN": 10, "VU": 7, "WF": 7, "WS": 7, "YE": 9, "YT": 9, "ZA": 9, "ZM": 9, "ZW": 9
    ]

    let countryCodes: [String: String] = [
        "Andorra": "AD", "United Arab Emirates": "AE", "Afghanistan": "AF", "Antigua and Barbuda": "AG",
        "Anguilla": "AI", "Albania": "AL", "Armenia": "AM", "Angola": "AO", "Argentina": "AR", "American Samoa": "AS",
        "Austria": "AT", "Australia": "AU", "Aruba": "AW", "Aland Islands": "AX", "Azerbaijan": "AZ", "Bosnia and Herzegovina": "BA",
        "Barbados": "BB", "Bangladesh": "BD", "Belgium": "BE", "Burkina Faso": "BF", "Bulgaria": "BG", "Bahrain": "BH", "Burundi": "BI",
        "Benin": "BJ", "Saint Barthelemy": "BL", "Bermuda": "BM", "Brunei Darussalam": "BN", "Bolivia (Plurinational State of)": "BO",
        "Bonaire, Sint Eustatius and Saba": "BQ", "Brazil": "BR", "Bahamas": "BS", "Bhutan": "BT", "Bouvet Island": "BV", "Botswana": "BW",
        "Belarus": "BY", "Belize": "BZ", "Canada": "CA", "Cocos (Keeling) Islands": "CC", "Congo, Democratic Republic of the": "CD",
        "Central African Republic": "CF", "Congo": "CG", "Switzerland": "CH", "Cote d'Ivoire": "CI", "Cook Islands": "CK", "Chile": "CL",
        "Cameroon": "CM", "China": "CN", "Colombia": "CO", "Costa Rica": "CR", "Cuba": "CU", "Cabo Verde": "CV", "Curacao": "CW",
        "Christmas Island": "CX", "Cyprus": "CY", "Czechia": "CZ", "Germany": "DE", "Djibouti": "DJ", "Denmark": "DK", "Dominica": "DM",
        "Dominican Republic": "DO", "Algeria": "DZ", "Ecuador": "EC", "Estonia": "EE", "Egypt": "EG", "Western Sahara": "EH", "Eritrea": "ER",
        "Spain": "ES", "Ethiopia": "ET", "Finland": "FI", "Fiji": "FJ", "Falkland Islands (Malvinas)": "FK", "Micronesia (Federated States of)": "FM",
        "Faroe Islands": "FO", "France": "FR", "Gabon": "GA", "United Kingdom of Great Britain and Northern Ireland": "GB", "Grenada": "GD",
        "Georgia": "GE", "French Guiana": "GF", "Guernsey": "GG", "Ghana": "GH", "Gibraltar": "GI", "Greenland": "GL", "Gambia": "GM",
        "Guinea": "GN", "Guadeloupe": "GP", "Equatorial Guinea": "GQ", "Greece": "GR", "South Georgia and the South Sandwich Islands": "GS",
        "Guatemala": "GT", "Guam": "GU", "Guinea-Bissau": "GW", "Guyana": "GY", "Hong Kong": "HK", "Heard Island and McDonald Islands": "HM",
        "Honduras": "HN", "Croatia": "HR", "Haiti": "HT", "Hungary": "HU", "Indonesia": "ID", "Ireland": "IE", "Israel": "IL", "Isle of Man": "IM",
        "India": "IN", "British Indian Ocean Territory": "IO", "Iraq": "IQ", "Iran (Islamic Republic of)": "IR", "Iceland": "IS", "Italy": "IT",
        "Jersey": "JE", "Jamaica": "JM", "Jordan": "JO", "Japan": "JP", "Kenya": "KE", "Kyrgyzstan": "KG", "Cambodia": "KH", "Kiribati": "KI",
        "Comoros": "KM", "Saint Kitts and Nevis": "KN", "Korea (Democratic People's Republic of)": "KP", "Korea (Republic of)": "KR", "Kuwait": "KW",
        "Cayman Islands": "KY", "Kazakhstan": "KZ", "Lao People's Democratic Republic": "LA", "Lebanon": "LB", "Saint Lucia": "LC",
        "Liechtenstein": "LI", "Sri Lanka": "LK", "Liberia": "LR", "Lesotho": "LS", "Lithuania": "LT", "Luxembourg": "LU", "Latvia": "LV",
        "Libya": "LY", "Morocco": "MA", "Monaco": "MC", "Republic of Moldova": "MD", "Montenegro": "ME", "Saint Martin (French part)": "MF",
        "Madagascar": "MG", "Marshall Islands": "MH", "North Macedonia": "MK", "Mali": "ML", "Myanmar": "MM", "Mongolia": "MN", "Macao": "MO",
        "Northern Mariana Islands": "MP", "Martinique": "MQ", "Mauritania": "MR", "Montserrat": "MS", "Malta": "MT", "Mauritius": "MU",
        "Maldives": "MV", "Malawi": "MW", "Mexico": "MX", "Malaysia": "MY", "Mozambique": "MZ", "Namibia": "NA", "New Caledonia": "NC",
        "Niger": "NE", "Norfolk Island": "NF", "Nigeria": "NG", "Nicaragua": "NI", "Netherlands": "NL", "Norway": "NO", "Nepal": "NP",
        "Nauru": "NR", "Niue": "NU", "New Zealand": "NZ", "Oman": "OM", "Panama": "PA", "Peru": "PE", "French Polynesia": "PF",
        "Papua New Guinea": "PG", "Philippines": "PH", "Pakistan": "PK", "Poland": "PL", "Saint Pierre and Miquelon": "PM",
        "Pitcairn": "PN", "Puerto Rico": "PR", "Palestine, State of": "PS", "Portugal": "PT", "Palau": "PW", "Paraguay": "PY",
        "Qatar": "QA", "Reunion": "RE", "Romania": "RO", "Serbia": "RS", "Russian Federation": "RU", "Rwanda": "RW",
        "Saudi Arabia": "SA", "Solomon Islands": "SB", "Seychelles": "SC", "Sudan": "SD", "Sweden": "SE", "Singapore": "SG",
        "Saint Helena, Ascension and Tristan da Cunha": "SH", "Slovenia": "SI", "Svalbard and Jan Mayen": "SJ", "Slovakia": "SK",
        "Sierra Leone": "SL", "San Marino": "SM", "Senegal": "SN", "Somalia": "SO", "Suriname": "SR", "South Sudan": "SS",
        "Sao Tome and Principe": "ST", "El Salvador": "SV", "Sint Maarten (Dutch part)": "SX", "Syrian Arab Republic": "SY",
        "Eswatini": "SZ", "Turks and Caicos Islands": "TC", "Chad": "TD", "French Southern Territories": "TF", "Togo": "TG",
        "Thailand": "TH", "Tajikistan": "TJ", "Tokelau": "TK", "Timor-Leste": "TL", "Turkmenistan": "TM", "Tunisia": "TN",
        "Tonga": "TO", "Turkey": "TR", "Trinidad and Tobago": "TT", "Tuvalu": "TV", "Taiwan": "TW", "Tanzania, United Republic of": "TZ",
        "Ukraine": "UA", "Uganda": "UG", "United States Minor Outlying Islands": "UM", "United States": "US", "Uruguay": "UY",
        "Uzbekistan": "UZ", "Holy See": "VA", "Saint Vincent and the Grenadines": "VC", "Venezuela (Bolivarian Republic of)": "VE",
        "Virgin Islands (British)": "VG", "Virgin Islands (U.S.)": "VI", "Viet Nam": "VN", "Vanuatu": "VU", "Wallis and Futuna": "WF",
        "Samoa": "WS", "Yemen": "YE", "Mayotte": "YT", "South Africa": "ZA", "Zambia": "ZM", "Zimbabwe": "ZW"
    ]
    
    
    func convertAmountInComma(_ amount: String?) -> String {
        guard let amount = amount else {
            return ""
        }

        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        
        if let numAmount = NumberFormatter().number(from: amount) {
            let formattedAmount = formatter.string(from: numAmount) ?? ""
            return "PKR \(formattedAmount)"
        } else {
            return ""
        }
    }
    
    func separateDateAndTime(from dateString: String) -> (date: String, time: String)? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        
        if let date = dateFormatter.date(from: dateString) {
            let dateFormatterForDate = DateFormatter()
            dateFormatterForDate.dateFormat = "yyyy-MM-dd"
            
            let dateFormatterForTime = DateFormatter()
            dateFormatterForTime.dateFormat = "HH:mm"
            
            let dateComponent = dateFormatterForDate.string(from: date)
            let timeComponent = dateFormatterForTime.string(from: date)
            
            return (date: dateComponent, time: timeComponent)
        }
        
        return nil // Invalid date string format
    }
    
    func downloadImage(from url: URL, to imageView: UIImageView) {
            URLSession.shared.dataTask(with: url) { [weak imageView] data, _, error in
                if let error = error {
                    print("Error downloading image: \(error)")
                    return
                }

                guard let data = data, let image = UIImage(data: data) else {
                    print("Invalid image data.")
                    return
                }

                DispatchQueue.main.async {
                    imageView?.image = image
                }
            }.resume()
        }
    func estimatedHeightOfLabel(text: String,view: UIView) -> CGFloat {

        let size = CGSize(width: view.frame.width - 16, height: 1000)

        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)

        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10)]

        let rectangleHeight = String(text).boundingRect(with: size, options: options, attributes: attributes, context: nil).height

        return rectangleHeight
    }
    
    func convertDateString(inputDateString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'" // Format for the input date string
        dateFormatter.timeZone = TimeZone(identifier: "UTC") // Set the input timezone (if known)
        
        guard let date = dateFormatter.date(from: inputDateString) else {
            return nil
        }
        
        return formatDateString(date: date)
    }

    func formatDateString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM/dd/yyyy. hh:mm a" // Format for the output date string
        dateFormatter.timeZone = TimeZone.current // Set the output timezone (device's timezone)
        
        return dateFormatter.string(from: date)
    }
    
    func removeHTMLTags(from input: String) -> String {
        do {
            let regex = try NSRegularExpression(pattern: "<[^>]+>", options: .dotMatchesLineSeparators)
            let range = NSRange(location: 0, length: input.utf16.count)
            return regex.stringByReplacingMatches(in: input, options: [], range: range, withTemplate: "")
        } catch {
            print("Error while creating regex: \(error.localizedDescription)")
            return input
        }
    }
    func htmlToString(text: String) -> String {
        do {
            let attributedString = try NSAttributedString(data: Data(text.utf8),
                                                          options: [
                                                            .documentType: NSAttributedString.DocumentType.html,
                                                            .characterEncoding: String.Encoding.utf8.rawValue
                                                          ],
                                                          documentAttributes: nil)
            return attributedString.string
        } catch {
            print("Error converting HTML to string: \(error.localizedDescription)")
            return text
        }
    }
    
    func applyStrikethrough(to label: UILabel, priceString: String, currencyLabel: String) {
        // Combine the currency label with the price string
        let fullPriceString = currencyLabel + priceString
        
        // Create an attributed string with a strikethrough
        let attributedString = NSMutableAttributedString(string: fullPriceString)
        
        // Set strikethrough style and color
        attributedString.addAttributes([
            .strikethroughStyle: NSUnderlineStyle.single.rawValue,
            .strikethroughColor: UIColor.red
        ], range: NSMakeRange(0, attributedString.length))
        
        // Assign the attributed string to the UILabel
        label.attributedText = attributedString
    }
    
     func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      var randomBytes = [UInt8](repeating: 0, count: length)
      let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
      if errorCode != errSecSuccess {
        fatalError(
          "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
        )
      }

      let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")

      let nonce = randomBytes.map { byte in
        // Pick a random character from the set, wrapping around if needed.
        charset[Int(byte) % charset.count]
      }

      return String(nonce)
    }
    
//    func formatNumberWithCommas(_ number: Double, label: UILabel?,addSymbol: Bool = true) -> String {
//        let numberFormatter = NumberFormatter()
//        numberFormatter.numberStyle = .decimal
//
//        var formattedString = ""
//
//        // Check the language and set font accordingly
//        if LanguageManager.language == "ar" {
//            label?.font = UIFont(name: "Bruna-Regular", size: 14) // Apply Arabic font
//            numberFormatter.locale = Locale(identifier: "ar_SA")
//            if addSymbol {
//                formattedString = (numberFormatter.string(from: NSNumber(value: number)) ?? "\(number)") + " "
//            }
//             // Append Arabic currency symbol on the right
//        } else {
////            label?.font = UIFont.systemFont(ofSize: 14) // Default font for English
////            numberFormatter.locale = Locale(identifier: "en_US") // English numeral format
////            formattedString = "SAR " + (numberFormatter.string(from: NSNumber(value: number)) ?? "\(number)")
//            label?.font = UIFont(name: "Bruna-Regular", size: 14) // Default font for English
//            numberFormatter.locale = Locale(identifier: "en_US") // English numeral format
//            if addSymbol {
//                formattedString = " " + (numberFormatter.string(from: NSNumber(value: number)) ?? "\(number)") // Append SAR on the left
//            }
//            }
//
//        return formattedString
//    }
    func formatNumberWithCommas(_ number: Double, label: UILabel?, addSymbol: Bool = true) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal

        var formattedString = ""

        // Check the language and set font accordingly
        if LanguageManager.language == "ar" {
            label?.font = UIFont(name: "custom-icons", size: 14) // Apply Arabic font
            numberFormatter.locale = Locale(identifier: "ar_SA") // Arabic numeral format
            formattedString = (numberFormatter.string(from: NSNumber(value: number)) ?? "\(number)")
            
            if addSymbol {
                formattedString += " " // Append Arabic currency symbol on the right
            }
        } else {
            label?.font = UIFont(name: "custom-icons", size: 14) // Default font for English
            numberFormatter.locale = Locale(identifier: "en_US") // English numeral format
            formattedString = numberFormatter.string(from: NSNumber(value: number)) ?? "\(number)"
            
            if addSymbol {
                formattedString = " " + formattedString // Append SAR on the left
            }
        }
        label?.textColor = UIColor.primaryColor

        return formattedString
    }

    func convertToArabicNumerals(_ number: Int) -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "ar") // Arabic locale
        return formatter.string(from: NSNumber(value: number)) ?? "\(number)"
    }
    
    
//    func formatNumberWithCommas(_ number: Double, label: UILabel?) -> String {
//        let numberFormatter = NumberFormatter()
//        numberFormatter.numberStyle = .decimal
//        
//        var formattedString = ""
//
//        // Check the language and set font accordingly
//        if LanguageManager.language == "ar" {
//            label?.font = UIFont(name: "Bruna-Regular", size: 17) // Apply Arabic font
//            numberFormatter.locale = Locale(identifier: "ar_SA") // Arabic numeral format
//            formattedString = (numberFormatter.string(from: NSNumber(value: number)) ?? "\(number)") + " " + "" // Append Arabic currency symbol
//        } else {
//            numberFormatter.locale = Locale(identifier: "en_US") // English numeral format
//            formattedString = numberFormatter.string(from: NSNumber(value: number)) ?? "\(number)"
//        }
//
//        return formattedString
//    }

//    func formatNumberWithCommas(_ number: Double, label: UILabel?, isStrikethrough: Bool = false) -> String {
//        let numberFormatter = NumberFormatter()
//        numberFormatter.numberStyle = .decimal
//        
//        var formattedString = ""
//
//        // Check the language and set font accordingly
//        if LanguageManager.language == "ar" {
//            label?.font = UIFont(name: "Bruna-Regular", size: 17) // Apply Arabic font
//            numberFormatter.locale = Locale(identifier: "ar_SA") // Arabic numeral format
//            formattedString = (numberFormatter.string(from: NSNumber(value: number)) ?? "\(number)") + " " + "" // Append Arabic currency symbol
//        } else {
//            numberFormatter.locale = Locale(identifier: "en_US") // English numeral format
//            formattedString = numberFormatter.string(from: NSNumber(value: number)) ?? "\(number)" + " " + "SAR "
//        }
//
//        // Apply strikethrough if needed
//        if isStrikethrough, let label = label {
//            let attributedString = NSAttributedString(
//                string: formattedString,
//                attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue]
//            )
//            label.attributedText = attributedString
//            return formattedString // Just return the value, but label is already updated
//        }
//
//        return formattedString
//    }

    
    func formatDateString(_ dateString: String) -> String? {
        let inputFormatter = ISO8601DateFormatter()
        guard let date = inputFormatter.date(from: dateString) else {
            return nil
        }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "MMMM dd, yyyy hh:mm a"
        outputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        return outputFormatter.string(from: date)
    }
    
    func convertDateString(_ dateString: String, fromFormat: String, toFormat: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromFormat
        guard let date = dateFormatter.date(from: dateString) else { return nil }
        
        dateFormatter.dateFormat = toFormat
        return dateFormatter.string(from: date)
    }

    func countryCode(for countryName: String) -> String? {
        // Normalize input country name to handle variations in capitalization
        let normalizedCountryName = countryName
        
        // Search for the country code in the dictionary
        if let countryCode = countryCodes[normalizedCountryName] {
            return countryCode
        } else {
            return nil  // Country code not found for the given country name
        }
    }
    
    
    func attributedStringWithColoredLastWord(_ text: String, lastWordColor: UIColor, otherWordsColor: UIColor) -> NSAttributedString {
        // Create the attributed string
        let attributedString = NSMutableAttributedString(string: text)
        
        // Find the range of the last word
        guard let lastSpaceRange = text.range(of: " ", options: .backwards) else {
            // If there's no space, assume the entire string is the last word
            attributedString.addAttribute(.foregroundColor, value: lastWordColor, range: NSRange(location: 0, length: text.count))
            return attributedString
        }
        
        let lastWordRange = NSRange(lastSpaceRange.upperBound..., in: text)
        let beforeLastWordRange = NSRange(text.startIndex..<lastSpaceRange.lowerBound, in: text)
        
        // Set the attributes
        attributedString.addAttribute(.foregroundColor, value: otherWordsColor, range: beforeLastWordRange)
        attributedString.addAttribute(.foregroundColor, value: lastWordColor, range: lastWordRange)
        
        return attributedString
    }
    
    func attributedStringWithColoredLastWordBold(_ text: String, lastWordColor: UIColor, otherWordsColor: UIColor) -> NSAttributedString {
        // Create the attributed string
        let attributedString = NSMutableAttributedString(string: text)
        
        // Find the range of the last word
        guard let lastSpaceRange = text.range(of: " ", options: .backwards) else {
            // If there's no space, assume the entire string is the last word
            attributedString.addAttribute(.foregroundColor, value: lastWordColor, range: NSRange(location: 0, length: text.count))
            attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 16, weight: .semibold), range: NSRange(location: 0, length: text.count))
            return attributedString
        }
        
        let lastWordRange = NSRange(lastSpaceRange.upperBound..., in: text)
        let beforeLastWordRange = NSRange(text.startIndex..<lastSpaceRange.lowerBound, in: text)
        
        // Set the attributes
        attributedString.addAttribute(.foregroundColor, value: otherWordsColor, range: beforeLastWordRange)
        attributedString.addAttribute(.foregroundColor, value: lastWordColor, range: lastWordRange)
        
        // Apply medium bold font to the last word
        let mediumBoldFont = UIFont.systemFont(ofSize: 16, weight: .semibold) // Adjust size as needed
        let BlackLightFont = UIFont.systemFont(ofSize: 16, weight: .regular)
        attributedString.addAttribute(.font, value: mediumBoldFont, range: lastWordRange)
        attributedString.addAttribute(.font, value: BlackLightFont, range: beforeLastWordRange)
        
        return attributedString
    }
    
    func attributedStringWithColoredStrings(_ firstText: String, firstTextColor: UIColor, _ secondText: String, secondTextColor: UIColor) -> NSAttributedString {
        // Combine the two strings
        let combinedText = firstText + " " + secondText
        
        // Create the attributed string
        let attributedString = NSMutableAttributedString(string: combinedText)
        
        // Define the ranges for the two parts
        let firstTextRange = NSRange(location: 0, length: firstText.count)
        let secondTextRange = NSRange(location: firstText.count + 1, length: secondText.count) // +1 for the space
        
        // Set the attributes
        attributedString.addAttribute(.foregroundColor, value: firstTextColor, range: firstTextRange)
        attributedString.addAttribute(.foregroundColor, value: secondTextColor, range: secondTextRange)
        
        return attributedString
    }
    
    func attributedStringWithColoredStringsBold(_ firstText: String, firstTextColor: UIColor, _ secondText: String, secondTextColor: UIColor) -> NSAttributedString {
        // Combine the two strings
        let combinedText = firstText + " " + secondText
        
        // Create the attributed string
        let attributedString = NSMutableAttributedString(string: combinedText)
        
        // Define the ranges for the two parts
        let firstTextRange = NSRange(location: 0, length: firstText.count)
        let secondTextRange = NSRange(location: firstText.count + 1, length: secondText.count) // +1 for the space
        
        // Set the color attributes
        attributedString.addAttribute(.foregroundColor, value: firstTextColor, range: firstTextRange)
        attributedString.addAttribute(.foregroundColor, value: secondTextColor, range: secondTextRange)
        
        // Set the font weight to medium bold for secondText
        let mediumBoldFont = UIFont.systemFont(ofSize: 16, weight: .semibold) // Adjust size as needed
        attributedString.addAttribute(.font, value: mediumBoldFont, range: secondTextRange)
        
        return attributedString
    }

    func attributedStringWithColoredLastCharacters(_ text: String, lastCharactersColor: UIColor, otherTextColor: UIColor, numberOfLastCharacters: Int) -> NSAttributedString {
        // Create the attributed string
        let attributedString = NSMutableAttributedString(string: text)
        
        // Ensure the number of characters to color is not greater than the text length
        let lastCharactersCount = min(numberOfLastCharacters, text.count)
        
        // Define the ranges
        let startRange = NSRange(location: 0, length: text.count - lastCharactersCount)
        let endRange = NSRange(location: text.count - lastCharactersCount, length: lastCharactersCount)
        
        // Set the attributes
        attributedString.addAttribute(.foregroundColor, value: otherTextColor, range: startRange)
        attributedString.addAttribute(.foregroundColor, value: lastCharactersColor, range: endRange)
        
        return attributedString
    }
    func setGradientBackground(view: UIView, colors: [String]) {
        let gradientLayer = CAGradientLayer()
        
        // Convert hex color strings to UIColor
        gradientLayer.colors = colors.compactMap { UIColor(hex: $0)?.cgColor }
        
        // Optionally set the direction of the gradient
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        
        // Set the gradient layer frame and add it to the view
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        // Ensure the gradient layer resizes with the view
        view.layoutIfNeeded()
        gradientLayer.frame = view.bounds
    }
    
    func setGradientBackgroundForBtn(button: UIButton, colors: [String]) {
        let gradientLayer = CAGradientLayer()
        
        // Convert hex color strings to UIColor
        gradientLayer.colors = colors.compactMap { UIColor(hex: $0)?.cgColor }
        
        // Optionally set the direction of the gradient
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        
        // Set the gradient layer frame and add it to the button
        gradientLayer.frame = button.bounds
        button.layer.insertSublayer(gradientLayer, at: 0)
        
        // Ensure the gradient layer resizes with the button
        button.layoutIfNeeded()
        gradientLayer.frame = button.bounds
    }

//    func setGradientBackground(view: UIView, colors: [String]) {
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.frame = view.bounds
//        gradientLayer.colors = colors.map { UIColor(hex: $0)?.cgColor as Any }
//        
//        // Optionally set the direction of the gradient
//        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
//        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
//        
//        view.layer.insertSublayer(gradientLayer, at: 0)
//    }
    
    func roundUp(_ value: Double) -> Int {
        return Int(ceil(value))
    }
    func roundDown(_ value: Double) -> Int {
        return Int(floor(value))
    }
    func roundDownToNearestFive(_ value: Int) -> Int {
        return Int(floor(Double(value) / 5.0) * 5)
    }
    func combinedRoundDown(_ value: Double) -> Int {
        let roundedValue = roundDown(value)
        return roundDownToNearestFive(roundedValue)
    }
    func addOrRemoveValue(_ value: String, from array: inout [String]) {
        if let index = array.firstIndex(of: value) {
            array.remove(at: index)
        } else {
            array.append(value)
        }
    }
    
//    func formattedText(text: String) -> NSAttributedString {
//        // Split the text into components
//        let components = text.split(separator: " ")
//        
//        // Ensure there are exactly two components: "SAR" and the number
//        guard components.count == 2 else {
//            return NSAttributedString(string: text) // Return unformatted text if the format is unexpected
//        }
//        
//        let currency = String(components[0])
//        let amount = String(components[1])
//        
//        // Create an NSMutableAttributedString from the full text
//        let attributedString = NSMutableAttributedString(string: text)
//        
//        // Define the attributes for the currency part ("SAR")
//        
//        
//        let currencyAttributes: [NSAttributedString.Key: Any] = [
//            .font: UIFont.boldSystemFont(ofSize: 10),
//            .foregroundColor: UIColor.black
//        ]
//        
//        // Define the attributes for the amount part ("1200")
//        let amountAttributes: [NSAttributedString.Key: Any] = [
//            .font: UIFont.boldSystemFont(ofSize: 14),
//            .foregroundColor: UIColor(named: "headercolor")!
//        ]
//        
//        // Apply the attributes to the respective ranges
//        attributedString.addAttributes(currencyAttributes, range: (text as NSString).range(of: currency))
//        attributedString.addAttributes(amountAttributes, range: (text as NSString).range(of: amount))
//        
//        return attributedString
//    }
    
    func formattedText(text: String) -> NSAttributedString {
        // Split the text into components
        let components = text.split(separator: " ")
        
        // Ensure there are exactly two components: "SAR" and the number
        guard components.count == 2 else {
            return NSAttributedString(string: text) // Return unformatted text if the format is unexpected
        }
        
        let currency = String(components[0])
        let amount = String(components[1])
        
        // Create an NSMutableAttributedString from the full text
        let attributedString = NSMutableAttributedString(string: text)
        
        // Check the language to set the correct fonts
        if LanguageManager.language == "ar" {
            let currencyAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont(name: "custom-icons", size: 12) ?? UIFont.systemFont(ofSize: 12), // Arabic custom font
                .foregroundColor: UIColor.black
            ]
            
            let amountAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont(name: "custom-icons", size: 16) ?? UIFont.boldSystemFont(ofSize: 16), // Arabic number font
                .foregroundColor: UIColor(named: "headercolor") ?? UIColor.darkGray
            ]
            
            // Apply the attributes
            attributedString.addAttributes(currencyAttributes, range: (text as NSString).range(of: currency))
            attributedString.addAttributes(amountAttributes, range: (text as NSString).range(of: amount))
        } else {
            let currencyAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont(name: "custom-icons",size:12),
                .foregroundColor: UIColor(named: "headercolor")
            ]
            
            let amountAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 14),
                .foregroundColor: UIColor(named: "headercolor") ?? UIColor.darkGray
            ]
            
            // Apply the attributes
            attributedString.addAttributes(currencyAttributes, range: (text as NSString).range(of: currency))
            attributedString.addAttributes(amountAttributes, range: (text as NSString).range(of: amount))
        }
        
        return attributedString
    }

    
    func formattedText2(text: String) -> NSAttributedString {
        // Split the text into components
        let components = text.split(separator: " ")
        
        // Ensure there are exactly two components: "SAR" and the number
        guard components.count == 2 else {
            return NSAttributedString(string: text) // Return unformatted text if the format is unexpected
        }
        
        let currency = String(components[0])
        let amount = String(components[1])
        
        // Create an NSMutableAttributedString from the full text
        let attributedString = NSMutableAttributedString(string: text)
        
        // Define the attributes for the currency part ("SAR")
        let currencyAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 12),
            .foregroundColor: UIColor.black
        ]
        
        // Define the attributes for the amount part ("1200")
        let amountAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 16),
            .foregroundColor: UIColor(named: "headercolor")!
        ]
        
        // Apply the attributes to the respective ranges
        attributedString.addAttributes(currencyAttributes, range: (text as NSString).range(of: currency))
        attributedString.addAttributes(amountAttributes, range: (text as NSString).range(of: amount))
        
        return attributedString
    }

    func formattedTextWhite(text: String) -> NSAttributedString {
        // Split the text into components
        let components = text.split(separator: " ")
        
        // Ensure there are exactly two components: "SAR" and the number
        guard components.count == 2 else {
            return NSAttributedString(string: text) // Return unformatted text if the format is unexpected
        }
        
        let currency = String(components[0])
        let amount = String(components[1])
        
        // Create an NSMutableAttributedString from the full text
        let attributedString = NSMutableAttributedString(string: text)
        
        // Define the attributes for the currency part ("SAR")
        let currencyAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 10),
            .foregroundColor: UIColor.white
        ]
        
        // Define the attributes for the amount part ("1200")
        let amountAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 14),
            
            .foregroundColor: primaryColor!
        ]
        
        // Apply the attributes to the respective ranges
        attributedString.addAttributes(currencyAttributes, range: (text as NSString).range(of: currency))
        attributedString.addAttributes(amountAttributes, range: (text as NSString).range(of: amount))
        
        return attributedString
    }
    func applyBottomLeftCornerRadius(to button: UIButton, radius: CGFloat) {
            let path = UIBezierPath(roundedRect: button.bounds,
                                    byRoundingCorners: [.bottomLeft],
                                    cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            button.layer.mask = mask
        }
    
    func makeOddNumberEven(_ number: Int) -> Int {
        if number % 2 != 0 {
            return number + 1
        } else {
            return number
        }
    }
    
    
    func getImageWidth(from urlString: String, completion: @escaping (CGFloat?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let image = UIImage(data: data), error == nil else {
                completion(nil)
                return
            }
            
            DispatchQueue.main.async {
                completion(image.size.width)
            }
        }
        task.resume()
    }
    
    func getIPAddress() -> String? {
        var address: String?

        // Get list of all interfaces on the device
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while ptr != nil {
                defer { ptr = ptr?.pointee.ifa_next }
                
                let interface = ptr?.pointee
                let addrFamily = interface?.ifa_addr.pointee.sa_family
                
                // Check for IPv4 or IPv6 interface
                if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                    if let ifaName = interface?.ifa_name, String(cString: ifaName) == "en0" {
                        // en0 is the Wi-Fi interface
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        getnameinfo(interface?.ifa_addr, socklen_t((interface?.ifa_addr.pointee.sa_len)!), &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST)
                        address = String(cString: hostname)
                    }
                }
            }
            freeifaddrs(ifaddr)
        }
        
        return address
    }
    
    func getMyPublicIpAsync() async -> String {
        do { let url = URL(string: "https://api.ipify.org")!
            let (data, _) = try await URLSession.shared.data(from: url)
            if let result = String(data: data, encoding: .utf8) { return result }
            else { return "error: Unable to decode response" } } catch { return "error: \(error)" }
    }
    
    func convertOddToEven(_ number: Int) -> Int {
        return number % 2 != 0 ? number + 1 : number
    }
    
    func convertToArabicNumerals(_ number: Double) -> String {
        guard number.isFinite else {
            return "—" // Fallback for NaN or infinity
        }

        let roundedNumber = Int(Darwin.round(number))
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: "ar_SA")
        return numberFormatter.string(from: NSNumber(value: roundedNumber)) ?? "\(roundedNumber)"
    }
    
}

extension UIColor {
  static func random () -> UIColor {
    return UIColor(
      red: CGFloat.random(in: 0...1),
      green: CGFloat.random(in: 0...1),
      blue: CGFloat.random(in: 0...1),
      alpha: 1.0)
  }
}


extension UIImageView{
    func pLoadImage(url: String) {
        if let http = URL(string: url) {
            var comps = URLComponents(url: http, resolvingAgainstBaseURL: false)!
            comps.scheme = "https"
            let https = comps.url!
            print(https)
            
            self.kf.indicatorType = .none
            
            // Fetch image from URL and resize it before setting to image view
            self.kf.setImage(with: https, placeholder: #imageLiteral(resourceName: "placeHolder")) { result in
                switch result {
                case .success(let value):
                    // Resize image after downloading
                    if let resizedImage = self.resizeImage(image: value.image, targetSize: self.bounds.size) {
                        self.image = resizedImage
                    }
                case .failure:
                    // Handle failure, set placeholder if image fails to load
                    self.image = #imageLiteral(resourceName: "placeHolder")
                }
            }
            
        } else {
            self.image = #imageLiteral(resourceName: "placeHolder")
        }
    }

    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
        guard targetSize.width > 0, targetSize.height > 0 else {
            print("⚠️ Invalid targetSize: \(targetSize)")
            return nil
        }

        let size = image.size
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        let scaleFactor = min(widthRatio, heightRatio)
        
        let newSize = CGSize(width: size.width * scaleFactor, height: size.height * scaleFactor)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(origin: .zero, size: newSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage
    }
    
    func pLoadImage2(url: String, completion: @escaping () -> Void) {
        guard let httpURL = URL(string: url) else {
            self.image = #imageLiteral(resourceName: "placeHolder")
            completion()
            return
        }

        var comps = URLComponents(url: httpURL, resolvingAgainstBaseURL: false)!
        comps.scheme = "https"
        guard let httpsURL = comps.url else {
            self.image = #imageLiteral(resourceName: "placeHolder")
            completion()
            return
        }

        self.kf.indicatorType = .none
        self.kf.setImage(
            with: httpsURL,
            placeholder: #imageLiteral(resourceName: "placeHolder"),
            options: nil
        ) { result in
            // This block is called on main thread by default
            switch result {
            case .success(_):
                completion()
            case .failure(_):
                self.image = #imageLiteral(resourceName: "placeHolder")
                completion()
            }
        }
    }

    
    
   
    
    func pLoadImage3(url:String) {
        if let http = URL(string: url) {
            var comps = URLComponents(url: http, resolvingAgainstBaseURL: false)!
            comps.scheme = "https"
            let https = comps.url!
            print(https)
            self.kf.indicatorType = .activity
            self.kf.setImage(with: http,placeholder: #imageLiteral(resourceName: "placeHolder2"))
        }else{
            self.image = #imageLiteral(resourceName: "placeHolder2")
        }

    }
    func pLoadImage4(url:String) {
        if let http = URL(string: url) {
            var comps = URLComponents(url: http, resolvingAgainstBaseURL: false)!
            comps.scheme = "https"
            let https = comps.url!
            print(https)

            self.kf.setImage(with: http)

        }else{

        }

    }



}
extension String {
    func htmlToString() -> String {
      return try! NSAttributedString(data: self.data(using: .utf8)!,
                      options: [.documentType: NSAttributedString.DocumentType.html],
                      documentAttributes: nil).string
    }
  var isContainsLetters : Bool{
    let letters = CharacterSet.letters
    return self.rangeOfCharacter(from: letters) != nil
  }
    
    func isStringOrHTML() -> String {
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
          .documentType: NSAttributedString.DocumentType.html,
          .characterEncoding: String.Encoding.utf8.rawValue
        ]
        if let attributedString = try? NSAttributedString(data: Data(self.utf8), options: options, documentAttributes: nil) {
          return "HTML"
        } else {
          return "String"
        }
      }
    public var withoutHtml: String {
          guard let data = self.data(using: .utf8) else {
              return self
          }

          let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
              .documentType: NSAttributedString.DocumentType.html,
              .characterEncoding: String.Encoding.utf8.rawValue
          ]

          guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
              return self
          }

          return attributedString.string
      }
}
extension UITextView {
    func addPlaceholder(_ placeholder: String) {

        let placeholderLabel = UILabel()
        placeholderLabel.text = placeholder
        placeholderLabel.font = self.font
        placeholderLabel.sizeToFit()
        placeholderLabel.frame.origin = CGPoint(x: 5, y: 8)
        placeholderLabel.textColor = UIColor.darkGray
        placeholderLabel.tag = 999
        placeholderLabel.isHidden = !self.text.isEmpty
        self.addSubview(placeholderLabel)
    }

    func showPlaceholder() {
        if let placeholderLabel = self.viewWithTag(999) as? UILabel {
            placeholderLabel.isHidden = false
        }
    }

    func hidePlaceholder() {
        if let placeholderLabel = self.viewWithTag(999) as? UILabel {
            placeholderLabel.isHidden = true
        }
    }
}
extension UIView {

    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
         let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
         let mask = CAShapeLayer()
         mask.path = path.cgPath
         self.layer.mask = mask
    }

}

@IBDesignable
class CustomRoundedView: UIView {

    @IBInspectable
    var topLeftCornerRadius: CGFloat = 0.0 {
        didSet {
            updateCornerRadius()
        }
    }

    @IBInspectable
    var topRightCornerRadius: CGFloat = 0.0 {
        didSet {
            updateCornerRadius()
        }
    }

    @IBInspectable
    var bottomLeftCornerRadius: CGFloat = 0.0 {
        didSet {
            updateCornerRadius()
        }
    }

    @IBInspectable
    var bottomRightCornerRadius: CGFloat = 0.0 {
        didSet {
            updateCornerRadius()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateCornerRadius()
    }

    private func updateCornerRadius() {
        let path = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: [.topLeft, .topRight, .bottomLeft, .bottomRight],
            cornerRadii: CGSize(
                width: topLeftCornerRadius,
                height: topRightCornerRadius
            )
        )

        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        layer.mask = maskLayer
    }
}
extension UISwitch {

    static let standardHeight: CGFloat = 31
    static let standardWidth: CGFloat = 51
    
    @IBInspectable var width: CGFloat {
        set {
            set(width: newValue, height: height)
        }
        get {
            frame.width
        }
    }
    
    @IBInspectable var height: CGFloat {
        set {
            set(width: width, height: newValue)
        }
        get {
            frame.height
        }
    }
    
    func set(width: CGFloat, height: CGFloat) {

        let heightRatio = height / UISwitch.standardHeight
        let widthRatio = width / UISwitch.standardWidth

        transform = CGAffineTransform(scaleX: widthRatio, y: heightRatio)
    }
    
    
}

struct PlatformUtils {
    static let isSimulator: Bool = {
        var isSim = false
        #if arch(i386) || arch(x86_64)
            isSim = true
        #endif
        return isSim
    }()
}

struct TokenUtils {
    static func fetchToken(from url : String, completionHandler: @escaping (String, Error?) -> Void) {
        var token: String = "TWILIO_ACCESS_TOKEN"
        let requestURL: URL = URL(string: url)!
        let task = URLSession.shared.dataTask(with: requestURL) {
            (data, response, error) in
            if let error = error {
                completionHandler(token, error)
                return
            }
            
            if let data = data, let tokenReponse = String(data: data, encoding: .utf8) {
                token = tokenReponse
                completionHandler(token, nil)
            }
        }
        task.resume()
    }
}
extension UIButton {

    private class Action {
        var action: (UIButton) -> Void

        init(action: @escaping (UIButton) -> Void) {
            self.action = action
        }
    }

    private struct AssociatedKeys {
        static var ActionTapped = "actionTapped"
    }

    private var tapAction: Action? {
        set { objc_setAssociatedObject(self, &AssociatedKeys.ActionTapped, newValue, .OBJC_ASSOCIATION_RETAIN) }
        get { return objc_getAssociatedObject(self, &AssociatedKeys.ActionTapped) as? Action }
    }


    @objc dynamic private func handleAction(_ recognizer: UIButton) {
        tapAction?.action(recognizer)
    }


    func mk_addTapHandler(action: @escaping (UIButton) -> Void) {
        self.addTarget(self, action: #selector(handleAction(_:)), for: .touchUpInside)
        tapAction = Action(action: action)

    }
}


extension UIColor {
    static let chinaRed = UIColor(red: 223.0/255.0, green: 24.0/255.0, blue: 33.0/255.0, alpha: 1.0)
    static let chinaPink = UIColor(red: 248.0/255.0, green: 70.0/255.0, blue: 86.0/255.0, alpha: 1.0)
    static let transparent = UIColor(red: 248.0/255.0, green: 70.0/255.0, blue: 86.0/255.0, alpha: 0.0)

    static let chinaShadow = UIColor(red: 243.0/255.0, green: 62.0/255.0, blue: 78.0/255.0, alpha: 1.0)
    
    static let pakistanGreen = UIColor(red: 17.0/255.0, green: 87.0/255.0, blue: 64.0/255.0, alpha: 1.0)
    static let pakistanBlue = UIColor(red: 1.0/255.0, green: 148.0/255.0, blue: 100.0/255.0, alpha: 1.0)
    static let pakistanShadow = UIColor(red: 15.0/255.0, green: 79.0/255.0, blue: 60.0/255.0, alpha: 1.0)
    
    static let saudiGreen = UIColor(red: 18.0/255.0, green: 190.0/255.0, blue: 102.0/255.0, alpha: 1.0)
    static let saudiLightGreen = UIColor(red: 26.0/255.0, green: 193.0/255.0, blue: 110.0/255.0, alpha: 1.0)
    static let saudiShadow = UIColor(red: 17.0/255.0, green: 192.0/255.0, blue: 107.0/255.0, alpha: 0.325)
}

extension UIView {
    func setAllLabelsFontConditionally(useCustomFont: Bool) {
        for subview in subviews {
            if let label = subview as? UILabel {
                if useCustomFont {
                    label.font = UIFont(name: "Bruna", size: label.font.pointSize) ?? UIFont.systemFont(ofSize: label.font.pointSize)
                } else {
                    label.font = UIFont.systemFont(ofSize: label.font.pointSize)
                }
            } else {
                subview.setAllLabelsFontConditionally(useCustomFont: useCustomFont)
            }
        }
    }
}
@IBDesignable
class CornerRadiusView: UIView {

    // Inspectable property for corner radius
    @IBInspectable var bottomRightCornerRadius: CGFloat = 0 {
        didSet {
            updateCornerRadius()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        // Initial setup if needed
    }

    private func updateCornerRadius() {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.bottomRight], cornerRadii: CGSize(width: bottomRightCornerRadius, height: bottomRightCornerRadius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateCornerRadius()
    }
}


struct KSAcat {
var name:String?
    var id:String?
    var img: String?
    var arName: String?
}

class PoppinsLabel: UILabel {

    enum FontStyle {
        case regular
        case medium
        case bold
    }

    init(fontStyle: FontStyle, fontSize: CGFloat) {
        super.init(frame: .zero)
        setFont(style: fontStyle, size: fontSize)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setFont(style: .regular, size: 17) // Default style and size
    }

    private func setFont(style: FontStyle, size: CGFloat) {
        switch style {
        case .regular:
            self.font = UIFont(name: "Bruna-Regular", size: size)
        case .medium:
            self.font = UIFont(name: "Bruna-Regular", size: size)
        case .bold:
            self.font = UIFont(name: "Bruna-Bold", size: size)
        }
    }
    
    // Optionally, you can provide a method to update the font dynamically
    func updateFont(style: FontStyle, size: CGFloat) {
        setFont(style: style, size: size)
    }
}


extension UIViewController {
    // Enum to represent different toast message types
    enum ToastType {
        case success
        case error
        case warning
    }

    // Function to show toast
    func showToast(message: String, toastType: ToastType, duration: Double = 2.0) {
        let toastLabel = UILabel()
        toastLabel.textColor = UIColor.white
        toastLabel.backgroundColor = UIColor.black
        toastLabel.textAlignment = .center
        toastLabel.font = UIFont.systemFont(ofSize: 14.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        toastLabel.numberOfLines = 0
        
        // Customize color based on toast type
        switch toastType {
        case .success:
            toastLabel.backgroundColor = UIColor.green
            toastLabel.textColor = UIColor.black
        case .error:
            toastLabel.backgroundColor = UIColor.red
            toastLabel.textColor = UIColor.white
        case .warning:
            toastLabel.backgroundColor = UIColor.orange
            toastLabel.textColor = UIColor.white
        }

        // Set size and position of toast
        let textSize = toastLabel.intrinsicContentSize
        let labelWidth = min(textSize.width + 40, view.frame.width - 40)
        toastLabel.frame = CGRect(x: (view.frame.width - labelWidth) / 2,
                                  y: view.frame.height - 100,
                                  width: labelWidth,
                                  height: textSize.height + 20)
        
        view.addSubview(toastLabel)

        // Animate the toast to fade out after the duration
        UIView.animate(withDuration: duration, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: { _ in
            toastLabel.removeFromSuperview()
        })
    }
}

import UIKit

extension UITextView {
    
    private struct AssociatedKeys {
        static var placeholderLabelKey = "placeholderLabelKey"
    }
    
    private var placeholderLabel: UILabel? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.placeholderLabelKey) as? UILabel
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.placeholderLabelKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// Adds a placeholder to the UITextView
    func addPlaceholder(_ placeholder: String, color: UIColor = .lightGray) {
        // Remove any existing placeholder label
        placeholderLabel?.removeFromSuperview()
        
        let label = UILabel()
        label.text = placeholder
        label.textColor = color
        label.font = self.font
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(label)
        placeholderLabel = label
        
        // Set constraints
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            label.topAnchor.constraint(equalTo: self.topAnchor, constant: 5)
        ])
        
        // Add observer to manage visibility
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(textDidChange),
            name: UITextView.textDidChangeNotification,
            object: nil
        )
        
        textDidChange() // Initial check
    }
    
    @objc private func textDidChange() {
        placeholderLabel?.isHidden = !self.text.isEmpty
    }
    
    /// Removes the placeholder
    func removePlaceholder() {
        placeholderLabel?.removeFromSuperview()
        NotificationCenter.default.removeObserver(
            self,
            name: UITextView.textDidChangeNotification,
            object: nil
        )
    }
}

extension String {
    func strikeThrough() -> NSAttributedString {
        let attributeString =  NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0,attributeString.length))
        return attributeString
    }
}

class ImageCache {
    static let shared = ImageCache()

    private let cache = NSCache<NSString, UIImage>()

    private init() {
        cache.countLimit = 100 // or adjust as needed
        cache.totalCostLimit = 50 * 1024 * 1024 // 50 MB
    }

    func image(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }

    func save(image: UIImage, forKey key: String) {
        let cost = image.pngData()?.count ?? 0
        cache.setObject(image, forKey: key as NSString, cost: cost)
    }
}
