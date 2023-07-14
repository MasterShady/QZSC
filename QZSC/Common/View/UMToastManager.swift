//
//  UMToastManager.swift
//  UmerChat
//
//  Created by zx on 2022/9/7.
//  Copyright © 2022 UmerQs. All rights reserved.
//

import Foundation

class UMToastManager {
    
    // MARK: - 居中提示框
    class func showToast(_ message: String?) {
        UMToast.show(message)
    }
    
    class func hideToast() {
        UMToast.hide()
    }
    
    // MARK: - Tips提示框
}
