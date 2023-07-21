//
//  OrderListModel.swift
//  QZSC
//
//  Created by LN C on 2023/7/21.
//

import Foundation

class OrderListModel: Codable{
    
    var id:Int = 0
    var order_sn:String = ""
    var goods_id:Int = 0
    var price:String = ""
    var order_day:Int = 0
    var amount:String = ""
    var start_date:String = ""
    var end_date:String = ""
    var spec_ids:String = ""
    var create_time:String = ""
    var status:Int = 0
    var goods_info:OrderGoodsInfoViewModel?
    var goods_cate_name:String = ""
    
    
    enum CodingKeys: String, CodingKey {
        case id, order_sn, goods_id, price, order_day,goods_cate_name
        case amount, start_date,end_date,spec_ids,create_time,status,goods_info
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decodeSafe(Int.self, forKey: .id)
        order_sn = try container.decodeSafe(String.self, forKey: .order_sn)
        goods_id = try container.decodeSafe(Int.self, forKey: .goods_id)
        price = try container.decodeSafe(String.self, forKey: .price)
        order_day = try container.decodeSafe(Int.self, forKey: .order_day)
        amount = try container.decodeSafe(String.self, forKey: .amount)
        start_date = try container.decodeSafe(String.self, forKey: .start_date)
        end_date = try container.decodeSafe(String.self, forKey: .end_date)
        spec_ids = try container.decodeSafe(String.self, forKey: .spec_ids)
        create_time = try container.decodeSafe(String.self, forKey: .create_time)
        status = try container.decodeSafe(Int.self, forKey: .status)
        
        goods_info = try container.decodeSafeIfPresent(OrderGoodsInfoViewModel.self, forKey: .goods_info)
        goods_cate_name = try container.decodeSafe(String.self, forKey: .goods_cate_name)
        
        
        
    }
}

class OrderGoodsInfoViewModel: Codable{
    var id:Int = 0
    var name:String = ""
    var list_pic:String = ""
    var goods_tag: [String] = []
    
    enum CodingKeys: String, CodingKey {
        case id, name, list_pic, goods_tag
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decodeSafe(Int.self, forKey: .id)
        name = try container.decodeSafe(String.self, forKey: .name)
        list_pic = try container.decodeSafe(String.self, forKey: .list_pic)
        goods_tag = try container.decodeSafe([String].self, forKey: .goods_tag)
        
    }
    
    
}
