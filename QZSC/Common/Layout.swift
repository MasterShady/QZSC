//
//  Layout.swift
//  QZSC
//
//  Created by 刘思源 on 2023/7/17.
//

import Foundation

//let kStatusBarHeight: CGFloat = UIApplication.shared.windows.first!.safeAreaInsets.top
//let kNavBarHeight = 44

let kNavBarMaxY = kStatusBarHeight + kNavBarHeight
let kBottomSafeInset = UIApplication.shared.windows.first!.safeAreaInsets.bottom

extension Double {
    var rw : Double{
        kScreenWidth/375.0 * self
    }
}
