// PaymentHandler.swift

import UIKit
import PassKit
import Frames



/// Now includes the Base64 token in the completion
typealias PaymentCompletionHandler = (_ success: Bool, _ base64Token: String?) -> Void

class PaymentHandler: NSObject {

    let checkoutAPIService = CheckoutAPIService(publicKey: "pk_uxnke5oowycft6nwura2n7dqlaz", environment: .live)
    
//    let checkoutAPIService = CheckoutAPIService(publicKey: "pk_sbox_w62qywpgb276ztufaq56c6leh4g", environment: .sandbox)
    
    
    static let shared = PaymentHandler()

    private var paymentController: PKPaymentAuthorizationController?
    private var paymentSummaryItems = [PKPaymentSummaryItem]()
    private var paymentStatus = PKPaymentAuthorizationStatus.failure
    private var completionHandler: PaymentCompletionHandler?
    private var isPresentingPayment = false

    /// Networks you support
    static let supportedNetworks: [PKPaymentNetwork] = [
        .amex, .discover, .masterCard, .visa
    ]

    class func applePayStatus() -> (canMakePayments: Bool, canSetupCards: Bool) {
        return (
            PKPaymentAuthorizationController.canMakePayments(),
            PKPaymentAuthorizationController.canMakePayments(usingNetworks: supportedNetworks)
        )
    }

    /// MARK: – Prepare your summary items here
    private func preparePaymentItems(price: Double) {
        let total = PKPaymentSummaryItem(
            label: "Total",
            amount: NSDecimalNumber(value: price),
            type: .final
        )
        paymentSummaryItems = [ total ]
    }

    /// MARK: – Public entry point
    func startPayment(
        price: Double,
        completion: @escaping PaymentCompletionHandler
    ) {
        // Prevent re-entrancy
        guard !isPresentingPayment else { return }
        isPresentingPayment = true
        completionHandler = completion

        // 1️⃣ Prepare items
        preparePaymentItems(price: price)

        // 2️⃣ Build the request
        let request = PKPaymentRequest()
        request.paymentSummaryItems = paymentSummaryItems
        request.merchantIdentifier = Configurations.Merchant.identifier  // ← your merchant ID
        request.merchantCapabilities = .capability3DS
        request.countryCode = "SA"    // Saudi Arabia
        request.currencyCode = "SAR"  // Riyal
        request.supportedNetworks = Self.supportedNetworks
        request.requiredShippingContactFields = [.name, .postalAddress]

        // Optionally support coupons on iOS 15+
        if #available(iOS 15.0, *) {
            request.supportsCouponCode = true
        }

        // 3️⃣ Create & present
        paymentController = PKPaymentAuthorizationController(paymentRequest: request)
        paymentController?.delegate = self
        paymentController?.present { [weak self] presented in
            guard let self = self else { return }
            if presented {
                print("✅ Apple Pay sheet presented")
            } else {
                print("❌ Failed to present Apple Pay sheet")
                self.isPresentingPayment = false
                self.completionHandler?(false, nil)
            }
        }
    }

}

// MARK: – PKPaymentAuthorizationControllerDelegate

extension PaymentHandler: PKPaymentAuthorizationControllerDelegate {

    func paymentAuthorizationController(
        _ controller: PKPaymentAuthorizationController,
        didAuthorizePayment payment: PKPayment,
        handler completion: @escaping (PKPaymentAuthorizationResult) -> Void
    ) {
        var errors = [Error]()
        var status: PKPaymentAuthorizationStatus = .success

        if let country = payment.shippingContact?.postalAddress?.isoCountryCode,
           country != "SA" {
            let error = PKPaymentRequest.paymentShippingAddressUnserviceableError(
                withLocalizedDescription: "We only ship within Saudi Arabia."
            )
            errors.append(error)
            status = .failure
        }

        // Extract token JSON
        let token = payment.token
        let tokenData = token.paymentData
        let tokenJSONString: String?

        do {
            if let jsonObject = try JSONSerialization.jsonObject(with: tokenData, options: []) as? [String: Any],
               let formattedData = try? JSONSerialization.data(withJSONObject: [
                    "type": "applepay",
                    "token_data": jsonObject
               ], options: [.prettyPrinted]) {
                tokenJSONString = String(data: formattedData, encoding: .utf8)
            } else {
                tokenJSONString = nil
            }
        } catch {
            print("❌ Error decoding Apple Pay token: \(error)")
            tokenJSONString = nil
        }

        if let jsonString = tokenJSONString {
            print("✅ Apple Pay token JSON:\n\(jsonString)")
            tokenizeApplePay(payment: payment)
        } else {
            print("⚠️ Could not decode Apple Pay token.")
        }

        paymentStatus = status
        completion(PKPaymentAuthorizationResult(status: status, errors: errors))
        completionHandler?(status == .success, tokenJSONString ?? "")
    }

    func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
        controller.dismiss {
            DispatchQueue.main.async {
                self.isPresentingPayment = false
            }
        }
    }

    func paymentAuthorizationController(
        _ controller: PKPaymentAuthorizationController,
        didChangeCouponCode couponCode: String,
        handler completion: @escaping (PKPaymentRequestCouponCodeUpdate) -> Void
    ) {
        completion(PKPaymentRequestCouponCodeUpdate(paymentSummaryItems: paymentSummaryItems))
    }

    func tokenizeApplePay(payment: PKPayment) {
        guard let paymentDataJSON = try? JSONSerialization.jsonObject(with: payment.token.paymentData, options: []) as? [String: Any],
              let header = paymentDataJSON["header"] as? [String: Any] else {
            print("❌ Invalid Apple Pay paymentData format.")
            return
        }

        let tokenPayload: [String: Any] = [
            "type": "applepay",
            "token_data": [
                "version": paymentDataJSON["version"] ?? "",
                "data": paymentDataJSON["data"] ?? "",
                "signature": paymentDataJSON["signature"] ?? "",
                "header": [
                    "ephemeralPublicKey": header["ephemeralPublicKey"] ?? "",
                    "publicKeyHash": header["publicKeyHash"] ?? "",
                    "transactionId": header["transactionId"] ?? ""
                ]
            ]
        ]

        print("📤 Final payload to Checkout:\n\(tokenPayload)")

        handle(payment: payment)
    }

  
    
    
    
    
    func handle(payment: PKPayment) {
        // Get the data containing the encrypted payment information.
        let paymentData = payment.token.paymentData

        // Request an Apple Pay token.
        checkoutAPIService.createToken(.applePay(ApplePay(tokenData: paymentData))) { result in
            switch result {
            case .success(let tokenDetails):
                print(tokenDetails)
                let tokenData: [String: String] = [
                    "token": tokenDetails.token,
                                
                                  ]
                                  NotificationCenter.default.post(name: Notification.Name("tokenData"), object: nil, userInfo: tokenData)

             
                
                // Congratulations, payment token is available
            case .failure(let error):
                print(error)

                // Ooooops, an error ocurred. Check `error.localizedDescription` for hint to what went wrong
            }
        }
    }
    
//    func tokenizeWithCheckout(payload: [String: Any]) {
//        guard let url = URL(string: "https://api.sandbox.checkout.com/tokens") else { return }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.addValue("sk_sbox_ckee23iw2y47wrfeuc4lkqnjva#", forHTTPHeaderField: "Authorization") // ✅ No '#' at end
//
//        do {
//            let jsonData = try JSONSerialization.data(withJSONObject: payload, options: [])
//            request.httpBody = jsonData
//            print("📤 Sending payload:\n\(String(data: jsonData, encoding: .utf8) ?? "")")
//        } catch {
//            print("Error encoding token JSON: \(error)")
//            return
//        }
//
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                print("❌ Tokenize API error: \(error)")
//                return
//            }
//
//            if let httpResponse = response as? HTTPURLResponse {
//                print("📡 HTTP Status Code: \(httpResponse.statusCode)")
//            }
//
//            guard let data = data, !data.isEmpty else {
//                print("❌ No token data received or empty response")
//                return
//            }
//
//            if let raw = String(data: data, encoding: .utf8) {
//                print("📦 Raw response:\n\(raw)")
//            }
//
//            do {
//                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
//                   let token = json["token"] as? String {
//                    print("✅ Token created: \(token)")
//                    // self.chargeTokenWithCheckout(token: token)
//                } else {
//                    print("❌ Tokenization failed: No token in response")
//                }
//            } catch {
//                print("❌ JSON parse error: \(error)")
//            }
//        }.resume()
//    }


//    func chargeTokenWithCheckout(token: String) {
//        guard let url = URL(string: "https://api.sandbox.checkout.com/payments") else { return }
//
//        let paymentPayload: [String: Any] = [
//            "source": [
//                "type": "token",
//                "token": token
//            ],
//            "amount": 1000, // In minor units, e.g., 1000 = 10.00 SAR
//            "currency": "SAR",
//            "capture": true,
//            "reference": "ORDER-12345"
//        ]
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.addValue("sk_sbox_ckee23iw2y47wrfeuc4lkqnjva#", forHTTPHeaderField: "Authorization") // Your secret key
//
//        do {
//            let jsonData = try JSONSerialization.data(withJSONObject: paymentPayload, options: [])
//            request.httpBody = jsonData
//        } catch {
//            print("❌ Error encoding payment JSON: \(error)")
//            return
//        }
//
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                print("❌ Payment API error: \(error)")
//                return
//            }
//
//            guard let data = data else {
//                print("❌ No payment data received")
//                return
//            }
//
//            do {
//                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
//                    print("✅ Payment success:\n\(json)")
//                }
//            } catch {
//                print("❌ JSON parse error: \(error)")
//            }
//        }.resume()
//    }
}
