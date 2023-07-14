//
//  QZSCNetPlugin.swift
//  CampusNext
//
//  Created by wyy on 2020/9/30.
//  Copyright © 2020 wisedu. All rights reserved.
//

import Foundation
import Alamofire

public protocol QZSCNetPlugin {

    func willSend(request: QZSCRequest, dataRequest: DataRequest)

    func didReceive(request: URLRequest?, response: HTTPURLResponse?, data: Result<Data, Error>?)
}

public struct LoggerPlugin: QZSCNetPlugin {

    public init() {
    }

    func printURL(request: URLRequest?) -> String {
        let hostHeader = request?.allHTTPHeaderFields?["Host"]
        let urlString = request?.url?.absoluteString
        let hostString = request?.url?.host
        if let hostField = hostHeader, let url = urlString, let host = hostString {
            return url.replacingOccurrences(of: host, with: hostField)
        } else {
            return urlString ?? ""
        }
    }

    public func willSend(request: QZSCRequest, dataRequest: DataRequest) {
        #if DEBUG
        var message = "\n-> -> -> -> -> -> -> -> -> -> -> -> -> -> ->\n"

        message += "[REQUEST:] \(request.method) \(request.baseURL + request.routerURL)\n"
        message += "\n[必须参数:]\n"
        if let required = request.requiredParameter {
            message += "\(printDic(dic: required))\n"
        }
        message += "\n[可选参数:]\n"
        if let optional = request.optionalParameter {
            message += "\(printDic(dic: optional))\n"
        }

        message += "[DATAREQUEST:]\n\(printURL(request: dataRequest.request))\n"
        message += "<- <- <- <- <- <- <- <- <- <- <- <- <- <- <-\n"
        print(message)
        #endif
    }

    public func didReceive(request: URLRequest?, response: HTTPURLResponse?, data: Result<Data, Error>?) {
        #if DEBUG
        let requestDescription = request.map {
            "\($0.httpMethod!) \(printURL(request: $0))"
        } ?? "nil"
        let requestBody = request?.httpBody.map {
            String(decoding: $0, as: UTF8.self)
        } ?? "None"
        let responseDescription = response.map { response in
            let sortedHeaders = response.headers.sorted()

            return """
                   [Status Code]: \(response.statusCode)
                   [Headers]:
                   \(sortedHeaders)
                   """
        } ?? "nil"

        var desc = """
                   [Request]: \(requestDescription)
                   [Request Body]: \n\(requestBody)\n
                   [Response]: \n\(responseDescription)
                   """

        let responseData: String
        if let data = data {
            switch data {
            case .success(let result):
                guard let dataStr = String(data: result, encoding: .utf8) else {
                    printDesc(desc: desc)
                    return
                }
                let encryStr = RC4Tool.rc4Decode(dataStr, key: QZSCAppEnvironment.shared.rc4EncrySecret)
                guard let encryData = encryStr.data(using: .utf8) else {
                    printDesc(desc: desc)
                    return
                }
                guard let json = try? JSONSerialization.jsonObject(with: encryData, options: .allowFragments) else {
                    printDesc(desc: desc)
                    return
                }
                guard let data = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) else {
                    printDesc(desc: desc)
                    return
                }
                responseData = String(data: data, encoding: .utf8) ?? "None"
            case .failure(let error):
                responseData = "\(error)"
            }
        } else {
            responseData = "None"
        }

        desc = "\(desc)\n[Data]: \n\(responseData)"

        printDesc(desc: desc)
        #endif
    }

    private func printDesc(desc: String) {
        let startSeparatorLine = "\n****************** RESPONSE LOG ****************************\n"
        let endSeparatorLine = "******************************************************\n"
        print("\(startSeparatorLine)\(desc)\n\(endSeparatorLine)")
    }

    private func printDic(dic: [String: Any]) -> String {
        guard let data = try? JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted) else {
            return ""
        }
        if let string = String(data: data, encoding: .utf8) {
            return string
        } else {
            return ""
        }

    }
}

struct LoggerMonitor: EventMonitor {

    /// 因为Alamofire 5 异步生成urlRequest，所以使用该回调打印 Request
    public func request(_ request: Request, didCreateInitialURLRequest urlRequest: URLRequest) {
        #if DEBUG
        let requestDescription = request.request.map {
            "\($0.httpMethod!) \(printURL(request: $0))"
        } ?? "nil"
        let headerDescription = !urlRequest.headers.description.isEmpty ? urlRequest.headers.description : "None"
        let urlQueryParam = urlRequest.url?.queryParameters?.description ?? "None"
        let requestBody = request.request?.httpBody.map {
            String(decoding: $0, as: UTF8.self)
        } ?? "None"

        let desc = """
                   [Request]: \(requestDescription)\("?")\(requestBody)
                   [Headers]: \n\(headerDescription)
                   [URL Query Parameters]: \n\(urlQueryParam)
                   """

        let startSeparatorLine = "\n@@@@@@@@@@@@@@@@@@ REQUEST LOG @@@@@@@@@@@@@@@@@@@\n"
        let endSeparatorLine = "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n"

        print("\(startSeparatorLine)\(desc)\n\(endSeparatorLine)")
        #endif
    }

    func printURL(request: URLRequest?) -> String {
        let hostHeader = request?.allHTTPHeaderFields?["Host"]
        let urlString = request?.url?.absoluteString
        let hostString = request?.url?.host
        if let hostField = hostHeader, let url = urlString, let host = hostString {
            return url.replacingOccurrences(of: host, with: hostField)
        } else {
            return urlString ?? ""
        }
    }
}

extension URL {
    public var queryParameters: [String: String]? {
        guard
                let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
                let queryItems = components.queryItems else {
            return nil
        }
        return queryItems.reduce(into: [String: String]()) { (result, item) in
            result[item.name] = item.value
        }
    }
}
