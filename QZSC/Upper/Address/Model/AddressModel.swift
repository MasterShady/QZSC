//
//  AddressModel.swift
//  QZSC
//
//  Created by LN C on 2023/7/20.
//

import Foundation
struct AddressListModel: Codable {
    let id: Int
    let uid: Int
    let uname: String
    let phone: String
    let address_area: String
    let address_detail: String
    let create_time: String
    let is_default: Int
    
    enum CodingKeys: String, CodingKey {
        case id, uid, uname, phone, address_area
        case address_detail, create_time,is_default
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decodeSafe(Int.self, forKey: .id)
        uid = try container.decodeSafe(Int.self, forKey: .uid)
        uname = try container.decodeSafe(String.self, forKey: .uname)
        phone = try container.decodeSafe(String.self, forKey: .phone)
        address_area = try container.decodeSafe(String.self, forKey: .address_area)
        address_detail = try container.decodeSafe(String.self, forKey: .address_detail)
        create_time = try container.decodeSafe(String.self, forKey: .create_time)
        is_default = try container.decodeSafe(Int.self, forKey: .is_default)
    }
}
