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
    let defaultEnv: QZSCAppEnvironmentType = QZSCAppEnvironmentType.development
    
    @objc var serverApi: String { // 网络请求域名
        switch defaultEnv {
        case .distribute:
            return "https://QZSC.uhuhzl.cn.cn"
        case .development:
            return "https://QZSC.uhuhzl.cn.cn"
        }
    }
    
    @objc var imageUrlApi: String { // 网络请求域名
        return serverApi
    }
    
    var privacyUrl: String {
        return "https://QZSC.uhuhzl.cn/QZSC_privacies.html"
    }
    
    var protocolUrl: String {
        return "https://QZSC.uhuhzl.cn//QZSC_protocol.html"
    }
    
    var rc4EncrySecret: String {
        return ""
    }
    
    @objc let hasSecret: Bool = false
    
    override var description: String {
        switch defaultEnv {
        case .distribute:
            return "正式环境"
        case .development:
            return "开发环境"
        }
    }
    
}
