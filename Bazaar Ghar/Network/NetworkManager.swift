//
//  NetworkManager.swift
//  RGB
//
//  Created by Usama on 25/05/2022.
//

import Foundation
import Network
import UIKit
@available(iOS 12.0, *)
class NetworkManager {
    public static var shared = NetworkManager()
    let monitor = NWPathMonitor()
//    let cellMonitor = NWPathMonitor(requiredInterfaceType: .cellular)
    func start() {
//        let queue = DispatchQueue(label: "Monitor")
//        monitor.start(queue: queue)
//        monitor.pathUpdateHandler = { path in
//            switch path.status {
//            case .requiresConnection:
//                UIApplication.startActivityIndicator(with: "Reconnecting...")
//            default:
//                UIApplication.stopActivityIndicator()
//            }
//        }
    }
}
