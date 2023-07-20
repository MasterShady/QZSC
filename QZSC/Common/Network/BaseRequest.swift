//
//  BaseRequest.swift
//  CampusNext
//
//  Created by wyy on 2020/10/9.
//  Copyright © 2020 wisedu. All rights reserved.
//

import Foundation

public protocol BaseRequest: QZSCRequest {}

/// 扩展： 设置默认值
public extension BaseRequest {
    var method: QZSCAFHTTPMethod {
        return .get
    }

    var baseURL: String {
        return target.baseURL
    }

    var parameterEncoding: QZSCParameterEncoding {
        if isNeedCrypt {
            return .CryptEncode
        }
        if method == .post {
            return .JSONEncode
        } else {
            return .URLEncode
        }
    }

    var requiredParameter: [String: Any]? {
        return ["uid": QZSCLoginManager.shared.userInfo?.uid]
    }

    var optionalParameter: [String: Any]? {
        return target.optionalDic
    }

    var target: QZSCTarget {
        return QZSCNetworkConfig.shared.dlTarget
    }

}
