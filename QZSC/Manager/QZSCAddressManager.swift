//
//  QZSCAddressManager.swift
//  QZSC
//
//  Created by fanyebo on 2023/7/21.
//

import Foundation

class QZSCAddressManager {
    
    static let shared = QZSCAddressManager()
    
    private let keyAddressInfo = "QZSC_local_addressModel"
    
    var defaultAddressModel: AddressListModel? {
        set {
            guard let info = newValue else { return }
            QZSCCache.cache(object: info, key: keyAddressInfo)
        }
        get {
            return QZSCCache.fetchObject(key: keyAddressInfo, to: AddressListModel.self)
        }
    }
    
    var hasDefaultAddress: Bool {
        if let _ = defaultAddressModel {
            return true
        }
        return false
    }
}
