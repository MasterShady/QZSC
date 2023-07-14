//
//  UMProgressManager.swift
//  UmerChat
//
//  Created by zx on 2022/9/7.
//  Copyright © 2022 UmerQs. All rights reserved.
//

import Foundation
import UIKit

class UMProgressManager {
    
    // 动画加载框主题颜色、字体大小
    class func configLoadingTheme() {
        // 提示文本颜色
        ProgressHUD.colorStatus = .black
        // 提示文本的字体大小
        ProgressHUD.fontStatus = UIFont.medium(14)
        // 动画内容的颜色
        ProgressHUD.colorAnimation = .systemBlue
        // 文本、动画背景框的颜色
        ProgressHUD.colorHUD = UIColor.systemGray
        // 加载框周围透明区域颜色
        ProgressHUD.colorBackground = UIColor(white: 0, alpha: 0)
    }
    
    // 成功、失败、警告提示框主题颜色、字体大小
    class func configStatusTheme() {
        // 提示文本颜色
        ProgressHUD.colorStatus = .white
        // 提示文本的字体大小
        ProgressHUD.fontStatus = UIFont.medium(14)
        // 动画内容的颜色
        ProgressHUD.colorAnimation = .white
        // 文本、动画背景框的颜色
        ProgressHUD.colorHUD = .black
        // 加载框周围透明区域颜色
        ProgressHUD.colorBackground = UIColor(white: 0, alpha: 0)
    }
    
    // MARK: - 全屏 加载中提示框
    /* 带文字的 默认菊花 加载框
     message: 文字提示信息
     interaction: false 不可响应，true 加载框透明区域可响应底层点击事件
     type: 加载框样式，默认 系统样式
     */
    class func showLoadingAnimation(_ message: String? = nil,
                                    interaction: Bool = true,
                                    type: AnimationType = .systemActivityIndicator) {
        UMProgressManager.configLoadingTheme()
        ProgressHUD.animationType = type
        ProgressHUD.show(message, interaction: interaction)
    }
    
    // 小圆圈循环加载框
    class func showLoadingCircleSpinAnimation(_ message: String? = nil,
                                              interaction: Bool = true) {
        UMProgressManager.showLoadingAnimation(message,
                                               interaction: interaction,
                                               type: .circleSpinFade)
    }
    
    // 线条循环加载框
    class func showLoadingCircleStrokenAnimation(_ message: String? = nil,
                                                 interaction: Bool = true) {
        UMProgressManager.showLoadingAnimation(message,
                                               interaction: interaction,
                                               type: .circleStrokeSpin)
    }
    
    // 水平三个小圆循环变动加载框
    class func showLoadingCirclesPulseAnimation(_ message: String? = nil,
                                                interaction: Bool = true) {
        UMProgressManager.showLoadingAnimation(message,
                                               interaction: interaction,
                                               type: .horizontalCirclesPulse)
    }
    
    // 水平多个线条变动动加载框，类似音量变动
    class func showLoadingLineScalingAnimation(_ message: String? = nil,
                                               interaction: Bool = true) {
        UMProgressManager.showLoadingAnimation(message,
                                               interaction: interaction,
                                               type: .lineScaling)
    }
    
    // MARK: - 指定view添加 加载框
    /*
     message: 文字提示信息
     superView: 加载框所在的父视图
     interaction: 默认false 不可响应，true 加载框透明区域可响应底层点击事件
     type: 加载框样式，默认 系统样式
     */
    class func showLoadingAnimation(_ message: String? = nil,
                                    superView: UIView? = nil,
                                    interaction: Bool = true,
                                    type: AnimationType = .systemActivityIndicator) {
        UMProgressManager.configLoadingTheme()
        ProgressHUD.shared.viewBackground = superView;
        ProgressHUD.animationType = type
        ProgressHUD.show(message, interaction: interaction)
    }
    
    // MARK: - 全屏加载成功 失败状态提示框
    /* 成功提示框
     message: 提示信息
     image: 成功提示图片
     interaction: 默认true 加载框透明区域可响应底层点击事件，false 不可响应
     */
    class func showSuccess(_ message: String? = nil,
                           image: UIImage? = nil,
                           interaction: Bool = true) {
        UMProgressManager.configStatusTheme()
        ProgressHUD.showSuccess(message,
                                image: image ?? UIImage(named: "toast_success_white"),
                                interaction: interaction)
    }
    
    // 失败提示框
    class func showError(_ message: String? = nil,
                         image: UIImage? = nil,
                         interaction: Bool = true) {
        UMProgressManager.configStatusTheme()
        ProgressHUD.showError(message,
                              image: image ?? UIImage(named: "toast_error_white"),
                              interaction: interaction)
    }
    
    // 警告提示框
    class func showWarn(_ message: String? = nil,
                        image: UIImage? = nil,
                        interaction: Bool = true) {
        UMProgressManager.configStatusTheme()
        ProgressHUD.showError(message,
                              image: image ?? UIImage(named: "toast_warn_white"),
                              interaction: interaction)
    }
    
    // 隐藏加载框
    class func hide() {
        ProgressHUD.dismiss()
    }
}
