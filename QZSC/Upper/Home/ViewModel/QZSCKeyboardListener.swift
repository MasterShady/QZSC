//
//  QZSCKeyboardListener.swift
//  QZSC
//
//  Created by fanyebo on 2023/7/19.
//

import Foundation

/// 键盘辅助类
class QZSCKeyboardListener: NSObject {
    
    /// 单例
    public static let shared = QZSCKeyboardListener()
    private let dBag = DisposeBag()
    /// 键盘高度
    public let keyboardHeight: PublishRelay<CGFloat> = .init()
    
    private override init() {
        super.init()
        self.setup()
    }
    
    /// 键盘通知监听
    private func setup() {
        // 键盘即将出现
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification).subscribe(onNext: { [weak self] value in
            guard let self = self else { return }
            let keyBoardEnd = (value.userInfo?["UIKeyboardFrameEndUserInfoKey"] as? CGRect) ?? .zero
            self.keyboardHeight.accept(keyBoardEnd.size.height)
        }).disposed(by: dBag)
        
        // 键盘即将消失
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification).subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.keyboardHeight.accept(0)
        }).disposed(by: dBag)
    }
    
}


