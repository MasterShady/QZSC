//
//  QZSCParameter.swift
//  CampusNext
//
//  Created by wyy on 2020/9/30.
//  Copyright © 2020 wisedu. All rights reserved.
//

import Foundation
import Alamofire

public enum QZSCParameterEncoding {
    case URLEncode
    case JSONEncode
    case CryptEncode
}

/// 一个请求的参数
public protocol QZSCParameter {

    var baseURL: String { get }

    var routerURL: String { get }

    /// 一个Request的传入参数, 必传参数和可选参数
    var requiredParameter: [String: Any]? { get }
    var optionalParameter: [String: Any]? { get }

    /// 请求参数编码方式
    var parameterEncoding: QZSCParameterEncoding { get }

    /// 一个Request的http请求方式
    var method: QZSCAFHTTPMethod { get }

    var stubData: Data? { get }

    var target: QZSCTarget { get }
}

extension QZSCParameter {
    public var stubData: Data? {
        return nil
    }
}

public protocol QZSCRequest: QZSCParameter {
    var isNeedToken: Bool { get }
    var isNeedLog: Bool { get }
    var isNeedCrypt: Bool { get }
    var addtionalHeader: QZSCAFHTTPHeaders? { get }
}

extension QZSCRequest {
    public var isNeedToken: Bool {
        return false
    }
    public var isNeedLog: Bool {
        return true
    }
    public var isNeedCrypt: Bool {
        return true
    }
    public var addtionalHeader: QZSCAFHTTPHeaders? {
        return nil
    }
}

public protocol RequestContainerTrait {
    var dataRequest: QZSCAFDataRequest { get }
    var target: QZSCTarget { get }
    var plugins: [QZSCNetPlugin] { get }
}

public struct RequestContainer: RequestContainerTrait {
    public let dataRequest: QZSCAFDataRequest
    public let target: QZSCTarget
    public let plugins: [QZSCNetPlugin]
}

/// 参数加密
public struct CryptParameterEncoding: ParameterEncoding {
    public static var `default`: CryptParameterEncoding { CryptParameterEncoding() }
    
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var urlRequest = try urlRequest.asURLRequest()

        guard let parameters = parameters else { return urlRequest }

        do {
            let data = try JSONSerialization.data(withJSONObject: parameters, options: [])
            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
            
            var str: String = String(data: data, encoding: .utf8) ?? ""

            str = RC4Tool.rc4Encode(str, key: QZSCAppEnvironment.shared.rc4EncrySecret)
            let encrypedData = str.data(using: .utf8)

            urlRequest.httpBody = encrypedData
        } catch {
            throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
        }

        return urlRequest
    }
}
