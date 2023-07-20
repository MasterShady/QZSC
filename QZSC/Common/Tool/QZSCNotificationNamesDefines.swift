//
//  QZSCNotificationNamesDefines.swift
//  DF_MSZ
//
//  Created by zzk on 2022/12/21.
//

import Foundation

/// 自定义通知名称
public enum QZSCNotification: String {
    
    case loginSuccess = "loginSuccess"  // 登录成功消息
    case logout = "logout"    // 登出
    
    public var name: Notification.Name {
        return Notification.Name(rawValue: self.rawValue)
    }
    
}
