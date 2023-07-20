//
//  QZSCUserInfo.swift
//  QZSC
//
//  Created by LN C on 2023/7/20.
//

import Foundation
import Combine

class QZSCUserInfo: Codable, ObservableObject{
    
    var uid: Int = 0
    @Published var nickname: String = ""
    @Published var foot_num: Int = 0
    @Published var is_sub_merchant: Int = 0
    @Published var collect_num: Int = 0
    @Published var bill_num: Int = 0
    
    var isLogin : Bool{
       return uid != 0
    }
    
    
    init() {
        
    }
    
    enum CodingKeys: String, CodingKey {
        case uid, nickname, foot_num, is_sub_merchant, collect_num, bill_num
    }
    
    func encode(to encoder: Encoder) throws{
        fatalError("error")
    }
    
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
