//
//  QZSCError.swift
//  CampusNext
//
//  Created by wyy on 2020/9/30.
//  Copyright © 2020 wisedu. All rights reserved.
//

import Foundation

public enum QZSCError: Swift.Error {

    public enum DecodeErrorReason {
        case noData
        case dialogBody
    }

    case decodeError(reason: DecodeErrorReason)
    case httpError
    case logicError
}

enum QZSCRequestError: Error {
    case timeOut
    case netWork
    case common
    case nsError(NSError)
    case custom(String?, Int)
}

extension QZSCRequestError: LocalizedError {
    var localizedDescription: String {
        switch self {
        case .timeOut:
            return "请求超时"
        case .netWork:
            return "网络错误"
        case .common:
            return "服务器错误"
        case .nsError(let error):
            return error.localizedDescription
        case .custom(let errorDes, _):
            return errorDes ?? ""
        }
    }

    var errorCode: Int {
        switch self {
        case .custom(_, let code):
            return code
        case .nsError(let error):
            return error.code
        default:
            return -1
        }
    }
}

enum CustomLogicError: Error {
    case mfm(_ error: Error)
    case acdm(_ error: Error)
}
