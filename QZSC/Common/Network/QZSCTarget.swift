//
//  QZSCTarget.swift
//  CampusNext
//
//  Created by wyy on 2020/9/30.
//  Copyright © 2020 wisedu. All rights reserved.
//

import Foundation

public protocol ParameterEncoder {
    /// 根据输入参数产生一个用于服务端验证的token 或者 key 之类的字段
    func accessToken(parameters: [String: Any]?) -> [String: Any]?
}

public protocol NetWorkConfig {
    var baseURL: String { get }
    var requiredDic: [String: Any] { get }
    var optionalDic: [String: Any] { get }
    var commonErrorHandler: ((_ errorCode: Int) -> Void)? { get }
}

public protocol QZSCTarget: ParameterEncoder, NetWorkConfig {
    var headers: QZSCAFHTTPHeaders? { get }
    var acceptContentTypes: [String] { get }
    var requestTimeoutInterval: Int { get }
}

/// 扩展：设定默认值
extension QZSCTarget {
    public var headers: QZSCAFHTTPHeaders? {
        let deviceId = QZSCAFHTTPHeader.init(name: "deviceNumber", value: "")
        let deviceType = QZSCAFHTTPHeader.init(name: "deviceType", value: "ios")
        let appVersion = QZSCAFHTTPHeader.init(name: "appVersion", value: kAppVersion)
        let application = QZSCAFHTTPHeader.init(name: "application", value: kAppName)

        let umerId = QZSCAFHTTPHeader.init(name: "userId", value: "")
        let network = QZSCAFHTTPHeader.init(name: "network", value: "network")
        let useragent = QZSCAFHTTPHeader.init(name: "User-Agent", value: "")
        let deviceInfo = QZSCAFHTTPHeader.init(name: "deviceInfo", value: "")
        
        /// 预发环境配置字段
        // let isTest = QZSCAFHTTPHeader.init(name: "istest", value: "true")
        
        var defaultHeaders = [deviceType, appVersion, application, umerId, network]
        
        if let tokenStr = UserDefaults.standard.object(forKey: "savedLogInToken") as? String {
            let tokenHeader = QZSCAFHTTPHeader.authorization(bearerToken: tokenStr)
            defaultHeaders.append(tokenHeader)
        }
        
        return QZSCAFHTTPHeaders.init(defaultHeaders)
    }

    public var acceptContentTypes: [String] {
        return ["application/json", "text/html"]
    }

    public var requestTimeoutInterval: Int {
        return 20
    }
}

/// 网络错误处理
public protocol CustomLogicErrorHandler {
    static func customLogicErrorHandler(code: Any, msg: String) -> NSError
}

extension CustomLogicErrorHandler {
    public static func customLogicErrorHandler(code: Any, msg: String) -> NSError {
        var fixMsg = ""
        if code is Int {
            switch code as! Int {
            case 400...599:
                fixMsg = "服务器错误,请稍后再试"
            case -1001:
                fixMsg = "连接超时,请稍后再试"
            case -1003, -1004, -1005, -1006:
                fixMsg = "网络连接失败"
            default:
                fixMsg = ""
            }
            if fixMsg.isEmpty {
                fixMsg = msg
            }
            
            let userInfo = [NSLocalizedDescriptionKey: fixMsg.isEmpty ? "error need review" : fixMsg]
            let error = NSError(domain: "com.umer", code: code as! Int, userInfo: userInfo)
            return error
        } else {
            let userInfo = [NSLocalizedDescriptionKey: msg.isEmpty ? "error need review" : msg, "originCode": code]
            if code is String && code as! String == "0" {
                let error = NSError(domain: "com.umer", code: 0, userInfo: userInfo)
                return error
            } else {
                let error = NSError(domain: "com.umer", code: -1, userInfo: userInfo)
                return error
            }
        }
    }
}


public struct DLTarget: QZSCTarget {

    public let baseURL: String

    public let requiredDic: [String: Any]

    public let optionalDic: [String: Any]

    public let commonErrorHandler: ((Int) -> Void)?

    public init(baseURL: String,
                requiredDic: [String: Any] = [:],
                optionalDic: [String: Any] = [:],
                commonErrorHandler: ((Int) -> Void)? = nil) {

        self.baseURL = baseURL
        self.requiredDic = requiredDic
        self.optionalDic = optionalDic
        self.commonErrorHandler = commonErrorHandler
    }

    public func accessToken(parameters: [String: Any]?) -> [String: Any]? {
        return nil
    }
}
