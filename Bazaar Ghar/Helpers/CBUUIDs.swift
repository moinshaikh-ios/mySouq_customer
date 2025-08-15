//
//  CBUUIDs.swift
//  Basic Chat MVC
//
//  Created by Trevor Beaton on 2/3/21.
//

import Foundation
import CoreBluetooth

struct CBUUIDs{

//    static let kBLEService_UUID = "49535343-fe7d-4ae5-8fa9-9fafd205e455"
//    static let kBLE_Characteristic_uuid_Tx = "49535343-8841-43F4-A8D4-ECBE34729BB3"
//    static let kBLE_Characteristic_uuid_Rx = "49535343-1e4d-4bd9-ba61-23c647249616"
    
    static let kBLEService_UUID = "49535343-FE7D-4AE5-8FA9-9FAFD205E455"
    static let kBLE_Characteristic_uuid_Tx = "49535345-FE7D-4AE5-8FA9-9FAFD205E455"
    static let kBLE_Characteristic_uuid_Rx = "49535344-FE7D-4AE5-8FA9-9FAFD205E455"
    
    static let MaxCharacters = 20

    static let BLEService_UUID = CBUUID(string: kBLEService_UUID)
    static let BLE_Characteristic_uuid_Tx = CBUUID(string: kBLE_Characteristic_uuid_Tx)//(Property = Write without response)
    static let BLE_Characteristic_uuid_Rx = CBUUID(string: kBLE_Characteristic_uuid_Rx)// (Property = Read/Notify)

}
