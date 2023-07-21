//
//  QZSCLoginManager.swift
//  QZSC
//
//  Created by zzk on 2023/7/14.
//

import Foundation


class QZSCLoginManager: NSObject, ObservableObject {
    
    static let shared = QZSCLoginManager()
    
    var loginSuccessComplete: (() -> Void)?
    
    @Published var userInfo: QZSCUserInfo? {
        didSet{
            QZSCCache.cache(object: userInfo, key: keyUserInfo)
        }
        
    }
    
    @objc class func Uid() -> NSString {
        if let uid = QZSCLoginManager().userInfo?.uid{
            return String(uid) as NSString
        }
        return "" as NSString
    }

        
    var isLogin: Bool{
        return userInfo != nil
    }
    
    var merchant: Bool {
        set {
            if let info = self.userInfo {
                info.is_sub_merchant = (newValue ? 1 : 0)
                self.userInfo = info
            }
        }
        get {
            if let info = self.userInfo {
                return info.is_sub_merchant == 1
            }
            return false
        }
    }
    
    private let keyUserInfo = "QZSC_local_userInfo"
    
    override init() {
        userInfo = QZSCCache.fetchObject(key: keyUserInfo, to: QZSCUserInfo.self)
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
        self.userInfo = nil
        loginSuccessComplete?()
    }
}
