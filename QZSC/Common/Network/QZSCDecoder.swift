//
//  QZSCDecoder.swift
//  CampusNext
//
//  Created by wyy on 2020/9/30.
//  Copyright © 2020 wisedu. All rights reserved.
//

import Alamofire

// MARK: - Decodable
extension RequestContainer: CustomLogicErrorHandler {

}

extension RequestContainer {
    @discardableResult
    public func responseDecodable<T: Decodable>(queue: DispatchQueue = .main,
                                                decoder: JSONDecoder = JSONDecoder(),
                                                completionHandler: @escaping (QZSCAFDataResponse<T>) -> Void) -> RequestContainer {
        // AFDataResponse<T, AFError> => DataResponse<T, Error>
        return _responseDecodable { (dataResponse: Alamofire.DataResponse<T, AFError>) in
            switch dataResponse.result {
            case .success(let t):
                let response = Alamofire.DataResponse<T, Error>(request: dataResponse.request, response: dataResponse.response, data: dataResponse.data, metrics: dataResponse.metrics, serializationDuration: dataResponse.serializationDuration, result: Result.success(t))
                completionHandler(response)
            case .failure(let aferror):
                var error: Error
                if let unError = aferror.underlyingError {
                    error = unError
                } else {
                    error = aferror
                }
                let result = Result<T, Error>.failure(error)
                let response = Alamofire.DataResponse<T, Error>(request: dataResponse.request, response: dataResponse.response, data: dataResponse.data, metrics: dataResponse.metrics, serializationDuration: dataResponse.serializationDuration, result: result)

                completionHandler(response)
            }
        }
    }

    private func _responseDecodable<T: Decodable>(queue: DispatchQueue = .main,
                                                  decoder: JSONDecoder = JSONDecoder(),
                                                  completionHandler: @escaping (AFDataResponse<T>) -> Void) -> RequestContainer {
        let preprocessor = CNDecodableDataProcessor(decoder: decoder,
                target: target)

        let responseSerializer = CNDecodableResponseSerializer<T>(dataPreprocessor: preprocessor,
                decoder: decoder,
                target: target,
                plugins: plugins)

        _ = self.dataRequest.response(queue: queue, responseSerializer: responseSerializer, completionHandler: completionHandler)

        return self
    }
}

// MARK: - Internal
struct CNDecodableDataProcessor: DataPreprocessor {
    let decoder: JSONDecoder
    let target: QZSCTarget

    func preprocess(_ data: Data) throws -> Data {
        guard let dataStr = String(data: data, encoding: .utf8) else {
            return data
        }
        let encryStr = RC4Tool.rc4Decode(dataStr, key: QZSCAppEnvironment.shared.rc4EncrySecret)
        guard let encryData = encryStr.data(using: .utf8) else {
            return data
        }
        guard var dict = try? JSONSerialization.jsonObject(with: encryData, options: .fragmentsAllowed) as? [String: Any] else {
            return data
        }
        if dict["data"] == nil {
            let emptyDic = [String: Any]()
            dict["data"] = emptyDic
            if let retData = try? JSONSerialization.data(withJSONObject: dict as Any, options: .prettyPrinted) {
                return retData
            }
            return data
        }
        return data
    }
}

final class CNDecodableResponseSerializer<T: Decodable>: ResponseSerializer, CustomLogicErrorHandler {
    let dataPreprocessor: DataPreprocessor
    /// The DataDecoder instance used to decode responses.
    let decoder: Alamofire.DataDecoder
    let emptyResponseCodes: Set<Int>
    let emptyRequestMethods: Set<QZSCAFHTTPMethod>
    let target: QZSCTarget
    let plugins: [QZSCNetPlugin]

    /// Creates an instance using the values provided.
    /// - Parameters:
    ///   - dataPreprocessor: DataPreprocessor used to prepare the received Data for serialization.
    ///   - decoder: The DataDecoder. JSONDecoder() by default.
    ///   - emptyResponseCodes: The HTTP response codes for which empty responses are allowed. [204, 205] by default.
    ///   - emptyRequestMethods: The HTTP request methods for which empty responses are allowed. [.head] by default.
    ///   - target: FGTarget
    ///   - plugins: FGPlugins
    init(dataPreprocessor: DataPreprocessor = CNDecodableResponseSerializer.defaultDataPreprocessor,
         decoder: Alamofire.DataDecoder = JSONDecoder(),
         emptyResponseCodes: Set<Int> = CNDecodableResponseSerializer.defaultEmptyResponseCodes,
         emptyRequestMethods: Set<QZSCAFHTTPMethod> = CNDecodableResponseSerializer.defaultEmptyRequestMethods,
         target: QZSCTarget,
         plugins: [QZSCNetPlugin]) {
        self.dataPreprocessor = dataPreprocessor
        self.decoder = decoder
        self.emptyResponseCodes = emptyResponseCodes
        self.emptyRequestMethods = emptyRequestMethods
        self.target = target
        self.plugins = plugins
    }

    func serialize(request: URLRequest?, response: HTTPURLResponse?, data: Data?, error: Error?) throws -> T {
        guard error == nil else {
            plugins.forEach {
                $0.didReceive(request: request, response: response, data: Result.failure(error!))
            }
            if let err = error?.asAFError?.underlyingError as NSError? {
                throw Self.customLogicErrorHandler(code: err.code, msg: err.localizedDescription)
            }
            throw error!
        }

        guard var data = data, !data.isEmpty else {
            guard emptyResponseAllowed(forRequest: request, response: response) else {
                throw AFError.responseSerializationFailed(reason: .inputDataNilOrZeroLength)
            }

            guard let emptyResponseType = T.self as? EmptyResponse.Type, let emptyValue = emptyResponseType.emptyValue() as? T else {
                throw AFError.responseSerializationFailed(reason: .invalidEmptyResponse(type: "(T.self)"))
            }
            return emptyValue
        }

        do {
            data = try dataPreprocessor.preprocess(data)
            plugins.forEach {
                $0.didReceive(request: request, response: response, data: Result.success(data))
            }
        } catch {
            plugins.forEach {
                $0.didReceive(request: request, response: response, data: Result.failure(error))
            }
            throw error
        }

        guard let code = response?.statusCode, code == 200 else {
            let nserror = Self.customLogicErrorHandler(code: response?.statusCode ?? 0, msg: "")
            throw nserror
        }
        do {
            let nserror = Self.customLogicErrorHandler(code: response?.statusCode ?? 0, msg: "数据解析异常")
            guard let dataStr = String(data: data, encoding: .utf8) else {
                throw nserror
            }
            let encryStr = RC4Tool.rc4Decode(dataStr, key: QZSCAppEnvironment.shared.rc4EncrySecret)
            guard let encryData = encryStr.data(using: .utf8) else {
                throw nserror
            }
            let object = try decoder.decode(QZSCRspBody<T>.self, from: encryData)
            if let resultData = object.data, object.code == 0 {
                return resultData
            }
            let error = Self.customLogicErrorHandler(code: object.code, msg: object.msg ?? "服务器异常")
            throw error
        } catch CustomLogicError.acdm(let error) {
            throw error
        } catch {
            do {
                /* 登陆失效处理操作，需要根据实际情况修改
                let acdmException = try decoder.decode(QZSCRspBody<QZSCResultNull>.self, from: data)
                let nserror = Self.customLogicErrorHandler(code: acdmException.code, msg: acdmException.msg ?? "")
                let error = CustomLogicError.acdm(nserror)
                target.commonErrorHandler?(nserror.code)
                if nserror.code == -1 {
                    //发生错误
                    let userInfo = nserror.userInfo
                    if let originCode = userInfo["originCode"] as? String, originCode == "A4001" {
                        //登录失效
                        handleReLogin()
                    }
                }
                 */
                throw error
            } catch CustomLogicError.acdm(let error) {
                throw error
            } catch {
                throw error
            }
        }

    }

    /// 当前账号在其他设备登录，被挤掉时的处理
    private func handleOtherDeviceLogin() {
//		DispatchQueue.main.async {
//			UIAlertController.singleMenuAlert(title: "您的帐号已在其它设备登录，请重新登录",
//											  message: nil,
//											  buttonTitle: "确定") { [weak self](_) in
//
//
//			}
//
//		}
    }
    
    /// 重新登录处理
    private func handleReLogin() {
//        QZSCLoginManager.shared.logoutHandler()
    }
}

// MARK: - JSON
extension RequestContainer {
    @discardableResult
    public func responseServiceObject(
            type: NSObject.Type? = nil,
            queue: DispatchQueue = .main,
            options: JSONSerialization.ReadingOptions = .allowFragments,
            completionHandler: @escaping (QZSCServiceObject) -> Void) -> RequestContainer {
        return _responseCampusJSON { (dataResponse: AFDataResponse<Any>) in
            switch dataResponse.result {
            case .success(let data):
                let ret = QZSCServiceObject()
                if let dic = data as? [String: Any] {
                    let keys = dic.keys
                    let defaultCode = "-9999"
                    if keys.contains("error_code") {
                        ret.errorCode = (dic["error_code"] as? String) ?? defaultCode
                    } else if keys.contains("code") {
                        if let codeValue = dic["code"] {
                            ret.errorCode = "\(codeValue)"
                        }
                    } else if keys.contains("success") {
                        if let codeValue = dic["success"] as? Int {
                            ret.errorCode = (codeValue == 1 ? "200" : defaultCode)
                        }
                    }

                    if keys.contains("msg") {
                        ret.msg = (dic["msg"] as? String) ?? ""
                    } else if keys.contains("message") {
                        ret.msg = (dic["message"] as? String) ?? ""
                    }

                    var dataInDic = dic["data"]
                    if dataInDic == nil {
                        dataInDic = dic["datas"]
                    } else if let tmp = dataInDic as? [String: Any], tmp.isEmpty {
                        dataInDic = dic["datas"]
                    }

                    ret.data = dataInDic
                    if ret.errorCode == "0" {
                        ret.state = .Response_Succ
                    } else {
                        ret.state = .Response_Fail
                    }
                } else {
                    ret.state = .Response_Fail
                    ret.msg = "defaultSystemError"
                }

                completionHandler(ret)

            case .failure(let aferror):
                var error: Error
                if let unError = aferror.underlyingError {
                    error = unError
                } else {
                    error = aferror
                }
                if let err = error as NSError? {
                    error = Self.customLogicErrorHandler(code: err.code, msg: err.localizedDescription)
                }
                let ret = QZSCServiceObject()
                ret.state = .Response_Fail
                ret.errorCode = String((error as NSError).code)
                ret.msg = error.localizedDescription
                completionHandler(ret)
            }
        }
    }

    @discardableResult
    public func responseCampusJSON(queue: DispatchQueue = .main,
                                   options: JSONSerialization.ReadingOptions = .allowFragments,
                                   completionHandler: @escaping (QZSCAFDataResponse<Any>) -> Void) -> RequestContainer {
        return _responseCampusJSON { (dataResponse: AFDataResponse<Any>) in
            switch dataResponse.result {
            case .success(let data):
                let response = Alamofire.DataResponse<Any, Error>(request: dataResponse.request,
                                                                  response: dataResponse.response,
                                                                  data: dataResponse.data,
                                                                  metrics: dataResponse.metrics,
                                                                  serializationDuration: dataResponse.serializationDuration,
                                                                  result: Result.success(data))
                completionHandler(response)

            case .failure(let aferror):
                var error: Error
                if let unError = aferror.underlyingError {
                    error = unError
                } else {
                    error = aferror
                }
                let result = Result<Any, Error>.failure(error)
                let response = Alamofire.DataResponse<Any, Error>(request: dataResponse.request,
                                                                  response: dataResponse.response,
                                                                  data: dataResponse.data,
                                                                  metrics: dataResponse.metrics,
                                                                  serializationDuration: dataResponse.serializationDuration,
                                                                  result: result)

                completionHandler(response)
            }
        }
    }

    private func _responseCampusJSON(queue: DispatchQueue = .main,
                                     options: JSONSerialization.ReadingOptions = .allowFragments,
                                     completionHandler: @escaping (AFDataResponse<Any>) -> Void) -> RequestContainer {
        let preprocessor = CNDecodableDataProcessor(decoder: JSONDecoder(),
                target: target)
        let responseSerializer = CNJSONResponseSerializer(dataPreprocessor: preprocessor, options: options, target: target, plugins: plugins)
        _ = self.dataRequest.response(queue: queue, responseSerializer: responseSerializer, completionHandler: completionHandler)
        return self
    }
}

/// A `ResponseSerializer` that decodes the response data using `JSONSerialization`. By default, a request returning
/// `nil` or no data is considered an error. However, if the response is has a status code valid for empty responses
/// (`204`, `205`), then an `NSNull`  value is returned.
public final class CNJSONResponseSerializer: ResponseSerializer, CustomLogicErrorHandler {
    public let dataPreprocessor: DataPreprocessor
    public let emptyResponseCodes: Set<Int>
    public let emptyRequestMethods: Set<HTTPMethod>
    /// `JSONSerialization.ReadingOptions` used when serializing a response.
    public let options: JSONSerialization.ReadingOptions

    let target: QZSCTarget
    let plugins: [QZSCNetPlugin]

    /// Creates an instance with the provided values.
    ///
    /// - Parameters:
    ///   - dataPreprocessor:    `DataPreprocessor` used to prepare the received `Data` for serialization.
    ///   - emptyResponseCodes:  The HTTP response codes for which empty responses are allowed. `[204, 205]` by default.
    ///   - emptyRequestMethods: The HTTP request methods for which empty responses are allowed. `[.head]` by default.
    ///   - options:             The options to use. `.allowFragments` by default.
    public init(dataPreprocessor: DataPreprocessor = JSONResponseSerializer.defaultDataPreprocessor,
                emptyResponseCodes: Set<Int> = JSONResponseSerializer.defaultEmptyResponseCodes,
                emptyRequestMethods: Set<HTTPMethod> = JSONResponseSerializer.defaultEmptyRequestMethods,
                options: JSONSerialization.ReadingOptions = .allowFragments,
                target: QZSCTarget,
                plugins: [QZSCNetPlugin]) {
        self.dataPreprocessor = dataPreprocessor
        self.emptyResponseCodes = emptyResponseCodes
        self.emptyRequestMethods = emptyRequestMethods
        self.options = options
        self.target = target
        self.plugins = plugins
    }

    public func serialize(request: URLRequest?, response: HTTPURLResponse?, data: Data?, error: Error?) throws -> Any {
        guard error == nil else {
            plugins.forEach {
                $0.didReceive(request: request, response: response, data: Result.failure(error!))
            }
            if let err = error?.asAFError?.underlyingError as NSError? {
                throw Self.customLogicErrorHandler(code: err.code, msg: err.localizedDescription)
            }
            throw error!
        }

        guard var data = data, !data.isEmpty else {
            guard emptyResponseAllowed(forRequest: request, response: response) else {
                throw AFError.responseSerializationFailed(reason: .inputDataNilOrZeroLength)
            }

            return NSNull()
        }

        do {
            data = try dataPreprocessor.preprocess(data)
            plugins.forEach {
                $0.didReceive(request: request, response: response, data: Result.success(data))
            }
        } catch {
            plugins.forEach {
                $0.didReceive(request: request, response: response, data: Result.failure(error))
            }
            throw error
        }
        guard let code = response?.statusCode, code == 200 else {
            let nserror = Self.customLogicErrorHandler(code: response?.statusCode ?? 0, msg: "")
            throw nserror
        }
        do {
            let nserror = Self.customLogicErrorHandler(code: response?.statusCode ?? 0, msg: "数据解析异常")
            guard let dataStr = String(data: data, encoding: .utf8) else {
                throw nserror
            }
            let encryStr = RC4Tool.rc4Decode(dataStr, key: QZSCAppEnvironment.shared.rc4EncrySecret)
            guard let encryData = encryStr.data(using: .utf8) else {
                throw nserror
            }
            let json = try JSONSerialization.jsonObject(with: encryData, options: options)
            return json
        } catch CustomLogicError.acdm(let error) {
            throw error
        } catch {
            throw AFError.responseSerializationFailed(reason: .jsonSerializationFailed(error: error))
        }

    }

//    public static func customLogicErrorHandler(code: Int, msg: String) -> NSError {
//        let userInfo = [NSLocalizedDescriptionKey: msg.isEmpty ? "error need review" : msg]
//        let error = NSError(domain: "com.wisedu", code: code, userInfo: userInfo)
//        return error
//    }
}
