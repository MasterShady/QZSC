//
//  QZSCCustomTextView.swift
//  QZSC
//
//  Created by fanyebo on 2023/2/21.
//

import UIKit
import RxCocoa
import RxSwift

public class QZSCCustomTextView: UITextView {
    /// 占位文字
    public var placeholder: String?
    /// 占位文字颜色
    public var placeholderColor: UIColor? = UIColor.lightGray
    /// 当前字数
    public var curCount: Int = 0 {
        didSet {
            if curCount == 0 {
                countL.textColor = .lightGray
                countL.text = "\(curCount)/\(maxCount)"
            } else {
                countL.textColor = .black
                let attrText = NSAttributedString.configSpecialStyle(normalStr: "\(curCount)", specialStr: "/\(maxCount)", font: UIFont.systemFont(ofSize: 14), textColor: .lightGray)
                countL.attributedText = attrText
            }
        }
    }
    /// 最大 字数，默认 500 字
    public var maxCount: Int = 500 {
        didSet {
            countL.text = "0/\(maxCount)"
        }
    }
    /// 是否显示字数统计，ture：显示
    public var isShowCountL: Bool = false {
        didSet {
            countL.isHidden = !isShowCountL
        }
    }
    /// 是否添加字数限制，true：限制最大字数；false: 不限制最大字数
    public var isLimitCount: Bool = false {
        didSet {
            if !isLimitCount { return }
            self.rx.text.orEmpty.subscribe(onNext: { [weak self] _ in
                guard let `self` = self else { return }
                // 获取非选中状态文字范围
                let selectedRange = self.markedTextRange
                // 没有非选中文字，截取多出的文字
                if selectedRange == nil {
                    let text = self.text ?? ""
                    if text.count > self.maxCount {
                        let index = text.index(text.startIndex, offsetBy: self.maxCount)
                        self.text = String(text[..<index])
                    }
                    self.curCount = self.text?.count ?? 0
                }
            }).disposed(by: disposeBag)
        }
    }
    
    private let disposeBag = DisposeBag()
    
    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        // 使用通知监听文字改变
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_:)), name: UITextView.textDidChangeNotification, object: nil)
        
        addSubview(countL)
        bringSubviewToFront(countL)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        countL.frame = CGRect(x: self.width - 75, y: self.height - 25, width: 70, height: 20)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func draw(_ rect: CGRect) {
        // 如果有文字,就直接返回,不需要画占位文字
        if self.hasText {
            return
        }
        
        // 属性
        let attrs: [NSAttributedString.Key : Any] = [NSAttributedString.Key.foregroundColor: self.placeholderColor as Any, NSAttributedString.Key.font: self.font!]
        
        // 文字
        let xOffset = self.textContainerInset.left
        let yOffset = self.textContainerInset.top
        var rect1 = rect
        rect1.origin.x = xOffset + 5
        rect1.origin.y = yOffset
        (self.placeholder! as NSString).draw(in: rect1, withAttributes: attrs)
    }
    
    @objc func textDidChange(_ note: Notification) {
        // 会重新调用drawRect:方法
        self.setNeedsDisplay()
    }
    
    // MARK: -lazy
    private lazy var countL: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 14)
        lbl.textColor = .lightGray
        lbl.text = "0/500"
        lbl.textAlignment = .right
        lbl.isHidden = true
        return lbl
    }()
}


