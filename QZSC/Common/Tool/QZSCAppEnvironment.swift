//
//  QZSCAppEnvironment.swift
//  UmerChat
//
//  Created by umer on 2022/6/8.
//  Copyright © 2022 UmerQs. All rights reserved.
//

import Foundation
import AVFoundation
import CoreTelephony

enum QZSCAppEnvironmentType: Int {
    case distribute = 1
    case development
}

class QZSCAppEnvironment: NSObject {
    @objc static let shared = QZSCAppEnvironment()
    
    // 当不可配置环境时，默认的开发环境
    static let defaultEnv: QZSCAppEnvironmentType = QZSCAppEnvironmentType.development
    
    // false 苹果商店app包
    static let isAppStore: Bool = false
    
    // MARK: - Set / Get
    var environment: QZSCAppEnvironmentType { // 可配置开发环境
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: "QZSCAppEnvironmentType")
            UserDefaults.standard.synchronize()
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.3) {
                exit(0)
            }
        }
        get {
            guard let type = UserDefaults.standard.object(forKey: "QZSCAppEnvironmentType") as? Int else {
                return QZSCAppEnvironment.defaultEnv
            }
            return QZSCAppEnvironmentType.init(rawValue: type) ?? QZSCAppEnvironment.defaultEnv
        }
    }
    
    @objc var serverApi: String { // 网络请求域名
        switch self.environment {
        case .distribute:
            return "https://uhuhzl.cn/qzsc/"
        case .development:
            return "https://uhuhzl.cn/qzsc/"
        }
    }
    
    @objc var imageUrlApi: String { // 网络请求域名
        switch self.environment {
        case .distribute:
            return "https://uhuhzl.cn/qzsc/"
        case .development:
            return "https://uhuhzl.cn/qzsc/"
        }
    }
    
    var privacyUrl: String {
        return "https://uhuhzl.cn/QZSC_privacies.html"
    }
    
    var protocolUrl: String {
        return "https://uhuhzl.cn/QZSC_protocol.html"
    }
    
    var rc4EncrySecret: String {
        return "package@dofun.cn"
    }
    
    override var description: String {
        switch self.environment {
        case .distribute:
            return "正式环境"
        case .development:
            return "开发环境"
        }
    }
    
}
