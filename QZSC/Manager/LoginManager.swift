//
//  LoginManager.swift
//  QZSC
//
//  Created by zzk on 2023/7/14.
//

import Foundation

class QZSCLoginManager {
    
    static let shared = QZSCLoginManager()
    
    var loginSuccessComplete: (() -> Void)?
    
    var isLogin: Bool { // 登录状态, true 已登录
        guard let _ = QZSCCache.fetchObject(key: keyUserInfo, to: QZSCUserInfo.self) else {
            return false
        }
        return true
    }
    
    var userInfo: QZSCUserInfo? {
        set {
            guard let info = newValue else { return }
            QZSCCache.cache(object: info, key: keyUserInfo)
        }
        get {
            return QZSCCache.fetchObject(key: keyUserInfo, to: QZSCUserInfo.self)
        }
    }
    
    private let keyUserInfo = "QZSC_local_userInfo"
    
    init() {
    }
    
    func autoOpenLogin() -> Bool {
        if isLogin {
            return true
        }
        // 未登录
        let ctl = QZSCLoginController()
        QZSCControllerTool.currentNavVC()?.pushViewController(ctl, animated: true)
        return false
    }
    
    func logOut() { // 退出登录
        QZSCCache.clearAll()
        loginSuccessComplete?()
    }
}
