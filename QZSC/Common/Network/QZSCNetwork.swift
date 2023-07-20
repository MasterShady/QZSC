//
//  QZSCNetwork.swift
//  CampusNext
//
//  Created by wyy on 2020/9/30.
//  Copyright © 2020 wisedu. All rights reserved.
//

import Foundation
import Alamofire

public class QZSCNetwork {

    public static func request(_ request: QZSCRequest, plugins: [QZSCNetPlugin] = [QZSCNetPlugin]()) -> RequestContainer {
        let target = request.target
        let url = request.baseURL + request.routerURL
        var dic = request.requiredParameter

        if let optionDic = request.optionalParameter {
            dic?.merge(optionDic, uniquingKeysWith: { (_, new) in new })
        }

        var plugins = plugins
        if request.isNeedLog {
            plugins.append(LoggerPlugin())
        }

        var headers = target.headers
        if let requestHeaders = request.addtionalHeader {
            for header in requestHeaders.dictionary {
                headers?.add(name: header.key, value: header.value)
            }
        }

        var paramEncoding: ParameterEncoding = URLEncoding.default
        if request.parameterEncoding == .JSONEncode {
            paramEncoding = URLEncoding.default
        } else if request.parameterEncoding == .CryptEncode {
            paramEncoding = CryptParameterEncoding.default
        }

        let dataRequest = QZSCSessionManager.sharedManager.request(url, method: request.method, parameters: dic, encoding: paramEncoding, headers: headers)
        plugins.forEach {
            $0.willSend(request: request, dataRequest: dataRequest)
        }
        return RequestContainer.init(dataRequest: dataRequest, target: target, plugins: plugins)
    }

    public func upload(_ request: QZSCRequest,
                       fileName: String,
                       mimeType: String,
                       plugins: [QZSCNetPlugin] = [QZSCNetPlugin](),
                       progress: ((_ progress: Progress) -> Void)? = nil) -> RequestContainer {
        let target = request.target
        let url = request.baseURL + request.routerURL
        var dic = request.requiredParameter
        if request.isNeedToken {
            if let token = target.accessToken(parameters: dic) {
                dic?.merge(token, uniquingKeysWith: { (_, new) in new })
            }
        }
        if let optionDic = request.optionalParameter {
            dic?.merge(optionDic, uniquingKeysWith: { (_, new) in new })
        }

        var plugins = plugins
        if request.isNeedLog {
            plugins.append(LoggerPlugin())
        }

        var headers: HTTPHeaders = HTTPHeaders()
        if let targetHeaders = target.headers {
            for header in targetHeaders.dictionary {
                headers.add(name: header.key, value: header.value)
            }
        }
        if let requestHeaders = request.addtionalHeader {
            for header in requestHeaders.dictionary {
                headers.add(name: header.key, value: header.value)
            }
        }

        let uploadRequest = QZSCSessionManager.sharedManager.upload(multipartFormData: { (multipartFormData) in
            dic?.forEach({ (key, value) in
                if let s = value as? String {
                    if let data = s.data(using: .utf8) {
                        multipartFormData.append(data, withName: key)
                    }
                } else if let n = value as? NSNumber {
                    if let data = n.stringValue.data(using: .utf8) {
                        multipartFormData.append(data, withName: key)
                    }
                } else if let d = value as? Data {
                    multipartFormData.append(d, withName: key, fileName: fileName, mimeType: mimeType)
                }
            })
        }, to: url,
                headers: headers)

        uploadRequest.uploadProgress { (progess) in
            progress?(progess)
        }

        return RequestContainer(dataRequest: uploadRequest, target: target, plugins: plugins)
    }
}

public class QZSCSessionManager {
    public static var timeoutIntervalForRequest: TimeInterval = 20
    public static var timeoutIntervalForResource: TimeInterval = 604800 //默认值7天
    public static let sharedManager: QZSCAFSessionManager = {
        let configuration = URLSessionConfiguration.default
        
        var defaultHeaders: [AnyHashable : Any]? = [QZSCAFHTTPHeader.defaultUserAgent.name: QZSCAFHTTPHeader.defaultUserAgent.value,
                       QZSCAFHTTPHeader.defaultAcceptEncoding.name: QZSCAFHTTPHeader.defaultAcceptEncoding.value,
                       QZSCAFHTTPHeader.defaultAcceptLanguage.name: QZSCAFHTTPHeader.defaultAcceptLanguage.value]
        
        var headers: [AnyHashable : Any]? = defaultHeaders?.merging(QZSCSessionRequiredHeader().header(), uniquingKeysWith: { first, _ in
            return first
        })
        
        configuration.httpAdditionalHeaders = headers
        
        
        configuration.timeoutIntervalForRequest = timeoutIntervalForRequest
        configuration.timeoutIntervalForResource = timeoutIntervalForResource

        let manager = Alamofire.Session(configuration: configuration, eventMonitors: [LoggerMonitor()])
        return manager
    }()
}

/// 必要header
public struct QZSCSessionRequiredHeader {
//    var appId: String = QZSCAppDomainConfig.appId
//    let appVer: String = appVersion
    var appId: String = ""
    let appVer: String = ""
    var deviceType: String = "IOS"
    
    /// 组装header
    public func header() -> [String: String] {
        return ["appid": appId, "appver": appVer, "device-type": deviceType]
    }
}
