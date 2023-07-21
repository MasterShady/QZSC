//
//  QZSCHomeModel.swift
//  QZSC
//
//  Created by fanyebo on 2023/7/20.
//

import Foundation
@objcMembers
class QZSCProductListModel: NSObject, Codable {
    let id: Int
    let category_id: Int
    let name: String
    let price: String
    let list_pic: String
    let brand_name: String
    let is_specail_price: Bool
    
    enum CodingKeys: String, CodingKey {
        case id, name, price, list_pic, category_id
        case brand_name, is_specail_price
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decodeSafe(Int.self, forKey: .id)
        category_id = try container.decodeSafe(Int.self, forKey: .category_id)
        name = try container.decodeSafe(String.self, forKey: .name)
        price = try container.decodeSafe(String.self, forKey: .price)
        list_pic = try container.decodeSafe(String.self, forKey: .list_pic)
        brand_name = try container.decodeSafe(String.self, forKey: .brand_name)
        is_specail_price = try container.decodeSafe(Bool.self, forKey: .is_specail_price)
    }
}

struct QZSCProductDetailsModel: Codable {
    let goods_info: QZSCProductDetailsInfoModel?
    
    enum CodingKeys: String, CodingKey {
        case goods_info
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        goods_info = try container.decodeSafeIfPresent(QZSCProductDetailsInfoModel.self, forKey: .goods_info)
    }
}


struct QZSCProductDetailsInfoModel: Codable {
    let id: Int
    let category_id: Int
    let name: String
    let price: String
    let list_pic: String
    let pics: [String]
    let content_pics: [String]
    let brand_name: String
    let is_specail_price: Bool
    let is_collect: Bool
    
    enum CodingKeys: String, CodingKey {
        case id, name, price, list_pic, pics, content_pics, category_id
        case brand_name, is_specail_price, is_collect
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decodeSafe(Int.self, forKey: .id)
        category_id = try container.decodeSafe(Int.self, forKey: .category_id)
        name = try container.decodeSafe(String.self, forKey: .name)
        price = try container.decodeSafe(String.self, forKey: .price)
        list_pic = try container.decodeSafe(String.self, forKey: .list_pic)
        pics = try container.decodeSafe([String].self, forKey: .pics)
        content_pics = try container.decodeSafe([String].self, forKey: .content_pics)
        brand_name = try container.decodeSafe(String.self, forKey: .brand_name)
        is_specail_price = try container.decodeSafe(Bool.self, forKey: .is_specail_price)
        is_collect = try container.decodeSafe(Bool.self, forKey: .is_collect)
    }
}
