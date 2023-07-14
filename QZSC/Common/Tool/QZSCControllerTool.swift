//
//  QZSCControllerTool.swift
//  UmerChat
//
//  Created by umer on 2022/6/8.
//  Copyright © 2022 UmerQs. All rights reserved.
//

import Foundation
import UIKit

class QZSCControllerTool {
    
    // 获取最顶层控制器
    static func currentVC() -> UIViewController? {
        var currentCtl = QZSCControllerTool.keyWindow()?.rootViewController
        while (currentCtl?.presentedViewController != nil)  {
            currentCtl = currentCtl?.presentedViewController
        }
        if let tabbarCtl = currentCtl as? UITabBarController, tabbarCtl.selectedViewController != nil {
            currentCtl = tabbarCtl.selectedViewController
        }
        while let navCtl = currentCtl as? UINavigationController, navCtl.topViewController != nil  {
            currentCtl = navCtl.topViewController
        }
        return currentCtl
    }
    
    static func keyWindow() -> UIWindow? {
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.connectedScenes.filter({
                $0.activationState == .foregroundActive
            }).map({
                $0 as? UIWindowScene
            }).compactMap({
                $0
            }).last?.windows.filter({
                $0.isKeyWindow
            }).last
            return window
        } else {
            return UIApplication.shared.keyWindow
        }
    }
    
    // 获取最顶层导航控制器
    static func currentNavVC() -> UINavigationController? {
        guard let rootCtl = QZSCControllerTool.keyWindow()?.rootViewController else {
            return nil
        }
        return QZSCControllerTool.getCurrentNavVcFrom(ctl: rootCtl)
    }
    
    private static func getCurrentNavVcFrom(ctl: UIViewController) -> UINavigationController? {
        if let tabCtl = ctl as? UITabBarController, let selectedCtl = tabCtl.selectedViewController {
            return QZSCControllerTool.getCurrentNavVcFrom(ctl: selectedCtl)
        } else if let navCtl = ctl as? UINavigationController, let topCtl = navCtl.topViewController {
            if let presentCtl = navCtl.presentedViewController {
                return QZSCControllerTool.getCurrentNavVcFrom(ctl: presentCtl)
            }
            return QZSCControllerTool.getCurrentNavVcFrom(ctl: topCtl)
        } else {
            if let vc = ctl.presentedViewController {
                return QZSCControllerTool.getCurrentNavVcFrom(ctl: vc)
            } else {
                return ctl.navigationController
            }
        }
    }
}
