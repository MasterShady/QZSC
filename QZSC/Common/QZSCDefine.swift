//
//  QZSCDefine.swift
//  QZSC
//
//  Created by fanyebo on 2023/2/10.
//

import UIKit

/// 屏幕宽度
public let kScreenWidth = UIScreen.main.bounds.size.width

/// 屏幕高度
public let kScreenHeight = UIScreen.main.bounds.size.height

/// 给定UI效果图的宽高, 默认5.5英寸, 根据需求修改
public let kFixedMeasure = CGSizeMake(375, 812)

public var kQZSCBundleName: String {
    guard let bundleName = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String else {
        return "unknown"
    }
    return bundleName
}

/// 命名空间
public var kNameSpace: String {
    guard let nameSpace = Bundle.main.infoDictionary!["CFBundleExecutable"] as? String else {
        return "unknown"
    }
    return nameSpace
}

// 根据UI效果图的宽度, 等比例缩放
public func kScaleBasicWidth(_ w: CGFloat) -> CGFloat {
    return w * kScreenWidth / kFixedMeasure.width
}

// 根据UI效果图的高度, 等比例缩放
public func kScaleBasicHeight(_ h: CGFloat) -> CGFloat {
    return h * kScreenHeight / kFixedMeasure.height
}

/// 状态栏高度
public var kStatusBarHeight: CGFloat {
    if #available(iOS 13.0, *) {
        return keyWindow?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
    } else {
        return UIApplication.shared.statusBarFrame.height
    }
}

/// 屏幕比例
public let kScreenScale = UIScreen.main.bounds.width / 375

/// 导航栏高度
public let kNavBarHeight: CGFloat = 44

/// 导航栏 + 状态栏 高度
public let kNavBarFullHeight: CGFloat = kStatusBarHeight + kNavBarHeight

/// keywindow
public var keyWindow: UIWindow? {
    var window: UIWindow?
    if #available(iOS 13.0, *) {
        // 初始化启动时, UIWindowScene 的状态是 foregroundInactive
        window = UIApplication.shared.connectedScenes.filter { $0.activationState == .foregroundActive }.compactMap { $0 as? UIWindowScene }.first?.windows.first(where: \.isKeyWindow)
        if window == nil {
            window = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }.first?.windows.first
        }
    } else {
        window = UIApplication.shared.keyWindow
    }
    if #available(iOS 15.0, *) {
        return window
    } else {
        return window ?? UIApplication.shared.windows.first
    }
}

/// 指示器高度
public func kHomeIndicatorHeight() -> CGFloat {
    return keyWindow?.safeAreaInsets.bottom ?? 0
}

/// tabbar height
public func kTabbarHeight() -> CGFloat {
    return 49 + kHomeIndicatorHeight()
}

/// App大版本号
public let kAppVersion: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""

/// App名称
public let kAppName: String = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? ""

// MARK: - 自定义日志输出函数 debug模式下有效 release模式下不打印
public func printLog<T>(_ message: T,
                 file: String = #file,
                 line: Int = #line) {
    #if DEBUG
    print("\((file as NSString).lastPathComponent)[\(line)]: \(message)")
    #endif
}

public func intValue(_ value: Any?) -> Int? {
    if let a = value as? Int {
        return a
    }

    if let a = value as? Int64 {
        return Int(a)
    }
    if let a = value as? Int32 {
        return Int(a)
    }
    if let a = value as? Int16 {
        return Int(a)
    }
    if let a = value as? Int8 {
        return Int(a)
    }
    if let a = value as? Double {
        return Int(a)
    }
    if let a = value as? Float {
        return Int(a)
    }

    if let a = value as? String {
        return Int(a)
    }

    return nil
}

public func stringValue(_ value: Any?, defalutPlace: String = "") -> String {
    if let val = value {
        return "\(val)"
    }
    return defalutPlace
}

// 保留小数点后指定位数
public func roundToPlaces(value: Double, places: Int) -> Double {
    let divisor = pow(10.0, Double(places))
    return round(value * divisor) / divisor
}


/*
 屏幕宽度
 */
public let SCREEN_WIDTH = UIScreen.main.bounds.size.width

/*
 屏幕高度
 */
public let SCREEN_HEIGHT = UIScreen.main.bounds.size.height

/*
 状态栏高度
 */
public let STATUSBAR_HEIGHT = UIApplication.shared.statusBarFrame.height
/*
 导航栏高度
 */
public let NAV_HEIGHT = UIApplication.shared.statusBarFrame.height + 44.0
/*
 底部TableBar高度
 */
public let TABLEBAR_HEIGHT:CGFloat  = UIApplication.shared.statusBarFrame.height > 20 ? 83.0 : 49.0
/*
 底部下巴高度
 */
public let BOTTOM_HEIGHT:CGFloat  = UIApplication.shared.statusBarFrame.height > 20 ? 34.0 : 0.0

public let BASE_HEIGHT_SCALE = (SCREEN_HEIGHT / 667.0)
 
public let BASE_WIDTH_SCALE = (SCREEN_WIDTH / 375.0)

/*
 导航栏基础高度
 */
public let NAVBAR_BASE_HEIGHT = CGFloat(44.0)

/*
 比例计算宽度(宽度)
 */
public func SCALE_WIDTHS(value:CGFloat) -> CGFloat {
    let width = value * BASE_WIDTH_SCALE
    let numFloat = width.truncatingRemainder(dividingBy: 1)
          let newWidth = width - numFloat
          return newWidth
}

/*
 比例计算高度(高度)
 */
public func SCALE_HEIGTHS(value:CGFloat) -> CGFloat {
    let width = value * BASE_WIDTH_SCALE
    let numFloat = width.truncatingRemainder(dividingBy: 1)
          let newWidth = width - numFloat
          return newWidth
}
