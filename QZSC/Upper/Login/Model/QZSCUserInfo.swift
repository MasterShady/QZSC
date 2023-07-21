//
//  QZSCUserInfo.swift
//  QZSC
//
//  Created by LN C on 2023/7/20.
//

import Foundation
import Combine

class QZSCUserInfo: Codable{
    
    var uid: Int = 0
    var nickname: String = ""
    var foot_num: Int = 0
    var is_sub_merchant: Int = 0
    var collect_num: Int = 0
    var bill_num: Int = 0
    
    init() {
        
    }
    
    enum CodingKeys: String, CodingKey {
        case uid, nickname, foot_num, is_sub_merchant, collect_num, bill_num
    }
    
    
//    func encode(to encoder: Encoder) throws {
//            var container = encoder.container(keyedBy: CodingKeys.self)
//            try container.encode(self.uid, forKey: .uid)
//            try container.encode(self.nickname, forKey: .nickname)
//            try container.encode(self.foot_num, forKey: .foot_num)
//            try container.encode(self.is_sub_merchant, forKey: .is_sub_merchant)
//            try container.encode(self.collect_num, forKey: .collect_num)
//            try container.encode(self.bill_num, forKey: .bill_num)
//        }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        uid = try container.decodeSafe(Int.self, forKey: .uid)
        nickname = try container.decodeSafe(String.self, forKey: .nickname)
        foot_num = try container.decodeSafe(Int.self, forKey: .foot_num)
        is_sub_merchant = try container.decodeSafe(Int.self, forKey: .is_sub_merchant)
        collect_num = try container.decodeSafe(Int.self, forKey: .collect_num)
        bill_num = try container.decodeSafe(Int.self, forKey: .bill_num)
    }
}
