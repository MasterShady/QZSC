//
//  QZSCRspBody.swift
//  CampusNext
//
//  Created by wyy on 2020/9/30.
//  Copyright © 2020 wisedu. All rights reserved.
//

import Foundation

/// 通用的response body
public struct QZSCRspBody<T: Decodable>: Decodable {

    let code: Int
    let data: T?
    let msg: String?

    fileprivate enum CodingKeys: String, CodingKey {
        case code, data
        case msg
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        code = try container.decodeSafe(Int.self, forKey: .code)
        data = try container.decodeSafeIfPresent(T.self, forKey: .data)
        msg = try container.decodeSafe(String.self, forKey: .msg)
	}
}

/// 空body
public struct QZSCResultNull: Decodable {

}
