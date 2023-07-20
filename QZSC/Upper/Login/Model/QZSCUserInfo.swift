//
//  QZSCUserInfo.swift
//  QZSC
//
//  Created by LN C on 2023/7/20.
//

import Foundation

struct QZSCUserInfo: Codable {
    
    var uid: Int
    var nickname: String
    var foot_num: Int
    var is_sub_merchant: Int
    var collect_num: Int
    var bill_num: Int
    
    enum CodingKeys: String, CodingKey {
        case uid, nickname, foot_num, is_sub_merchant, collect_num, bill_num
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        uid = try container.decodeSafe(Int.self, forKey: .uid)
        nickname = try container.decodeSafe(String.self, forKey: .nickname)
        foot_num = try container.decodeSafe(Int.self, forKey: .foot_num)
        is_sub_merchant = try container.decodeSafe(Int.self, forKey: .is_sub_merchant)
        collect_num = try container.decodeSafe(Int.self, forKey: .collect_num)
        bill_num = try container.decodeSafe(Int.self, forKey: .bill_num)
    }
}
