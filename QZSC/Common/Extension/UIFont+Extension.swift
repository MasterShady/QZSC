//
//  UIFont+Extension.swift
//  UmerChat
//
//  Created by zx on 2022/7/4.
//  Copyright © 2022 UmerQs. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
    
    // 普通
    class func normal(_ fontSize: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: fontSize)
    }
    
    // 中等加粗
    class func medium(_ fontSize: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: fontSize, weight: .medium)
    }
    
    // 最大加粗
    class func semibold(_ fontSize: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: fontSize, weight: .semibold)
    }
}
