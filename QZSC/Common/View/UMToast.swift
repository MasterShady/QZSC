//
//  UMToast.swift
//  UmerChat
//
//  Created by zx on 2022/9/7.
//  Copyright © 2022 UmerQs. All rights reserved.
//

import UIKit
import SnapKit

class UMToast: UIView {
    
    static let shared = UMToast(frame: UIScreen.main.bounds)

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        self.backgroundColor = .clear
        addSubview(backgroundView)
        addSubview(messageL)
        
        messageL.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.lessThanOrEqualToSuperview().offset(150)
            make.height.lessThanOrEqualToSuperview()
        }
        backgroundView.snp.makeConstraints { make in
            make.center.equalTo(messageL)
            make.width.equalTo(messageL).offset(32)
            make.height.equalTo(messageL).offset(20)
        }
    }
    
    @objc class func show(_ message: String?) {
        // 空文本信息直接返回
        guard let msg = message else { return }
        
        var t: TimeInterval = 0
        if UMToast.shared.superview != nil {
            t = 0.1
        }
        UMToast.hide()
        DispatchQueue.main.asyncAfter(deadline: .now() + t) {
            UMToast.shared.messageL.text = msg
            QZSCControllerTool.keyWindow()?.addSubview(UMToast.shared)
            QZSCControllerTool.keyWindow()?.bringSubviewToFront(UMToast.shared)
            UMToast.shared.alpha = 1.0
            UIView.animate(withDuration: 0.5, delay: 1, options: [.curveEaseIn, .curveEaseOut, .allowUserInteraction]) {
                UMToast.shared.alpha = 0
            } completion: { _ in
                UMToast.hide()
            }
        }
    }
    
    class func hide() {
        UMToast.shared.removeFromSuperview()
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        return nil
    }
    
    // MARK: - lazy
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.3, alpha: 0.8)
        view.layer.cornerRadius = 4
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var messageL: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = UIFont.medium(16)
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        return lbl
    }()
}
