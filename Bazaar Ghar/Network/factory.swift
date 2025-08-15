import Frames
import UIKit

enum Factory {
    
    // swiftlint:disable:next force_unwrapping
    static let successURL = URL(string: "https://httpstat.us/200")!
    // swiftlint:disable:next force_unwrapping
    static let failureURL = URL(string: "https://httpstat.us/403")!
    static let Nenviromen = AppConstants.API.environment
    static var environment: Frames.Environment {
        return Nenviromen == .prod ? .live : .sandbox
    }
    static var apiKey: String {
        return environment == .live ? "pk_uxnke5oowycft6nwura2n7dqlaz" : "pk_sbox_w62qywpgb276ztufaq56c6leh4g"
    }
    
    static func getDefaultPaymentViewController(completionHandler: @escaping (Result<TokenDetails, TokenRequestError>) -> Void) -> UIViewController {
        #if UITEST
        return getMinimalUITestVC(completionHandler: completionHandler)
        #endif
        
        UIApplication.pTopViewController().navigationController?.navigationBar.isHidden = false
        // swiftlint:disable:next force_unwrapping
        let country = Country(iso3166Alpha2: "GB")!
        
        let address = Address(addressLine1: AppDefault.currentUser?.defaultAddress?.address,
                              addressLine2: nil,
                              city: AppDefault.currentUser?.defaultAddress?.city,
                              state: "",
                              zip: "\(AppDefault.currentUser?.defaultAddress?.zipCode ?? 0)",
                              country: country)
        
        let phone = Phone(number: AppDefault.currentUser?.defaultAddress?.phone, country: country)
        
        let billingFormData = BillingForm(name:AppDefault.currentUser?.fullname, address: address, phone: phone)
        
        let billingFormStyle = FramesFactory.defaultBillingFormStyle
        
        var paymentFormStyle = FramesFactory.defaultPaymentFormStyle
        
        
        // Comment out below lines to hide billing address (Optional)
        paymentFormStyle.editBillingSummary = nil
        paymentFormStyle.addBillingSummary = nil
        
        let supportedSchemes: [CardScheme] = [.mada, .visa, .mastercard, .maestro, .americanExpress, .discover, .dinersClub, .jcb ]
        
        let configuration = PaymentFormConfiguration(apiKey: apiKey,
                                                     environment: environment,
                                                     supportedSchemes: supportedSchemes,
                                                     billingFormData: billingFormData)
        
        let style = PaymentStyle(paymentFormStyle: paymentFormStyle,
                                     billingFormStyle: billingFormStyle)
        
        let viewController = PaymentFormFactory.buildViewController(configuration: configuration,
                                                                    style: style,
                                                                    completionHandler: completionHandler)
        
        return viewController
    }
    
    static func getBordersPaymentViewController(completionHandler: @escaping (Result<TokenDetails, TokenRequestError>) -> Void) -> UIViewController {
        
        let address = Address(addressLine1: "Address line 1",
                              addressLine2: "Address line 2",
                              city: "City",
                              state: "State",
                              zip: "Postcode",
                              country: Country(iso3166Alpha2: "GB"))
        let phone = Phone(number: "77 1234 1234", country: Country(iso3166Alpha2: "GB"))
        let billingFormData = BillingForm(name: "Full name", address: address, phone: phone)
        let supportedSchemes: [CardScheme] = [.visa, .mastercard, .maestro, .americanExpress, .mada]
        let configuration = PaymentFormConfiguration(apiKey: apiKey,
                                                             environment: environment,
                                                             supportedSchemes: supportedSchemes,
                                                             billingFormData: billingFormData)
        let style = ThemeDemo.buildBorderExample()
        let viewController = PaymentFormFactory.buildViewController(configuration: configuration,
                                                                    style: style,
                                                                    completionHandler: completionHandler)
        return viewController
    }
    
    static func getMatrixPaymentViewController(completionHandler: @escaping (Result<TokenDetails, TokenRequestError>) -> Void) -> UIViewController {
        #if UITEST
        return getCompleteUITestVC(completionHandler: completionHandler)
        #endif
        
        // swiftlint:disable:next force_unwrapping
        let country = Country(iso3166Alpha2: "GB")!
        
        let address = Address(addressLine1: "Test line1",
                              addressLine2: nil,
                              city: "London",
                              state: "London",
                              zip: "N12345",
                              country: country)
        
        let phone = Phone(number: "77 1234 1234", country: country)
        
        let billingFormData = BillingForm(name: "Şan Lacey", address: address, phone: phone)
        
        let billingFormStyle = Style.billingForm
        
        let paymentFormStyle = Style.paymentForm
        
        let supportedSchemes: [CardScheme] = [.visa, .mastercard, .maestro]
        
        let configuration = PaymentFormConfiguration(apiKey: apiKey,
                                                     environment: environment,
                                                     supportedSchemes: supportedSchemes,
                                                     billingFormData: billingFormData)
        
        let style = PaymentStyle(paymentFormStyle: paymentFormStyle,
                                     billingFormStyle: billingFormStyle)
        
        let viewController = PaymentFormFactory.buildViewController(configuration: configuration,
                                                                    style: style,
                                                                    completionHandler: completionHandler)
        
        return viewController
    }
    
    static func getOtherPaymentViewController(completionHandler: @escaping (Result<TokenDetails, TokenRequestError>) -> Void) -> UIViewController {
        
        let address = Address(addressLine1: "78 Marvelous Rd",
                              addressLine2: nil,
                              city: "London",
                              state: nil,
                              zip: nil,
                              country: Country(iso3166Alpha2: "GB"))
        
        let billingFormData = BillingForm(name: "Bob Higgins", address: address, phone: nil)
        
        let supportedSchemes: [CardScheme] = [.visa, .mastercard, .maestro, .americanExpress, .mada]
        
        let configuration = PaymentFormConfiguration(apiKey: apiKey,
                                                         environment: environment,
                                                         supportedSchemes: supportedSchemes,
                                                         billingFormData: billingFormData)
        
        let style = ThemeDemo.buildCustom2Example()
        
        let viewController = PaymentFormFactory.buildViewController(configuration: configuration,
                                                                    style: style,
                                                                    completionHandler: completionHandler)
        
        return viewController
    }
    
}
