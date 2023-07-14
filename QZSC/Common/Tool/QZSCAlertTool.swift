//
//  QZSCAlertTool.swift
//  QZSC
//
//  Created by fanyebo on 2023/2/21.
//

import UIKit

// 系统Alert 管理类
public class QZSCAlertTool {
    
    // alert 类型提示信息，默认选项actionTitle - 我知道了
    public static func showCommonAlert(title: String? = nil,
                                       msg: String? = nil,
                                       actionTitle: String? = nil,
                                       complete: (() -> ())? = nil) {
        let alert = UIAlertController.init(title: title, message: msg, preferredStyle: .alert)
        let newTitle = actionTitle ?? "我知道了"
        let action = UIAlertAction.init(title: newTitle, style: .default) { _ in
            if complete != nil {
                complete!()
            } else {
                QZSCControllerTool.currentVC()?.dismiss(animated: true, completion: nil)
            }
        }
        alert.addAction(action)
        QZSCControllerTool.currentVC()?.present(alert, animated: true, completion: nil)
    }
    
    // 弹出 alert 类型
    public static func showCommonAlert(title: String? = nil,
                                       msg: String? = nil,
                                       isAddCancel: Bool = true,
                                       actionTitles: [String],
                                       complete: @escaping(Int) -> ()) {
        QZSCAlertTool.showCommonAlertController(style: .alert,
                                                  title: title,
                                                  msg: msg,
                                                  isAddCancel: isAddCancel,
                                                  actionTitles: actionTitles,
                                                  complete: complete)
    }
    
    // 弹出 sheet 类型
    public static func showCommonSheet(title: String? = nil,
                                       msg: String? = nil,
                                       isAddCancel: Bool = true,
                                       actionTitles: [String],
                                       complete: @escaping(Int) -> ()) {
        QZSCAlertTool.showCommonAlertController(style: .actionSheet,
                                                  title: title,
                                                  msg: msg,
                                                  isAddCancel: isAddCancel,
                                                  actionTitles: actionTitles,
                                                  complete: complete)
    }
    
    
    // 弹出多个选项 AlertController，isAddCancel 是否添加取消选项：true 默认添加
    public static func showCommonAlertController(style: UIAlertController.Style,
                                                 title: String? = nil,
                                                 msg: String? = nil,
                                                 isAddCancel: Bool = true,
                                                 actionTitles: [String],
                                                 complete: @escaping(Int) -> ()) {
        let alert = UIAlertController.init(title: title, message: msg, preferredStyle: style)
        for (i, actionTitle) in actionTitles.enumerated() {
            let action = UIAlertAction.init(title: actionTitle, style: .default) { _IOFBF in
                complete(i)
            }
            alert.addAction(action)
        }
        if isAddCancel { // 是否添加 默认 的取消选项
            let cancelAction = UIAlertAction.init(title: "取消", style: .cancel) { _ in
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(cancelAction)
        }
        QZSCControllerTool.currentVC()?.present(alert, animated: true, completion: nil)
    }
}
